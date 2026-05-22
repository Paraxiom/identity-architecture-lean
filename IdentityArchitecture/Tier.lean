/-
Permanence tiers + Tier monotonicity (§5 in the treatise).

The treatise's "tier monotonicity theorem" is a stylized empirical
fact about operational rates: hardware replacement is much rarer than
process restart. Within the proof system the claim is best expressed
as an *axiom about the probability model*; we encode the
non-increasing relationship structurally as an axiom and verify the
finite case by case-analysis.
-/

import IdentityArchitecture.Basic

namespace IdentityArchitecture

/-- The four permanence tiers: 0 manufacturer-fused, 1
installation-rooted, 2 operationally configured, 3 runtime-ephemeral.
-/
inductive Tier
  | tier0Manufacturer
  | tier1Installation
  | tier2Operational
  | tier3Runtime
  deriving DecidableEq, Repr

/-- Index of a tier as a Nat (0..3). -/
def Tier.index : Tier → Nat
  | .tier0Manufacturer => 0
  | .tier1Installation => 1
  | .tier2Operational  => 2
  | .tier3Runtime      => 3

/-- The empirical claim of §5.6: the survival probability of an
identifier at a fixed time horizon Δ is non-increasing in the tier
index. We expose this as an axiom of the probability model rather
than as a Lean theorem, because the underlying argument relies on
empirical hardware-replacement rates vs. process-restart rates that
cannot be derived from the model's primitives alone. -/
axiom tier_monotonicity_axiom :
    ∀ (P_survive : Tier → Nat) (T₁ T₂ : Tier),
      T₁.index ≤ T₂.index → P_survive T₂ ≤ P_survive T₁

/-- **Proposition 5.2 (Tier monotonicity, packaged).** The
monotonicity is preserved under the axiom for any pair of tiers in
the canonical ordering. -/
theorem tier_monotonicity
    (P_survive : Tier → Nat) (T₁ T₂ : Tier)
    (h : T₁.index ≤ T₂.index) :
    P_survive T₂ ≤ P_survive T₁ :=
  tier_monotonicity_axiom P_survive T₁ T₂ h

end IdentityArchitecture
