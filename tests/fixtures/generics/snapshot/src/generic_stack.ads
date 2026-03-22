  generic
     type Element_Type is private;
//        ^^^^^^^^^^^^ definition scip-ada . . . [Element_Type]
     Max_Size : Positive;
//   ^^^^^^^^ definition scip-ada . . . Max_Size.
  package Generic_Stack is
//        ^^^^^^^^^^^^^ definition scip-ada . . . Generic_Stack/
     type Stack is private;
//        ^^^^^ definition scip-ada . . . Stack#
//                            ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
  
     procedure Push (S : in out Stack; Item : Element_Type);
//             ^^^^ definition scip-ada . . . Push().
//             documentation
//             > procedure Push (S : in out Stack; Item : Element_Type)
     procedure Pop (S : in out Stack; Item : out Element_Type);
//             ^^^ definition scip-ada . . . Pop().
//             documentation
//             > procedure Pop (S : in out Stack; Item : out Element_Type)
     function Is_Empty (S : Stack) return Boolean;
//            ^^^^^^^^ definition scip-ada . . . Is_Empty().
//            documentation
//            > function Is_Empty (S : Stack) return Boolean
//                             ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
     function Size (S : Stack) return Natural;
//      ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
//            ^^^^ definition scip-ada . . . Size().
//            documentation
//            > function Size (S : Stack) return Natural
  
//      ^^^^^^^^ reference scip-ada . . . Max_Size.
  private
     type Element_Array is array (1 .. Max_Size) of Element_Type;
  
//                  ^^^^^ reference scip-ada . . . Stack#
     type Stack is record
        Data : Element_Array;
        Top  : Natural := 0;
//             ^^^^ reference scip-ada . . . Push().
     end record;
  end Generic_Stack;
//              ^^^^ reference scip-ada . . . Push().
//                 ^^^^^^^^^^^^^ reference scip-ada . . . Generic_Stack/
  
