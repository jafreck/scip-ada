  package body Ada2022_Types is
//             ^^^^^^^^^^^^^ definition scip-ada . . . Ada2022_Types/
  
     function Is_Valid (Value : Positive_Int) return Boolean is
//            ^^^^^^^^ definition scip-ada . . . Is_Valid().
//                      ^^^^^ definition scip-ada . . . Value#
//                              ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
     begin
        return Value.Value > 0;
//                   ^^^^^ reference scip-ada . . . Value.
     end Is_Valid;
  
     function Make (V : Positive) return Positive_Int is
//            ^^^^ definition scip-ada . . . Make().
//                  ^ definition scip-ada . . . V.
     begin
        return (Value => V);
     end Make;
  
     function Get (Value : Positive_Int) return Positive is
//            ^^^ definition scip-ada . . . Get().
//                 ^^^^^ definition scip-ada . . . Value#
     begin
        return Value.Value;
     end Get;
  
     function Area (S : Shape) return Float is
//            ^^^^ definition scip-ada . . . Area().
//                  ^ definition scip-ada . . . S#
//                      ^^^^^ reference scip-ada . . . Shape#
        pragma Unreferenced (S);
     begin
        return 0.0;
     end Area;
  
     function Area (S : Circle) return Float is
//            ^^^^ definition scip-ada . . . Area().
//                  ^ definition scip-ada . . . S#
//                      ^^^^^^ reference scip-ada . . . Circle#
     begin
        return 3.14159 * S.Radius * S.Radius;
//                         ^^^^^^ reference scip-ada . . . Radius.
     end Area;
  
  end Ada2022_Types;
  
