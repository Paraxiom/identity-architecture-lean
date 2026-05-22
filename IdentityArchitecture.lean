/-
Identity as Accountability Chain — Lean 4 formalization
Top-level module: imports + theorem index.

The seven principal theorems of the treatise, kernel-verified by
Lean 4.27.0 + Mathlib v4.27.0:

  1. founding_uniqueness          (Founding.lean)   — Theorem 2.8
  2. tier_monotonicity            (Tier.lean)       — Theorem 5.2
  3. stratum_wellfoundedness      (Stratum.lean)    — Theorem 6.2
  4. llm_instance_non_identity    (LLM.lean)        — Theorem 7.3
  5. cryptographic_survival       (Crypto.lean)     — Theorem 9.1
  6. crypto_shredding_completeness (Crypto.lean)    — Theorem 11.1
  7. verification_time_accountability (Verify.lean) — Theorem 11.3

Status:
  - Theorems 1, 3, 4, 7 are deductively proven from the model
    primitives (no sorries, no security-assumption axioms).
  - Theorem 2 (tier monotonicity) is an empirical claim about
    operational rates and is exposed as an axiom of the
    probability model; the chain-level statement is then a
    one-line derivation.
  - Theorems 5 and 6 depend on cryptographic hardness assumptions
    (EUF-CMA of post-quantum schemes; IND-CPA of AES-256-GCM); the
    Lean formalization records the chain-level reduction relative
    to these axioms, in the same convention as EasyCrypt and
    CryptoVerif.

This file builds cleanly with `lake build`. No sorries.
-/

import IdentityArchitecture.Basic
import IdentityArchitecture.Founding
import IdentityArchitecture.Stratum
import IdentityArchitecture.LLM
import IdentityArchitecture.Tier
import IdentityArchitecture.Crypto
import IdentityArchitecture.Verify
