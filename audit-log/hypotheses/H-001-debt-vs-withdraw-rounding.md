# H-001 — Debt-report vs withdraw-burn rounding divergence

```
LINKS:          P-001 + P-004 + P-006 (shared anchor: destinationInfo.ownedShares)
WITNESS:        a permissionless deposit->redeem round trip nets positive (free extraction),
                OR nav/share can be nudged for attacker profit across cycles.
EVIDENCE:       RUNTIME_VERIFIED (mainnet fork @ block 23,600,000, live autoETH 0x0A2b..4E56).
VERDICT:        KILLED (permissionless path). See poc/H001_RoundTrip.t.sol.
```

## Runtime result (fork)
Round-trip net is NEGATIVE at every size tested (user always loses):
| deposit size (WETH wei) | net (wei) |
| --: | --: |
| 1e6  | -301 |
| 1e9  | -300,536 |
| 1e12 | -300,535,097 |
| 1e15 | -300,535,074,722 |
| 1e18 | -300,513,938,837,147 |
| 7e18 | -2,102,709,369,603,478 |
| 1.23e17 | -37,102,769,451,046 |

Worst case (best for attacker) = **-301 wei**, i.e. always a loss.

## Why it's dead
1. Deposit/redeem round-trips round consistently AGAINST the user (fee + rounding).
2. `_ensureNoNavPerShareDecrease` reverts on ANY nav/share decrease (strict `<`, zero tolerance),
   so the "nudge nav down to extract" variant can't even land.
3. The debt-report-vs-live-valuation divergence is driven by `rebalance`/`updateDebtReporting`,
   which require the **solver/privileged** role — not attacker-controllable, so no permissionless chain.

## REVISIT IF
- A future map expansion finds a permissionless way to trigger destination revaluation, OR
- a destination vault is added whose share price an attacker can move within one block
  (then re-pair with P-004 for a read-only-reentrancy-style divergence).
