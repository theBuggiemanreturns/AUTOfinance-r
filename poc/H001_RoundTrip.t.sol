// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;

import "forge-std/Test.sol";

interface IWETH {
    function deposit() external payable;
    function approve(address, uint256) external returns (bool);
    function balanceOf(address) external view returns (uint256);
}

interface IAutopool {
    function asset() external view returns (address);
    function totalAssets() external view returns (uint256);
    function totalSupply() external view returns (uint256);
    function convertToShares(uint256) external view returns (uint256);
    function deposit(uint256 assets, address receiver) external returns (uint256);
    function redeem(uint256 shares, address receiver, address owner) external returns (uint256);
    function balanceOf(address) external view returns (uint256);
}

// H-001: can a permissionless deposit->redeem round trip net positive via rounding?
contract H001_RoundTrip is Test {
    address constant WETH = 0xC02aaA39b223FE8D0A0e5C4F27eAD9083C756Cc2;
    address constant AUTOETH = 0x0A2b94F6871c1D7A32Fe58E1ab5e6deA2f114E56;
    IAutopool pool = IAutopool(AUTOETH);

    function setUp() public {
        vm.createSelectFork(vm.envString("ETH_RPC_URL"), 23_600_000);
    }

    function _roundTrip(address a, uint256 amt) internal returns (int256 net, bool ran) {
        if (pool.convertToShares(amt) == 0) return (0, false);
        uint256 before = IWETH(WETH).balanceOf(a);
        try pool.deposit(amt, a) returns (uint256 shares) {
            if (shares == 0) return (0, false);
            try pool.redeem(shares, a, a) { } catch { return (0, false); }
            uint256 aft = IWETH(WETH).balanceOf(a);
            return (int256(aft) - int256(before), true);
        } catch {
            return (0, false);
        }
    }

    function test_round_trip_not_profitable() public {
        emit log_named_uint("totalAssets", pool.totalAssets());
        emit log_named_uint("totalSupply", pool.totalSupply());

        address attacker = address(0xBEEF);
        vm.startPrank(attacker);
        vm.deal(attacker, 2000 ether);
        IWETH(WETH).deposit{value: 1500 ether}();
        IWETH(WETH).approve(AUTOETH, type(uint256).max);

        uint256[7] memory sizes = [
            uint256(1e6), 1e9, 1e12, 1e15, 1 ether, 7 ether, 123_456_789_987_654_321
        ];
        int256 worst = type(int256).min;
        for (uint256 i = 0; i < sizes.length; i++) {
            (int256 net, bool ran) = _roundTrip(attacker, sizes[i]);
            if (!ran) { emit log_named_uint("skipped size", sizes[i]); continue; }
            emit log_named_int("net wei @ size (below)", net);
            emit log_named_uint("  size", sizes[i]);
            if (net > worst) worst = net;
            assertLe(net, int256(0), "ROUND TRIP PROFITABLE - investigate!");
        }
        emit log_named_int("worst-case net (max over sizes, wei)", worst);
        vm.stopPrank();
    }
}
