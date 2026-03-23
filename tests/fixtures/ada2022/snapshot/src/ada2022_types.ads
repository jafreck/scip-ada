  --  Ada 2022 Types — types and contracts for Ada 2022 feature testing
  
  package Ada2022_Types is
//        ^^^^^^^^^^^^^ definition scip-ada . Ada2022 . Ada2022_Types/
//        kind Namespace
  
     --  Basic record type for delta aggregates
//             ^^^^^ reference scip-ada . Ada2022 . Value#
     type Point is record
//       ^^^^^^^^ reference scip-ada . Ada2022 . Is_Valid().
//        ^^^^^ definition scip-ada . Ada2022 . Point#
//        kind Class
//        documentation
//        > Basic record type for delta aggregates
//               ^^^^^^^^ reference scip-ada . Ada2022 . Is_Valid().
        X : Integer := 0;
//      ^ definition scip-ada . Ada2022 . X.
//      kind Variable
        Y : Integer := 0;
//      ^ definition scip-ada . Ada2022 . Y.
//      kind Variable
//                                       ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
     end record;
//             ^^^^^ reference scip-ada . Ada2022 . Point#
  
//              ^^^^^ reference scip-ada . Ada2022 . Value.
//                       ^ reference scip-ada . Ada2022 . V.
     --  Record with more fields for aggregate testing
//       ^^^^ reference scip-ada . Ada2022 . Make().
//           ^^^^ reference scip-ada . Ada2022 . Make().
//                        ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
     type Color is record
//        ^^^^^ definition scip-ada . Ada2022 . Color#
//        kind Class
//        documentation
//        > Record with more fields for aggregate testing
        R : Integer := 0;
//      ^ definition scip-ada . Ada2022 . R.
//      kind Variable
//                         ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
        G : Integer := 0;
//      ^ definition scip-ada . Ada2022 . G.
//      kind Variable
        B : Integer := 0;
//      ^ definition scip-ada . Ada2022 . B.
//      kind Variable
//             ^^^^^ reference scip-ada . Ada2022 . Value#
//                   ^^^^^ reference scip-ada . Ada2022 . Value.
        A : Integer := 255;
//      ^ definition scip-ada . Ada2022 . A.
//      kind Variable
//       ^^^ reference scip-ada . Ada2022 . Get().
//          ^^^ reference scip-ada . Ada2022 . Get().
     end record;
//             ^^^^^ reference scip-ada . Ada2022 . Color#
  
     --  Array types for iterated component associations
//                           ^ reference scip-ada . Ada2022 . S#
     type Int_Array is array (Positive range <>) of Integer;
//        ^^^^^^^^^^^^^^^^^^ definition scip-ada . Ada2022 . `Int_Array(integer)`#
//        kind Type
//        documentation
//        > Array types for iterated component associations
     type Fixed_Array is array (1 .. 5) of Integer;
//        ^^^^^ reference scip-ada . Ada2022 . Point#
//        ^^^^^^^^^^^^^^^^^^^^ definition scip-ada . Ada2022 . `Fixed_Array(integer)`#
//        kind Type
     type Matrix is array (1 .. 3, 1 .. 3) of Integer;
//       ^^^^ reference scip-ada . Ada2022 . Area().
//        ^^^^^^^^^^^^^^^ definition scip-ada . Ada2022 . `Matrix(integer)`#
//        kind Type
//           ^^^^ reference scip-ada . Ada2022 . Area().
  
     --  Type with Default_Initial_Condition (Ada 2022 contract aspect)
//                 ^^^^^ reference scip-ada . Ada2022 . Point#
     type Positive_Int is private
//        ^^^^^^^^^^^^ definition scip-ada . Ada2022 . Positive_Int#
//        kind Class
//        documentation
//        > Type with Default_Initial_Condition (Ada 2022 contract aspect)
       with Default_Initial_Condition => Is_Valid (Positive_Int);
//                       ^ reference scip-ada . Ada2022 . S#
//                                  ^ reference scip-ada . Ada2022 . S#
//                                    ^^^^^^ reference scip-ada . Ada2022 . Radius.
//                                       ^^^^^^^^ reference scip-ada . Ada2022 . Is_Valid().
  
