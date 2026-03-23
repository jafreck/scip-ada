  --  Type conversion and printing utilities
  package Converters is
//        ^^^^^^^^^^ definition scip-ada . Overloads . Converters/
//        kind Namespace
//        documentation
//        > Type conversion and printing utilities
     --  Convert an integer to its string representation
     function To_String (Value : Integer) return String;
//            ^^^^^^^^^ definition scip-ada . Overloads . To_String().
//            kind Function
//            documentation
//            > Convert an integer to its string representation
//                       ^^^^^ definition scip-ada . Overloads . Value.
//                       kind Variable
//                       documentation
//                       > Convert an integer to its string representation
     --  Convert a float to its string representation
//   ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
     function To_String (Value : Float) return String;
//   ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//                            ^^^^^ reference scip-ada . Overloads . Value.
     --  Convert a boolean to its string representation
//   ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//       ^^^^^^^^^ reference scip-ada . Overloads . To_String().
//                ^^^^^^^^^ reference scip-ada . Overloads . To_String().
     function To_String (Value : Boolean) return String;
  
     --  Print an integer value to standard output
//                              ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
     procedure Print (Value : Integer);
//             ^^^^^ definition scip-ada . Overloads . Print().
//             kind Function
//             documentation
//             > Print an integer value to standard output
//                          ^^^^^ reference scip-ada . Overloads . Value.
//                              ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
     --  Print a float value to standard output
//       ^^^^^^^^^ reference scip-ada . Overloads . To_String().
//                ^^^^^^^^^ reference scip-ada . Overloads . To_String().
//                              ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
     procedure Print (Value : Float);
     --  Print a string value to standard output
//      ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//                 ^^^^^ reference scip-ada . Overloads . Print().
     procedure Print (Value : String);
//      ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//                 ^^^^^ reference scip-ada . Overloads . Print().
  end Converters;
//    ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//      ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//              ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
//                 ^^^^^ reference scip-ada . Overloads . Print().
//                            ^^^^^ reference scip-ada . Overloads . Value.
  
//       ^^^^^^^^^ reference scip-ada . Overloads . To_String().
//                ^^^^^^^^^ reference scip-ada . Overloads . To_String().
