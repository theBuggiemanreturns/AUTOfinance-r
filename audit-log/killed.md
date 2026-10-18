# Killed hypotheses (dead ends + WHY)

- K-001 | from H-001 | Permissionless deposit->redeem rounding extraction. RUNTIME_VERIFIED on
  fork @ 23,600,000: round trip nets negative at every size (worst -301 wei). Vault rounds
  against the user and nav-guard is strict-`<`. REVISIT IF a permissionless destination
  revaluation path appears (debt divergence today needs the solver role). PoC: poc/H001_RoundTrip.t.sol.
- K-002 | from H-002 | Profit-unlock timing capture. Realization is role-gated (REPORTING_EXECUTOR,
  SOLVER; runtime-confirmed revert for attacker), unlock is linear with no step to front-run, and
  entry/exit pricing is skewed against round-trippers. REVISIT IF reporting goes permissionless or a
  single report can jump nav more than the deposit/withdraw spread. PoC: poc/H002_ProfitUnlock.t.sol.