//       ^^^^ reference scip-ada . Ada2022 . Area().
//           ^^^^ reference scip-ada . Ada2022 . Area().
     function Is_Valid (Value : Positive_Int) return Boolean;
//            ^^^^^^^^ definition scip-ada . Ada2022 . Is_Valid().
//            kind Function
//                      ^^^^^ definition scip-ada . Ada2022 . Value#
//                      kind Struct
//                         ^^^^^ reference scip-ada . Ada2022 . Color#
//                              ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
     function Make (V : Positive) return Positive_Int;
//    ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
//            ^^^^ definition scip-ada . Ada2022 . Make().
//            kind Function
//                 ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
//                  ^ definition scip-ada . Ada2022 . V.
//                  kind Variable
//                                       ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
     function Get (Value : Positive_Int) return Positive;
//            ^^^ definition scip-ada . Ada2022 . Get().
//            kind Function
//                         ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
  
     --  Tagged type for class-wide / extension testing
     type Shape is tagged record
//        ^^^^^ definition scip-ada . Ada2022 . Shape#
//        kind Class
//        documentation
//        > Tagged type for class-wide / extension testing
        Name : String (1 .. 10) := (others => ' ');
//      ^^^^ definition scip-ada . Ada2022 . Name.
//      kind Variable
     end record;
//             ^^^^^ reference scip-ada . Ada2022 . Shape#
  
     function Area (S : Shape) return Float;
//            ^^^^ definition scip-ada . Ada2022 . Area().
//            kind Function
//            ^^^^^ reference scip-ada . Ada2022 . Shape#
//                  ^ definition scip-ada . Ada2022 . S#
//                  kind Struct
//                      ^^^^^ reference scip-ada . Ada2022 . Shape#
  
//                      ^^^^^^^^^^^^^^^^^^^^ reference scip-ada . Ada2022 . `Fixed_Array(integer)`#
     type Circle is new Shape with record
//        ^^^^^^ definition scip-ada . Ada2022 . Circle#
//        kind Class
//        relationship scip-ada . Ada2022 . Ada2022_Types#Shape# type_definition
//                      ^^^^^ reference scip-ada . Ada2022 . Shape#
        Radius : Float := 0.0;
//      ^^^^^^ definition scip-ada . Ada2022 . Radius.
//      kind Variable
     end record;
//             ^^^^^^ reference scip-ada . Ada2022 . Circle#
  
     overriding function Area (S : Circle) return Float;
//                       ^^^^^^ reference scip-ada . Ada2022 . Circle#
//                                 ^^^^^^ reference scip-ada . Ada2022 . Circle#
  
     --  Enumeration for various tests
     type Direction is (North, South, East, West);
//        ^^^^^^^^^ definition scip-ada . Ada2022 . Direction#
//        kind Enum
//        documentation
//        > Enumeration for various tests
//                      ^^^^^ definition scip-ada . Ada2022 . North.
//                      kind EnumMember
//                      documentation
//                      > Enumeration for various tests
//                             ^^^^^ definition scip-ada . Ada2022 . South.
//                             kind EnumMember
//                             documentation
//                             > Enumeration for various tests
//                                    ^^^^ definition scip-ada . Ada2022 . East.
//                                    kind EnumMember
//                                    documentation
//                                    > Enumeration for various tests
//                                          ^^^^ definition scip-ada . Ada2022 . West.
//                                          kind EnumMember
//                                          documentation
//                                          > Enumeration for various tests
//                                               ^^^^^^^^^ reference scip-ada . Ada2022 . Direction#
  
     --  Access type
     type Int_Access is access all Integer;
//        ^^^^^^^^^^^^^^^^^^^ definition scip-ada . Ada2022 . `Int_Access(integer)`#
//        kind Type
//        documentation
//        > Access type
  
  private
     type Positive_Int is record
//        ^^^^^^^^^^^^ definition scip-ada . Ada2022 . Positive_Int#
//        kind Class
//        documentation
//        > Type with Default_Initial_Condition (Ada 2022 contract aspect)
//        ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
        Value : Positive := 1;
//      ^^^^^ definition scip-ada . Ada2022 . Value.
//      kind Variable
     end record;
//             ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
  
  end Ada2022_Types;
//    ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
//                 ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
  
