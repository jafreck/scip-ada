--  Geometric shape hierarchy for 2D figures
package Shapes is
   --  Drawable interface for rendering capability
   type Drawable is interface;

   --  Draw the object
   procedure Draw (D : Drawable) is abstract;

   --  Base abstract shape with position
   type Shape is abstract tagged record
      X : Float := 0.0;
      Y : Float := 0.0;
   end record;

   --  Compute the area of the shape
   function Area (S : Shape) return Float is abstract;
   --  Move the shape by the given delta
   procedure Move (S : in out Shape; DX, DY : Float);

   --  A pointer to any shape
   type Shape_Access is access all Shape'Class;

   --  A circle with a radius
   type Circle is new Shape and Drawable with record
      Radius : Float := 1.0;
   end record;

   overriding function Area (S : Circle) return Float;
   overriding procedure Draw (S : Circle);

   type Rectangle is new Shape with record
      Width  : Float := 1.0;
      Height : Float := 1.0;
   end record;

   overriding function Area (S : Rectangle) return Float;
end Shapes;
