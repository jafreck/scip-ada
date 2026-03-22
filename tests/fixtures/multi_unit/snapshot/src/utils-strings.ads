  package Utils.Strings is
//        ^^^^^ reference scip-ada . . . Utils/
//              ^^^^^^^ definition scip-ada . . . Strings/
     function Repeat_Char (C : Character; Count : Natural) return String;
//            ^^^^^^^^^^^ definition scip-ada . . . Repeat_Char().
//            documentation
//            > function Repeat_Char (C : Character; Count : Natural) return String
//                         ^ definition scip-ada . . . C.
//                         documentation
//                         > function Repeat_Char (C : Character; Count : Natural) return String
//                                        ^^^^^ definition scip-ada . . . Count.
//                                        documentation
//                                        > function Repeat_Char (C : Character; Count : Natural) return String
  end Utils.Strings;
//          ^^^^^^^ reference scip-ada . . . Strings/
//                 ^^^^^^^ reference scip-ada . . . Strings/
//                            ^^^^^ reference scip-ada . . . Count.
//                                                 ^ reference scip-ada . . . C.
  
