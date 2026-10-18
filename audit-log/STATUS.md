# STATUS — Tokemak Autopilot hunt

Last updated: 2026-10-19 by agent "poc/H-002"

## Done or not?
**Pass complete (2026-10-19).** H-001/H-002 killed with fork PoCs, H-003 Informational, crossref + guard audit + sigs + live roles done. No Critical/High found.

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
Crossref + guard audit done; nothing survived. Oracles reviewed: H-003 Curve read-only reentrancy gap is real but no permissionless consumer (Informational). claimFor sig replay killed; live roles read on fork (deployer EOA holds ORACLE_MANAGER: centralization note only). Audit pass CLOSED. Fork tip: don't warp past oracle maxAge.

## Hard blocker
GitHub integration cannot create repos (owner must create them). Not blocking research.
