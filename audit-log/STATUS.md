# STATUS — Tokemak Autopilot hunt

Last updated: 2026-10-19 by agent "poc/H-002"

## Done or not?
**NOT done.** H-001 and H-002 both KILLED with runtime fork PoCs. No live hypotheses. Crossref + guard audit RUN; no surviving Critical/High. Backlog in crossref.md.

## Where we are
- [x] Scope locked (see scope.md). Source pinned: v2-core-pub @ de163d5a1edf99281d7d000783b4dc8ade03591e.
- [x] Environment: Foundry 1.8.5, `forge build` passes, mainnet fork reachable (block ~26.22M, chainid 1).
- [x] Thin map: 318 sol files / ~30.7k LOC. Value in vault/ strategy/ rewarders/ liquidation/ oracles/.
- [x] Primitives ledger: 6 primitives, 2 seams prioritized (primitives.md).
- [x] H-001 taken to RUNTIME proof -> KILLED (poc/H001_RoundTrip.t.sol).
- [x] Fork PoC harness working (standalone forge project, forks mainnet via vault's public ABI).
- [x] Cross-reference (20-family) pass + guard audit — RUN 2026-10-19 (see crossref.md). No surviving Critical/High.
- [ ] Confirmed finding — none.

## Immediate next step for the next agent
Crossref + guard audit done; nothing survived. Next (backlog in crossref.md): live role holders on fork, rewarder claimFor sig replay, stats calculators debt math. Fork tip: don't warp past oracle maxAge.

## Hard blocker
GitHub integration cannot create repos (owner must create them). Not blocking research.
