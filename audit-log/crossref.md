# Cross-reference pass (20-family) + guard audit — STATUS: RUN (2026-10-19)

Hypothesis generation only. Note: pipeline/knowledge has no 20-family list (only CHAIN-K001),
so the standard DeFi family set below was used. Source: src/ @ audited commit; live target autoETH.

## Guard audit — every permissionless state-changing entry point
| Entry point | Guard | Verdict |
|---|---|---|
| AutopoolETH deposit/mint/withdraw/redeem | nav-per-share no-decrease (strict, 0 tol); Deposit purpose prices high, Withdraw low | covered by K-001 |
| AutopoolETH transfer/permit/approve | std ERC20 + EIP-2612 | no issue |
| updateDebtReporting / flashRebalance | AUTO_POOL_REPORTING_EXECUTOR / SOLVER | K-002 (runtime-confirmed revert) |
| AutopoolETH / DestinationVault initialize | `_disableInitializers()` in implementation ctor; clones initialized by factory | no takeover |
| DestinationVault.withdrawBaseAsset | burns msg.sender's DV shares (only Autopools hold them) | no issue |
| DestinationVault deposit/withdrawUnderlying | onlyAutopool (registry check) | no issue |
| AutopoolMainRewarder.withdraw/getReward | msg.sender == account OR router | see F-03 |
| AutopoolMainRewarder.stake(account) | none (stake-for-others with own tokens) | harmless gift |
| ExtraRewarder stake/withdraw | mainRewardOnly | no issue |
| DestinationVaultMainRewarder withdraw/getReward | onlyStakeTracker / account | no issue |
| AutopilotRouter* (deposit/redeem/swap/multicall) | uses msg.sender as owner; vault/rewarder checked against registry | see F-03, F-04 |
| PctFeeSplitter.claimFees | caller must be a recipient; splits by pct | dust-griefing only (zero-share recipient reverts), Low/OOS |
| LiquidationRow claim/liquidate | REWARD_LIQUIDATION_EXECUTOR | no issue |
| CustomSetOracle setPrices/registerTokens | ORACLE_MANAGER / role; maxAge staleness revert | no issue (stale = DoS by design) |
| Autopool recover / shutdown | TOKEN_RECOVERY_MANAGER / AUTO_POOL_MANAGER | no issue |

## Family map
| # | Family | Applicable? | Result |
|---|---|---|---|
| 1 | Access control / missing auth | yes | guard table above: every value-moving path gated or msg.sender-bound |
| 2 | Uninitialized proxy / init front-run | yes | killed: `_disableInitializers` |
| 3 | ERC4626 first-depositor inflation | no | live vault has ~13.5k supply |
| 4 | Share/asset rounding | yes | K-001 runtime |
| 5 | Oracle spot manipulation | partial | NAV uses cached min/max debt from reports, not live spot; spot only in solver rebalance |
| 6 | Oracle staleness | yes | maxAge reverts (observed on fork) — DoS-by-design, not theft |
| 7 | Flash-loan nav manipulation | yes | needs live-spot NAV; not present (see 5) |
| 8 | Withdrawal slippage socialization | yes | killed: withdrawer burns shares for max(actualAssets, debtBurned); positive slippage → idle, PositivePriceRecoup check |
| 9 | Fee/profit-lock timing | yes | K-002 runtime |
| 10 | Reward accounting (Synthetix) | yes | std pattern, updateReward on stake/withdraw; no flaw found |
| 11 | Reward theft via trusted router | yes | F-03 killed |
| 12 | Arbitrary call / delegatecall | yes | F-04 killed |
| 13 | Reentrancy | yes | nonReentrant on Autopool/rewarder/router swap; swapper doc requires caller guard (router has it) |
| 14 | Approval leakage | yes | router approves exact amounts, holds no balances between txs |
| 15 | Router leftover-balance sweep | yes | known multicall design; user error only, OOS |
| 16 | Signature replay (permit/claimFor) | partial | claimFor requires msg.sender == recipient.wallet; not deep-checked → backlog |
| 17 | Integer overflow/underflow | low | 0.8.x checked; `unchecked` slippage block guarded by `<` |
| 18 | Queue/DoS (withdrawal queue, dust) | partial | dvSharesToBurn min 1; DoS-only → OOS for Critical/High |
| 19 | Cross-chain / bridged calculators | n/a for autoETH mainnet | |
| 20 | Governance/role misconfig | live-state question | backlog: check live role holders on fork |

