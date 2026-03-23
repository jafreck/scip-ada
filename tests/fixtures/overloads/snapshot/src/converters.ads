  --  Type conversion and printing utilities
  package Converters is
//        ^^^^^^^^^^ definition scip-ada . . . Converters/
//        kind Namespace
     --  Convert an integer to its string representation
     function To_String (Value : Integer) return String;
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//            kind Function
//            documentation
//            > function To_String (Value : Integer) return String
//                       ^^^^^ definition scip-ada . . . Value.
//                       kind Variable
//                       documentation
//                       > function To_String (Value : Integer) return String
     --  Convert a float to its string representation
//   ^^^^^^^^^^ reference scip-ada . . . Converters/
     function To_String (Value : Float) return String;
//   ^^^^^^^^^^ reference scip-ada . . . Converters/
//                            ^^^^^ reference scip-ada . . . Value.
     --  Convert a boolean to its string representation
//   ^^^^^^^^^^ reference scip-ada . . . Converters/
//       ^^^^^^^^^ reference scip-ada . . . To_String().
//                ^^^^^^^^^ reference scip-ada . . . To_String().
     function To_String (Value : Boolean) return String;
  
     --  Print an integer value to standard output
//                              ^^^^^^^^^^ reference scip-ada . . . Converters/
     procedure Print (Value : Integer);
//             ^^^^^ definition scip-ada . . . Print().
//             kind Function
//             documentation
//             > procedure Print (Value : Integer)
//                          ^^^^^ reference scip-ada . . . Value.
//                              ^^^^^^^^^^ reference scip-ada . . . Converters/
     --  Print a float value to standard output
//       ^^^^^^^^^ reference scip-ada . . . To_String().
//                ^^^^^^^^^ reference scip-ada . . . To_String().
//                              ^^^^^^^^^^ reference scip-ada . . . Converters/
     procedure Print (Value : Float);
     --  Print a string value to standard output
//      ^^^^^^^^^^ reference scip-ada . . . Converters/
//                 ^^^^^ reference scip-ada . . . Print().
     procedure Print (Value : String);
//      ^^^^^^^^^^ reference scip-ada . . . Converters/
//                 ^^^^^ reference scip-ada . . . Print().
  end Converters;
//    ^^^^^^^^^^ reference scip-ada . . . Converters/
//      ^^^^^^^^^^ reference scip-ada . . . Converters/
//              ^^^^^^^^^^ reference scip-ada . . . Converters/
//                 ^^^^^ reference scip-ada . . . Print().
//                            ^^^^^ reference scip-ada . . . Value.
  
//       ^^^^^^^^^ reference scip-ada . . . To_String().
//                ^^^^^^^^^ reference scip-ada . . . To_String().
