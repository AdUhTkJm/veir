module

public import Veir.IR.Attribute
public import Std.Data.HashMap

namespace Veir

public section

/--
  Properties of the `smt.bv.constant` operation.
-/
structure SMTBitVectorConstantProperties where
  value : SMT.BitVectorAttr
deriving Inhabited, Repr, Hashable, DecidableEq

def SMTBitVectorConstantProperties.fromAttrDict
    (attrDict : Std.HashMap ByteArray Attribute) :
    Except String SMTBitVectorConstantProperties := do
  if attrDict.size > 1 then
    throw s!"smt.bv.constant: expected only 'value' property, but got {attrDict.size} properties"
  let some attr := attrDict["value".toUTF8]?
    | throw "smt.bv.constant: missing 'value' property"
  let .smtBitVectorAttr bvAttr := attr
    | throw s!"smt.bv.constant: expected 'value' to be an SMT bit-vector attribute, but got {attr}"
  return { value := bvAttr }

end

end Veir
