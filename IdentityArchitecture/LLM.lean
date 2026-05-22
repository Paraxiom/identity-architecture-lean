/-
LLM substrate vs. instance + LLM instance non-identity (Theorem 7.3).

Two LLM instances with the same weights blob but distinct deployment
identifiers are distinct identity loci. The theorem is close to
definitional once the substrate/instance distinction is made; the
Lean formalization makes that crystal-clear.
-/

import IdentityArchitecture.Basic

namespace IdentityArchitecture

/-- An LLM substrate: weights hash, tokenizer/architecture spec hash,
training-run attestation hash. -/
structure LLMSubstrate where
  weightsHash       : Nat
  archSpecHash      : Nat
  trainingRunHash   : Nat
  deriving DecidableEq, Repr

/-- An LLM instance: reference to a substrate, a deployment identifier,
and (opaque) conversational state. Two instances of the *same*
substrate with *different* deployment ids are distinct as identity
loci. -/
structure LLMInstance where
  substrateRef     : LLMSubstrate
  deploymentId     : Nat
  conversationState : Nat   -- opaque
  deriving DecidableEq, Repr

/-- **Theorem 7.3 (LLM instance non-identity).** Two LLM instances
with identical substrate reference but distinct deployment identifiers
are distinct.

Proof: structural --- inequality of the `deploymentId` field implies
inequality of the records. -/
theorem llm_instance_non_identity
    (I₁ I₂ : LLMInstance)
    (h_same_substrate : I₁.substrateRef = I₂.substrateRef)
    (h_diff_deployment : I₁.deploymentId ≠ I₂.deploymentId) :
    I₁ ≠ I₂ := by
  intro h_eq
  apply h_diff_deployment
  rw [h_eq]

end IdentityArchitecture
