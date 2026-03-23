  package body Utils.Strings is
//             ^^^^^ reference scip-ada . Multi_Unit . Utils/
//                   ^^^^^^^ definition scip-ada . Multi_Unit . Strings/
     function Repeat_Char (C : Character; Count : Natural) return String is
//            ^^^^^^^^^^^ definition scip-ada . Multi_Unit . Repeat_Char().
//                         ^ definition scip-ada . Multi_Unit . C.
//                                        ^^^^^ definition scip-ada . Multi_Unit . Count.
        Result : String (1 .. Count) := (others => C);
//      ^^^^^^ definition scip-ada . Multi_Unit . Result.
//      kind Variable
     begin
        return Result;
//             ^^^^^^ reference scip-ada . Multi_Unit . Result.
     end Repeat_Char;
  end Utils.Strings;
  
