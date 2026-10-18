# STATUS — Tokemak Autopilot hunt

Last updated: 2026-10-19 by agent "poc/H-002"

## Done or not?
**NOT done.** H-001 and H-002 both KILLED with runtime fork PoCs. No live hypotheses. Cross-reference pass NOT yet run — that is the next step.

## Where we are
- [x] Scope locked (see scope.md). Source pinned: v2-core-pub @ de163d5a1edf99281d7d000783b4dc8ade03591e.
- [x] Environment: Foundry 1.8.5, `forge build` passes, mainnet fork reachable (block ~26.22M, chainid 1).
- [x] Thin map: 318 sol files / ~30.7k LOC. Value in vault/ strategy/ rewarders/ liquidation/ oracles/.
- [x] Primitives ledger: 6 primitives, 2 seams prioritized (primitives.md).
- [x] H-001 taken to RUNTIME proof -> KILLED (poc/H001_RoundTrip.t.sol).
- [x] Fork PoC harness working (standalone forge project, forks mainnet via vault's public ABI).
- [ ] Cross-reference (20-family) pass — NOT run.
- [ ] Confirmed finding — none.

## Immediate next step for the next agent
Both seed hypotheses dead. Next: run the 20-family cross-reference pass + guard-audit to generate NEW hypotheses (oracles/ custom-set oracle, destination vaults, rewarders, liquidation). Fork tip: don't warp past oracle maxAge.

## Hard blocker
GitHub integration cannot create repos (owner must create them). Not blocking research.
