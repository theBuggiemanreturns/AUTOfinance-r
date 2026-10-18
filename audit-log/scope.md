# Scope — Tokemak Autopilot (AUTO finance Autopools)
Program: https://r.xyz/bug-bounty/programs/tokemak
Mode: hunt
Authorization: public bug bounty, user-directed (test subject #1)
Environment: READ_ONLY_PRODUCTION; **all testing on local fork only**
Live/testnet exploitation: PROHIBITED by program rules
Chain: Ethereum mainnet only
In scope: github.com/Tokemak/v2-core-pub  -> src/** (except out-of-scope paths)
         deployed addresses: docs.auto.finance/developer-docs/contracts-overview/contract-addresses
Commit pinned (clone HEAD): de163d5a1edf99281d7d000783b4dc8ade03591e
Reward rubric (verbatim): Smart Contracts Critical $25,000–$125,000; High $25,000. Medium/Low/Info NOT eligible.
Prior audits: Hexens (x3), Certora (formal verif LMPStrategy), Halborn, Hats crowd comp. Heavily reviewed.
Severity note: only Critical/High pay. CLASS=EXTRACT is the target; grief/griefing likely out.
