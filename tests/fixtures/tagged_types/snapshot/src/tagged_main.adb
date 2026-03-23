  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  with Shapes;
//     ^^^^^^ reference scip-ada . . . Shapes/
  
  procedure Tagged_Main is
//          ^^^^^^^^^^^ definition scip-ada . . . Tagged_Main().
//          kind Function
//          documentation
//          > procedure Tagged_Main
//          ^^^^^^^^^^^ definition scip-ada . . . Tagged_Main().
//          kind Function
//          documentation
//          > procedure Tagged_Main
     C : Shapes.Circle := (X => 0.0, Y => 0.0, Radius => 5.0);
//   ^ definition scip-ada . . . C#
//   kind Struct
//              ^^^^^^ reference scip-ada . . . Circle#
//                         ^ reference scip-ada . . . X.
//                                   ^ reference scip-ada . . . Y.
//                                             ^^^^^^ reference scip-ada . . . Radius.
     R : Shapes.Rectangle := (X => 1.0, Y => 2.0, Width => 3.0, Height => 4.0);
//   ^ definition scip-ada . . . R#
//   kind Struct
//              ^^^^^^^^^ reference scip-ada . . . Rectangle#
//                                                ^^^^^ reference scip-ada . . . Width.
//                                                              ^^^^^^ reference scip-ada . . . Height.
  
     procedure Print_Area (S : Shapes.Shape'Class) is
//             ^^^^^^^^^^ definition scip-ada . . . Print_Area().
//             kind Function
//             documentation
//             > procedure Print_Area (S : Shapes.Shape'Class)
//             ^^^^^^^^^^ definition scip-ada . . . Print_Area().
//             kind Function
//             documentation
//             > procedure Print_Area (S : Shapes.Shape'Class)
//                         ^ definition scip-ada . . . S#
//                         kind Type
//                         documentation
//                         > procedure Print_Area (S : Shapes.Shape'Class)
//                                    ^^^^^ reference scip-ada . . . Shape#
     begin
        Ada.Text_IO.Put_Line ("Area:" & Float'Image (Shapes.Area (S)));
//                  ^^^^^^^^ reference scip-ada . . . Put_Line().
//                                                          ^^^^ reference scip-ada . . . Area().
//                                                                ^ reference scip-ada . . . S#
     end Print_Area;
//       ^^^^^^^^^^ reference scip-ada . . . Print_Area().
//                 ^^^^^^^^^^ reference scip-ada . . . Print_Area().
  begin
     Print_Area (S => C);
//   ^^^^^^^^^^ reference scip-ada . . . Print_Area().
//               ^ reference scip-ada . . . S#
//                    ^ reference scip-ada . . . C#
     Print_Area (S => R);
//   ^^^^^^^^^^ reference scip-ada . . . Print_Area().
//               ^ reference scip-ada . . . S#
//                    ^ reference scip-ada . . . R#
  
     Shapes.Move (C, 1.0, 2.0);
//          ^^^^ reference scip-ada . . . Move().
//                ^ reference scip-ada . . . C#
     Ada.Text_IO.Put_Line ("Circle moved to:" &
                            Float'Image (C.X) & "," & Float'Image (C.Y));
//                                       ^ reference scip-ada . . . C#
//                                                                 ^ reference scip-ada . . . C#
  end Tagged_Main;
//    ^^^^^^^^^^^ reference scip-ada . . . Tagged_Main().
//               ^^^^^^^^^^^ reference scip-ada . . . Tagged_Main().
  
