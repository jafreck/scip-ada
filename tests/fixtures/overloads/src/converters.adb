with Ada.Text_IO;

package body Converters is
   function To_String (Value : Integer) return String is
   begin
      return Integer'Image (Value);
   end To_String;

   function To_String (Value : Float) return String is
   begin
      return Float'Image (Value);
   end To_String;

   function To_String (Value : Boolean) return String is
   begin
      return Boolean'Image (Value);
   end To_String;

   procedure Print (Value : Integer) is
   begin
      Ada.Text_IO.Put_Line ("Int: " & To_String (Value));
   end Print;

   procedure Print (Value : Float) is
   begin
      Ada.Text_IO.Put_Line ("Float: " & To_String (Value));
   end Print;

   procedure Print (Value : String) is
   begin
      Ada.Text_IO.Put_Line ("String: " & Value);
   end Print;
end Converters;
