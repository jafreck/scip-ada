  package body Ada2022_Types is
//             ^^^^^^^^^^^^^ definition scip-ada . Ada2022 . Ada2022_Types/
  
     function Is_Valid (Value : Positive_Int) return Boolean is
//            ^^^^^^^^ definition scip-ada . Ada2022 . Is_Valid().
//                      ^^^^^ definition scip-ada . Ada2022 . Value#
//                              ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
     begin
        return Value.Value > 0;
//                   ^^^^^ reference scip-ada . Ada2022 . Value.
     end Is_Valid;
  
     function Make (V : Positive) return Positive_Int is
//            ^^^^ definition scip-ada . Ada2022 . Make().
//                  ^ definition scip-ada . Ada2022 . V.
     begin
        return (Value => V);
     end Make;
  
     function Get (Value : Positive_Int) return Positive is
//            ^^^ definition scip-ada . Ada2022 . Get().
//                 ^^^^^ definition scip-ada . Ada2022 . Value#
     begin
        return Value.Value;
     end Get;
  
     function Area (S : Shape) return Float is
//            ^^^^ definition scip-ada . Ada2022 . Area().
//                  ^ definition scip-ada . Ada2022 . S#
//                      ^^^^^ reference scip-ada . Ada2022 . Shape#
        pragma Unreferenced (S);
     begin
        return 0.0;
     end Area;
  
     function Area (S : Circle) return Float is
//            ^^^^ definition scip-ada . Ada2022 . Area().
//                  ^ definition scip-ada . Ada2022 . S#
//                      ^^^^^^ reference scip-ada . Ada2022 . Circle#
     begin
        return 3.14159 * S.Radius * S.Radius;
//                         ^^^^^^ reference scip-ada . Ada2022 . Radius.
     end Area;
  
  end Ada2022_Types;
  
