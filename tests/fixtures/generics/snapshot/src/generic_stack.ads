  generic
     type Element_Type is private;
//        ^^^^^^^^^^^^ definition scip-ada . . . [Element_Type]
//        kind TypeParameter
//        ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
     Max_Size : Positive;
//   ^^^^^^^^ definition scip-ada . . . Max_Size.
//   kind Variable
//   ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
  package Generic_Stack is
//        ^^^^^^^^^^^^^ definition scip-ada . . . Generic_Stack/
//        kind Namespace
//         ^ reference scip-ada . . . S#
     type Stack is private;
//        ^^^^^ definition scip-ada . . . Stack#
//        kind Class
//         ^ reference scip-ada . . . S#
//           ^^^ reference scip-ada . . . Top.
//                  ^ reference scip-ada . . . S#
//                    ^^^ reference scip-ada . . . Top.
//                            ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
  
//         ^ reference scip-ada . . . S#
//                 ^ reference scip-ada . . . S#
//                   ^^^ reference scip-ada . . . Top.
//                           ^^^^ reference scip-ada . . . [Item]
     procedure Push (S : in out Stack; Item : Element_Type);
//             ^^^^ definition scip-ada . . . Push().
//             kind Function
//             documentation
//             > procedure Push (S : in out Stack; Item : Element_Type)
//                   ^ definition scip-ada . . . S#
//                   kind Struct
//                   documentation
//                   > procedure Push (S : in out Stack; Item : Element_Type)
//                              ^^^^^ reference scip-ada . . . Stack#
//                                     ^^^^ definition scip-ada . . . [Item]
//                                     kind TypeParameter
//                                     documentation
//                                     > procedure Push (S : in out Stack; Item : Element_Type)
//                                            ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
     procedure Pop (S : in out Stack; Item : out Element_Type);
//       ^^^^ reference scip-ada . . . Push().
//           ^^^^ reference scip-ada . . . Push().
//             ^^^ definition scip-ada . . . Pop().
//             kind Function
//             documentation
//             > procedure Pop (S : in out Stack; Item : out Element_Type)
//                             ^^^^^ reference scip-ada . . . Stack#
//                                               ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
     function Is_Empty (S : Stack) return Boolean;
//            ^^^^^^^^ definition scip-ada . . . Is_Empty().
//            kind Function
//            documentation
//            > function Is_Empty (S : Stack) return Boolean
//                          ^^^^^ reference scip-ada . . . Stack#
//                             ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
     function Size (S : Stack) return Natural;
//      ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
//            ^^^^ definition scip-ada . . . Size().
//            kind Function
//            documentation
//            > function Size (S : Stack) return Natural
//                      ^^^^^ reference scip-ada . . . Stack#
//                             ^^^^^ reference scip-ada . . . Stack#
//                                               ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
  
//      ^^^^^^^^ reference scip-ada . . . Max_Size.
  private
//      ^^^^ reference scip-ada . . . [Item]
//              ^ reference scip-ada . . . S#
//                ^^^^ reference scip-ada . . . Data.
//                      ^ reference scip-ada . . . S#
//                        ^^^ reference scip-ada . . . Top.
     type Element_Array is array (1 .. Max_Size) of Element_Type;
//      ^ reference scip-ada . . . S#
//        ^^^ reference scip-ada . . . Top.
//        ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
//        ^^^^^^^^^^^^^^^^^^ definition scip-ada . . . Element_Array(2+9)#
//        kind Type
//               ^ reference scip-ada . . . S#
//                 ^^^ reference scip-ada . . . Top.
//                                     ^^^^^^^^ reference scip-ada . . . Max_Size.
//                                                  ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
  
//       ^^^ reference scip-ada . . . Pop().
//          ^^^ reference scip-ada . . . Pop().
//                  ^^^^^ reference scip-ada . . . Stack#
     type Stack is record
//        ^^^^^ definition scip-ada . . . Stack#
//        kind Class
        Data : Element_Array;
//      ^^^^ definition scip-ada . . . Data.
//      kind Variable
//             ^^^^^^^^^^^^^^^^^^ reference scip-ada . . . Element_Array(2+9)#
//                          ^^^^^ reference scip-ada . . . Stack#
        Top  : Natural := 0;
//      ^^^ definition scip-ada . . . Top.
//      kind Variable
//             ^^^^ reference scip-ada . . . Push().
     end record;
//             ^ reference scip-ada . . . S#
//             ^^^^^ reference scip-ada . . . Stack#
//               ^^^ reference scip-ada . . . Top.
  end Generic_Stack;
//    ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
//       ^^^^^^^^ reference scip-ada . . . Is_Empty().
//              ^^^^ reference scip-ada . . . Push().
//               ^^^^^^^^ reference scip-ada . . . Is_Empty().
//                 ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
  
