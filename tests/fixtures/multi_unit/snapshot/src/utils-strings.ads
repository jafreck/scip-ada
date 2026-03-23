  package Utils.Strings is
//        ^^^^^ reference scip-ada . Multi_Unit . Utils/
//              ^^^^^^^ definition scip-ada . Multi_Unit . Strings/
//              kind Namespace
     function Repeat_Char (C : Character; Count : Natural) return String;
//            ^^^^^^^^^^^ definition scip-ada . Multi_Unit . Repeat_Char().
//            kind Function
//                         ^ definition scip-ada . Multi_Unit . C.
//                         kind Variable
//                                        ^^^^^ definition scip-ada . Multi_Unit . Count.
//                                        kind Variable
  end Utils.Strings;
//          ^^^^^^^ reference scip-ada . Multi_Unit . Strings/
//                 ^^^^^^^ reference scip-ada . Multi_Unit . Strings/
//                            ^^^^^ reference scip-ada . Multi_Unit . Count.
//                                                 ^ reference scip-ada . Multi_Unit . C.
  
