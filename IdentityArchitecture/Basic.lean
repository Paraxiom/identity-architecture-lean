/-
Identity as Accountability Chain — Lean 4 formalization
Basic types and primitives.

Companion to:
  Cormier, S. *Identity as Accountability Chain: A Post-Quantum
  Architecture for Persistent Identity Across Human, Machine, and
  AI Agent Substrates.* Paraxiom Technologies Inc., May 2026.
  Zenodo DOI: 10.5281/zenodo.20328038 (forthcoming)

This file fixes the primitive types used throughout the formalization.
The biological / hardware / weights / good content of the substrate is
opaque at the model layer; we represent substrates by a typed
identifier.
-/

namespace IdentityArchitecture

/-- Discrete time as natural numbers (block height in the chain
realization). -/
abbrev Time := Nat

/-- The six accretion layers L₀…L₅ of the model. -/
inductive Layer
  | l0Substrate
  | l1Narrative
  | l2Relational
  | l3Cryptographic
  | l4Civic
  | l5Behavioral
  deriving DecidableEq, Repr

/-- A substrate is opaque at this level; what matters is identity and
discreteness. -/
structure Substrate where
  id : Nat
  deriving DecidableEq, Repr

/-- A claim in the accretion chain: layer tag, time, opaque content,
opaque signature/witness, optional prior reference. -/
structure Claim where
  layer    : Layer
  time     : Time
  content  : Nat           -- opaque payload (a hash in practice)
  witness  : Nat           -- opaque signature/witness identifier
  refIdx   : Option Nat    -- index of prior referenced claim, if any
  deriving Repr

/-- Founding event: substrate, time, witness set. -/
structure FoundingEvent where
  substrate : Substrate
  time      : Time
  witnesses : List Nat
  deriving Repr

end IdentityArchitecture
