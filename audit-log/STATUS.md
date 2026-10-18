# STATUS — Tokemak Autopilot hunt

Last updated: 2026-10-19 by agent "setup/checkpoint-1"

## Done or not?
**NOT done.** Setup complete; reconnaissance + primitives ledger done. **No PoC run yet. Cross-reference pass NOT yet run.**

## Where we are
- [x] Scope locked (see scope.md). Source pinned: v2-core-pub @ de163d5a1edf99281d7d000783b4dc8ade03591e.
- [x] Environment: Foundry 1.8.5, `forge build` passes, mainnet fork reachable (block ~26.22M, chainid 1).
- [x] Thin map: 318 sol files / ~30.7k LOC. Value in vault/ strategy/ rewarders/ liquidation/ oracles/.
- [x] Primitives ledger: 6 primitives, 2 seams prioritized (primitives.md).
- [ ] Hypotheses taken to RUNTIME proof — NONE yet.
- [ ] Fork PoC harness — not written.
- [ ] Cross-reference (20-family) pass — NOT run.
- [ ] Confirmed finding — none.

## Immediate next step for the next agent
Take H-001 (debt-report vs withdraw-burn rounding) to a fork PoC, OR run the cross-reference pass first to widen the hypothesis set. See hypotheses/.

## Hard blocker
GitHub integration cannot create repos (owner must create them). Not blocking research.
