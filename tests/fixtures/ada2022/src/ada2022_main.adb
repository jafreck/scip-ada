--  Ada 2022 Main — exercises Ada 2022 language constructs
--  Features tested:
--    - Delta aggregates
--    - Iterated component associations
--    - Declare expressions
--    - Target name symbol (@) in assignments
--    - Default_Initial_Condition aspect (via Ada2022_Types)
--    - Image attribute on all types ('Image without prefix in Ada 2022)

with Ada.Text_IO;   use Ada.Text_IO;
with Ada2022_Types; use Ada2022_Types;

procedure Ada2022_Main is

   -----------------------------------------------------------------
   --  Delta aggregates
   -----------------------------------------------------------------
   Origin : constant Point := (X => 0, Y => 0);

   --  Record delta aggregate: modify one field
   P1 : Point := (Origin with delta X => 10);

   --  Chain delta: modify both fields
   P2 : constant Point := (P1 with delta Y => 20);

   --  Color delta aggregate
   Base_Color : constant Color := (R => 255, G => 128, B => 0, A => 255);
   Faded      : constant Color := (Base_Color with delta A => 128);

   -----------------------------------------------------------------
   --  Iterated component associations
   -----------------------------------------------------------------

   --  Array with iterated association: squares
   Squares : constant Fixed_Array := (for I in 1 .. 5 => I * I);

   --  Array with expression
   Doubled : constant Fixed_Array := (for I in 1 .. 5 => I * 2);

   -----------------------------------------------------------------
   --  Target name symbol (@) in assignments
   -----------------------------------------------------------------
   Counter : Integer := 10;

   -----------------------------------------------------------------
   --  Default_Initial_Condition (aspect on Positive_Int type)
   -----------------------------------------------------------------
   PI : Positive_Int := Make (42);

   -----------------------------------------------------------------
   --  Declare expression
   -----------------------------------------------------------------
   function Triangle_Area (Base, Height : Float) return Float is
     (declare
        Half : constant Float := Base / 2.0;
      begin
        Half * Height);

   -----------------------------------------------------------------
   --  Local subprogram using Ada 2022 features
   -----------------------------------------------------------------
   procedure Show_Point (Label : String; P : Point) is
   begin
      Put_Line (Label & ": (" & P.X'Image & "," & P.Y'Image & ")");
   end Show_Point;

   procedure Show_Array (Label : String; A : Fixed_Array) is
   begin
      Put (Label & ": [");
      for I in A'Range loop
         Put (A (I)'Image);
         if I < A'Last then
            Put (",");
         end if;
      end loop;
      Put_Line ("]");
   end Show_Array;

   --  More locals for testing
   Area_Val : Float;

begin
   -----------------------------------------------------------------
   --  Show delta aggregate results
   -----------------------------------------------------------------
   Show_Point ("Origin", Origin);
   Show_Point ("P1 (delta X)", P1);
   Show_Point ("P2 (delta Y)", P2);

   Put_Line ("Faded alpha: " & Faded.A'Image);

   -----------------------------------------------------------------
   --  Show iterated component associations
   -----------------------------------------------------------------
   Show_Array ("Squares", Squares);
   Show_Array ("Doubled", Doubled);

   -----------------------------------------------------------------
   --  Target name (@) — increment Counter using @
   -----------------------------------------------------------------
   Counter := @ + 5;
   Put_Line ("Counter after @+5: " & Counter'Image);

   Counter := @ * 2;
   Put_Line ("Counter after @*2: " & Counter'Image);

   -----------------------------------------------------------------
   --  Declare expression
   -----------------------------------------------------------------
   Area_Val := Triangle_Area (10.0, 5.0);
   Put_Line ("Triangle area: " & Area_Val'Image);

   -----------------------------------------------------------------
   --  Default_Initial_Condition — use the validated type
   -----------------------------------------------------------------
   Put_Line ("Positive_Int value: " & Get (PI)'Image);
   PI := Make (99);
   Put_Line ("Updated value: " & Get (PI)'Image);

   -----------------------------------------------------------------
   --  Ada 2022 'Image on non-scalar prefix (if supported)
   -----------------------------------------------------------------
   Put_Line ("Direction: " & North'Image);

end Ada2022_Main;
