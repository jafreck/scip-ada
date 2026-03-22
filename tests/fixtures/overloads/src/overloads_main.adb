with Converters;

procedure Overloads_Main is
begin
   Converters.Print (42);
   Converters.Print (3.14);
   Converters.Print ("hello");

   declare
      S1 : constant String := Converters.To_String (100);
      S2 : constant String := Converters.To_String (2.718);
      S3 : constant String := Converters.To_String (True);
   begin
      Converters.Print (S1);
      Converters.Print (S2);
      Converters.Print (S3);
   end;
end Overloads_Main;
