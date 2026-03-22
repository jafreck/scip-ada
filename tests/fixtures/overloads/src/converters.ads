--  Type conversion and printing utilities
package Converters is
   --  Convert an integer to its string representation
   function To_String (Value : Integer) return String;
   --  Convert a float to its string representation
   function To_String (Value : Float) return String;
   --  Convert a boolean to its string representation
   function To_String (Value : Boolean) return String;

   --  Print an integer value to standard output
   procedure Print (Value : Integer);
   --  Print a float value to standard output
   procedure Print (Value : Float);
   --  Print a string value to standard output
   procedure Print (Value : String);
end Converters;
