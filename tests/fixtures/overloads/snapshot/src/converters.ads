  --  Type conversion and printing utilities
  package Converters is
//        ^^^^^^^^^^ definition scip-ada . . . Converters/
//        documentation
//        > Type conversion and printing utilities
     --  Convert an integer to its string representation
     function To_String (Value : Integer) return String;
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//            documentation
//            > function To_String (Value : Boolean) return String
//            documentation
//            > Convert a boolean to its string representation
//                       ^^^^^ definition scip-ada . . . Value.
//                       documentation
//                       > procedure Print (Value : String)
//                       documentation
//                       > Print a string value to standard output
     --  Convert a float to its string representation
     function To_String (Value : Float) return String;
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//            documentation
//            > function To_String (Value : Boolean) return String
//            documentation
//            > Convert a boolean to its string representation
//                       ^^^^^ definition scip-ada . . . Value.
//                       documentation
//                       > procedure Print (Value : String)
//                       documentation
//                       > Print a string value to standard output
//                            ^^^^^ reference scip-ada . . . Value.
     --  Convert a boolean to its string representation
//       ^^^^^^^^^ reference scip-ada . . . To_String().
//                ^^^^^^^^^ reference scip-ada . . . To_String().
     function To_String (Value : Boolean) return String;
//            ^^^^^^^^^ definition scip-ada . . . To_String().
//            documentation
//            > function To_String (Value : Boolean) return String
//            documentation
//            > Convert a boolean to its string representation
//                       ^^^^^ definition scip-ada . . . Value.
//                       documentation
//                       > procedure Print (Value : String)
//                       documentation
//                       > Print a string value to standard output
  
     --  Print an integer value to standard output
     procedure Print (Value : Integer);
//             ^^^^^ definition scip-ada . . . Print().
//             documentation
//             > procedure Print (Value : String)
//             documentation
//             > Print a string value to standard output
//                    ^^^^^ definition scip-ada . . . Value.
//                    documentation
//                    > procedure Print (Value : String)
//                    documentation
//                    > Print a string value to standard output
//                          ^^^^^ reference scip-ada . . . Value.
     --  Print a float value to standard output
//       ^^^^^^^^^ reference scip-ada . . . To_String().
//                ^^^^^^^^^ reference scip-ada . . . To_String().
     procedure Print (Value : Float);
//             ^^^^^ definition scip-ada . . . Print().
//             documentation
//             > procedure Print (Value : String)
//             documentation
//             > Print a string value to standard output
//                    ^^^^^ definition scip-ada . . . Value.
//                    documentation
//                    > procedure Print (Value : String)
//                    documentation
//                    > Print a string value to standard output
     --  Print a string value to standard output
     procedure Print (Value : String);
//             ^^^^^ definition scip-ada . . . Print().
//             documentation
//             > procedure Print (Value : String)
//             documentation
//             > Print a string value to standard output
//                    ^^^^^ definition scip-ada . . . Value.
//                    documentation
//                    > procedure Print (Value : String)
//                    documentation
//                    > Print a string value to standard output
  end Converters;
//    ^^^^^^^^^^ reference scip-ada . . . Converters/
//              ^^^^^^^^^^ reference scip-ada . . . Converters/
//                            ^^^^^ reference scip-ada . . . Value.
  
//       ^^^^^^^^^ reference scip-ada . . . To_String().
//                ^^^^^^^^^ reference scip-ada . . . To_String().
