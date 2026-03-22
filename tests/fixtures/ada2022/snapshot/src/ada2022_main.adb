  --  Ada 2022 Main — exercises Ada 2022 language constructs
  --  Features tested:
  --    - Delta aggregates
  --    - Iterated component associations
  --    - Declare expressions
  --    - Target name symbol (@) in assignments
  --    - Default_Initial_Condition aspect (via Ada2022_Types)
  --    - Image attribute on all types ('Image without prefix in Ada 2022)
  
  with Ada.Text_IO;   use Ada.Text_IO;
//     ^^^ reference scip-ada . . . Ada/
//         ^^^^^^^ reference scip-ada . . . Text_IO/
  with Ada2022_Types; use Ada2022_Types;
//     ^^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Types/
  
  procedure Ada2022_Main is
//          ^^^^^^^^^^^^ definition scip-ada . . . Ada2022_Main().
//          documentation
//          > procedure Ada2022_Main
//          ^^^^^^^^^^^^ definition scip-ada . . . Ada2022_Main().
//          documentation
//          > procedure Ada2022_Main
  
     -----------------------------------------------------------------
     --  Delta aggregates
     -----------------------------------------------------------------
     Origin : constant Point := (X => 0, Y => 0);
//   ^^^^^^ definition scip-ada . . . Origin#
//   documentation
//   > --------------------------------------------------------------
//   > Delta aggregates
//   > --------------------------------------------------------------
//                     ^^^^^ reference scip-ada . . . Point#
//                               ^ reference scip-ada . . . X.
//                                       ^ reference scip-ada . . . Y.
  
     --  Record delta aggregate: modify one field
     P1 : Point := (Origin with delta X => 10);
//   ^^ definition scip-ada . . . P1#
//   documentation
//   > Record delta aggregate: modify one field
//                  ^^^^^^ reference scip-ada . . . Origin#
  
     --  Chain delta: modify both fields
     P2 : constant Point := (P1 with delta Y => 20);
//   ^^ definition scip-ada . . . P2#
//   documentation
//   > Chain delta: modify both fields
//                           ^^ reference scip-ada . . . P1#
  
     --  Color delta aggregate
     Base_Color : constant Color := (R => 255, G => 128, B => 0, A => 255);
//   ^^^^^^^^^^ definition scip-ada . . . Base_Color#
//   documentation
//   > Color delta aggregate
//                         ^^^^^ reference scip-ada . . . Color#
//                                   ^ reference scip-ada . . . R.
//                                             ^ reference scip-ada . . . G.
//                                                       ^ reference scip-ada . . . B.
//                                                               ^ reference scip-ada . . . A.
     Faded      : constant Color := (Base_Color with delta A => 128);
//   ^^^^^ definition scip-ada . . . Faded#
//                                   ^^^^^^^^^^ reference scip-ada . . . Base_Color#
  
     -----------------------------------------------------------------
     --  Iterated component associations
     -----------------------------------------------------------------
  
     --  Array with iterated association: squares
     Squares : constant Fixed_Array := (for I in 1 .. 5 => I * I);
//   ^^^^^^^ definition scip-ada . . . Squares.
//   documentation
//   > Array with iterated association: squares
//                      ^^^^^^^^^^^^^^^^^^^^ reference scip-ada . . . Fixed_Array(integer)#
//                                          ^ definition scip-ada . . . I.
//                                                         ^ reference scip-ada . . . I.
//                                                             ^ reference scip-ada . . . I.
  
     --  Array with expression
     Doubled : constant Fixed_Array := (for I in 1 .. 5 => I * 2);
//   ^^^^^^^ definition scip-ada . . . Doubled.
//   documentation
//   > Array with expression
//                                          ^ definition scip-ada . . . I.
//                                                         ^ reference scip-ada . . . I.
  
     -----------------------------------------------------------------
     --  Target name symbol (@) in assignments
     -----------------------------------------------------------------
     Counter : Integer := 10;
//   ^^^^^^^ definition scip-ada . . . Counter.
//   documentation
//   > --------------------------------------------------------------
//   > Target name symbol (@) in assignments
//   > --------------------------------------------------------------
  
     -----------------------------------------------------------------
     --  Default_Initial_Condition (aspect on Positive_Int type)
     -----------------------------------------------------------------
     PI : Positive_Int := Make (42);
//   ^^ definition scip-ada . . . PI#
//   documentation
//   > --------------------------------------------------------------
//   > Default_Initial_Condition (aspect on Positive_Int type)
//   > --------------------------------------------------------------
//        ^^^^^^^^^^^^ reference scip-ada . . . Positive_Int#
//                        ^^^^ reference scip-ada . . . Make().
  
     -----------------------------------------------------------------
     --  Declare expression
     -----------------------------------------------------------------
     function Triangle_Area (Base, Height : Float) return Float is
//            ^^^^^^^^^^^^^ definition scip-ada . . . Triangle_Area().
//            documentation
//            > function Triangle_Area (Base, Height : Float) return Float
//            ^^^^^^^^^^^^^ definition scip-ada . . . Triangle_Area().
//            documentation
//            > function Triangle_Area (Base, Height : Float) return Float
//                           ^^^^ definition scip-ada . . . Base.
//                           documentation
//                           > function Triangle_Area (Base, Height : Float) return Float
//                                 ^^^^^^ definition scip-ada . . . Height.
//                                 documentation
//                                 > function Triangle_Area (Base, Height : Float) return Float
       (declare
          Half : constant Float := Base / 2.0;
//        ^^^^ definition scip-ada . . . Half.
//                                 ^^^^ reference scip-ada . . . Base.
        begin
          Half * Height);
//        ^^^^ reference scip-ada . . . Half.
//               ^^^^^^ reference scip-ada . . . Height.
  
     -----------------------------------------------------------------
     --  Local subprogram using Ada 2022 features
     -----------------------------------------------------------------
     procedure Show_Point (Label : String; P : Point) is
//             ^^^^^^^^^^ definition scip-ada . . . Show_Point().
//             documentation
//             > procedure Show_Point (Label : String; P : Point)
//             documentation
//             > --------------------------------------------------------------
//             > Local subprogram using Ada 2022 features
//             > --------------------------------------------------------------
//             ^^^^^^^^^^ definition scip-ada . . . Show_Point().
//             documentation
//             > procedure Show_Point (Label : String; P : Point)
//             documentation
//             > --------------------------------------------------------------
//             > Local subprogram using Ada 2022 features
//             > --------------------------------------------------------------
//                         ^^^^^ definition scip-ada . . . Label.
//                         documentation
//                         > procedure Show_Array (Label : String; A : Fixed_Array)
//                                         ^ definition scip-ada . . . P#
//                                         documentation
//                                         > procedure Show_Point (Label : String; P : Point)
//                                         documentation
//                                         > --------------------------------------------------------------
//                                         > Local subprogram using Ada 2022 features
//                                         > --------------------------------------------------------------
     begin
        Put_Line (Label & ": (" & P.X'Image & "," & P.Y'Image & ")");
//      ^^^^^^^^ reference scip-ada . . . Put_Line().
//                ^^^^^ reference scip-ada . . . Label.
//                                ^ reference scip-ada . . . P#
//                                                  ^ reference scip-ada . . . P#
     end Show_Point;
//       ^^^^^^^^^^ reference scip-ada . . . Show_Point().
//                 ^^^^^^^^^^ reference scip-ada . . . Show_Point().
  
     procedure Show_Array (Label : String; A : Fixed_Array) is
//             ^^^^^^^^^^ definition scip-ada . . . Show_Array().
//             documentation
//             > procedure Show_Array (Label : String; A : Fixed_Array)
//             ^^^^^^^^^^ definition scip-ada . . . Show_Array().
//             documentation
//             > procedure Show_Array (Label : String; A : Fixed_Array)
//                         ^^^^^ definition scip-ada . . . Label.
//                         documentation
//                         > procedure Show_Array (Label : String; A : Fixed_Array)
//                                         ^ definition scip-ada . . . A.
//                                         documentation
//                                         > procedure Show_Array (Label : String; A : Fixed_Array)
     begin
        Put (Label & ": [");
//      ^^^ reference scip-ada . . . Put().
//           ^^^^^ reference scip-ada . . . Label.
        for I in A'Range loop
//          ^ definition scip-ada . . . I.
//               ^ reference scip-ada . . . A.
           Put (A (I)'Image);
//              ^ reference scip-ada . . . A.
//                 ^ reference scip-ada . . . I.
           if I < A'Last then
//            ^ reference scip-ada . . . I.
//                ^ reference scip-ada . . . A.
              Put (",");
           end if;
        end loop;
        Put_Line ("]");
     end Show_Array;
//       ^^^^^^^^^^ reference scip-ada . . . Show_Array().
//                 ^^^^^^^^^^ reference scip-ada . . . Show_Array().
  
     --  More locals for testing
     Area_Val : Float;
//   ^^^^^^^^ definition scip-ada . . . Area_Val.
//   documentation
//   > More locals for testing
  
  begin
     -----------------------------------------------------------------
     --  Show delta aggregate results
     -----------------------------------------------------------------
     Show_Point ("Origin", Origin);
//   ^^^^^^^^^^ reference scip-ada . . . Show_Point().
//                         ^^^^^^ reference scip-ada . . . Origin#
     Show_Point ("P1 (delta X)", P1);
//   ^^^^^^^^^^ reference scip-ada . . . Show_Point().
//                               ^^ reference scip-ada . . . P1#
     Show_Point ("P2 (delta Y)", P2);
//   ^^^^^^^^^^ reference scip-ada . . . Show_Point().
//                               ^^ reference scip-ada . . . P2#
  
     Put_Line ("Faded alpha: " & Faded.A'Image);
//                               ^^^^^ reference scip-ada . . . Faded#
  
     -----------------------------------------------------------------
     --  Show iterated component associations
     -----------------------------------------------------------------
     Show_Array ("Squares", Squares);
//   ^^^^^^^^^^ reference scip-ada . . . Show_Array().
//                          ^^^^^^^ reference scip-ada . . . Squares.
     Show_Array ("Doubled", Doubled);
//   ^^^^^^^^^^ reference scip-ada . . . Show_Array().
//                          ^^^^^^^ reference scip-ada . . . Doubled.
  
     -----------------------------------------------------------------
     --  Target name (@) — increment Counter using @
     -----------------------------------------------------------------
     Counter := @ + 5;
//   ^^^^^^^ reference scip-ada . . . Counter.
     Put_Line ("Counter after @+5: " & Counter'Image);
//                                     ^^^^^^^ reference scip-ada . . . Counter.
  
     Counter := @ * 2;
//   ^^^^^^^ reference scip-ada . . . Counter.
     Put_Line ("Counter after @*2: " & Counter'Image);
//                                     ^^^^^^^ reference scip-ada . . . Counter.
  
     -----------------------------------------------------------------
     --  Declare expression
     -----------------------------------------------------------------
     Area_Val := Triangle_Area (10.0, 5.0);
//   ^^^^^^^^ reference scip-ada . . . Area_Val.
//               ^^^^^^^^^^^^^ reference scip-ada . . . Triangle_Area().
     Put_Line ("Triangle area: " & Area_Val'Image);
//                                 ^^^^^^^^ reference scip-ada . . . Area_Val.
  
     -----------------------------------------------------------------
     --  Default_Initial_Condition — use the validated type
     -----------------------------------------------------------------
     Put_Line ("Positive_Int value: " & Get (PI)'Image);
//                                      ^^^ reference scip-ada . . . Get().
//                                           ^^ reference scip-ada . . . PI#
     PI := Make (99);
//   ^^ reference scip-ada . . . PI#
     Put_Line ("Updated value: " & Get (PI)'Image);
//                                      ^^ reference scip-ada . . . PI#
  
     -----------------------------------------------------------------
     --  Ada 2022 'Image on non-scalar prefix (if supported)
     -----------------------------------------------------------------
     Put_Line ("Direction: " & North'Image);
//                             ^^^^^ reference scip-ada . . . North.
  
  end Ada2022_Main;
//    ^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Main().
//                ^^^^^^^^^^^^ reference scip-ada . . . Ada2022_Main().
  
