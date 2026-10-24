// RUN: not veir-opt %s 2>&1 | filecheck %s

// CHECK: error: SMT bit-vector value does not fit in the given bit-width
"builtin.module"() ({
  "func.func"() <{sym_name = "f", function_type = () -> !smt.bv<8>}> ({
  ^bb0:
    %0 = "smt.bv.constant"() <{"value" = #smt.bv<256> : !smt.bv<8>}> : () -> !smt.bv<8>
    "func.return"(%0) : (!smt.bv<8>) -> ()
  }) : () -> ()
}) : () -> ()
