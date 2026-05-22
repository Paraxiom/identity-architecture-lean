/-
Stratification + Stratum well-foundedness (Theorem 6.2).

Five strata: S1 Person, S2 Scoped, S3 Vault, S4 Agent instance,
S5 Cross-tenant. The chain registration discipline requires every
S2 / S4 / S5 identity to carry a parent reference, with the parent's
block height strictly less than the child's.

Well-foundedness then says: every non-S1 identity traces in finite
steps to an S1. This is genuinely non-trivial --- it relies on
strong induction over block heights.
-/

import IdentityArchitecture.Basic
import Mathlib.Data.Nat.Basic

namespace IdentityArchitecture

/-- The five identity strata. -/
inductive Stratum
  | s1Person
  | s2Scoped
  | s3Vault
  | s4AgentInstance
  | s5CrossTenant
  deriving DecidableEq, Repr

/-- A stratified identity record on the chain: id, stratum, optional
parent id, and the block height at which the record was registered. -/
structure StratifiedIdentity where
  id           : Nat
  stratum      : Stratum
  parentId     : Option Nat   -- None iff stratum = s1Person
  blockHeight  : Nat
  deriving Repr

/-- An identity registry: a finite list of stratified identities. -/
abbrev Registry := List StratifiedIdentity

/-- Lookup an identity by its id. -/
def Registry.lookup (R : Registry) (target : Nat) : Option StratifiedIdentity :=
  R.find? (fun I => I.id == target)

/-- The chain-discipline invariant. Three clauses:
(i)  every S1 identity has no parent;
(ii) every non-S1 identity has a parent that exists in the registry;
(iii) the parent's block height is strictly less than the child's.

This invariant is what the registration extrinsic enforces in the
runtime. -/
structure ChainDiscipline (R : Registry) : Prop where
  s1_no_parent :
    ∀ I ∈ R, I.stratum = Stratum.s1Person → I.parentId = none
  nons1_has_parent :
    ∀ I ∈ R, I.stratum ≠ Stratum.s1Person →
      ∃ pid, I.parentId = some pid ∧ ∃ P ∈ R, P.id = pid
  parent_height_strict :
    ∀ I ∈ R, ∀ pid, I.parentId = some pid →
      ∀ P ∈ R, P.id = pid → P.blockHeight < I.blockHeight

/-- "J is the n-step ancestor of I in R": there is a chain of length n
of parent pointers from I to J in R. -/
inductive AncestorAt (R : Registry) : Nat → StratifiedIdentity → StratifiedIdentity → Prop
  | refl  (I : StratifiedIdentity) : AncestorAt R 0 I I
  | step  {n : Nat} {I J P : StratifiedIdentity}
          (hI : I ∈ R)
          (hP_in : P ∈ R)
          (hPid : I.parentId = some P.id)
          (hJ : AncestorAt R n P J) : AncestorAt R (n + 1) I J

/-- **Theorem 6.2 (Stratum well-foundedness).** Under the chain
discipline, every identity in the registry has an S1 ancestor in
finitely many steps.

Proof: strong induction on block height. If I is S1, the 0-step
ancestor is I itself. If I is non-S1, it has a parent P in R with
strictly smaller block height; by induction P reaches an S1 in
finitely many steps, so I does too. -/
theorem stratum_wellfoundedness
    (R : Registry) (hCD : ChainDiscipline R) :
    ∀ I ∈ R, ∃ n J, J ∈ R ∧ J.stratum = Stratum.s1Person ∧ AncestorAt R n I J := by
  -- Strengthen: prove the statement for all identities with blockHeight ≤ k,
  -- by induction on k.
  suffices h : ∀ k : Nat, ∀ I ∈ R, I.blockHeight ≤ k →
      ∃ n J, J ∈ R ∧ J.stratum = Stratum.s1Person ∧ AncestorAt R n I J by
    intro I hI
    exact h I.blockHeight I hI (Nat.le_refl _)
  intro k
  induction k with
  | zero =>
    intro I hI hbh
    by_cases hS1 : I.stratum = Stratum.s1Person
    · exact ⟨0, I, hI, hS1, AncestorAt.refl I⟩
    · -- I has a parent P with P.blockHeight < I.blockHeight ≤ 0 — impossible
      obtain ⟨pid, hpid, P, hP_in, hP_id⟩ := hCD.nons1_has_parent I hI hS1
      have hP_lt : P.blockHeight < I.blockHeight :=
        hCD.parent_height_strict I hI pid hpid P hP_in hP_id
      have hI0 : I.blockHeight = 0 := Nat.le_zero.mp hbh
      omega
  | succ n ih =>
    intro I hI hbh
    by_cases hS1 : I.stratum = Stratum.s1Person
    · exact ⟨0, I, hI, hS1, AncestorAt.refl I⟩
    · obtain ⟨pid, hpid, P, hP_in, hP_id⟩ := hCD.nons1_has_parent I hI hS1
      have hP_lt : P.blockHeight < I.blockHeight :=
        hCD.parent_height_strict I hI pid hpid P hP_in hP_id
      have hP_le_n : P.blockHeight ≤ n := by omega
      obtain ⟨m, J, hJ_in, hJ_S1, hAncP⟩ := ih P hP_in hP_le_n
      refine ⟨m + 1, J, hJ_in, hJ_S1, ?_⟩
      have hpidP : I.parentId = some P.id := hP_id ▸ hpid
      exact AncestorAt.step hI hP_in hpidP hAncP

end IdentityArchitecture
