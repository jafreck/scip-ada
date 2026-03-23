  package Utils.Strings is
//        ^^^^^ reference scip-ada . . . Utils/
//              ^^^^^^^ definition scip-ada . . . Strings/
//              kind Namespace
     function Repeat_Char (C : Character; Count : Natural) return String;
//            ^^^^^^^^^^^ definition scip-ada . . . Repeat_Char().
//            kind Function
//            documentation
//            > function Repeat_Char (C : Character; Count : Natural) return String
//                         ^ definition scip-ada . . . C.
//                         kind Variable
//                         documentation
//                         > function Repeat_Char (C : Character; Count : Natural) return String
//                                        ^^^^^ definition scip-ada . . . Count.
//                                        kind Variable
//                                        documentation
//                                        > function Repeat_Char (C : Character; Count : Natural) return String
  end Utils.Strings;
//          ^^^^^^^ reference scip-ada . . . Strings/
//                 ^^^^^^^ reference scip-ada . . . Strings/
//                            ^^^^^ reference scip-ada . . . Count.
//                                                 ^ reference scip-ada . . . C.
  
