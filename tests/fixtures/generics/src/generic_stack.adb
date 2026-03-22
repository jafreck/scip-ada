package body Generic_Stack is
   procedure Push (S : in out Stack; Item : Element_Type) is
   begin
      if S.Top < Max_Size then
         S.Top := S.Top + 1;
         S.Data (S.Top) := Item;
      end if;
   end Push;

   procedure Pop (S : in out Stack; Item : out Element_Type) is
   begin
      Item := S.Data (S.Top);
      S.Top := S.Top - 1;
   end Pop;

   function Is_Empty (S : Stack) return Boolean is
   begin
      return S.Top = 0;
   end Is_Empty;

   function Size (S : Stack) return Natural is
   begin
      return S.Top;
   end Size;
end Generic_Stack;
