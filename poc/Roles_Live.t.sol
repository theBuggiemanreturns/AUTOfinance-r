// SPDX-License-Identifier: MIT
pragma solidity ^0.8.23;
import "forge-std/Test.sol";
interface IA { function getSystemRegistry() external view returns (address); }
interface ISR { function accessController() external view returns (address); function autoPoolRouter() external view returns (address); }
interface IAC { function getRoleMemberCount(bytes32) external view returns (uint256); function getRoleMember(bytes32,uint256) external view returns (address); function hasRole(bytes32,address) external view returns (bool); }
contract Roles_Live is Test {
    function test_roles() public {
        vm.createSelectFork(vm.envString("ETH_RPC_URL"), 23_600_000);
        address sr = IA(0x0A2b94F6871c1D7A32Fe58E1ab5e6deA2f114E56).getSystemRegistry();
        IAC ac = IAC(ISR(sr).accessController());
        emit log_named_address("systemRegistry", sr);
        emit log_named_address("accessController", address(ac));
        emit log_named_address("router", ISR(sr).autoPoolRouter());
        string[8] memory n; string[8] memory h;
        n[0]="AUTO_POOL_REPORTING_EXECUTOR"; h[0]="AUTO_POOL_UPDATE_DEBT_REPORTING_ROLE";
        n[1]="SOLVER"; h[1]="SOLVER_ROLE";
        n[2]="AUTO_POOL_MANAGER"; h[2]="AUTO_POOL_ADMIN";
        n[3]="ORACLE_MANAGER"; h[3]="ORACLE_MANAGER_ROLE";
        n[4]="TOKEN_RECOVERY_MANAGER"; h[4]="TOKEN_RECOVERY_ROLE";
        n[5]="AUTO_POOL_FEE_UPDATER"; h[5]="AUTO_POOL_FEE_SETTER_ROLE";
        n[6]="STATS_SNAPSHOT_EXECUTOR"; h[6]="STATS_SNAPSHOT_ROLE";
        n[7]="DESTINATION_VAULT_MANAGER"; h[7]="DESTINATION_VAULT_MANAGER";
        for (uint256 i; i < 8; i++) {
            bytes32 id = keccak256(bytes(h[i]));
            uint256 c = ac.getRoleMemberCount(id);
            emit log_named_uint(n[i], c);
            for (uint256 j; j < c; j++) { address m = ac.getRoleMember(id, j); emit log_named_address("   member", m); emit log_named_uint("   codesize", m.code.length); }
        }
    }
}
