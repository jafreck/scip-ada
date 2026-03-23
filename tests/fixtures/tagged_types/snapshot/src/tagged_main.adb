  with Ada.Text_IO;
//     ^^^ reference scip-ada . Tagged_Types . Ada/
//         ^^^^^^^ reference scip-ada . Tagged_Types . Text_IO/
  with Shapes;
//     ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
  
  procedure Tagged_Main is
//          ^^^^^^^^^^^ definition scip-ada . Tagged_Types . Tagged_Main().
//          kind Function
//          ^^^^^^^^^^^ definition scip-ada . Tagged_Types . Tagged_Main().
//          kind Function
     C : Shapes.Circle := (X => 0.0, Y => 0.0, Radius => 5.0);
//   ^ definition scip-ada . Tagged_Types . C#
//   kind Struct
//              ^^^^^^ reference scip-ada . Tagged_Types . Circle#
//                         ^ reference scip-ada . Tagged_Types . X.
//                                   ^ reference scip-ada . Tagged_Types . Y.
//                                             ^^^^^^ reference scip-ada . Tagged_Types . Radius.
     R : Shapes.Rectangle := (X => 1.0, Y => 2.0, Width => 3.0, Height => 4.0);
//   ^ definition scip-ada . Tagged_Types . R#
//   kind Struct
//              ^^^^^^^^^ reference scip-ada . Tagged_Types . Rectangle#
//                                                ^^^^^ reference scip-ada . Tagged_Types . Width.
//                                                              ^^^^^^ reference scip-ada . Tagged_Types . Height.
  
     procedure Print_Area (S : Shapes.Shape'Class) is
//             ^^^^^^^^^^ definition scip-ada . Tagged_Types . Print_Area().
//             kind Function
//             ^^^^^^^^^^ definition scip-ada . Tagged_Types . Print_Area().
//             kind Function
//                         ^ definition scip-ada . Tagged_Types . S#
//                         kind Type
//                                    ^^^^^ reference scip-ada . Tagged_Types . Shape#
     begin
        Ada.Text_IO.Put_Line ("Area:" & Float'Image (Shapes.Area (S)));
//                  ^^^^^^^^ reference scip-ada . Tagged_Types . Put_Line().
//                                                          ^^^^ reference scip-ada . Tagged_Types . Area().
//                                                                ^ reference scip-ada . Tagged_Types . S#
     end Print_Area;
//       ^^^^^^^^^^ reference scip-ada . Tagged_Types . Print_Area().
//                 ^^^^^^^^^^ reference scip-ada . Tagged_Types . Print_Area().
  begin
     Print_Area (S => C);
//   ^^^^^^^^^^ reference scip-ada . Tagged_Types . Print_Area().
//               ^ reference scip-ada . Tagged_Types . S#
//                    ^ reference scip-ada . Tagged_Types . C#
     Print_Area (S => R);
//   ^^^^^^^^^^ reference scip-ada . Tagged_Types . Print_Area().
//               ^ reference scip-ada . Tagged_Types . S#
//                    ^ reference scip-ada . Tagged_Types . R#
  
     Shapes.Move (C, 1.0, 2.0);
//          ^^^^ reference scip-ada . Tagged_Types . Move().
//                ^ reference scip-ada . Tagged_Types . C#
     Ada.Text_IO.Put_Line ("Circle moved to:" &
                            Float'Image (C.X) & "," & Float'Image (C.Y));
//                                       ^ reference scip-ada . Tagged_Types . C#
//                                                                 ^ reference scip-ada . Tagged_Types . C#
  end Tagged_Main;
//    ^^^^^^^^^^^ reference scip-ada . Tagged_Types . Tagged_Main().
//               ^^^^^^^^^^^ reference scip-ada . Tagged_Types . Tagged_Main().
  
