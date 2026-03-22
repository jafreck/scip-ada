with Ada.Text_IO;
with Utils;
with Utils.Strings;

procedure Multi_Main is
   Sum  : constant Integer := Utils.Add (3, 4);
   Fact : constant Positive := Utils.Factorial (5);
   Line : constant String := Utils.Strings.Repeat_Char ('-', 20);
begin
   Ada.Text_IO.Put_Line (Line);
   Ada.Text_IO.Put_Line ("Sum:" & Integer'Image (Sum));
   Ada.Text_IO.Put_Line ("Fact:" & Positive'Image (Fact));
   Ada.Text_IO.Put_Line (Line);
end Multi_Main;
