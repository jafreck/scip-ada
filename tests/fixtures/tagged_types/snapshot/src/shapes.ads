  --  Geometric shape hierarchy for 2D figures
  package Shapes is
//        ^^^^^^ definition scip-ada . . . Shapes/
//        documentation
//        > Geometric shape hierarchy for 2D figures
     --  Drawable interface for rendering capability
     type Drawable is interface;
  
//       ^^^^^^ reference scip-ada . . . Shapes/
     --  Draw the object
//       ^^^^^^ reference scip-ada . . . Shapes/
//                            ^ reference scip-ada . . . X.
//                                      ^ reference scip-ada . . . Y.
     procedure Draw (D : Drawable) is abstract;
  
//                             ^^^^^^ reference scip-ada . . . Shapes/
     --  Base abstract shape with position
     type Shape is abstract tagged record
//        ^^^^^ definition scip-ada . . . Shape#
//        documentation
//        > Base abstract shape with position
//                                                   ^^^^^^ reference scip-ada . . . Shapes/
        X : Float := 0.0;
//      ^ definition scip-ada . . . X.
        Y : Float := 0.0;
//      ^ definition scip-ada . . . Y.
     end record;
//             ^^^^^ reference scip-ada . . . Shape#
  
     --  Compute the area of the shape
     function Area (S : Shape) return Float is abstract;
//   ^^^^^^ reference scip-ada . . . Shapes/
//            ^^^^ definition scip-ada . . . Area().
//            documentation
//            > function Area (S : Shape) return Float
     --  Move the shape by the given delta
     procedure Move (S : in out Shape; DX, DY : Float);
//             ^^^^ definition scip-ada . . . Move().
//             documentation
//             > procedure Move (S : in out Shape; DX, DY : Float)
//             documentation
//             > Move the shape by the given delta
//                                         ^ reference scip-ada . . . X.
//                                                                   ^ reference scip-ada . . . Y.
  
     --  A pointer to any shape
     type Shape_Access is access all Shape'Class;
  
     --  A circle with a radius
     type Circle is new Shape and Drawable with record
//        ^^^^^^ definition scip-ada . . . Circle#
//        documentation
//        > A circle with a radius
//        relationship scip-ada . . . Drawable# type_definition
//        relationship scip-ada . . . Shape# type_definition
        Radius : Float := 1.0;
//      ^^^^^^ definition scip-ada . . . Radius.
     end record;
//             ^^^^^^ reference scip-ada . . . Circle#
  
     overriding function Area (S : Circle) return Float;
     overriding procedure Draw (S : Circle);
  
     type Rectangle is new Shape with record
//        ^^^^^^^^^ definition scip-ada . . . Rectangle#
//        relationship scip-ada . . . Shape# type_definition
        Width  : Float := 1.0;
//      ^^^^^ definition scip-ada . . . Width.
        Height : Float := 1.0;
//      ^^^^^^ definition scip-ada . . . Height.
     end record;
//             ^^^^^^^^^ reference scip-ada . . . Rectangle#
  
     overriding function Area (S : Rectangle) return Float;
  end Shapes;
//          ^^^^^^ reference scip-ada . . . Shapes/
  
