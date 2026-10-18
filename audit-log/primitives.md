# Primitives Ledger — Tokemak Autopilot (HEAD de163d5)
CLASS: INFLUENCE | GUARD | ORDERING | INFO

| ID | CLASS | What it influences / protects | Mechanism | Sev alone | Chain seam? |
| :-- | :-- | :-- | :-- | :-- | :-- |
| P-001 | INFLUENCE | share price on deposit/withdraw | convertToShares/Assets mulDiv, rounding dir chosen per-call | Info | round-up vs round-down divergence on debt burn |
| P-002 | GUARD | nav/share must not drop on withdraw (line 1008) | post-op tolerance check | Info | can rounding be steered to breach tolerance repeatedly? |
| P-003 | INFLUENCE | profit unlock rate | _updateProfitUnlockTimings weighted avg div, uint48 fullUnlockTime | Low? | rate=0 branch / div truncation -> instant unlock -> nav jump |
| P-004 | INFLUENCE | debt valuation of destination shares | totalAssetsTimeChecked values owned dest shares, Rounding.Up on burn | Info | aggregate totalDebt vs per-destination valuation divergence |
| P-005 | GUARD | periodic/streaming fee caps | uint16 fee, bounded <= MAX before cast | none | cast is bounds-checked; not a seam |
| P-006 | INFO | destinationInfo.ownedShares is the per-dest accounting anchor | shared across valuation + burn paths | - | shared-mechanism candidate with P-004 |

## Seams prioritized for the hunt (hunt mode, EXTRACT only; only Crit/High pay)
1. Debt reporting vs withdraw burn: does rounding-up on share burn (AutopoolDebt ~700-820) let totalDebt and actual owned value diverge across repeated rebalance/withdraw, so nav/share can be nudged? (P-001+P-004+P-006 shared-mechanism)
2. Profit-unlock timing: the rate=0 / division-truncation branches (P-003) interacting with fee marks — can a deposit right before unlock capture unlocked profit (entitlement/payment split)?

## Honest status
Heavily audited (Hexens x3, Certora formal verif on LMPStrategy, Halborn, Hats crowd comp).
Rounding directions are deliberate and commented. No confirmed contradiction yet.
No fabricated finding will be promoted; a candidate reaches a card only with an assertable witness.
