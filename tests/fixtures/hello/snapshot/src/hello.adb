  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  
  --  Main entry point; prints a greeting message
  procedure Hello is
//          ^^^^^ definition scip-ada . . . Hello().
//          kind Function
//          documentation
//          > procedure Hello
//          ^^^^^ definition scip-ada . . . Hello().
//          kind Function
//          documentation
//          > procedure Hello
     Message : constant String := "Hello, World!";
//   ^^^^^^^ definition scip-ada . . . Message.
//   kind Variable
  begin
     Ada.Text_IO.Put_Line (Message);
//               ^^^^^^^^ reference scip-ada . . . Put_Line().
//                         ^^^^^^^ reference scip-ada . . . Message.
  end Hello;
//    ^^^^^ reference scip-ada . . . Hello().
//         ^^^^^ reference scip-ada . . . Hello().
  
