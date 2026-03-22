  package body Utils.Strings is
//             ^^^^^ reference scip-ada . . . Utils/
//                   ^^^^^^^ definition scip-ada . . . Strings/
     function Repeat_Char (C : Character; Count : Natural) return String is
//            ^^^^^^^^^^^ definition scip-ada . . . Repeat_Char().
//                         ^ definition scip-ada . . . C.
//                                        ^^^^^ definition scip-ada . . . Count.
        Result : String (1 .. Count) := (others => C);
//      ^^^^^^ definition scip-ada . . . Result.
     begin
        return Result;
//             ^^^^^^ reference scip-ada . . . Result.
     end Repeat_Char;
  end Utils.Strings;
  
