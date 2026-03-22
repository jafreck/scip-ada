with Ada.Text_IO;
with Shapes;

procedure Tagged_Main is
   C : Shapes.Circle := (X => 0.0, Y => 0.0, Radius => 5.0);
   R : Shapes.Rectangle := (X => 1.0, Y => 2.0, Width => 3.0, Height => 4.0);

   procedure Print_Area (S : Shapes.Shape'Class) is
   begin
      Ada.Text_IO.Put_Line ("Area:" & Float'Image (Shapes.Area (S)));
   end Print_Area;
begin
   Print_Area (S => C);
   Print_Area (S => R);

   Shapes.Move (C, 1.0, 2.0);
   Ada.Text_IO.Put_Line ("Circle moved to:" &
                          Float'Image (C.X) & "," & Float'Image (C.Y));
end Tagged_Main;
