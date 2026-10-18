# H-002 — Profit-unlock timing capture

```
LINKS:          P-003 (profit unlock rate truncation + rate=0 branch)
WITNESS:        attacker captures profit whose unlock window has not elapsed, by triggering
                or sandwiching a profit-realization / unlock event, for PnL > fair share.
EVIDENCE:       SOURCE_VERIFIED + RUNTIME_VERIFIED (fork @ 23,600,000, live autoETH).
VERDICT:        KILLED (permissionless path). See poc/H002_ProfitUnlock.t.sol.
```

## Why it's dead
1. **No attacker trigger.** Profit is only realized/locked inside `updateDebtReporting`
   (`hasRole(AUTO_POOL_REPORTING_EXECUTOR)`) and `flashRebalance` (`hasRole(SOLVER)`).
   Runtime: `updateDebtReporting` from an unprivileged address reverts. You cannot force the event.
2. **No step to sandwich.** Locked profit shares unlock *linearly* (`profitUnlockRate * dt`), and
   `totalSupply()` subtracts unlocked shares continuously, so nav/share drifts smoothly; there is no
   discrete jump a deposit can front-run. `unlockedShares()` at the fork block = 0.
3. Sandwiching the keeper's report tx (deposit before, redeem after) faces the same per-round-trip
   loss measured in H-001 (~3e-4 of size) plus `Deposit`-purpose pricing (values assets HIGHER on entry)
   — the vault deliberately prices deposits high / withdrawals low against exactly this.

## Fork artifact (not a finding)
The passive "deposit → warp 30 days → redeem" test reverts with `InvalidLastUpdateDetails`
for the `osETH/ETH` custom oracle: after warping, the oracle's maxAge guard rejects stale prices
because no keeper updates on a fork. Correct guard behaviour, not a bug. Note for future agents:
**don't vm.warp far past oracle maxAge in fork PoCs** — mock or refresh the custom oracle instead.

## REVISIT IF
- A reporting/rebalance path becomes permissionless, OR
- someone finds the keeper report tx is MEV-sandwichable with a profit bigger than the
  deposit-high/withdraw-low spread (would need a large single-report nav jump).
