# AUTOfinance-r — Tokemak Autopilot audit (shared agent brain)

A persistent workspace for a series of agents auditing the **Tokemak Autopilot**
bug bounty. The repo IS the memory: methodology, what was tried, what was proven,
and where past agents went wrong.

**New agent? Read `audit-log/AGENT_HANDOFF.md` first, then `audit-log/STATUS.md`.**

```
audit-log/        the live state of the hunt
  AGENT_HANDOFF.md  how to work here + lessons so far
  STATUS.md         one-screen current state (is it done? what's next?)
  scope.md          exact scope, rules, reward tiers
  primitives.md     primitives ledger (every sub-critical observation)
  representations.md where components disagree about a fact (chain seams)
  hypotheses/       one file per hypothesis, with witness + evidence level + verdict
  killed.md         dead ends with WHY (don't repeat them)
  crossref.md       the 20-family cross-reference pass
pipeline/         the methodology these agents follow (v2 orchestrator, mirrored)
poc/              Foundry fork PoCs (created when a hypothesis reaches runtime)
```

Source under audit: `Tokemak/v2-core-pub` @ `de163d5` (Ethereum mainnet only).
Testing is local-fork only, per program rules. Secrets (RPC keys) live in the
operator's vault, never in this repo.
