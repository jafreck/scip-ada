with Ada.Text_IO;

package body Sample is

   function Area (S : Shape) return Float is
      pragma Unreferenced (S);
   begin
      return 0.0;
   end Area;

   procedure Draw (S : Shape) is
      pragma Unreferenced (S);
   begin
      Ada.Text_IO.Put_Line ("Drawing shape");
   end Draw;

   overriding function Area (C : Circle) return Float is
   begin
      return 3.14159 * C.Radius * C.Radius;
   end Area;

   overriding procedure Draw (C : Circle) is
      pragma Unreferenced (C);
   begin
      Ada.Text_IO.Put_Line ("Drawing circle");
   end Draw;

   package body Bounded_Stack is
      Stack : array (1 .. Size) of Element_Type;
      Top   : Natural := 0;

      procedure Push (Item : Element_Type) is
      begin
         Top := Top + 1;
         Stack (Top) := Item;
      end Push;

      function Pop return Element_Type is
         Result : constant Element_Type := Stack (Top);
      begin
         Top := Top - 1;
         return Result;
      end Pop;

      function Is_Empty return Boolean is
      begin
         return Top = 0;
      end Is_Empty;
   end Bounded_Stack;

   function "+" (L, R : Point) return Point is
   begin
      return (X => L.X + R.X, Y => L.Y + R.Y);
   end "+";

end Sample;
