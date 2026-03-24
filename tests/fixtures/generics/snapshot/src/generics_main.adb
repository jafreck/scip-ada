  with Ada.Text_IO;
//     ^^^ reference scip-ada . Generics . Ada/
//         ^^^^^^^ reference scip-ada . Generics . Text_IO/
  with Generic_Stack;
//     ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
  
  procedure Generics_Main is
//          ^^^^^^^^^^^^^ definition scip-ada . Generics . Generics_Main().
//          kind Function
//          ^^^^^^^^^^^^^ definition scip-ada . Generics . Generics_Main().
//          kind Function
     package Int_Stack is new Generic_Stack
//           ^^^^^^^^^ definition scip-ada . Generics . Int_Stack/
//           kind Namespace
       (Element_Type => Integer,
//      ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
        Max_Size     => 10);
//      ^^^^^^^^ reference scip-ada . Generics . Max_Size.
  
     package Char_Stack is new Generic_Stack
//           ^^^^^^^^^^ definition scip-ada . Generics . Char_Stack/
//           kind Namespace
       (Element_Type => Character,
        Max_Size     => 5);
  
     S : Int_Stack.Stack;
//   ^ definition scip-ada . Generics . S#
//   kind Struct
//       ^^^^^^^^^ reference scip-ada . Generics . Int_Stack/
//                 ^^^^^ reference scip-ada . Generics . Stack#
     C : Char_Stack.Stack;
//   ^ definition scip-ada . Generics . C#
//   kind Struct
//       ^^^^^^^^^^ reference scip-ada . Generics . Char_Stack/
  begin
     Int_Stack.Push (S, 42);
//   ^^^^^^^^^ reference scip-ada . Generics . Int_Stack/
//             ^^^^ reference scip-ada . Generics . Push().
//                   ^ reference scip-ada . Generics . S#
     Int_Stack.Push (S, 99);
//   ^^^^^^^^^ reference scip-ada . Generics . Int_Stack/
//                   ^ reference scip-ada . Generics . S#
  
     Char_Stack.Push (C, 'A');
//   ^^^^^^^^^^ reference scip-ada . Generics . Char_Stack/
//                    ^ reference scip-ada . Generics . C#
  
     Ada.Text_IO.Put_Line ("Int stack size:" & Natural'Image (Int_Stack.Size (S)));
//               ^^^^^^^^ reference scip-ada . Generics . Put_Line().
//                                                            ^^^^^^^^^ reference scip-ada . Generics . Int_Stack/
//                                                                      ^^^^ reference scip-ada . Generics . Size().
//                                                                            ^ reference scip-ada . Generics . S#
     Ada.Text_IO.Put_Line ("Char stack empty: " & Boolean'Image (Char_Stack.Is_Empty (C)));
//                                                               ^^^^^^^^^^ reference scip-ada . Generics . Char_Stack/
//                                                                          ^^^^^^^^ reference scip-ada . Generics . Is_Empty().
//                                                                                    ^ reference scip-ada . Generics . C#
  
     declare
        Val : Integer;
//      ^^^ definition scip-ada . Generics . Val.
//      kind Variable
     begin
        Int_Stack.Pop (S, Val);
//      ^^^^^^^^^ reference scip-ada . Generics . Int_Stack/
//                ^^^ reference scip-ada . Generics . Pop().
//                     ^ reference scip-ada . Generics . S#
//                        ^^^ reference scip-ada . Generics . Val.
        Ada.Text_IO.Put_Line ("Popped:" & Integer'Image (Val));
//                                                       ^^^ reference scip-ada . Generics . Val.
     end;
  end Generics_Main;
//    ^^^^^^^^^^^^^ reference scip-ada . Generics . Generics_Main().
//                 ^^^^^^^^^^^^^ reference scip-ada . Generics . Generics_Main().
  
