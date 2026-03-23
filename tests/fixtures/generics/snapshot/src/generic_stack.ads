  generic
     type Element_Type is private;
//        ^^^^^^^^^^^^ definition scip-ada . Generics . [Element_Type]
//        kind TypeParameter
//        ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
     Max_Size : Positive;
//   ^^^^^^^^ definition scip-ada . Generics . Max_Size.
//   kind Variable
//   ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
  package Generic_Stack is
//        ^^^^^^^^^^^^^ definition scip-ada . Generics . Generic_Stack/
//        kind Namespace
//         ^ reference scip-ada . Generics . S#
     type Stack is private;
//        ^^^^^ definition scip-ada . Generics . Stack#
//        kind Class
//         ^ reference scip-ada . Generics . S#
//           ^^^ reference scip-ada . Generics . Top.
//                  ^ reference scip-ada . Generics . S#
//                    ^^^ reference scip-ada . Generics . Top.
//                            ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
  
//         ^ reference scip-ada . Generics . S#
//                 ^ reference scip-ada . Generics . S#
//                   ^^^ reference scip-ada . Generics . Top.
//                           ^^^^ reference scip-ada . Generics . [Item]
     procedure Push (S : in out Stack; Item : Element_Type);
//             ^^^^ definition scip-ada . Generics . Push().
//             kind Function
//                   ^ definition scip-ada . Generics . S#
//                   kind Struct
//                              ^^^^^ reference scip-ada . Generics . Stack#
//                                     ^^^^ definition scip-ada . Generics . [Item]
//                                     kind TypeParameter
//                                            ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
     procedure Pop (S : in out Stack; Item : out Element_Type);
//       ^^^^ reference scip-ada . Generics . Push().
//           ^^^^ reference scip-ada . Generics . Push().
//             ^^^ definition scip-ada . Generics . Pop().
//             kind Function
//                             ^^^^^ reference scip-ada . Generics . Stack#
//                                               ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
     function Is_Empty (S : Stack) return Boolean;
//            ^^^^^^^^ definition scip-ada . Generics . Is_Empty().
//            kind Function
//                          ^^^^^ reference scip-ada . Generics . Stack#
//                             ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
     function Size (S : Stack) return Natural;
//      ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
//            ^^^^ definition scip-ada . Generics . Size().
//            kind Function
//                      ^^^^^ reference scip-ada . Generics . Stack#
//                             ^^^^^ reference scip-ada . Generics . Stack#
//                                               ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
  
//      ^^^^^^^^ reference scip-ada . Generics . Max_Size.
  private
//      ^^^^ reference scip-ada . Generics . [Item]
//              ^ reference scip-ada . Generics . S#
//                ^^^^ reference scip-ada . Generics . Data.
//                      ^ reference scip-ada . Generics . S#
//                        ^^^ reference scip-ada . Generics . Top.
     type Element_Array is array (1 .. Max_Size) of Element_Type;
//      ^ reference scip-ada . Generics . S#
//        ^^^ reference scip-ada . Generics . Top.
//        ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
//        ^^^^^^^^^^^^^^^^^^ definition scip-ada . Generics . `Element_Array(2+9)`#
//        kind Type
//               ^ reference scip-ada . Generics . S#
//                 ^^^ reference scip-ada . Generics . Top.
//                                     ^^^^^^^^ reference scip-ada . Generics . Max_Size.
//                                                  ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
  
//       ^^^ reference scip-ada . Generics . Pop().
//          ^^^ reference scip-ada . Generics . Pop().
//                  ^^^^^ reference scip-ada . Generics . Stack#
     type Stack is record
//        ^^^^^ definition scip-ada . Generics . Stack#
//        kind Class
        Data : Element_Array;
//      ^^^^ definition scip-ada . Generics . Data.
//      kind Variable
//             ^^^^^^^^^^^^^^^^^^ reference scip-ada . Generics . `Element_Array(2+9)`#
//                          ^^^^^ reference scip-ada . Generics . Stack#
        Top  : Natural := 0;
//      ^^^ definition scip-ada . Generics . Top.
//      kind Variable
//             ^^^^ reference scip-ada . Generics . Push().
     end record;
//             ^ reference scip-ada . Generics . S#
//             ^^^^^ reference scip-ada . Generics . Stack#
//               ^^^ reference scip-ada . Generics . Top.
  end Generic_Stack;
//    ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
//       ^^^^^^^^ reference scip-ada . Generics . Is_Empty().
//              ^^^^ reference scip-ada . Generics . Push().
//               ^^^^^^^^ reference scip-ada . Generics . Is_Empty().
//                 ^^^^^^^^^^^^^ reference scip-ada . Generics . Generic_Stack/
  
