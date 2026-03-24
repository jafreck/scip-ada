  --  Ada 2022 Main — exercises Ada 2022 language constructs
  --  Features tested:
  --    - Delta aggregates
  --    - Iterated component associations
  --    - Declare expressions
  --    - Target name symbol (@) in assignments
  --    - Default_Initial_Condition aspect (via Ada2022_Types)
  --    - Image attribute on all types ('Image without prefix in Ada 2022)
  
  with Ada.Text_IO;   use Ada.Text_IO;
//     ^^^ reference scip-ada . Ada2022 . Ada/
//         ^^^^^^^ reference scip-ada . Ada2022 . Text_IO/
  with Ada2022_Types; use Ada2022_Types;
//     ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Types/
  
  procedure Ada2022_Main is
//          ^^^^^^^^^^^^ definition scip-ada . Ada2022 . Ada2022_Main().
//          kind Function
//          ^^^^^^^^^^^^ definition scip-ada . Ada2022 . Ada2022_Main().
//          kind Function
  
     -----------------------------------------------------------------
     --  Delta aggregates
     -----------------------------------------------------------------
     Origin : constant Point := (X => 0, Y => 0);
//   ^^^^^^ definition scip-ada . Ada2022 . Origin#
//   kind Struct
//   documentation
//   > --------------------------------------------------------------
//   > Delta aggregates
//   > --------------------------------------------------------------
//                     ^^^^^ reference scip-ada . Ada2022 . Point#
//                               ^ reference scip-ada . Ada2022 . X.
//                                       ^ reference scip-ada . Ada2022 . Y.
  
     --  Record delta aggregate: modify one field
     P1 : Point := (Origin with delta X => 10);
//   ^^ definition scip-ada . Ada2022 . P1#
//   kind Struct
//   documentation
//   > Record delta aggregate: modify one field
//                  ^^^^^^ reference scip-ada . Ada2022 . Origin#
  
     --  Chain delta: modify both fields
     P2 : constant Point := (P1 with delta Y => 20);
//   ^^ definition scip-ada . Ada2022 . P2#
//   kind Struct
//   documentation
//   > Chain delta: modify both fields
//                           ^^ reference scip-ada . Ada2022 . P1#
  
     --  Color delta aggregate
     Base_Color : constant Color := (R => 255, G => 128, B => 0, A => 255);
//   ^^^^^^^^^^ definition scip-ada . Ada2022 . Base_Color#
//   kind Struct
//   documentation
//   > Color delta aggregate
//                         ^^^^^ reference scip-ada . Ada2022 . Color#
//                                   ^ reference scip-ada . Ada2022 . R.
//                                             ^ reference scip-ada . Ada2022 . G.
//                                                       ^ reference scip-ada . Ada2022 . B.
//                                                               ^ reference scip-ada . Ada2022 . A.
     Faded      : constant Color := (Base_Color with delta A => 128);
//   ^^^^^ definition scip-ada . Ada2022 . Faded#
//   kind Struct
//                                   ^^^^^^^^^^ reference scip-ada . Ada2022 . Base_Color#
  
     -----------------------------------------------------------------
     --  Iterated component associations
     -----------------------------------------------------------------
  
     --  Array with iterated association: squares
     Squares : constant Fixed_Array := (for I in 1 .. 5 => I * I);
//   ^^^^^^^ definition scip-ada . Ada2022 . Squares.
//   kind Variable
//   documentation
//   > Array with iterated association: squares
//                      ^^^^^^^^^^^^^^^^^^^^ reference scip-ada . Ada2022 . `Fixed_Array(integer)`#
//                                          ^ definition scip-ada . Ada2022 . I.
//                                          kind Variable
//                                          documentation
//                                          > Array with iterated association: squares
//                                                         ^ reference scip-ada . Ada2022 . I.
//                                                             ^ reference scip-ada . Ada2022 . I.
  
     --  Array with expression
     Doubled : constant Fixed_Array := (for I in 1 .. 5 => I * 2);
//   ^^^^^^^ definition scip-ada . Ada2022 . Doubled.
//   kind Variable
//   documentation
//   > Array with expression
//                                                         ^ reference scip-ada . Ada2022 . I.
  
     -----------------------------------------------------------------
     --  Target name symbol (@) in assignments
     -----------------------------------------------------------------
     Counter : Integer := 10;
//   ^^^^^^^ definition scip-ada . Ada2022 . Counter.
//   kind Variable
//   documentation
//   > --------------------------------------------------------------
//   > Target name symbol (@) in assignments
//   > --------------------------------------------------------------
  
     -----------------------------------------------------------------
     --  Default_Initial_Condition (aspect on Positive_Int type)
     -----------------------------------------------------------------
     PI : Positive_Int := Make (42);
//   ^^ definition scip-ada . Ada2022 . PI#
//   kind Struct
//   documentation
//   > --------------------------------------------------------------
//   > Default_Initial_Condition (aspect on Positive_Int type)
//   > --------------------------------------------------------------
//        ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Positive_Int#
//                        ^^^^ reference scip-ada . Ada2022 . Make().
  
     -----------------------------------------------------------------
     --  Declare expression
     -----------------------------------------------------------------
     function Triangle_Area (Base, Height : Float) return Float is
//            ^^^^^^^^^^^^^ definition scip-ada . Ada2022 . Triangle_Area().
//            kind Function
//            ^^^^^^^^^^^^^ definition scip-ada . Ada2022 . Triangle_Area().
//            kind Function
//                           ^^^^ definition scip-ada . Ada2022 . Base.
//                           kind Variable
//                                 ^^^^^^ definition scip-ada . Ada2022 . Height.
//                                 kind Variable
       (declare
          Half : constant Float := Base / 2.0;
//        ^^^^ definition scip-ada . Ada2022 . Half.
//        kind Variable
//                                 ^^^^ reference scip-ada . Ada2022 . Base.
        begin
          Half * Height);
//        ^^^^ reference scip-ada . Ada2022 . Half.
//               ^^^^^^ reference scip-ada . Ada2022 . Height.
  
     -----------------------------------------------------------------
     --  Local subprogram using Ada 2022 features
     -----------------------------------------------------------------
     procedure Show_Point (Label : String; P : Point) is
//             ^^^^^^^^^^ definition scip-ada . Ada2022 . Show_Point().
//             kind Function
//             documentation
//             > --------------------------------------------------------------
//             > Local subprogram using Ada 2022 features
//             > --------------------------------------------------------------
//             ^^^^^^^^^^ definition scip-ada . Ada2022 . Show_Point().
//             kind Function
//             documentation
//             > --------------------------------------------------------------
//             > Local subprogram using Ada 2022 features
//             > --------------------------------------------------------------
//                         ^^^^^ definition scip-ada . Ada2022 . Label.
//                         kind Variable
//                         documentation
//                         > --------------------------------------------------------------
//                         > Local subprogram using Ada 2022 features
//                         > --------------------------------------------------------------
//                                         ^ definition scip-ada . Ada2022 . P#
//                                         kind Struct
//                                         documentation
//                                         > --------------------------------------------------------------
//                                         > Local subprogram using Ada 2022 features
//                                         > --------------------------------------------------------------
     begin
        Put_Line (Label & ": (" & P.X'Image & "," & P.Y'Image & ")");
//      ^^^^^^^^ reference scip-ada . Ada2022 . Put_Line().
//                ^^^^^ reference scip-ada . Ada2022 . Label.
//                                ^ reference scip-ada . Ada2022 . P#
//                                                  ^ reference scip-ada . Ada2022 . P#
     end Show_Point;
//       ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Point().
//                 ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Point().
  
     procedure Show_Array (Label : String; A : Fixed_Array) is
//             ^^^^^^^^^^ definition scip-ada . Ada2022 . Show_Array().
//             kind Function
//             ^^^^^^^^^^ definition scip-ada . Ada2022 . Show_Array().
//             kind Function
//                                         ^ definition scip-ada . Ada2022 . A.
//                                         kind Variable
     begin
        Put (Label & ": [");
//      ^^^ reference scip-ada . Ada2022 . Put().
//           ^^^^^ reference scip-ada . Ada2022 . Label.
        for I in A'Range loop
//               ^ reference scip-ada . Ada2022 . A.
           Put (A (I)'Image);
//              ^ reference scip-ada . Ada2022 . A.
//                 ^ reference scip-ada . Ada2022 . I.
           if I < A'Last then
//            ^ reference scip-ada . Ada2022 . I.
//                ^ reference scip-ada . Ada2022 . A.
              Put (",");
           end if;
        end loop;
        Put_Line ("]");
     end Show_Array;
//       ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Array().
//                 ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Array().
  
     --  More locals for testing
     Area_Val : Float;
//   ^^^^^^^^ definition scip-ada . Ada2022 . Area_Val.
//   kind Variable
//   documentation
//   > More locals for testing
  
  begin
     -----------------------------------------------------------------
     --  Show delta aggregate results
     -----------------------------------------------------------------
     Show_Point ("Origin", Origin);
//   ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Point().
//                         ^^^^^^ reference scip-ada . Ada2022 . Origin#
     Show_Point ("P1 (delta X)", P1);
//   ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Point().
//                               ^^ reference scip-ada . Ada2022 . P1#
     Show_Point ("P2 (delta Y)", P2);
//   ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Point().
//                               ^^ reference scip-ada . Ada2022 . P2#
  
     Put_Line ("Faded alpha: " & Faded.A'Image);
//                               ^^^^^ reference scip-ada . Ada2022 . Faded#
  
     -----------------------------------------------------------------
     --  Show iterated component associations
     -----------------------------------------------------------------
     Show_Array ("Squares", Squares);
//   ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Array().
//                          ^^^^^^^ reference scip-ada . Ada2022 . Squares.
     Show_Array ("Doubled", Doubled);
//   ^^^^^^^^^^ reference scip-ada . Ada2022 . Show_Array().
//                          ^^^^^^^ reference scip-ada . Ada2022 . Doubled.
  
     -----------------------------------------------------------------
     --  Target name (@) — increment Counter using @
     -----------------------------------------------------------------
     Counter := @ + 5;
//   ^^^^^^^ reference scip-ada . Ada2022 . Counter.
     Put_Line ("Counter after @+5: " & Counter'Image);
//                                     ^^^^^^^ reference scip-ada . Ada2022 . Counter.
  
     Counter := @ * 2;
//   ^^^^^^^ reference scip-ada . Ada2022 . Counter.
     Put_Line ("Counter after @*2: " & Counter'Image);
//                                     ^^^^^^^ reference scip-ada . Ada2022 . Counter.
  
     -----------------------------------------------------------------
     --  Declare expression
     -----------------------------------------------------------------
     Area_Val := Triangle_Area (10.0, 5.0);
//   ^^^^^^^^ reference scip-ada . Ada2022 . Area_Val.
//               ^^^^^^^^^^^^^ reference scip-ada . Ada2022 . Triangle_Area().
     Put_Line ("Triangle area: " & Area_Val'Image);
//                                 ^^^^^^^^ reference scip-ada . Ada2022 . Area_Val.
  
     -----------------------------------------------------------------
     --  Default_Initial_Condition — use the validated type
     -----------------------------------------------------------------
     Put_Line ("Positive_Int value: " & Get (PI)'Image);
//                                      ^^^ reference scip-ada . Ada2022 . Get().
//                                           ^^ reference scip-ada . Ada2022 . PI#
     PI := Make (99);
//   ^^ reference scip-ada . Ada2022 . PI#
     Put_Line ("Updated value: " & Get (PI)'Image);
//                                      ^^ reference scip-ada . Ada2022 . PI#
  
     -----------------------------------------------------------------
     --  Ada 2022 'Image on non-scalar prefix (if supported)
     -----------------------------------------------------------------
     Put_Line ("Direction: " & North'Image);
//                             ^^^^^ reference scip-ada . Ada2022 . North.
  
  end Ada2022_Main;
//    ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Main().
//                ^^^^^^^^^^^^ reference scip-ada . Ada2022 . Ada2022_Main().
  
