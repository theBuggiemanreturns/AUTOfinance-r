# STATUS — Tokemak Autopilot hunt

Last updated: 2026-10-19 by agent "poc/H-001"

## Done or not?
**NOT done.** H-001 KILLED with a runtime fork PoC. H-002 still OPEN. Cross-reference pass NOT yet run.

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
H-001 is dead (permissionless). Next: H-002 (profit-unlock timing) fork PoC, then the cross-reference pass. See hypotheses/ and killed.md.

## Hard blocker
GitHub integration cannot create repos (owner must create them). Not blocking research.
