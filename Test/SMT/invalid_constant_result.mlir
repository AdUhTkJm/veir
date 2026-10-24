// RUN: not veir-opt %s 2>&1 | filecheck %s

// CHECK: Error verifying input program: smt.bv.constant: Expected result 0 type to match the constant's bit-vector sort
"builtin.module"() ({
  "func.func"() <{sym_name = "f", function_type = () -> !smt.bv<16>}> ({
  ^bb0:
    %0 = "smt.bv.constant"() <{"value" = #smt.bv<92> : !smt.bv<8>}> : () -> !smt.bv<16>
    "func.return"(%0) : (!smt.bv<16>) -> ()
  }) : () -> ()
}) : () -> ()
