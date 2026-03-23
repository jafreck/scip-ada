  with Ada.Text_IO;
//     ^^^ reference scip-ada . Hello . Ada/
//         ^^^^^^^ reference scip-ada . Hello . Text_IO/
  
  --  Main entry point; prints a greeting message
  procedure Hello is
//          ^^^^^ definition scip-ada . Hello . Hello().
//          kind Function
//          documentation
//          > Main entry point; prints a greeting message
//          ^^^^^ definition scip-ada . Hello . Hello().
//          kind Function
//          documentation
//          > Main entry point; prints a greeting message
     Message : constant String := "Hello, World!";
//   ^^^^^^^ definition scip-ada . Hello . Message.
//   kind Variable
  begin
     Ada.Text_IO.Put_Line (Message);
//               ^^^^^^^^ reference scip-ada . Hello . Put_Line().
//                         ^^^^^^^ reference scip-ada . Hello . Message.
  end Hello;
//    ^^^^^ reference scip-ada . Hello . Hello().
//         ^^^^^ reference scip-ada . Hello . Hello().
  
