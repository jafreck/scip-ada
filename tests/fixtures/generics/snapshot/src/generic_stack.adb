  package body Generic_Stack is
//             ^^^^^^^^^^^^^ definition scip-ada . Generics . Generic_Stack/
     procedure Push (S : in out Stack; Item : Element_Type) is
//             ^^^^ definition scip-ada . Generics . Push().
//                   ^ definition scip-ada . Generics . S#
//                              ^^^^^ reference scip-ada . Generics . Stack#
//                                     ^^^^ definition scip-ada . Generics . [Item]
//                                            ^^^^^^^^^^^^ reference scip-ada . Generics . [Element_Type]
     begin
        if S.Top < Max_Size then
//           ^^^ reference scip-ada . Generics . Top.
//                 ^^^^^^^^ reference scip-ada . Generics . Max_Size.
           S.Top := S.Top + 1;
           S.Data (S.Top) := Item;
//           ^^^^ reference scip-ada . Generics . Data.
        end if;
     end Push;
  
     procedure Pop (S : in out Stack; Item : out Element_Type) is
//             ^^^ definition scip-ada . Generics . Pop().
//                  ^ definition scip-ada . Generics . S#
//                                    ^^^^ definition scip-ada . Generics . [Item]
     begin
        Item := S.Data (S.Top);
        S.Top := S.Top - 1;
     end Pop;
  
     function Is_Empty (S : Stack) return Boolean is
//            ^^^^^^^^ definition scip-ada . Generics . Is_Empty().
//                      ^ definition scip-ada . Generics . S#
     begin
        return S.Top = 0;
     end Is_Empty;
  
     function Size (S : Stack) return Natural is
//            ^^^^ definition scip-ada . Generics . Size().
//                  ^ definition scip-ada . Generics . S#
     begin
        return S.Top;
     end Size;
  end Generic_Stack;
  
