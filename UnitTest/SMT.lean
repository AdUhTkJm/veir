import Veir.Interpreter.Evaluate

/-! Tests for the symbolic semantics of the SMT dialect. -/

open Veir

private def bv8 : TypeAttr := TypeAttr.of SMT.SortType (.bv 8)
private def bv16 : TypeAttr := TypeAttr.of SMT.SortType (.bv 16)
private def boolTy : TypeAttr := TypeAttr.of SMT.SortType .bool

/-- `smt.bv.add` builds the corresponding SMT term instead of computing a
    bit-vector. -/
private def testSMTBvAdd : String := Id.run do
  let lhs := SMT.Term.bvConst 8 3
  let rhs := SMT.Term.bvConst 8 5
  let .ok results :=
    (foldEvaluate (.smt .bv__add) () #[bv8] #[.smt lhs, .smt rhs]
      : Interp (Array RuntimeValue))
    | return "smt.bv.add did not evaluate"
  if results.toList ≠ [.smt (.bvAdd 8 lhs rhs)] then
    return "smt.bv.add produced an unexpected term"
  return "ok"

/--
info: "ok"
-/
#guard_msgs in
#eval! testSMTBvAdd

/-- `smt.bv.neg` is represented by a `bvNeg` node carrying the operand's width. -/
private def testSMTBvNeg : String := Id.run do
  let operand := SMT.Term.bvVar 8 "x"
  let .ok results :=
    (foldEvaluate (.smt .bv__neg) () #[bv8] #[.smt operand]
      : Interp (Array RuntimeValue))
    | return "smt.bv.neg did not evaluate"
  if results.toList ≠ [.smt (.bvNeg 8 operand)] then
    return "smt.bv.neg produced an unexpected term"
  return "ok"

/--
info: "ok"
-/
#guard_msgs in
#eval! testSMTBvNeg

/-- `smt.eq` produces a Boolean term from two terms of the same sort. -/
private def testSMTEq : String := Id.run do
  let lhs := SMT.Term.bvConst 16 42
  let rhs := SMT.Term.bvVar 16 "y"
  let .ok results :=
    (foldEvaluate (.smt .eq) () #[boolTy] #[.smt lhs, .smt rhs]
      : Interp (Array RuntimeValue))
    | return "smt.eq did not evaluate"
  if results.toList ≠ [.smt (.eq lhs rhs)] then
    return "smt.eq produced an unexpected term"
  return "ok"

/--
info: "ok"
-/
#guard_msgs in
#eval! testSMTEq

/-- Applying a bit-vector operation to mismatched widths is an interpreter
    failure, not a silently ill-sorted term. -/
private def testSMTWidthMismatch : String := Id.run do
  let .fail _ :=
    (foldEvaluate (.smt .bv__add) () #[bv8]
      #[.smt (.bvConst 8 1), .smt (.bvConst 16 1)] : Interp (Array RuntimeValue))
    | return "smt.bv.add accepted operands of different widths"
  return "ok"

/--
info: "ok"
-/
#guard_msgs in
#eval! testSMTWidthMismatch

/-- An SMT result whose declared sort does not match the constructed term is a
    failure. -/
private def testSMTResultSortMismatch : String := Id.run do
  let .fail _ :=
    (foldEvaluate (.smt .bv__add) () #[bv16]
      #[.smt (.bvConst 8 1), .smt (.bvConst 8 2)] : Interp (Array RuntimeValue))
    | return "smt.bv.add produced a result of the wrong sort"
  return "ok"

/--
info: "ok"
-/
#guard_msgs in
#eval! testSMTResultSortMismatch
