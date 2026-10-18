# H-001 — Debt-report vs withdraw-burn rounding divergence

```
LINKS:          P-001 + P-004 + P-006 (shared anchor: destinationInfo.ownedShares)
IMPOSSIBLE STATE: nav/share drifts upward (or a withdrawer extracts more than pro-rata)
                  by repeatedly exploiting Rounding.Up on destination-share burn vs the
                  cached totalDebt used in share-price math.
WHY IT CHAINS:  shared-mechanism — ownedShares feeds both the valuation (totalAssets)
                and the burn (AutopoolDebt ~700-820), rounded in opposite directions.
WITNESS:        after N rebalance/withdraw cycles, assert navPerShare_after > navPerShare_before
                beyond the stated rounding tolerance (AutopoolETH line 1008), with attacker PnL > gas.
EVIDENCE:       SOURCE_VERIFIED only (read the code; divergence not yet demonstrated).
CLASS:          EXTRACT (if it yields attacker profit) — else likely Low/unpaid.
VERDICT:        OPEN — needs fork PoC.
KILL IDEA:      the tolerance check at line 1008 may bound the drift to dust; if so, killed.
POC:            TODO -> poc/H-001.t.sol (fork at pinned block, real autopool).
```
