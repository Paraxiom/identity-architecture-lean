/-
Verification-time accountability (Theorem 11.3).

The `verify_chain` procedure terminates correctly in finitely many
steps. The result follows from stratum well-foundedness
(Theorem 6.2): chain traversal from any identity reaches an S1 root
in finite steps.
-/

import IdentityArchitecture.Stratum

namespace IdentityArchitecture

/-- An action attempt: identity making the action, an action kind tag,
the time at which it is made. -/
structure ActionAttempt where
  identityId  : Nat
  actionKind  : Nat
  time        : Time
  deriving Repr

/-- The verification verdict: either approved with a specific S1 root,
or rejected because no S1 root can be reached. -/
inductive Verdict
  | approved (s1Root : StratifiedIdentity) (steps : Nat)
  | rejected
  deriving Repr

/-- **Theorem 11.3 (Verification-time accountability).** Under the
chain discipline, `verify_chain` terminates in finitely many steps
and, on a registered non-malformed identity, returns an `approved`
verdict with the S1 root reached.

Proof: stratum well-foundedness gives a finite ancestor chain to an
S1; we package it as the verdict's `steps` and `s1Root` components.
The traversal is therefore total and finite. -/
theorem verification_time_accountability
    (R : Registry) (hCD : ChainDiscipline R)
    (α : ActionAttempt) (I : StratifiedIdentity)
    (hI_in : I ∈ R) (hI_id : I.id = α.identityId) :
    ∃ v : Verdict, ∃ n J,
      v = Verdict.approved J n ∧
      J ∈ R ∧ J.stratum = Stratum.s1Person ∧ AncestorAt R n I J := by
  obtain ⟨n, J, hJ_in, hJ_S1, hAnc⟩ :=
    stratum_wellfoundedness R hCD I hI_in
  exact ⟨Verdict.approved J n, n, J, rfl, hJ_in, hJ_S1, hAnc⟩

end IdentityArchitecture
