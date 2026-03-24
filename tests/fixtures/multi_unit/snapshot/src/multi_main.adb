  with Ada.Text_IO;
//     ^^^ reference scip-ada . Multi_Unit . Ada/
//         ^^^^^^^ reference scip-ada . Multi_Unit . Text_IO/
  with Utils;
//     ^^^^^ reference scip-ada . Multi_Unit . Utils/
  with Utils.Strings;
//           ^^^^^^^ reference scip-ada . Multi_Unit . Strings/
  
  procedure Multi_Main is
//          ^^^^^^^^^^ definition scip-ada . Multi_Unit . Multi_Main().
//          kind Function
//          ^^^^^^^^^^ definition scip-ada . Multi_Unit . Multi_Main().
//          kind Function
     Sum  : constant Integer := Utils.Add (3, 4);
//   ^^^ definition scip-ada . Multi_Unit . Sum.
//   kind Variable
//                                    ^^^ reference scip-ada . Multi_Unit . Add().
     Fact : constant Positive := Utils.Factorial (5);
//   ^^^^ definition scip-ada . Multi_Unit . Fact.
//   kind Variable
//                                     ^^^^^^^^^ reference scip-ada . Multi_Unit . Factorial().
     Line : constant String := Utils.Strings.Repeat_Char ('-', 20);
//   ^^^^ definition scip-ada . Multi_Unit . Line.
//   kind Variable
//                                           ^^^^^^^^^^^ reference scip-ada . Multi_Unit . Repeat_Char().
  begin
     Ada.Text_IO.Put_Line (Line);
//               ^^^^^^^^ reference scip-ada . Multi_Unit . Put_Line().
//                         ^^^^ reference scip-ada . Multi_Unit . Line.
     Ada.Text_IO.Put_Line ("Sum:" & Integer'Image (Sum));
//                                                 ^^^ reference scip-ada . Multi_Unit . Sum.
     Ada.Text_IO.Put_Line ("Fact:" & Positive'Image (Fact));
//                                                   ^^^^ reference scip-ada . Multi_Unit . Fact.
     Ada.Text_IO.Put_Line (Line);
//                         ^^^^ reference scip-ada . Multi_Unit . Line.
  end Multi_Main;
//    ^^^^^^^^^^ reference scip-ada . Multi_Unit . Multi_Main().
//              ^^^^^^^^^^ reference scip-ada . Multi_Unit . Multi_Main().
  
