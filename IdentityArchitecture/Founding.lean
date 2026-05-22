/-
Identity locus + Founding uniqueness (Theorem 2.8 in the treatise).

The identity locus is the central object of the formalization. By
construction it carries a single founding event; the founding-uniqueness
theorem then falls out as a kernel-verified consequence of the
axioms below.

The result is admittedly close to definitional --- this is by design.
The treatise positions founding uniqueness as a sanity invariant the
chain registration logic must respect, not as a deep mathematical
theorem. The Lean formalization makes the definitional content
explicit.
-/

import IdentityArchitecture.Basic

namespace IdentityArchitecture

/-- An accretion chain is a list of claims that respects founding
precedence (every claim time ≥ founding time) and monotone-in-time
ordering. -/
structure AccretionChain (founding_time : Time) where
  claims : List Claim
  precedence : ∀ a ∈ claims, founding_time ≤ a.time
  monotone   : claims.Pairwise (fun a b => a.time ≤ b.time)

/-- An identity locus = substrate + founding + accretion + relations.
We model the relational graph abstractly as a set of identity-id pairs;
its details are not needed for founding uniqueness. -/
structure IdentityLocus where
  substrate              : Substrate
  founding               : FoundingEvent
  accretion              : AccretionChain founding.time
  founding_substrate_eq  : founding.substrate = substrate

/-- Founding-event candidacy: an event F is a candidate founding for
locus I iff (i) it has the same substrate, (ii) its time precedes all
claim times in the accretion, and (iii) it matches the locus's
recorded founding. -/
def isFoundingCandidate (I : IdentityLocus) (F : FoundingEvent) : Prop :=
  F.substrate = I.substrate ∧
  (∀ a ∈ I.accretion.claims, F.time ≤ a.time) ∧
  F = I.founding

/-- **Theorem 2.8 (Founding uniqueness).** For every identity locus I,
exactly one founding event F is recorded for I --- expressed here as
existence-and-uniqueness directly to avoid binder-syntax surprises.

Proof: by construction --- the `founding` field of `IdentityLocus` is a
single value. Any two candidates that satisfy the candidacy predicate
must equal `I.founding`. -/
theorem founding_uniqueness (I : IdentityLocus) :
    ∃ F : FoundingEvent, isFoundingCandidate I F ∧
      ∀ G : FoundingEvent, isFoundingCandidate I G → G = F := by
  refine ⟨I.founding, ?_, ?_⟩
  · -- existence: I.founding is a candidate
    refine ⟨I.founding_substrate_eq, ?_, rfl⟩
    intro a ha
    exact I.accretion.precedence a ha
  · -- uniqueness: any candidate equals I.founding
    intro G hG
    exact hG.2.2

end IdentityArchitecture
