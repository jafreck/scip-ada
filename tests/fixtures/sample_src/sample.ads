--  Sample package demonstrating various Ada constructs
package Sample is

   --  Represents a basic color enumeration
   type Color is (Red, Green, Blue);

   --  A 2D point with integer coordinates
   type Point is record
      X : Integer;
      Y : Integer;
   end record;

   --  Base tagged type for geometric shapes
   type Shape is tagged record
      Origin : Point;
   end record;

   --  Compute the area of the shape
   function Area (S : Shape) return Float;
   --  Draw the shape to the output
   procedure Draw (S : Shape);

   --  A circle defined by its radius, derived from Shape
   type Circle is new Shape with record
      Radius : Float;
   end record;

   overriding function Area (C : Circle) return Float;
   overriding procedure Draw (C : Circle);

   generic
      type Element_Type is private;
      Size : Positive;
   package Bounded_Stack is
      procedure Push (Item : Element_Type);
      function Pop return Element_Type;
      function Is_Empty return Boolean;
   end Bounded_Stack;

   function "+" (L, R : Point) return Point;

   Null_Point : constant Point := (X => 0, Y => 0);

   type Int_Array is array (Positive range <>) of Integer;

   subtype Small_Int is Integer range -100 .. 100;

   Default_Color : Color := Red;

end Sample;
