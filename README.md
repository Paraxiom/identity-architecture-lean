# identity-architecture-lean

Lean 4 formalization companion to:

> Cormier, S. *Identity as Accountability Chain: A Post-Quantum
> Architecture for Persistent Identity Across Human, Machine, and AI
> Agent Substrates.* Paraxiom Technologies Inc., May 2026.
> Zenodo DOI: `10.5281/zenodo.20328038` (draft).

The treatise states seven principal theorems on identity as a layered
accountability chain. This repository contains their machine-checked
formalization in Lean 4.27.0 against Mathlib v4.27.0.

## Status

`lake build` succeeds with **zero sorries**, **zero unresolved
goals**, **zero kernel errors**. The seven theorems are kernel-checked
modulo the cryptographic and probabilistic axioms enumerated below.

## Theorem index

| # | Treatise § | Lean identifier | File | Notes |
|---|---|---|---|---|
| 1 | Theorem 2.8 | `founding_uniqueness` | `Founding.lean` | Deductive |
| 2 | Theorem 5.2 | `tier_monotonicity` | `Tier.lean` | Axiomatized (empirical) |
| 3 | Theorem 6.2 | `stratum_wellfoundedness` | `Stratum.lean` | Deductive (Nat strong induction) |
| 4 | Theorem 7.3 | `llm_instance_non_identity` | `LLM.lean` | Deductive |
| 5 | Theorem 9.1 | `cryptographic_survival` | `Crypto.lean` | Chain-level reduction modulo EUF-CMA / Shor axioms |
| 6 | Theorem 11.1 | `crypto_shredding_completeness` | `Crypto.lean` | Chain-level reduction modulo IND-CPA axiom |
| 7 | Theorem 11.3 | `verification_time_accountability` | `Verify.lean` | Deductive (via stratum well-foundedness) |

## Axioms used (intentional)

Four axioms are declared in the formalization, each documenting an
assumption that cannot be discharged inside Lean without re-formalizing
the underlying theory:

- `tier_monotonicity_axiom` (`Tier.lean`) — empirical claim that
  hardware-replacement rates < installation-reset rates <
  configuration-rotation rates < process-restart rates. The probability
  model is opaque at this layer.
- `euf_cma_pq_secure_under_crqc` (`Crypto.lean`) — post-quantum
  signature security under quantum adversary (FIPS 203/204/205).
- `shor_breaks_classical_under_crqc` (`Crypto.lean`) — classical
  signature security collapse under sufficient CRQC.
- `aes_256_gcm_ind_cpa` (`Crypto.lean`) — IND-CPA security of
  AES-256-GCM.

The four/five-theorem subset that does not depend on any of these
axioms (founding uniqueness, stratum well-foundedness, LLM instance
non-identity, verification-time accountability) is purely deductive
from the model primitives and Mathlib.

This convention follows EasyCrypt / CryptoVerif practice: chain-level
reductions are kernel-checked relative to named cryptographic
hardness assumptions; the assumptions themselves are not internally
reducible.

## Build

```bash
lake update    # first time only — fetches Mathlib v4.27.0
lake build     # ~5–8 minutes on first cold build
```

Requires `elan` toolchain manager. The pinned `leanprover/lean4:v4.27.0`
toolchain installs automatically.

## Layout

```
IdentityArchitecture.lean       — top-level module + theorem index
IdentityArchitecture/
  Basic.lean                    — primitive types (Time, Layer, Substrate, Claim, FoundingEvent)
  Founding.lean                 — IdentityLocus + founding_uniqueness
  Stratum.lean                  — Stratum + ChainDiscipline + stratum_wellfoundedness
  LLM.lean                      — LLMSubstrate / LLMInstance + llm_instance_non_identity
  Tier.lean                     — Permanence tiers + tier_monotonicity (axiomatic)
  Crypto.lean                   — Crypto axioms + cryptographic_survival + crypto_shredding_completeness
  Verify.lean                   — ActionAttempt + Verdict + verification_time_accountability
```

## License

Apache License 2.0. See `LICENSE`.

The companion treatise text and diagrams are CC BY-SA 4.0 in the
companion repo `Paraxiom/identity-architecture`.

## Citation

```bibtex
@misc{cormier-identity-arch-lean-2026,
  author       = {Cormier, Sylvain},
  title        = {{identity-architecture-lean: Lean 4 formalization
                  of Identity as Accountability Chain}},
  year         = 2026,
  publisher    = {Paraxiom Technologies Inc.},
  howpublished = {\url{https://github.com/Paraxiom/identity-architecture-lean}},
}
```
