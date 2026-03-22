  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  
  --  Main entry point; prints a greeting message
  procedure Hello is
//          ^^^^^ definition scip-ada . . . Hello().
//          documentation
//          > procedure Hello
//          documentation
//          > Main entry point; prints a greeting message
//          ^^^^^ definition scip-ada . . . Hello().
//          documentation
//          > procedure Hello
//          documentation
//          > Main entry point; prints a greeting message
     Message : constant String := "Hello, World!";
//   ^^^^^^^ definition scip-ada . . . Message.
  begin
     Ada.Text_IO.Put_Line (Message);
//               ^^^^^^^^ reference scip-ada . . . Put_Line().
//                         ^^^^^^^ reference scip-ada . . . Message.
  end Hello;
//    ^^^^^ reference scip-ada . . . Hello().
//         ^^^^^ reference scip-ada . . . Hello().
  
