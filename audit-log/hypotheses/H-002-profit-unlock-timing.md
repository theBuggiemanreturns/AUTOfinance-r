# H-002 — Profit-unlock timing capture

```
LINKS:          P-003 (profit unlock rate truncation + rate=0 branch)
IMPOSSIBLE STATE: a deposit timed around an unlock/period-change captures profit that
                  should still be locked, or the weighted-avg division truncation zeros
                  the rate and dumps all locked profit into nav instantly.
WHY IT CHAINS:  entitlement/payment split — unlock schedule vs who holds shares at unlock.
WITNESS:        depositor who enters at block T and exits at T+1 realizes a share of
                profit whose unlock window had not elapsed; assert their PnL > fair share.
EVIDENCE:       SOURCE_VERIFIED only.
CLASS:          EXTRACT if profitable; otherwise unpaid.
VERDICT:        OPEN — needs fork PoC.
KILL IDEA:      _totalAssetsTimeChecked / unlock accounting may already exclude locked
                shares from the deposit price; if so, killed.
POC:            TODO -> poc/H-002.t.sol
```
