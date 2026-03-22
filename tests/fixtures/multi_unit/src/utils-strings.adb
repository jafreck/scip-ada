package body Utils.Strings is
   function Repeat_Char (C : Character; Count : Natural) return String is
      Result : String (1 .. Count) := (others => C);
   begin
      return Result;
   end Repeat_Char;
end Utils.Strings;
