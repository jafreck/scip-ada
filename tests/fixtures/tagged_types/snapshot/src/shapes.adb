  with Ada.Text_IO;
//     ^^^ reference scip-ada . Tagged_Types . Ada/
//         ^^^^^^^ reference scip-ada . Tagged_Types . Text_IO/
  
  package body Shapes is
//             ^^^^^^ definition scip-ada . Tagged_Types . Shapes/
     procedure Move (S : in out Shape; DX, DY : Float) is
//             ^^^^ definition scip-ada . Tagged_Types . Move().
//                   ^ definition scip-ada . Tagged_Types . S#
//                              ^^^^^ reference scip-ada . Tagged_Types . Shape#
//                                     ^^ definition scip-ada . Tagged_Types . DX.
//                                         ^^ definition scip-ada . Tagged_Types . DY.
     begin
        S.X := S.X + DX;
//        ^ reference scip-ada . Tagged_Types . X.
        S.Y := S.Y + DY;
//        ^ reference scip-ada . Tagged_Types . Y.
     end Move;
  
     overriding function Area (S : Circle) return Float is
//                       ^^^^ definition scip-ada . Tagged_Types . Area().
//                             ^ definition scip-ada . Tagged_Types . S#
//                                 ^^^^^^ reference scip-ada . Tagged_Types . Circle#
        Pi : constant Float := 3.14159;
//      ^^ definition scip-ada . Tagged_Types . Pi.
//      kind Variable
     begin
        return Pi * S.Radius * S.Radius;
//             ^^ reference scip-ada . Tagged_Types . Pi.
//                    ^^^^^^ reference scip-ada . Tagged_Types . Radius.
     end Area;
  
     overriding procedure Draw (S : Circle) is
//                        ^^^^ definition scip-ada . Tagged_Types . Draw().
//                              ^ definition scip-ada . Tagged_Types . S#
     begin
        Ada.Text_IO.Put_Line ("Drawing circle");
//                  ^^^^^^^^ reference scip-ada . Tagged_Types . Put_Line().
     end Draw;
  
     overriding function Area (S : Rectangle) return Float is
//                       ^^^^ definition scip-ada . Tagged_Types . Area().
//                             ^ definition scip-ada . Tagged_Types . S#
//                                 ^^^^^^^^^ reference scip-ada . Tagged_Types . Rectangle#
     begin
        return S.Width * S.Height;
//               ^^^^^ reference scip-ada . Tagged_Types . Width.
//                         ^^^^^^ reference scip-ada . Tagged_Types . Height.
     end Area;
  end Shapes;
  
