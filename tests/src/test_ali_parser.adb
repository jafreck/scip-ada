with Ada.Text_IO;
with Ada.Strings.Unbounded;
with SCIP_Ada.ALI.Parser;
with SCIP_Ada.ALI.Types;

package body Test_ALI_Parser is

   use Ada.Text_IO;
   use Ada.Strings.Unbounded;
   use SCIP_Ada.ALI.Types;

   Fixtures : constant String := "tests/fixtures/";

   ---------------------------------------------------------------------------
   --  Test helpers
   ---------------------------------------------------------------------------

   procedure Assert
     (Condition : Boolean;
      Message   : String;
      Passed    : in out Natural;
      Failed    : in out Natural)
   is
   begin
      if Condition then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Put_Line ("  FAIL: " & Message);
      end if;
   end Assert;

   procedure Assert_Eq_Nat
     (Actual   : Natural;
      Expected : Natural;
      Label    : String;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      Assert (Actual = Expected,
              Label & ": got" & Natural'Image (Actual) &
              ", expected" & Natural'Image (Expected),
              Passed, Failed);
   end Assert_Eq_Nat;

   procedure Assert_Eq_Str
     (Actual   : String;
      Expected : String;
      Label    : String;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      Assert (Actual = Expected,
              Label & ": got """ & Actual &
              """, expected """ & Expected & """",
              Passed, Failed);
   end Assert_Eq_Str;

   ---------------------------------------------------------------------------
   --  Test: basic.ali — D lines, X sections, entities, refs
   ---------------------------------------------------------------------------

   procedure Test_Basic
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "basic.ali");
   begin
      --  D lines: 3 files
      Assert_Eq_Nat (Natural (A.Files.Length), 3,
                     "basic: D line count", Passed, Failed);
      Assert_Eq_Str (To_String (A.Files (1).Path), "hello.ads",
                     "basic: D(1) path", Passed, Failed);
      Assert_Eq_Str (To_String (A.Files (2).Path), "hello.adb",
                     "basic: D(2) path", Passed, Failed);
      Assert_Eq_Str (To_String (A.Files (3).Path), "system.ads",
                     "basic: D(3) path", Passed, Failed);

      --  X sections: 2 sections
      Assert_Eq_Nat (Natural (A.Sections.Length), 2,
                     "basic: X section count", Passed, Failed);
      Assert_Eq_Nat (A.Sections (1).File_Index, 1,
                     "basic: X(1) file_index", Passed, Failed);
      Assert_Eq_Nat (A.Sections (2).File_Index, 2,
                     "basic: X(2) file_index", Passed, Failed);

      --  Section 1 entities: Hello, Say_Hello, Count
      Assert_Eq_Nat (Natural (A.Sections (1).Entities.Length), 3,
                     "basic: X(1) entity count", Passed, Failed);

      --  Entity: 5K9*Hello
      declare
         E : Entity_Def renames A.Sections (1).Entities (1);
      begin
         Assert_Eq_Nat (E.Line, 5, "basic: Hello line", Passed, Failed);
         Assert (E.Kind = Package_Entity,
                 "basic: Hello kind", Passed, Failed);
         Assert_Eq_Nat (E.Column, 9, "basic: Hello col", Passed, Failed);
         Assert (E.Is_Library_Level,
                 "basic: Hello library-level", Passed, Failed);
         Assert_Eq_Str (To_String (E.Name), "Hello",
                        "basic: Hello name", Passed, Failed);
         --  Refs: 6e13 2|3b7 2|11l8
         Assert_Eq_Nat (Natural (E.References.Length), 3,
                        "basic: Hello ref count", Passed, Failed);
         Assert_Eq_Nat (E.References (1).Line, 6,
                        "basic: Hello ref1 line", Passed, Failed);
         Assert (E.References (1).Kind = End_Of_Spec,
                 "basic: Hello ref1 kind", Passed, Failed);
         Assert_Eq_Nat (E.References (1).Column, 13,
                        "basic: Hello ref1 col", Passed, Failed);
         Assert_Eq_Nat (E.References (1).File_Index, 1,
                        "basic: Hello ref1 file", Passed, Failed);
         Assert_Eq_Nat (E.References (2).File_Index, 2,
                        "basic: Hello ref2 file", Passed, Failed);
         Assert_Eq_Nat (E.References (2).Line, 3,
                        "basic: Hello ref2 line", Passed, Failed);
         Assert (E.References (2).Kind = Body_Ref,
                 "basic: Hello ref2 kind", Passed, Failed);
         Assert_Eq_Nat (E.References (2).Column, 7,
                        "basic: Hello ref2 col", Passed, Failed);
         Assert_Eq_Nat (E.References (3).File_Index, 2,
                        "basic: Hello ref3 file", Passed, Failed);
         Assert (E.References (3).Kind = Label_On_End,
                 "basic: Hello ref3 kind", Passed, Failed);
      end;

      --  Entity: 7U14*Say_Hello
      declare
         E : Entity_Def renames A.Sections (1).Entities (2);
      begin
         Assert_Eq_Nat (E.Line, 7, "basic: Say_Hello line", Passed, Failed);
         Assert (E.Kind = Procedure_Entity,
                 "basic: Say_Hello kind", Passed, Failed);
         Assert_Eq_Nat (E.Column, 14,
                        "basic: Say_Hello col", Passed, Failed);
         Assert (E.Is_Library_Level,
                 "basic: Say_Hello library-level", Passed, Failed);
         Assert_Eq_Str (To_String (E.Name), "Say_Hello",
                        "basic: Say_Hello name", Passed, Failed);
         Assert_Eq_Nat (Natural (E.References.Length), 2,
                        "basic: Say_Hello ref count", Passed, Failed);
      end;

      --  Entity: 9I9*Count
      declare
         E : Entity_Def renames A.Sections (1).Entities (3);
      begin
         Assert_Eq_Nat (E.Line, 9, "basic: Count line", Passed, Failed);
         Assert (E.Kind = Integer_Type,
                 "basic: Count kind", Passed, Failed);
         Assert (E.Is_Library_Level,
                 "basic: Count library-level", Passed, Failed);
         Assert_Eq_Str (To_String (E.Name), "Count",
                        "basic: Count name", Passed, Failed);
         --  Refs: 10r5 2|7m9
         Assert_Eq_Nat (Natural (E.References.Length), 2,
                        "basic: Count ref count", Passed, Failed);
         Assert (E.References (1).Kind = Reference_Ref,
                 "basic: Count ref1 kind=r", Passed, Failed);
         Assert (E.References (2).Kind = Modification_Ref,
                 "basic: Count ref2 kind=m", Passed, Failed);
      end;

      --  Section 2: non-library-level entities
      Assert_Eq_Nat (Natural (A.Sections (2).Entities.Length), 3,
                     "basic: X(2) entity count", Passed, Failed);
      declare
         E : Entity_Def renames A.Sections (2).Entities (1);
      begin
         Assert (not E.Is_Library_Level,
                 "basic: X(2) Hello not library-level", Passed, Failed);
         Assert_Eq_Str (To_String (E.Name), "Hello",
                        "basic: X(2) Hello name", Passed, Failed);
      end;
   end Test_Basic;

   ---------------------------------------------------------------------------
   --  Test: generics.ali — generic packages, formal types, instantiations
   ---------------------------------------------------------------------------

   procedure Test_Generics
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "generics.ali");
   begin
      Assert_Eq_Nat (Natural (A.Files.Length), 4,
                     "generics: D line count", Passed, Failed);
      Assert_Eq_Nat (Natural (A.Sections.Length), 3,
                     "generics: X section count", Passed, Failed);

      --  Section 1: Generic_Stack
      declare
         S : XRef_Section renames A.Sections (1);
      begin
         Assert_Eq_Nat (S.File_Index, 1,
                        "generics: X(1) file", Passed, Failed);
         Assert_Eq_Nat (Natural (S.Entities.Length), 8,
                        "generics: X(1) entity count", Passed, Failed);

         --  3G9*Generic_Stack — generic package
         Assert (S.Entities (1).Kind = Generic_Package,
                 "generics: Generic_Stack kind=G", Passed, Failed);
         Assert (S.Entities (1).Is_Library_Level,
                 "generics: Generic_Stack library-level", Passed, Failed);

         --  5+9*Element_Type — generic formal type
         Assert (S.Entities (2).Kind = Generic_Formal_Type,
                 "generics: Element_Type kind=+", Passed, Failed);
         Assert_Eq_Str (To_String (S.Entities (2).Name), "Element_Type",
                        "generics: Element_Type name", Passed, Failed);

         --  7R9*Stack — tagged record type
         Assert (S.Entities (3).Kind = Tagged_Record_Type,
                 "generics: Stack kind=R", Passed, Failed);
         --  Refs: 2|5r9 8c9 3|4r9
         Assert_Eq_Nat (Natural (S.Entities (3).References.Length), 3,
                        "generics: Stack ref count", Passed, Failed);
      end;

      --  Section 3: Int_Stack (instantiation)
      declare
         S : XRef_Section renames A.Sections (3);
      begin
         Assert_Eq_Nat (S.File_Index, 3,
                        "generics: X(3) file", Passed, Failed);
         --  3k9*My_Stack[1|3{1|3}] — generic package instantiation
         Assert (S.Entities (2).Kind = Generic_Package_Instantiation,
                 "generics: My_Stack kind=k", Passed, Failed);
         Assert_Eq_Str (To_String (S.Entities (2).Name), "My_Stack",
                        "generics: My_Stack name (no brackets)",
                        Passed, Failed);
      end;
   end Test_Generics;

   ---------------------------------------------------------------------------
   --  Test: tagged_types.ali — tagged types, type extension, dispatching
   ---------------------------------------------------------------------------

   procedure Test_Tagged_Types
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "tagged_types.ali");
   begin
      Assert (Natural (A.Files.Length) > 0,
              "tagged: D line count > 0", Passed, Failed);
      Assert (Natural (A.Sections.Length) >= 3,
              "tagged: X section count >= 3", Passed, Failed);

      --  Find the shapes.ads section by scanning sections
      declare
         Found_Shapes : Boolean := False;
      begin
         for Sec_Idx in 1 .. Natural (A.Sections.Length) loop
            declare
               S : XRef_Section renames A.Sections (Sec_Idx);
            begin
               --  Look for Shape entity (Abstract_Type 'H')
               for E_Idx in 1 .. Natural (S.Entities.Length) loop
                  declare
                     E : Entity_Def renames S.Entities (E_Idx);
                  begin
                     if To_String (E.Name) = "Shape"
                       and then E.Kind = Abstract_Type
                     then
                        Found_Shapes := True;
                        Assert (True,
                                "tagged: Shape kind=H",
                                Passed, Failed);
                     end if;
                  end;
               end loop;

               --  Look for Draw entity with dispatching/overriding
               for E_Idx in 1 .. Natural (S.Entities.Length) loop
                  declare
                     E : Entity_Def renames S.Entities (E_Idx);
                     Found_D : Boolean := False;
                     Found_P : Boolean := False;
                  begin
                     if To_String (E.Name) = "Draw"
                       and then E.Kind = Procedure_Entity
                     then
                        for R of E.References loop
                           if R.Kind = Dispatching_Call then
                              Found_D := True;
                           end if;
                           if R.Kind = Overriding_Primitive then
                              Found_P := True;
                           end if;
                        end loop;
                        if Found_D then
                           Assert
                             (True,
                              "tagged: Draw has dispatching call ref",
                              Passed, Failed);
                        end if;
                        if Found_P then
                           Assert
                             (True,
                              "tagged: Draw has overriding primitive",
                              Passed, Failed);
                        end if;
                     end if;
                  end;
               end loop;

               --  Look for Circle (Tagged_Record_Type)
               for E_Idx in 1 .. Natural (S.Entities.Length) loop
                  declare
                     E : Entity_Def renames S.Entities (E_Idx);
                  begin
                     if To_String (E.Name) = "Circle"
                       and then E.Kind = Tagged_Record_Type
                     then
                        Assert
                          (True,
                           "tagged: Circle kind=R",
                           Passed, Failed);
                     end if;
                  end;
               end loop;
            end;
         end loop;
         Assert (Found_Shapes,
                 "tagged: found shapes.ads section",
                 Passed, Failed);
      end;
   end Test_Tagged_Types;

   ---------------------------------------------------------------------------
   --  Test: overloaded.ali — overloaded subprograms
   ---------------------------------------------------------------------------

   procedure Test_Overloaded
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "overloaded.ali");
   begin
      Assert_Eq_Nat (Natural (A.Files.Length), 3,
                     "overloaded: D line count", Passed, Failed);
      Assert_Eq_Nat (Natural (A.Sections.Length), 2,
                     "overloaded: X section count", Passed, Failed);

      --  Section 1
      declare
         S : XRef_Section renames A.Sections (1);
      begin
         Assert_Eq_Nat (Natural (S.Entities.Length), 8,
                        "overloaded: X(1) entity count", Passed, Failed);

         --  Three overloaded Add functions
         Assert_Eq_Str (To_String (S.Entities (2).Name), "Add",
                        "overloaded: Add(1) name", Passed, Failed);
         Assert_Eq_Str (To_String (S.Entities (3).Name), "Add",
                        "overloaded: Add(2) name", Passed, Failed);
         Assert_Eq_Str (To_String (S.Entities (4).Name), "Add",
                        "overloaded: Add(3) name", Passed, Failed);
         Assert (S.Entities (2).Kind = Function_Entity,
                 "overloaded: Add(1) kind=V", Passed, Failed);

         --  Two overloaded Process procedures
         Assert_Eq_Str (To_String (S.Entities (5).Name), "Process",
                        "overloaded: Process(1) name", Passed, Failed);
         Assert_Eq_Str (To_String (S.Entities (6).Name), "Process",
                        "overloaded: Process(2) name", Passed, Failed);
         Assert (S.Entities (5).Kind = Procedure_Entity,
                 "overloaded: Process(1) kind=U", Passed, Failed);
      end;
   end Test_Overloaded;

   ---------------------------------------------------------------------------
   --  Test: operators.ali — operator symbols
   ---------------------------------------------------------------------------

   procedure Test_Operators
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "operators.ali");
   begin
      Assert_Eq_Nat (Natural (A.Files.Length), 3,
                     "operators: D line count", Passed, Failed);
      Assert_Eq_Nat (Natural (A.Sections.Length), 2,
                     "operators: X section count", Passed, Failed);

      declare
         S : XRef_Section renames A.Sections (1);
      begin
         --  9V14*"+" — operator plus (index 5, after Vectors/Vec2/X/Y)
         Assert_Eq_Str (To_String (S.Entities (5).Name), """+""",
                        "operators: ""+""  name", Passed, Failed);
         Assert (S.Entities (5).Kind = Function_Entity,
                 "operators: ""+"" kind=V", Passed, Failed);
         Assert (S.Entities (5).Is_Library_Level,
                 "operators: ""+"" library-level", Passed, Failed);
         --  Refs: 2|5b14 2|20s14
         Assert_Eq_Nat (Natural (S.Entities (5).References.Length), 2,
                        "operators: ""+"" ref count", Passed, Failed);

         --  10V14*"-" — operator minus
         Assert_Eq_Str (To_String (S.Entities (6).Name), """-""",
                        "operators: ""-"" name", Passed, Failed);

         --  11V14*"*" — operator multiply
         Assert_Eq_Str (To_String (S.Entities (7).Name), """*""",
                        "operators: ""*"" name", Passed, Failed);

         --  12V14*"=" — operator equals
         Assert_Eq_Str (To_String (S.Entities (8).Name), """=""",
                        "operators: ""="" name", Passed, Failed);
      end;

      --  Section 2 also has operator names
      declare
         S : XRef_Section renames A.Sections (2);
      begin
         Assert_Eq_Str (To_String (S.Entities (2).Name), """+""",
                        "operators: X(2) ""+"" name", Passed, Failed);
      end;
   end Test_Operators;

   ---------------------------------------------------------------------------
   --  Test: renaming.ali — renaming declarations
   ---------------------------------------------------------------------------

   procedure Test_Renaming
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "renaming.ali");
   begin
      Assert_Eq_Nat (Natural (A.Files.Length), 3,
                     "renaming: D line count", Passed, Failed);

      declare
         S : XRef_Section renames A.Sections (1);
      begin
         --  7U14*Renamed_Proc=Original_Proc — renaming
         --  Name should be just "Renamed_Proc", renaming skipped
         Assert_Eq_Str (To_String (S.Entities (3).Name), "Renamed_Proc",
                        "renaming: Renamed_Proc name", Passed, Failed);
         Assert (S.Entities (3).Kind = Procedure_Entity,
                 "renaming: Renamed_Proc kind=U", Passed, Failed);
         --  Should have ref: 2|12s14
         Assert_Eq_Nat (Natural (S.Entities (3).References.Length), 1,
                        "renaming: Renamed_Proc ref count", Passed, Failed);

         --  10i9*Alias_Count=Base_Count — renaming of object
         Assert_Eq_Str (To_String (S.Entities (5).Name), "Alias_Count",
                        "renaming: Alias_Count name", Passed, Failed);
         Assert (S.Entities (5).Kind = Integer_Object,
                 "renaming: Alias_Count kind=i", Passed, Failed);
      end;
   end Test_Renaming;

   ---------------------------------------------------------------------------
   --  Test: continuation.ali — multi-line continuation with '.'
   ---------------------------------------------------------------------------

   procedure Test_Continuation
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "continuation.ali");
   begin
      Assert_Eq_Nat (Natural (A.Files.Length), 5,
                     "continuation: D line count", Passed, Failed);
      Assert_Eq_Nat (Natural (A.Sections.Length), 2,
                     "continuation: X section count", Passed, Failed);

      declare
         S : XRef_Section renames A.Sections (1);
      begin
         --  5I9*Important_Type has refs spread across 3 lines
         --  2|5r9 2|10r9 2|15r9 2|20r9  (4 on first line)
         --  . 2|25r9 2|30r9 3|5r9 3|10r9  (4 on continuation)
         --  . 3|15r9 4|5r9 4|10r9 4|15r9  (4 on continuation)
         --  Total: 12 references
         Assert_Eq_Nat (Natural (S.Entities (2).References.Length), 12,
                        "continuation: Important_Type ref count",
                        Passed, Failed);
         --  Check first ref
         Assert_Eq_Nat (S.Entities (2).References (1).File_Index, 2,
                        "continuation: ref1 file", Passed, Failed);
         Assert_Eq_Nat (S.Entities (2).References (1).Line, 5,
                        "continuation: ref1 line", Passed, Failed);
         --  Check last ref (from third continuation line)
         Assert_Eq_Nat (S.Entities (2).References (12).File_Index, 4,
                        "continuation: ref12 file", Passed, Failed);
         Assert_Eq_Nat (S.Entities (2).References (12).Line, 15,
                        "continuation: ref12 line", Passed, Failed);

         --  7U14*Widely_Used has refs across 3 lines too
         --  2|7b14 2|12s14 2|22s14  (3)
         --  . 2|32s14 3|7s14 3|12s14  (3)
         --  . 4|7s14 4|12s14  (2)
         --  Total: 8 references
         Assert_Eq_Nat (Natural (S.Entities (3).References.Length), 8,
                        "continuation: Widely_Used ref count",
                        Passed, Failed);
         --  First ref is body ref
         Assert (S.Entities (3).References (1).Kind = Body_Ref,
                 "continuation: Widely_Used ref1 kind=b",
                 Passed, Failed);
      end;
   end Test_Continuation;

   ---------------------------------------------------------------------------
   --  Test: GNAT-compiled ALI files (gnat_sample.ali, gnat_sample_main.ali)
   ---------------------------------------------------------------------------

   procedure Test_Gnat_Sample
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "gnat_sample.ali");
   begin
      --  D lines: 30 dependency entries
      Assert_Eq_Nat (Natural (A.Files.Length), 30,
                     "gnat_sample: D line count", Passed, Failed);
      Assert_Eq_Str (To_String (A.Files (13).Path), "sample.ads",
                     "gnat_sample: D(13) path", Passed, Failed);
      Assert_Eq_Str (To_String (A.Files (14).Path), "sample.adb",
                     "gnat_sample: D(14) path", Passed, Failed);

      --  X sections: 4 (ada.ads, a-textio.ads, sample.ads, sample.adb)
      Assert_Eq_Nat (Natural (A.Sections.Length), 4,
                     "gnat_sample: X section count", Passed, Failed);
      Assert_Eq_Nat (A.Sections (1).File_Index, 1,
                     "gnat_sample: X(1) file", Passed, Failed);
      Assert_Eq_Nat (A.Sections (3).File_Index, 13,
                     "gnat_sample: X(3) file=13", Passed, Failed);
      Assert_Eq_Nat (A.Sections (4).File_Index, 14,
                     "gnat_sample: X(4) file=14", Passed, Failed);

      --  Section 3 (sample.ads, file 13): many entities
      Assert (Natural (A.Sections (3).Entities.Length) >= 20,
              "gnat_sample: X(13) entity count >= 20",
              Passed, Failed);

      --  First entity: 1K9*Sample
      Assert_Eq_Str (To_String (A.Sections (3).Entities (1).Name), "Sample",
                     "gnat_sample: entity 1 = Sample", Passed, Failed);
      Assert (A.Sections (3).Entities (1).Kind = Package_Entity,
              "gnat_sample: Sample kind=K", Passed, Failed);
      Assert (A.Sections (3).Entities (1).Is_Library_Level,
              "gnat_sample: Sample library-level", Passed, Failed);

      --  Color entity: 3E9*Color
      Assert_Eq_Str (To_String (A.Sections (3).Entities (2).Name), "Color",
                     "gnat_sample: entity 2 = Color", Passed, Failed);
      Assert (A.Sections (3).Entities (2).Kind = Enumeration_Type,
              "gnat_sample: Color kind=E", Passed, Failed);

      --  Red entity: 3n19*Red
      Assert_Eq_Str (To_String (A.Sections (3).Entities (3).Name), "Red",
                     "gnat_sample: entity 3 = Red", Passed, Failed);
      Assert (A.Sections (3).Entities (3).Kind = Enumeration_Literal,
              "gnat_sample: Red kind=n", Passed, Failed);

      --  Point entity: 5R9*Point
      Assert (A.Sections (3).Entities (6).Kind = Tagged_Record_Type,
              "gnat_sample: Point kind=R", Passed, Failed);
      --  Point refs include cross-file refs to file 14
      declare
         Found_Cross : Boolean := False;
      begin
         for R of A.Sections (3).Entities (6).References loop
            if R.File_Index = 14 then
               Found_Cross := True;
            end if;
         end loop;
         Assert (Found_Cross,
                 "gnat_sample: Point has cross-file ref to file 14",
                 Passed, Failed);
      end;

      --  Operator "+" entity
      declare
         Found_Op : Boolean := False;
      begin
         for E of A.Sections (3).Entities loop
            if To_String (E.Name) = """+"" " then
               Found_Op := True;
            elsif To_String (E.Name) = """+""" then
               Found_Op := True;
            end if;
         end loop;
         Assert (Found_Op,
                 "gnat_sample: found ""+"" operator entity",
                 Passed, Failed);
      end;

      --  Bounded_Stack entity
      declare
         Found_Stack : Boolean := False;
      begin
         for E of A.Sections (3).Entities loop
            if To_String (E.Name) = "Bounded_Stack" then
               Found_Stack := True;
            end if;
         end loop;
         Assert (Found_Stack,
                 "gnat_sample: found Bounded_Stack entity",
                 Passed, Failed);
      end;

      --  Section 4 (sample.adb, file 14): entities
      Assert (Natural (A.Sections (4).Entities.Length) >= 3,
              "gnat_sample: X(14) entity count >= 3",
              Passed, Failed);
   end Test_Gnat_Sample;

   procedure Test_Gnat_Sample_Main
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      A : constant ALI_File :=
        SCIP_Ada.ALI.Parser.Parse (Fixtures & "gnat_sample_main.ali");
   begin
      --  D lines: 24
      Assert_Eq_Nat (Natural (A.Files.Length), 24,
                     "gnat_main: D line count", Passed, Failed);

      --  X sections: 2 (sample.ads, sample_main.adb)
      Assert_Eq_Nat (Natural (A.Sections.Length), 2,
                     "gnat_main: X section count", Passed, Failed);
      Assert_Eq_Nat (A.Sections (1).File_Index, 10,
                     "gnat_main: X(1) file=10", Passed, Failed);
      Assert_Eq_Nat (A.Sections (2).File_Index, 11,
                     "gnat_main: X(2) file=11", Passed, Failed);

      --  Section 1 (sample.ads): entities include Sample, Point, Shape
      Assert (Natural (A.Sections (1).Entities.Length) >= 5,
              "gnat_main: X(10) entity count >= 5",
              Passed, Failed);
      Assert_Eq_Str (To_String (A.Sections (1).Entities (1).Name), "Sample",
                     "gnat_main: entity 1 = Sample", Passed, Failed);

      --  Section 2 (sample_main.adb): contains Sample_Main
      Assert_Eq_Str (To_String (A.Sections (2).Entities (1).Name),
                     "Sample_Main",
                     "gnat_main: entity 1 = Sample_Main", Passed, Failed);
      Assert (A.Sections (2).Entities (1).Kind = Procedure_Entity,
              "gnat_main: Sample_Main kind=U", Passed, Failed);

      --  Section 1 (sample.ads refs into sample_main.adb file 11)
      declare
         Found_Cross : Boolean := False;
      begin
         for E of A.Sections (1).Entities loop
            for R of E.References loop
               if R.File_Index = 11 then
                  Found_Cross := True;
               end if;
            end loop;
         end loop;
         Assert (Found_Cross,
                 "gnat_main: found cross-file ref to sample_main.adb",
                 Passed, Failed);
      end;
   end Test_Gnat_Sample_Main;

   ---------------------------------------------------------------------------
   --  Test: error handling — missing file should raise Name_Error
   ---------------------------------------------------------------------------

   procedure Test_Missing_File
     (Passed : in out Natural;
      Failed : in out Natural)
   is
   begin
      declare
         A : ALI_File;
         pragma Unreferenced (A);
      begin
         A := SCIP_Ada.ALI.Parser.Parse ("nonexistent_file.ali");
         Failed := Failed + 1;
         Put_Line ("  FAIL: Parse of missing file should raise exception");
      exception
         when Ada.Text_IO.Name_Error =>
            Passed := Passed + 1;
         when others =>
            Failed := Failed + 1;
            Put_Line ("  FAIL: wrong exception for missing file");
      end;
   end Test_Missing_File;

   ---------------------------------------------------------------------------
   --  Run — execute all ALI Parser tests
   ---------------------------------------------------------------------------

   procedure Run (Passed : out Natural; Failed : out Natural) is
   begin
      Passed := 0;
      Failed := 0;

      Test_Basic (Passed, Failed);
      Test_Generics (Passed, Failed);
      Test_Tagged_Types (Passed, Failed);
      Test_Overloaded (Passed, Failed);
      Test_Operators (Passed, Failed);
      Test_Renaming (Passed, Failed);
      Test_Continuation (Passed, Failed);
      Test_Gnat_Sample (Passed, Failed);
      Test_Gnat_Sample_Main (Passed, Failed);
      Test_Missing_File (Passed, Failed);
   end Run;

end Test_ALI_Parser;
