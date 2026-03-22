with Ada.Text_IO;
with Generic_Stack;

procedure Generics_Main is
   package Int_Stack is new Generic_Stack
     (Element_Type => Integer,
      Max_Size     => 10);

   package Char_Stack is new Generic_Stack
     (Element_Type => Character,
      Max_Size     => 5);

   S : Int_Stack.Stack;
   C : Char_Stack.Stack;
begin
   Int_Stack.Push (S, 42);
   Int_Stack.Push (S, 99);

   Char_Stack.Push (C, 'A');

   Ada.Text_IO.Put_Line ("Int stack size:" & Natural'Image (Int_Stack.Size (S)));
   Ada.Text_IO.Put_Line ("Char stack empty: " & Boolean'Image (Char_Stack.Is_Empty (C)));

   declare
      Val : Integer;
   begin
      Int_Stack.Pop (S, Val);
      Ada.Text_IO.Put_Line ("Popped:" & Integer'Image (Val));
   end;
end Generics_Main;
