with Ada.Text_IO;

--  Main entry point; prints a greeting message
procedure Hello is
   Message : constant String := "Hello, World!";
begin
   Ada.Text_IO.Put_Line (Message);
end Hello;
