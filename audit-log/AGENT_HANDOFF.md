# AGENT HANDOFF — read this first

You are one in a series of agents hammering the **Tokemak Autopilot** bug bounty.
This repo is the shared brain: what was tried, what was proven, where past agents
went wrong. Read in this order:

1. `audit-log/STATUS.md`      — current state in one screen. Is it done? What's blocking?
2. `audit-log/scope.md`       — exact scope, rules, reward tiers. Do not test outside it.
3. `audit-log/primitives.md`  — the primitives ledger (every sub-critical observation).
4. `audit-log/hypotheses/`    — one file per hypothesis: witness, evidence level, VERDICT.
5. `audit-log/killed.md`      — dead ends with WHY, so you don't repeat them.
6. `audit-log/crossref.md`    — the 20-family cross-reference pass, once run.
7. `pipeline/`                — the methodology these agents follow (v2 skill, mirrored).

## How to record your work (so the next agent learns from you)
- Every hypothesis gets a file in `hypotheses/H-###-<slug>.md` from `pipeline/templates/chain-card.md`.
- Advance its `EVIDENCE:` ladder honestly: SOURCE → DEPLOYMENT → RUNTIME → ECONOMICALLY.
- When you kill a hypothesis, MOVE its conclusion to `killed.md` with a one-line WHY and a `REVISIT IF` trigger. Keep the file.
- A finding is CONFIRMED only with a runtime fork PoC committed under `poc/` + economics + a recorded kill attempt.
- Update `STATUS.md` at the end of every session. It is the first thing the next agent reads.
- Never fabricate a finding. "Nothing found yet, here's where I looked" is a valid, valuable session.

## Where you might go wrong (lessons so far)
- This target is heavily audited (Hexens x3, Certora formal verification, Halborn, Hats). Low-hanging fruit is gone. Think chains, not single bugs.
- Only Critical/High pay. A griefing or Low is not worth a report here.
- Rounding directions in the vault are deliberate and commented — don't flag them as bugs without a witness showing economic divergence.
