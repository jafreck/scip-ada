  --  Geometric shape hierarchy for 2D figures
  package Shapes is
//        ^^^^^^ definition scip-ada . Tagged_Types . Shapes/
//        kind Namespace
//        documentation
//        > Geometric shape hierarchy for 2D figures
     --  Drawable interface for rendering capability
     type Drawable is interface;
//        ^^^^^^^^ definition scip-ada . Tagged_Types . Drawable().
//        kind Interface
//        documentation
//        > Drawable interface for rendering capability
//        ^^^^^^^^ definition scip-ada . Tagged_Types . Drawable#
//        kind Interface
//        documentation
//        > Drawable interface for rendering capability
  
//       ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
     --  Draw the object
//      ^ reference scip-ada . Tagged_Types . S#
//       ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
//             ^ reference scip-ada . Tagged_Types . S#
//               ^ reference scip-ada . Tagged_Types . X.
//                   ^^ reference scip-ada . Tagged_Types . DX.
//                            ^ reference scip-ada . Tagged_Types . X.
//                                      ^ reference scip-ada . Tagged_Types . Y.
     procedure Draw (D : Drawable) is abstract;
//      ^ reference scip-ada . Tagged_Types . S#
//             ^ reference scip-ada . Tagged_Types . S#
//             ^^^^ definition scip-ada . Tagged_Types . Draw().
//             kind Function
//             ^^^^^^^^ reference scip-ada . Tagged_Types . Drawable().
//               ^ reference scip-ada . Tagged_Types . Y.
//                   ^ definition scip-ada . Tagged_Types . D#
//                   kind Struct
//                   ^^ reference scip-ada . Tagged_Types . DY.
//                       ^^^^^^^^ reference scip-ada . Tagged_Types . Drawable().
  
//       ^^^^ reference scip-ada . Tagged_Types . Move().
//           ^^^^ reference scip-ada . Tagged_Types . Move().
//                             ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
     --  Base abstract shape with position
     type Shape is abstract tagged record
//        ^^^^^ definition scip-ada . Tagged_Types . Shape#
//        kind Class
//        documentation
//        > Base abstract shape with position
//                                                   ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
        X : Float := 0.0;
//      ^ definition scip-ada . Tagged_Types . X.
//      kind Variable
        Y : Float := 0.0;
//      ^ definition scip-ada . Tagged_Types . Y.
//      kind Variable
     end record;
//             ^^^^^ reference scip-ada . Tagged_Types . Shape#
//                  ^ reference scip-ada . Tagged_Types . S#
//                             ^ reference scip-ada . Tagged_Types . S#
//                               ^^^^^^ reference scip-ada . Tagged_Types . Radius.
  
//       ^^^^ reference scip-ada . Tagged_Types . Area().
//           ^^^^ reference scip-ada . Tagged_Types . Area().
     --  Compute the area of the shape
     function Area (S : Shape) return Float is abstract;
//   ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
//            ^^^^ definition scip-ada . Tagged_Types . Area().
//            kind Method
//            ^^^^^ reference scip-ada . Tagged_Types . Shape#
//                  ^ definition scip-ada . Tagged_Types . S#
//                  kind Struct
//                      ^^^^^ reference scip-ada . Tagged_Types . Shape#
//                                  ^^^^^^ reference scip-ada . Tagged_Types . Circle#
     --  Move the shape by the given delta
     procedure Move (S : in out Shape; DX, DY : Float);
//             ^^^^ definition scip-ada . Tagged_Types . Move().
//             kind Function
//             documentation
//             > Move the shape by the given delta
//             ^^^^^ reference scip-ada . Tagged_Types . Shape#
//             ^^^^^^ reference scip-ada . Tagged_Types . Circle#
//             ^^^^^^^^^ reference scip-ada . Tagged_Types . Rectangle#
//                              ^^^^^ reference scip-ada . Tagged_Types . Shape#
//                                     ^^ definition scip-ada . Tagged_Types . DX.
//                                     kind Variable
//                                     documentation
//                                     > Move the shape by the given delta
//                                         ^ reference scip-ada . Tagged_Types . X.
//                                         ^^ definition scip-ada . Tagged_Types . DY.
//                                         kind Variable
//                                         documentation
//                                         > Move the shape by the given delta
//                                                                   ^ reference scip-ada . Tagged_Types . Y.
  
//       ^^^^ reference scip-ada . Tagged_Types . Draw().
//           ^^^^ reference scip-ada . Tagged_Types . Draw().
     --  A pointer to any shape
     type Shape_Access is access all Shape'Class;
//        ^^^^^^^^^^^^^^^^^^ definition scip-ada . Tagged_Types . `Shape_Access(10R9)`#
//        kind Type
//        documentation
//        > A pointer to any shape
//                                   ^^^^^ reference scip-ada . Tagged_Types . Shape#
  
     --  A circle with a radius
//             ^ reference scip-ada . Tagged_Types . S#
//                       ^ reference scip-ada . Tagged_Types . S#
     type Circle is new Shape and Drawable with record
//       ^^^^ reference scip-ada . Tagged_Types . Area().
//        ^^^^^^ definition scip-ada . Tagged_Types . Circle#
//        kind Class
//        documentation
//        > A circle with a radius
//        relationship scip-ada . Tagged_Types . Shapes#Drawable# type_definition
//        relationship scip-ada . Tagged_Types . Shapes#Shape# type_definition
//           ^^^^ reference scip-ada . Tagged_Types . Area().
//                      ^^^^^ reference scip-ada . Tagged_Types . Shape#
//                                ^^^^^^^^ reference scip-ada . Tagged_Types . Drawable().
        Radius : Float := 1.0;
//    ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
//      ^^^^^^ definition scip-ada . Tagged_Types . Radius.
//      kind Variable
//          ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
     end record;
//             ^^^^^^ reference scip-ada . Tagged_Types . Circle#
  
     overriding function Area (S : Circle) return Float;
//                       ^^^^^^ reference scip-ada . Tagged_Types . Circle#
//                                 ^^^^^^ reference scip-ada . Tagged_Types . Circle#
     overriding procedure Draw (S : Circle);
//                        ^^^^^^ reference scip-ada . Tagged_Types . Circle#
//                                  ^^^^^^ reference scip-ada . Tagged_Types . Circle#
  
     type Rectangle is new Shape with record
//        ^^^^^^^^^ definition scip-ada . Tagged_Types . Rectangle#
//        kind Class
//        relationship scip-ada . Tagged_Types . Shapes#Shape# type_definition
//                         ^^^^^ reference scip-ada . Tagged_Types . Shape#
        Width  : Float := 1.0;
//      ^^^^^ definition scip-ada . Tagged_Types . Width.
//      kind Variable
        Height : Float := 1.0;
//      ^^^^^^ definition scip-ada . Tagged_Types . Height.
//      kind Variable
     end record;
//             ^^^^^^^^^ reference scip-ada . Tagged_Types . Rectangle#
  
     overriding function Area (S : Rectangle) return Float;
//                       ^^^^^^^^^ reference scip-ada . Tagged_Types . Rectangle#
//                                 ^^^^^^^^^ reference scip-ada . Tagged_Types . Rectangle#
  end Shapes;
//    ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
//          ^^^^^^ reference scip-ada . Tagged_Types . Shapes/
  
