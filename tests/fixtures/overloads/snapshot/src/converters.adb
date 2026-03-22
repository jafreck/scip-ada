  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  
  package body Converters is
//             ^^^^^^^^^^ definition scip-ada . . . Converters/
     function To_String (Value : Integer) return String is
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//                       ^^^^^ definition scip-ada . . . Value.
     begin
        return Integer'Image (Value);
     end To_String;
  
     function To_String (Value : Float) return String is
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//                       ^^^^^ definition scip-ada . . . Value.
     begin
        return Float'Image (Value);
     end To_String;
  
     function To_String (Value : Boolean) return String is
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//                       ^^^^^ definition scip-ada . . . Value.
     begin
        return Boolean'Image (Value);
     end To_String;
  
     procedure Print (Value : Integer) is
//             ^^^^^ definition scip-ada . . . Print().
//                    ^^^^^ definition scip-ada . . . Value.
     begin
        Ada.Text_IO.Put_Line ("Int: " & To_String (Value));
//                  ^^^^^^^^ reference scip-ada . . . Put_Line().
     end Print;
  
     procedure Print (Value : Float) is
//             ^^^^^ definition scip-ada . . . Print().
//                    ^^^^^ definition scip-ada . . . Value.
     begin
        Ada.Text_IO.Put_Line ("Float: " & To_String (Value));
     end Print;
  
     procedure Print (Value : String) is
//             ^^^^^ definition scip-ada . . . Print().
//                    ^^^^^ definition scip-ada . . . Value.
     begin
        Ada.Text_IO.Put_Line ("String: " & Value);
     end Print;
  end Converters;
  
