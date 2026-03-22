  --  Ada 2022 Types — types and contracts for Ada 2022 feature testing
  
  package Ada2022_Types is
//        ^^^^^^^^^^^^^ definition scip-ada . . . Ada2022_Types/
  
     --  Basic record type for delta aggregates
     type Point is record
//        ^^^^^ definition scip-ada . . . Point#
//        documentation
//        > Basic record type for delta aggregates
        X : Integer := 0;
//      ^ definition scip-ada . . . X.
        Y : Integer := 0;
//      ^ definition scip-ada . . . Y.
     end record;
//             ^^^^^ reference scip-ada . . . Point#
  
     --  Record with more fields for aggregate testing
//                        ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
     type Color is record
//        ^^^^^ definition scip-ada . . . Color#
//        documentation
//        > Record with more fields for aggregate testing
        R : Integer := 0;
//      ^ definition scip-ada . . . R.
        G : Integer := 0;
//      ^ definition scip-ada . . . G.
        B : Integer := 0;
//      ^ definition scip-ada . . . B.
        A : Integer := 255;
//      ^ definition scip-ada . . . A.
     end record;
//             ^^^^^ reference scip-ada . . . Color#
  
     --  Array types for iterated component associations
     type Int_Array is array (Positive range <>) of Integer;
     type Fixed_Array is array (1 .. 5) of Integer;
//        ^^^^^ reference scip-ada . . . Point#
//        ^^^^^^^^^^^^^^^^^^^^ definition scip-ada . . . Fixed_Array(integer)#
     type Matrix is array (1 .. 3, 1 .. 3) of Integer;
  
     --  Type with Default_Initial_Condition (Ada 2022 contract aspect)
//                 ^^^^^ reference scip-ada . . . Point#
     type Positive_Int is private
//        ^^^^^^^^^^^^ definition scip-ada . . . Positive_Int#
//        documentation
//        > Type with Default_Initial_Condition (Ada 2022 contract aspect)
       with Default_Initial_Condition => Is_Valid (Positive_Int);
  
     function Is_Valid (Value : Positive_Int) return Boolean;
//                         ^^^^^ reference scip-ada . . . Color#
     function Make (V : Positive) return Positive_Int;
//            ^^^^ definition scip-ada . . . Make().
//            documentation
//            > function Make (V : Positive) return Positive_Int
     function Get (Value : Positive_Int) return Positive;
//            ^^^ definition scip-ada . . . Get().
//            documentation
//            > function Get (Value : Positive_Int) return Positive
  
     --  Tagged type for class-wide / extension testing
     type Shape is tagged record
        Name : String (1 .. 10) := (others => ' ');
     end record;
  
     function Area (S : Shape) return Float;
  
//                      ^^^^^^^^^^^^^^^^^^^^ reference scip-ada . . . Fixed_Array(integer)#
     type Circle is new Shape with record
        Radius : Float := 0.0;
     end record;
  
     overriding function Area (S : Circle) return Float;
  
     --  Enumeration for various tests
     type Direction is (North, South, East, West);
//                      ^^^^^ definition scip-ada . . . North.
//                      documentation
//                      > Enumeration for various tests
  
     --  Access type
     type Int_Access is access all Integer;
  
  private
     type Positive_Int is record
        Value : Positive := 1;
     end record;
//             ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
  
  end Ada2022_Types;
//                 ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
  
