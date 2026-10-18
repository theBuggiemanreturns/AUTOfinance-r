# H-003 — Curve read-only reentrancy on LP valuation

```
LINKS:      oracles/RootPriceOracle.getRangePricesLP + CurveV1StableEthOracle.getSafeSpotPriceInfo
WITNESS:    attacker inflates LP price mid-callback (classic Curve ETH-pool remove_liquidity reentrancy:
            LP supply burned before all balances decrement) and makes the Autopool value debt at that price.
EVIDENCE:   SOURCE_VERIFIED. VERDICT: KILLED (no permissionless consumer). Informational gap noted.
```

## What's real (source)
- RootPriceOracle comment (L190) and provider headers say oracles are non-view "so we can perform the Curve
  reentrancy check", and CurveV1/V2 note ETH pools "should be registered for reentrancy checks".
- But the LP path actually used for NAV — `getRangePricesLP` → `CurveV1StableEthOracle.getSafeSpotPriceInfo`
  — is `view` and contains **no reentrancy check**. It prices LP as sum(live reserves × safe price) / live
  totalSupply, exactly the quantity read-only reentrancy distorts. The per-token isSpotSafe check compares
  token spot vs safe price, not reserve/supply consistency. The documented guard appears to be vestigial.

## Why it's not exploitable (permissionless)
Every consumer of a live LP price is privileged or off the money path:
- `_recalculateDestInfo` ← `_updateDebtReporting` (REPORTING_EXECUTOR) and `flashRebalance` (SOLVER) only.
- `DestinationVault.debtValue / getValidatedSpot/SafePrice` ← strategy (solver rebalance) + stats calculators
  (STATS_SNAPSHOT_EXECUTOR).
- User deposit/withdraw/redeem use CACHED min/max debt from the last report, never a live price.
An attacker's reentrant callback can't make a keeper/solver tx execute inside it → no path to NAV.

## Classification
Informational / defense-in-depth (doc says guarded, code isn't). Not Critical/High. Not a bounty report on its own.

## REVISIT IF
- any user-callable path ever reads a live LP price (e.g. a future "deposit at live NAV" mode), or
- a keeper/solver tx is shown to perform an external call into attacker code before pricing.
