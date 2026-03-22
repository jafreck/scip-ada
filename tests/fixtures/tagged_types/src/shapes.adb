with Ada.Text_IO;

package body Shapes is
   procedure Move (S : in out Shape; DX, DY : Float) is
   begin
      S.X := S.X + DX;
      S.Y := S.Y + DY;
   end Move;

   overriding function Area (S : Circle) return Float is
      Pi : constant Float := 3.14159;
   begin
      return Pi * S.Radius * S.Radius;
   end Area;

   overriding procedure Draw (S : Circle) is
   begin
      Ada.Text_IO.Put_Line ("Drawing circle");
   end Draw;

   overriding function Area (S : Rectangle) return Float is
   begin
      return S.Width * S.Height;
   end Area;
end Shapes;
