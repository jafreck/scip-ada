  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  with Utils;
//     ^^^^^ reference scip-ada . . . Utils/
  with Utils.Strings;
//           ^^^^^^^ reference scip-ada . . . Strings/
  
  procedure Multi_Main is
//          ^^^^^^^^^^ definition scip-ada . . . Multi_Main().
//          documentation
//          > procedure Multi_Main
//          ^^^^^^^^^^ definition scip-ada . . . Multi_Main().
//          documentation
//          > procedure Multi_Main
     Sum  : constant Integer := Utils.Add (3, 4);
//   ^^^ definition scip-ada . . . Sum.
//                                    ^^^ reference scip-ada . . . Add().
     Fact : constant Positive := Utils.Factorial (5);
//   ^^^^ definition scip-ada . . . Fact.
//                                     ^^^^^^^^^ reference scip-ada . . . Factorial().
     Line : constant String := Utils.Strings.Repeat_Char ('-', 20);
//   ^^^^ definition scip-ada . . . Line.
//                                           ^^^^^^^^^^^ reference scip-ada . . . Repeat_Char().
  begin
     Ada.Text_IO.Put_Line (Line);
//               ^^^^^^^^ reference scip-ada . . . Put_Line().
//                         ^^^^ reference scip-ada . . . Line.
     Ada.Text_IO.Put_Line ("Sum:" & Integer'Image (Sum));
//                                                 ^^^ reference scip-ada . . . Sum.
     Ada.Text_IO.Put_Line ("Fact:" & Positive'Image (Fact));
//                                                   ^^^^ reference scip-ada . . . Fact.
     Ada.Text_IO.Put_Line (Line);
//                         ^^^^ reference scip-ada . . . Line.
  end Multi_Main;
//    ^^^^^^^^^^ reference scip-ada . . . Multi_Main().
//              ^^^^^^^^^^ reference scip-ada . . . Multi_Main().
  
