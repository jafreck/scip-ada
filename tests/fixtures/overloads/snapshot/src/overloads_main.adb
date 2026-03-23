  with Converters;
//     ^^^^^^^^^^ reference scip-ada . Overloads . Converters/
  
  procedure Overloads_Main is
//          ^^^^^^^^^^^^^^ definition scip-ada . Overloads . Overloads_Main().
//          kind Function
//          ^^^^^^^^^^^^^^ definition scip-ada . Overloads . Overloads_Main().
//          kind Function
  begin
     Converters.Print (42);
//              ^^^^^ reference scip-ada . Overloads . Print().
     Converters.Print (3.14);
//              ^^^^^ reference scip-ada . Overloads . Print().
     Converters.Print ("hello");
//              ^^^^^ reference scip-ada . Overloads . Print().
  
     declare
        S1 : constant String := Converters.To_String (100);
//      ^^ definition scip-ada . Overloads . S1.
//      kind Variable
//                                         ^^^^^^^^^ reference scip-ada . Overloads . To_String().
        S2 : constant String := Converters.To_String (2.718);
//      ^^ definition scip-ada . Overloads . S2.
//      kind Variable
//                                         ^^^^^^^^^ reference scip-ada . Overloads . To_String().
        S3 : constant String := Converters.To_String (True);
//      ^^ definition scip-ada . Overloads . S3.
//      kind Variable
//                                         ^^^^^^^^^ reference scip-ada . Overloads . To_String().
     begin
        Converters.Print (S1);
//                        ^^ reference scip-ada . Overloads . S1.
        Converters.Print (S2);
//                        ^^ reference scip-ada . Overloads . S2.
        Converters.Print (S3);
//                        ^^ reference scip-ada . Overloads . S3.
     end;
  end Overloads_Main;
//    ^^^^^^^^^^^^^^ reference scip-ada . Overloads . Overloads_Main().
//                  ^^^^^^^^^^^^^^ reference scip-ada . Overloads . Overloads_Main().
  
