package body Utils is
   function Add (X, Y : Integer) return Integer is
   begin
      return X + Y;
   end Add;

   function Factorial (N : Natural) return Positive is
   begin
      if N <= 1 then
         return 1;
      else
         return N * Factorial (N - 1);
      end if;
   end Factorial;
end Utils;
