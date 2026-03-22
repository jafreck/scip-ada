--  Ada 2022 Types — types and contracts for Ada 2022 feature testing

package Ada2022_Types is

   --  Basic record type for delta aggregates
   type Point is record
      X : Integer := 0;
      Y : Integer := 0;
   end record;

   --  Record with more fields for aggregate testing
   type Color is record
      R : Integer := 0;
      G : Integer := 0;
      B : Integer := 0;
      A : Integer := 255;
   end record;

   --  Array types for iterated component associations
   type Int_Array is array (Positive range <>) of Integer;
   type Fixed_Array is array (1 .. 5) of Integer;
   type Matrix is array (1 .. 3, 1 .. 3) of Integer;

   --  Type with Default_Initial_Condition (Ada 2022 contract aspect)
   type Positive_Int is private
     with Default_Initial_Condition => Is_Valid (Positive_Int);

   function Is_Valid (Value : Positive_Int) return Boolean;
   function Make (V : Positive) return Positive_Int;
   function Get (Value : Positive_Int) return Positive;

   --  Tagged type for class-wide / extension testing
   type Shape is tagged record
      Name : String (1 .. 10) := (others => ' ');
   end record;

   function Area (S : Shape) return Float;

   type Circle is new Shape with record
      Radius : Float := 0.0;
   end record;

   overriding function Area (S : Circle) return Float;

   --  Enumeration for various tests
   type Direction is (North, South, East, West);

   --  Access type
   type Int_Access is access all Integer;

private
   type Positive_Int is record
      Value : Positive := 1;
   end record;

end Ada2022_Types;
