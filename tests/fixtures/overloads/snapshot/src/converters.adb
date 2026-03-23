  with Ada.Text_IO;
//     ^^^ reference scip-ada . Overloads . Ada/
//         ^^^^^^^ reference scip-ada . Overloads . Text_IO/
  
  package body Converters is
//             ^^^^^^^^^^ definition scip-ada . Overloads . Converters/
     function To_String (Value : Integer) return String is
//            ^^^^^^^^^ definition scip-ada . Overloads . To_String().
//                       ^^^^^ definition scip-ada . Overloads . Value.
     begin
        return Integer'Image (Value);
     end To_String;
  
     function To_String (Value : Float) return String is
//            ^^^^^^^^^ definition scip-ada . Overloads . To_String().
//                       ^^^^^ definition scip-ada . Overloads . Value.
     begin
        return Float'Image (Value);
     end To_String;
  
     function To_String (Value : Boolean) return String is
//            ^^^^^^^^^ definition scip-ada . Overloads . To_String().
//                       ^^^^^ definition scip-ada . Overloads . Value.
     begin
        return Boolean'Image (Value);
     end To_String;
  
     procedure Print (Value : Integer) is
//             ^^^^^ definition scip-ada . Overloads . Print().
//                    ^^^^^ definition scip-ada . Overloads . Value.
     begin
        Ada.Text_IO.Put_Line ("Int: " & To_String (Value));
//                  ^^^^^^^^ reference scip-ada . Overloads . Put_Line().
     end Print;
  
     procedure Print (Value : Float) is
//             ^^^^^ definition scip-ada . Overloads . Print().
//                    ^^^^^ definition scip-ada . Overloads . Value.
     begin
        Ada.Text_IO.Put_Line ("Float: " & To_String (Value));
     end Print;
  
     procedure Print (Value : String) is
//             ^^^^^ definition scip-ada . Overloads . Print().
//                    ^^^^^ definition scip-ada . Overloads . Value.
     begin
        Ada.Text_IO.Put_Line ("String: " & Value);
     end Print;
  end Converters;
  
