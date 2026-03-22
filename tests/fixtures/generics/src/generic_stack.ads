generic
   type Element_Type is private;
   Max_Size : Positive;
package Generic_Stack is
   type Stack is private;

   procedure Push (S : in out Stack; Item : Element_Type);
   procedure Pop (S : in out Stack; Item : out Element_Type);
   function Is_Empty (S : Stack) return Boolean;
   function Size (S : Stack) return Natural;

private
   type Element_Array is array (1 .. Max_Size) of Element_Type;

   type Stack is record
      Data : Element_Array;
      Top  : Natural := 0;
   end record;
end Generic_Stack;
