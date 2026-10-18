# Representations ledger
Track where two components hold divergent views of the same fact (the richest chain seam).

| Fact | Component A view | Component B view | Can they diverge? | Primitive |
| :-- | :-- | :-- | :-- | :-- |
| owned destination value | totalDebt (aggregate, cached at report) | per-destination live valuation on withdraw | candidate (P-004/P-006) | investigate |
| nav/share | convertToShares (Down) | convertToAssets (Up) | by design; needs economic witness | P-001/P-002 |
