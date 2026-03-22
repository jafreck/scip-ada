  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  
  package body Shapes is
//             ^^^^^^ definition scip-ada . . . Shapes/
     procedure Move (S : in out Shape; DX, DY : Float) is
//             ^^^^ definition scip-ada . . . Move().
//                   ^ definition scip-ada . . . S#
//                              ^^^^^ reference scip-ada . . . Shape#
//                                     ^^ definition scip-ada . . . DX.
//                                         ^^ definition scip-ada . . . DY.
     begin
        S.X := S.X + DX;
//        ^ reference scip-ada . . . X.
        S.Y := S.Y + DY;
//        ^ reference scip-ada . . . Y.
     end Move;
  
     overriding function Area (S : Circle) return Float is
//                       ^^^^ definition scip-ada . . . Area().
//                             ^ definition scip-ada . . . S#
//                                 ^^^^^^ reference scip-ada . . . Circle#
        Pi : constant Float := 3.14159;
//      ^^ definition scip-ada . . . Pi.
     begin
        return Pi * S.Radius * S.Radius;
//             ^^ reference scip-ada . . . Pi.
//                    ^^^^^^ reference scip-ada . . . Radius.
     end Area;
  
     overriding procedure Draw (S : Circle) is
//                        ^^^^ definition scip-ada . . . Draw().
//                              ^ definition scip-ada . . . S#
     begin
        Ada.Text_IO.Put_Line ("Drawing circle");
//                  ^^^^^^^^ reference scip-ada . . . Put_Line().
     end Draw;
  
     overriding function Area (S : Rectangle) return Float is
//                       ^^^^ definition scip-ada . . . Area().
//                             ^ definition scip-ada . . . S#
//                                 ^^^^^^^^^ reference scip-ada . . . Rectangle#
     begin
        return S.Width * S.Height;
//               ^^^^^ reference scip-ada . . . Width.
//                         ^^^^^^ reference scip-ada . . . Height.
     end Area;
  end Shapes;
  
