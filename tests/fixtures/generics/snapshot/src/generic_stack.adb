  package body Generic_Stack is
//             ^^^^^^^^^^^^^ definition scip-ada . . . Generic_Stack/
     procedure Push (S : in out Stack; Item : Element_Type) is
//             ^^^^ definition scip-ada . . . Push().
//                   ^ definition scip-ada . . . S#
//                              ^^^^^ reference scip-ada . . . Stack#
//                                     ^^^^ definition scip-ada . . . [Item]
//                                            ^^^^^^^^^^^^ reference scip-ada . . . [Element_Type]
     begin
        if S.Top < Max_Size then
//           ^^^ reference scip-ada . . . Top.
//                 ^^^^^^^^ reference scip-ada . . . Max_Size.
           S.Top := S.Top + 1;
           S.Data (S.Top) := Item;
//           ^^^^ reference scip-ada . . . Data.
        end if;
     end Push;
  
     procedure Pop (S : in out Stack; Item : out Element_Type) is
//             ^^^ definition scip-ada . . . Pop().
//                  ^ definition scip-ada . . . S#
//                                    ^^^^ definition scip-ada . . . [Item]
     begin
        Item := S.Data (S.Top);
        S.Top := S.Top - 1;
     end Pop;
  
     function Is_Empty (S : Stack) return Boolean is
//            ^^^^^^^^ definition scip-ada . . . Is_Empty().
//                      ^ definition scip-ada . . . S#
     begin
        return S.Top = 0;
     end Is_Empty;
  
     function Size (S : Stack) return Natural is
//            ^^^^ definition scip-ada . . . Size().
//                  ^ definition scip-ada . . . S#
     begin
        return S.Top;
     end Size;
  end Generic_Stack;
  
