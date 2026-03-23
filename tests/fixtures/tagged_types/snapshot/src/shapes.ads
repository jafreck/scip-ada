  --  Geometric shape hierarchy for 2D figures
  package Shapes is
//        ^^^^^^ definition scip-ada . . . Shapes/
//        kind Namespace
     --  Drawable interface for rendering capability
     type Drawable is interface;
//        ^^^^^^^^ definition scip-ada . . . Drawable().
//        kind Interface
//        ^^^^^^^^ definition scip-ada . . . Drawable#
//        kind Interface
  
//       ^^^^^^ reference scip-ada . . . Shapes/
     --  Draw the object
//      ^ reference scip-ada . . . S#
//       ^^^^^^ reference scip-ada . . . Shapes/
//             ^ reference scip-ada . . . S#
//               ^ reference scip-ada . . . X.
//                   ^^ reference scip-ada . . . DX.
//                            ^ reference scip-ada . . . X.
//                                      ^ reference scip-ada . . . Y.
     procedure Draw (D : Drawable) is abstract;
//      ^ reference scip-ada . . . S#
//             ^ reference scip-ada . . . S#
//             ^^^^ definition scip-ada . . . Draw().
//             kind Function
//             documentation
//             > procedure Draw (D : Drawable)
//             ^^^^^^^^ reference scip-ada . . . Drawable().
//               ^ reference scip-ada . . . Y.
//                   ^ definition scip-ada . . . D#
//                   kind Struct
//                   documentation
//                   > procedure Draw (D : Drawable)
//                   ^^ reference scip-ada . . . DY.
//                       ^^^^^^^^ reference scip-ada . . . Drawable().
  
//       ^^^^ reference scip-ada . . . Move().
//           ^^^^ reference scip-ada . . . Move().
//                             ^^^^^^ reference scip-ada . . . Shapes/
     --  Base abstract shape with position
     type Shape is abstract tagged record
//        ^^^^^ definition scip-ada . . . Shape#
//        kind Class
//                                                   ^^^^^^ reference scip-ada . . . Shapes/
        X : Float := 0.0;
//      ^ definition scip-ada . . . X.
//      kind Variable
        Y : Float := 0.0;
//      ^ definition scip-ada . . . Y.
//      kind Variable
     end record;
//             ^^^^^ reference scip-ada . . . Shape#
//                  ^ reference scip-ada . . . S#
//                             ^ reference scip-ada . . . S#
//                               ^^^^^^ reference scip-ada . . . Radius.
  
//       ^^^^ reference scip-ada . . . Area().
//           ^^^^ reference scip-ada . . . Area().
     --  Compute the area of the shape
     function Area (S : Shape) return Float is abstract;
//   ^^^^^^ reference scip-ada . . . Shapes/
//            ^^^^ definition scip-ada . . . Area().
//            kind Method
//            documentation
//            > function Area (S : Shape) return Float
//            ^^^^^ reference scip-ada . . . Shape#
//                  ^ definition scip-ada . . . S#
//                  kind Struct
//                  documentation
//                  > function Area (S : Shape) return Float
//                      ^^^^^ reference scip-ada . . . Shape#
//                                  ^^^^^^ reference scip-ada . . . Circle#
     --  Move the shape by the given delta
     procedure Move (S : in out Shape; DX, DY : Float);
//             ^^^^ definition scip-ada . . . Move().
//             kind Function
//             documentation
//             > procedure Move (S : in out Shape; DX, DY : Float)
//             ^^^^^ reference scip-ada . . . Shape#
//             ^^^^^^ reference scip-ada . . . Circle#
//             ^^^^^^^^^ reference scip-ada . . . Rectangle#
//                              ^^^^^ reference scip-ada . . . Shape#
//                                     ^^ definition scip-ada . . . DX.
//                                     kind Variable
//                                     documentation
//                                     > procedure Move (S : in out Shape; DX, DY : Float)
//                                         ^ reference scip-ada . . . X.
//                                         ^^ definition scip-ada . . . DY.
//                                         kind Variable
//                                         documentation
//                                         > procedure Move (S : in out Shape; DX, DY : Float)
//                                                                   ^ reference scip-ada . . . Y.
  
//       ^^^^ reference scip-ada . . . Draw().
//           ^^^^ reference scip-ada . . . Draw().
     --  A pointer to any shape
     type Shape_Access is access all Shape'Class;
//        ^^^^^^^^^^^^^^^^^^ definition scip-ada . . . Shape_Access(10R9)#
//        kind Type
//                                   ^^^^^ reference scip-ada . . . Shape#
  
     --  A circle with a radius
//             ^ reference scip-ada . . . S#
//                       ^ reference scip-ada . . . S#
     type Circle is new Shape and Drawable with record
//       ^^^^ reference scip-ada . . . Area().
//        ^^^^^^ definition scip-ada . . . Circle#
//        kind Class
//           ^^^^ reference scip-ada . . . Area().
//                      ^^^^^ reference scip-ada . . . Shape#
//                                ^^^^^^^^ reference scip-ada . . . Drawable().
        Radius : Float := 1.0;
//    ^^^^^^ reference scip-ada . . . Shapes/
//      ^^^^^^ definition scip-ada . . . Radius.
//      kind Variable
//          ^^^^^^ reference scip-ada . . . Shapes/
     end record;
//             ^^^^^^ reference scip-ada . . . Circle#
  
     overriding function Area (S : Circle) return Float;
//                       ^^^^^^ reference scip-ada . . . Circle#
//                                 ^^^^^^ reference scip-ada . . . Circle#
     overriding procedure Draw (S : Circle);
//                        ^^^^^^ reference scip-ada . . . Circle#
//                                  ^^^^^^ reference scip-ada . . . Circle#
  
     type Rectangle is new Shape with record
//        ^^^^^^^^^ definition scip-ada . . . Rectangle#
//        kind Class
//                         ^^^^^ reference scip-ada . . . Shape#
        Width  : Float := 1.0;
//      ^^^^^ definition scip-ada . . . Width.
//      kind Variable
        Height : Float := 1.0;
//      ^^^^^^ definition scip-ada . . . Height.
//      kind Variable
     end record;
//             ^^^^^^^^^ reference scip-ada . . . Rectangle#
  
     overriding function Area (S : Rectangle) return Float;
//                       ^^^^^^^^^ reference scip-ada . . . Rectangle#
//                                 ^^^^^^^^^ reference scip-ada . . . Rectangle#
  end Shapes;
//    ^^^^^^ reference scip-ada . . . Shapes/
//          ^^^^^^ reference scip-ada . . . Shapes/
  
