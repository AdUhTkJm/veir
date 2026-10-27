module

public import Veir.IR.Attribute

namespace Veir.Data.SMT

open Veir.SMT

public section

/--
  The operational semantics of SMT terms are defined to be a symbolic AST.
-/
inductive Term where
| bvConst (width : Nat) (value : BitVec width)
| bvVar (width : Nat) (name : String)
| bvAdd (width : Nat) (lhs rhs : Term)
| bvNeg (width : Nat) (operand : Term)
| eq (lhs rhs : Term)
deriving Inhabited, Repr, Hashable, BEq, DecidableEq

def Term.sort : Term → SortType
  | .bvConst width _ => .bv width
  | .bvVar width _ => .bv width
  | .bvAdd width _ _ => .bv width
  | .bvNeg width _ => .bv width
  | .eq _ _ => .bool

def Term.bvWidth? (term : Term) : Option Nat := term.sort.bvWidth?

/-- Print a term in SMT-LIB syntax. -/
def Term.toString : Term → String
  | .bvConst width value => s!"(_ bv{value.toNat} {width})"
  | .bvVar _ name => name
  | .bvAdd _ lhs rhs => s!"(bvadd {Term.toString lhs} {Term.toString rhs})"
  | .bvNeg _ operand => s!"(bvneg {Term.toString operand})"
  | .eq lhs rhs => s!"(= {Term.toString lhs} {Term.toString rhs})"

instance : ToString Term where
  toString := Term.toString

end

end Veir.Data.SMT
