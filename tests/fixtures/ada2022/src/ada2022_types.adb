package body Ada2022_Types is

   function Is_Valid (Value : Positive_Int) return Boolean is
   begin
      return Value.Value > 0;
   end Is_Valid;

   function Make (V : Positive) return Positive_Int is
   begin
      return (Value => V);
   end Make;

   function Get (Value : Positive_Int) return Positive is
   begin
      return Value.Value;
   end Get;

   function Area (S : Shape) return Float is
      pragma Unreferenced (S);
   begin
      return 0.0;
   end Area;

   function Area (S : Circle) return Float is
   begin
      return 3.14159 * S.Radius * S.Radius;
   end Area;

end Ada2022_Types;