## Findings worked & killed this pass
- **F-03 router-as-trusted-caller reward theft.** Rewarder trusts router for any `account`; router's
  only arbitrary-data path is `swapToken` → delegatecall registered BaseAsyncSwapper → `AGGREGATOR.call(data)`
  with immutable aggregator. Calls the aggregator makes have msg.sender = aggregator, not router, and every
  router path passes `msg.sender` as account. No path to `getReward(victim, attacker)`. KILLED (source).
- **F-04 arbitrary delegatecall via router.** Swapper must be in AsyncSwapperRegistry; target immutable. KILLED (source).
- **F-08 withdraw slippage.** See family 8. KILLED (source).

## Backlog (worth a look, none currently promising for Critical/High)
1. Live role holders / registry entries on fork (family 20).
2. Rewarder `claimFor` signature domain / replay (family 16).
3. Per-destination debtValue math in stats calculators (31 files; largest unaudited surface).

## Backlog #3 resolved — stats calculators (2026-10-19)
- Calculators do NOT feed NAV. Debt value comes from `rootPriceOracle().getRangePricesLP()` (src/oracles):
  `DestinationVault._debtValue` and `AutopoolDebt._recalculateDestInfo` (min/max of spot vs safe, reverts if !isSpotSafe).
- Calculator outputs feed only the strategy (SummaryStats / PriceReturn / Incentives) that scores
  SOLVER-initiated `flashRebalance`. `snapshot()` is gated by STATS_SNAPSHOT_EXECUTOR.
- So a calculator bug can at worst bias rebalance approval, and only a trusted solver can act on it → no
  permissionless theft path. KILLED as a family (source).
- **Re-pointed backlog:** the real valuation surface is `src/oracles` — RootPriceOracle.getRangePricesLP,
  the isSpotSafe tolerance, and per-pool LP pricers (Curve/Balancer/Maverick/Aerodrome). Question to answer:
  can an attacker push spot and safe so both drift together while staying "safe", then hit a keeper report
  or a withdraw that prices at that drifted level?

## Backlog #1/#2 resolved — signatures + live roles (2026-10-19)
**Rewards.claimFor (family 16): KILLED (source).** Cumulative-amount model: pays `recipient.amount - claimedAmounts[wallet]`,
so replaying a used sig pays 0 (reverts ZeroAmount) and an older lower sig underflow-reverts. Typed data covers
chainId + cycle + wallet + amount; EIP712 domain binds verifyingContract; OZ ECDSA rejects malleable s; funds always go
to `recipient.wallet`; only the router may call, and the router requires msg.sender == wallet.

**Live roles @ block 23,600,000 (poc/Roles_Live.t.sol, fork-read):** systemRegistry 0x2218…4285, accessController 0x3776…2dF6.
| Role | Holders |
|---|---|
| REPORTING_EXECUTOR | 1 EOA keeper (0x241b…aea3) + 1 Safe-style proxy (0x8b43…969B) |
| SOLVER | 11 contracts, all `FlashBorrowerSolver` (verified, deployed by Tokemak Deployer 1) |
| AUTO_POOL_MANAGER / DESTINATION_VAULT_MANAGER | 2 Safe-style proxies |
| ORACLE_MANAGER | 2 Safe-style proxies + **1 EOA = Tokemak Deployer 1 (0x123c…10e5A3)** |
| AUTO_POOL_FEE_UPDATER | 1 Safe-style proxy |
| STATS_SNAPSHOT_EXECUTOR | 4 contracts |
| TOKEN_RECOVERY_MANAGER | none |

- **FlashBorrowerSolver** (verified source): `execute` gated by SOLVER_EXECUTION_ROLE; `recover` by SOLVER_RECOVERY_ROLE;
  `onFlashLoan` requires msg.sender to be a registered Autopool, and Autopools only call it inside SOLVER-gated
  flashRebalance. Initiator arg is ignored, but every possible initiator is another trusted solver. No outsider path into
  its weiroll VM. KILLED.
- **Observation (centralization, NOT a bounty finding):** a deployer EOA still holds ORACLE_MANAGER, which can set
  safe-spot thresholds and register/unregister LP pricers, i.e. it can steer NAV inputs. Privileged-key risk; typically
  out of scope for bounties. Worth a courtesy note to the team, not a Critical/High claim.

## CLOSE-OUT
All seed hypotheses (H-001..H-003) and backlog items worked. No scope-eligible Critical/High with a permissionless path.
