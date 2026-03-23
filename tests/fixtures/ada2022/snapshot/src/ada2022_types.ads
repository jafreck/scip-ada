  --  Ada 2022 Types — types and contracts for Ada 2022 feature testing
  
  package Ada2022_Types is
//        ^^^^^^^^^^^^^ definition scip-ada . . . Ada2022_Types/
//        kind Namespace
  
     --  Basic record type for delta aggregates
//             ^^^^^ reference scip-ada . . . Value#
     type Point is record
//       ^^^^^^^^ reference scip-ada . . . Is_Valid().
//        ^^^^^ definition scip-ada . . . Point#
//        kind Class
//               ^^^^^^^^ reference scip-ada . . . Is_Valid().
        X : Integer := 0;
//      ^ definition scip-ada . . . X.
//      kind Variable
        Y : Integer := 0;
//      ^ definition scip-ada . . . Y.
//      kind Variable
//                                       ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
     end record;
//             ^^^^^ reference scip-ada . . . Point#
  
//              ^^^^^ reference scip-ada . . . Value.
//                       ^ reference scip-ada . . . V.
     --  Record with more fields for aggregate testing
//       ^^^^ reference scip-ada . . . Make().
//           ^^^^ reference scip-ada . . . Make().
//                        ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
     type Color is record
//        ^^^^^ definition scip-ada . . . Color#
//        kind Class
        R : Integer := 0;
//      ^ definition scip-ada . . . R.
//      kind Variable
//                         ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
        G : Integer := 0;
//      ^ definition scip-ada . . . G.
//      kind Variable
        B : Integer := 0;
//      ^ definition scip-ada . . . B.
//      kind Variable
//             ^^^^^ reference scip-ada . . . Value#
//                   ^^^^^ reference scip-ada . . . Value.
        A : Integer := 255;
//      ^ definition scip-ada . . . A.
//      kind Variable
//       ^^^ reference scip-ada . . . Get().
//          ^^^ reference scip-ada . . . Get().
     end record;
//             ^^^^^ reference scip-ada . . . Color#
  
     --  Array types for iterated component associations
//                           ^ reference scip-ada . . . S#
     type Int_Array is array (Positive range <>) of Integer;
//        ^^^^^^^^^^^^^^^^^^ definition scip-ada . . . Int_Array(integer)#
//        kind Type
     type Fixed_Array is array (1 .. 5) of Integer;
//        ^^^^^ reference scip-ada . . . Point#
//        ^^^^^^^^^^^^^^^^^^^^ definition scip-ada . . . Fixed_Array(integer)#
//        kind Type
     type Matrix is array (1 .. 3, 1 .. 3) of Integer;
//       ^^^^ reference scip-ada . . . Area().
//        ^^^^^^^^^^^^^^^ definition scip-ada . . . Matrix(integer)#
//        kind Type
//           ^^^^ reference scip-ada . . . Area().
  
     --  Type with Default_Initial_Condition (Ada 2022 contract aspect)
//                 ^^^^^ reference scip-ada . . . Point#
     type Positive_Int is private
//        ^^^^^^^^^^^^ definition scip-ada . . . Positive_Int#
//        kind Class
       with Default_Initial_Condition => Is_Valid (Positive_Int);
//                       ^ reference scip-ada . . . S#
//                                  ^ reference scip-ada . . . S#
//                                    ^^^^^^ reference scip-ada . . . Radius.
//                                       ^^^^^^^^ reference scip-ada . . . Is_Valid().
  
//       ^^^^ reference scip-ada . . . Area().
//           ^^^^ reference scip-ada . . . Area().
     function Is_Valid (Value : Positive_Int) return Boolean;
//            ^^^^^^^^ definition scip-ada . . . Is_Valid().
//            kind Function
//            documentation
//            > function Is_Valid (Value : Positive_Int) return Boolean
//                      ^^^^^ definition scip-ada . . . Value#
//                      kind Struct
//                      documentation
//                      > function Is_Valid (Value : Positive_Int) return Boolean
//                         ^^^^^ reference scip-ada . . . Color#
//                              ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
     function Make (V : Positive) return Positive_Int;
//    ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
//            ^^^^ definition scip-ada . . . Make().
//            kind Function
//            documentation
//            > function Make (V : Positive) return Positive_Int
//                 ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
//                  ^ definition scip-ada . . . V.
//                  kind Variable
//                  documentation
//                  > function Make (V : Positive) return Positive_Int
//                                       ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
     function Get (Value : Positive_Int) return Positive;
//            ^^^ definition scip-ada . . . Get().
//            kind Function
//            documentation
//            > function Get (Value : Positive_Int) return Positive
//                         ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
  
     --  Tagged type for class-wide / extension testing
     type Shape is tagged record
//        ^^^^^ definition scip-ada . . . Shape#
//        kind Class
        Name : String (1 .. 10) := (others => ' ');
//      ^^^^ definition scip-ada . . . Name.
//      kind Variable
     end record;
//             ^^^^^ reference scip-ada . . . Shape#
  
     function Area (S : Shape) return Float;
//            ^^^^ definition scip-ada . . . Area().
//            kind Function
//            documentation
//            > function Area (S : Shape) return Float
//            ^^^^^ reference scip-ada . . . Shape#
//                  ^ definition scip-ada . . . S#
//                  kind Struct
//                  documentation
//                  > function Area (S : Shape) return Float
//                      ^^^^^ reference scip-ada . . . Shape#
  
//                      ^^^^^^^^^^^^^^^^^^^^ reference scip-ada . . . Fixed_Array(integer)#
     type Circle is new Shape with record
//        ^^^^^^ definition scip-ada . . . Circle#
//        kind Class
//                      ^^^^^ reference scip-ada . . . Shape#
        Radius : Float := 0.0;
//      ^^^^^^ definition scip-ada . . . Radius.
//      kind Variable
     end record;
//             ^^^^^^ reference scip-ada . . . Circle#
  
     overriding function Area (S : Circle) return Float;
//                       ^^^^^^ reference scip-ada . . . Circle#
//                                 ^^^^^^ reference scip-ada . . . Circle#
  
     --  Enumeration for various tests
     type Direction is (North, South, East, West);
//        ^^^^^^^^^ definition scip-ada . . . Direction#
//        kind Enum
//                      ^^^^^ definition scip-ada . . . North.
//                      kind EnumMember
//                             ^^^^^ definition scip-ada . . . South.
//                             kind EnumMember
//                                    ^^^^ definition scip-ada . . . East.
//                                    kind EnumMember
//                                          ^^^^ definition scip-ada . . . West.
//                                          kind EnumMember
//                                               ^^^^^^^^^ reference scip-ada . . . Direction#
  
     --  Access type
     type Int_Access is access all Integer;
//        ^^^^^^^^^^^^^^^^^^^ definition scip-ada . . . Int_Access(integer)#
//        kind Type
  
  private
     type Positive_Int is record
//        ^^^^^^^^^^^^ definition scip-ada . . . Positive_Int#
//        kind Class
//        ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
        Value : Positive := 1;
//      ^^^^^ definition scip-ada . . . Value.
//      kind Variable
     end record;
//             ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
  
  end Ada2022_Types;
//    ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
//                 ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
  
