  with Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  with Generic_Stack;
//     ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
  
  procedure Generics_Main is
//          ^^^^^^^^^^^^^ definition scip-ada . . . Generics_Main().
//          kind Function
//          documentation
//          > procedure Generics_Main
//          ^^^^^^^^^^^^^ definition scip-ada . . . Generics_Main().
//          kind Function
//          documentation
//          > procedure Generics_Main
     package Int_Stack is new Generic_Stack
//           ^^^^^^^^^ definition scip-ada . . . Int_Stack/
//           kind Namespace
       (Element_Type => Integer,
//      ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
        Max_Size     => 10);
//      ^^^^^^^^ reference scip-ada . . . Max_Size.
  
     package Char_Stack is new Generic_Stack
//           ^^^^^^^^^^ definition scip-ada . . . Char_Stack/
//           kind Namespace
       (Element_Type => Character,
        Max_Size     => 5);
  
     S : Int_Stack.Stack;
//   ^ definition scip-ada . . . S#
//   kind Struct
//       ^^^^^^^^^ reference scip-ada . . . Int_Stack/
//                 ^^^^^ reference scip-ada . . . Stack#
     C : Char_Stack.Stack;
//   ^ definition scip-ada . . . C#
//   kind Struct
//       ^^^^^^^^^^ reference scip-ada . . . Char_Stack/
  begin
     Int_Stack.Push (S, 42);
//   ^^^^^^^^^ reference scip-ada . . . Int_Stack/
//             ^^^^ reference scip-ada . . . Push().
//                   ^ reference scip-ada . . . S#
     Int_Stack.Push (S, 99);
//   ^^^^^^^^^ reference scip-ada . . . Int_Stack/
//                   ^ reference scip-ada . . . S#
  
     Char_Stack.Push (C, 'A');
//   ^^^^^^^^^^ reference scip-ada . . . Char_Stack/
//                    ^ reference scip-ada . . . C#
  
     Ada.Text_IO.Put_Line ("Int stack size:" & Natural'Image (Int_Stack.Size (S)));
//               ^^^^^^^^ reference scip-ada . . . Put_Line().
//                                                            ^^^^^^^^^ reference scip-ada . . . Int_Stack/
//                                                                      ^^^^ reference scip-ada . . . Size().
//                                                                            ^ reference scip-ada . . . S#
     Ada.Text_IO.Put_Line ("Char stack empty: " & Boolean'Image (Char_Stack.Is_Empty (C)));
//                                                               ^^^^^^^^^^ reference scip-ada . . . Char_Stack/
//                                                                          ^^^^^^^^ reference scip-ada . . . Is_Empty().
//                                                                                    ^ reference scip-ada . . . C#
  
     declare
        Val : Integer;
//      ^^^ definition scip-ada . . . Val.
//      kind Variable
     begin
        Int_Stack.Pop (S, Val);
//      ^^^^^^^^^ reference scip-ada . . . Int_Stack/
//                ^^^ reference scip-ada . . . Pop().
//                     ^ reference scip-ada . . . S#
//                        ^^^ reference scip-ada . . . Val.
        Ada.Text_IO.Put_Line ("Popped:" & Integer'Image (Val));
//                                                       ^^^ reference scip-ada . . . Val.
     end;
  end Generics_Main;
//    ^^^^^^^^^^^^^ reference scip-ada . . . Generics_Main().
//                 ^^^^^^^^^^^^^ reference scip-ada . . . Generics_Main().
  
