with Ada.Text_IO;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with SCIP_Ada.ALI.Types;    use SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Symbols; use SCIP_Ada.SCIP.Symbols;

package body Test_SCIP_Symbols is

   procedure Check
     (Name     : String;
      Got      : String;
      Expected : String;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      if Got = Expected then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: " & Name);
         Ada.Text_IO.Put_Line
           ("    Expected: """ & Expected & """");
         Ada.Text_IO.Put_Line
           ("    Got:      """ & Got & """");
      end if;
   end Check;

   --  Helper: make an Entity_Def with given name and kind
   function Make_Entity
     (Name : String;
      Kind : Entity_Kind) return Entity_Def
   is
      E : Entity_Def;
   begin
      E.Name := To_Unbounded_String (Name);
      E.Kind := Kind;
      return E;
   end Make_Entity;

   procedure Run (Passed : out Natural; Failed : out Natural) is
      P : Natural := 0;
      F : Natural := 0;

      Alr_Ctx : constant Symbol_Context :=
        Make_Context ("alr", "my_project", ".");
      Dot_Ctx : constant Symbol_Context :=
        Make_Context (".", "standalone", "1.0.0");

      No_Parents : Descriptor_Vectors.Vector renames
        Descriptor_Vectors.Empty_Vector;

      --  Reusable parent chain: package Hello
      Hello_Parent : Descriptor_Vectors.Vector;

      --  Reusable parent chain: Parent.Child (child package)
      Child_Parent : Descriptor_Vectors.Vector;

   begin
      --  Build parent chains
      Hello_Parent.Append
        ((Name     => To_Unbounded_String ("Hello"),
          Kind     => Namespace,
          Overload => 0));

      Child_Parent.Append
        ((Name     => To_Unbounded_String ("Parent"),
          Kind     => Namespace,
          Overload => 0));
      Child_Parent.Append
        ((Name     => To_Unbounded_String ("Child"),
          Kind     => Namespace,
          Overload => 0));

      -----------------------------------------------------------------------
      --  1. Package entity (top-level)
      -----------------------------------------------------------------------
      Check
        ("Package (top-level)",
         To_Symbol_String (Make_Entity ("Hello", Package_Entity),
                           Alr_Ctx, No_Parents),
         "scip-ada alr my_project . Hello/",
         P, F);

      -----------------------------------------------------------------------
      --  2. Procedure in a package
      -----------------------------------------------------------------------
      Check
        ("Procedure in package",
         To_Symbol_String (Make_Entity ("Say_Hello", Procedure_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Say_Hello().",
         P, F);

      -----------------------------------------------------------------------
      --  3. Function in a package
      -----------------------------------------------------------------------
      Check
        ("Function in package",
         To_Symbol_String (Make_Entity ("Get_Value", Function_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Get_Value().",
         P, F);

      -----------------------------------------------------------------------
      --  4. Type (tagged record) in a package
      -----------------------------------------------------------------------
      Check
        ("Tagged record type",
         To_Symbol_String (Make_Entity ("Greeting", Tagged_Record_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Greeting#",
         P, F);

      -----------------------------------------------------------------------
      --  5. Integer type
      -----------------------------------------------------------------------
      Check
        ("Integer type",
         To_Symbol_String (Make_Entity ("Count", Integer_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Count#",
         P, F);

      -----------------------------------------------------------------------
      --  6. Integer object (variable)
      -----------------------------------------------------------------------
      Check
        ("Integer object",
         To_Symbol_String (Make_Entity ("X", Integer_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/X.",
         P, F);

      -----------------------------------------------------------------------
      --  7. Enumeration type
      -----------------------------------------------------------------------
      Check
        ("Enumeration type",
         To_Symbol_String (Make_Entity ("Color", Enumeration_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Color#",
         P, F);

      -----------------------------------------------------------------------
      --  8. Enumeration literal
      -----------------------------------------------------------------------
      Check
        ("Enumeration literal",
         To_Symbol_String (Make_Entity ("Red", Enumeration_Literal),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Red.",
         P, F);

      -----------------------------------------------------------------------
      --  9. Component (record field)
      -----------------------------------------------------------------------
      Check
        ("Component (field)",
         To_Symbol_String (Make_Entity ("Length", Component),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Length.",
         P, F);

      -----------------------------------------------------------------------
      --  10. Named number
      -----------------------------------------------------------------------
      Check
        ("Named number",
         To_Symbol_String (Make_Entity ("Max", Named_Number),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Max.",
         P, F);

      -----------------------------------------------------------------------
      --  11. Exception
      -----------------------------------------------------------------------
      Check
        ("Exception entity",
         To_Symbol_String (Make_Entity ("My_Error", Exception_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Error.",
         P, F);

      -----------------------------------------------------------------------
      --  12. Access type
      -----------------------------------------------------------------------
      Check
        ("Access type",
         To_Symbol_String (Make_Entity ("Ptr", Access_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Ptr#",
         P, F);

      -----------------------------------------------------------------------
      --  13. Generic package
      -----------------------------------------------------------------------
      Check
        ("Generic package",
         To_Symbol_String (Make_Entity ("Gen_Pkg", Generic_Package),
                           Alr_Ctx, No_Parents),
         "scip-ada alr my_project . Gen_Pkg/",
         P, F);

      -----------------------------------------------------------------------
      --  14. Generic formal type
      -----------------------------------------------------------------------
      Check
        ("Generic formal type",
         To_Symbol_String (Make_Entity ("Element", Generic_Formal_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/[Element]",
         P, F);

      -----------------------------------------------------------------------
      --  15. Private generic formal type
      -----------------------------------------------------------------------
      Check
        ("Private generic formal type",
         To_Symbol_String
           (Make_Entity ("Item", Private_Generic_Formal_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/[Item]",
         P, F);

      -----------------------------------------------------------------------
      --  16. Child package (Parent.Child.Proc)
      -----------------------------------------------------------------------
      Check
        ("Child package procedure",
         To_Symbol_String (Make_Entity ("Do_Work", Procedure_Entity),
                           Alr_Ctx, Child_Parent),
         "scip-ada alr my_project . Parent/Child/Do_Work().",
         P, F);

      -----------------------------------------------------------------------
      --  17. Local symbol
      -----------------------------------------------------------------------
      Check
        ("Local symbol 1",
         To_Local_Symbol (1),
         "local 1",
         P, F);

      Check
        ("Local symbol 42",
         To_Local_Symbol (42),
         "local 42",
         P, F);

      -----------------------------------------------------------------------
      --  18. Standalone GPR context (manager = ".")
      -----------------------------------------------------------------------
      Check
        ("Standalone GPR package",
         To_Symbol_String (Make_Entity ("Utils", Package_Entity),
                           Dot_Ctx, No_Parents),
         "scip-ada . standalone 1.0.0 Utils/",
         P, F);

      -----------------------------------------------------------------------
      --  19. Subtype entity
      -----------------------------------------------------------------------
      Check
        ("Subtype entity",
         To_Symbol_String (Make_Entity ("My_Sub", Subtype_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Sub#",
         P, F);

      -----------------------------------------------------------------------
      --  20. Task type
      -----------------------------------------------------------------------
      Check
        ("Task type",
         To_Symbol_String (Make_Entity ("Worker", Task_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Worker#",
         P, F);

      -----------------------------------------------------------------------
      --  21. Task object
      -----------------------------------------------------------------------
      Check
        ("Task object",
         To_Symbol_String (Make_Entity ("My_Worker", Task_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Worker.",
         P, F);

      -----------------------------------------------------------------------
      --  22. Entry entity
      -----------------------------------------------------------------------
      Check
        ("Entry entity",
         To_Symbol_String (Make_Entity ("Start", Entry_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Start().",
         P, F);

      -----------------------------------------------------------------------
      --  23. Generic procedure
      -----------------------------------------------------------------------
      Check
        ("Generic procedure",
         To_Symbol_String (Make_Entity ("Gen_Proc", Generic_Procedure),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Gen_Proc().",
         P, F);

      -----------------------------------------------------------------------
      --  24. Generic function
      -----------------------------------------------------------------------
      Check
        ("Generic function",
         To_Symbol_String (Make_Entity ("Gen_Func", Generic_Function),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Gen_Func().",
         P, F);

      -----------------------------------------------------------------------
      --  25. Abstract procedure
      -----------------------------------------------------------------------
      Check
        ("Abstract procedure",
         To_Symbol_String (Make_Entity ("Do_It", Abstract_Procedure),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Do_It().",
         P, F);

      -----------------------------------------------------------------------
      --  26. Abstract function
      -----------------------------------------------------------------------
      Check
        ("Abstract function",
         To_Symbol_String (Make_Entity ("Get_It", Abstract_Function),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Get_It().",
         P, F);

      -----------------------------------------------------------------------
      --  27. Protected object
      -----------------------------------------------------------------------
      Check
        ("Protected object",
         To_Symbol_String (Make_Entity ("Mutex", Protected_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Mutex.",
         P, F);

      -----------------------------------------------------------------------
      --  28. String object
      -----------------------------------------------------------------------
      Check
        ("String object",
         To_Symbol_String (Make_Entity ("Msg", String_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Msg.",
         P, F);

      -----------------------------------------------------------------------
      --  29. Array type
      -----------------------------------------------------------------------
      Check
        ("Array type",
         To_Symbol_String (Make_Entity ("Table", Array_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Table#",
         P, F);

      -----------------------------------------------------------------------
      --  30. Array object
      -----------------------------------------------------------------------
      Check
        ("Array object",
         To_Symbol_String (Make_Entity ("Data", Array_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Data.",
         P, F);

      -----------------------------------------------------------------------
      --  31. Boolean type
      -----------------------------------------------------------------------
      Check
        ("Boolean type",
         To_Symbol_String (Make_Entity ("Flag_Type", Boolean_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Flag_Type#",
         P, F);

      -----------------------------------------------------------------------
      --  32. Float type
      -----------------------------------------------------------------------
      Check
        ("Float type",
         To_Symbol_String (Make_Entity ("Real", Float_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Real#",
         P, F);

      -----------------------------------------------------------------------
      --  33. Float object
      -----------------------------------------------------------------------
      Check
        ("Float object",
         To_Symbol_String (Make_Entity ("Temp", Float_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Temp.",
         P, F);

      -----------------------------------------------------------------------
      --  34. Procedure instantiation
      -----------------------------------------------------------------------
      Check
        ("Procedure instantiation",
         To_Symbol_String
           (Make_Entity ("My_Swap", Procedure_Instantiation),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Swap().",
         P, F);

      -----------------------------------------------------------------------
      --  35. Function instantiation
      -----------------------------------------------------------------------
      Check
        ("Function instantiation",
         To_Symbol_String
           (Make_Entity ("My_Max", Function_Instantiation),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Max().",
         P, F);

      -----------------------------------------------------------------------
      --  36. Generic package instantiation
      -----------------------------------------------------------------------
      Check
        ("Generic package instantiation",
         To_Symbol_String
           (Make_Entity ("Int_Lists", Generic_Package_Instantiation),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Int_Lists/",
         P, F);

      -----------------------------------------------------------------------
      --  37. Formal procedure
      -----------------------------------------------------------------------
      Check
        ("Formal procedure",
         To_Symbol_String (Make_Entity ("Action", Formal_Procedure),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Action().",
         P, F);

      -----------------------------------------------------------------------
      --  38. Formal function
      -----------------------------------------------------------------------
      Check
        ("Formal function",
         To_Symbol_String (Make_Entity ("Predicate", Formal_Function),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Predicate().",
         P, F);

      -----------------------------------------------------------------------
      --  39. Label entities (various label kinds → Term)
      -----------------------------------------------------------------------
      Check
        ("Label",
         To_Symbol_String (Make_Entity ("My_Label", Label),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Label.",
         P, F);

      Check
        ("Block label",
         To_Symbol_String (Make_Entity ("Blk", Block_Label),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Blk.",
         P, F);

      -----------------------------------------------------------------------
      --  40. Format_Descriptor directly — Method with overload
      -----------------------------------------------------------------------
      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Put"),
            Kind     => Method,
            Overload => 3);
      begin
         Check
           ("Method descriptor with overload",
            Format_Descriptor (D),
            "Put(+3).",
            P, F);
      end;

      -----------------------------------------------------------------------
      --  41. Format_Descriptor — Parameter
      -----------------------------------------------------------------------
      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Item"),
            Kind     => Parameter,
            Overload => 0);
      begin
         Check
           ("Parameter descriptor",
            Format_Descriptor (D),
            "(Item)",
            P, F);
      end;

      -----------------------------------------------------------------------
      --  42. Format_Descriptor — Meta
      -----------------------------------------------------------------------
      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Info"),
            Kind     => Meta,
            Overload => 0);
      begin
         Check
           ("Meta descriptor",
            Format_Descriptor (D),
            "Info:",
            P, F);
      end;

      -----------------------------------------------------------------------
      --  43. Format_Descriptor — Macro
      -----------------------------------------------------------------------
      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Expand"),
            Kind     => Macro,
            Overload => 0);
      begin
         Check
           ("Macro descriptor",
            Format_Descriptor (D),
            "Expand!",
            P, F);
      end;

      -----------------------------------------------------------------------
      --  44. Build_Symbol with manual descriptor chain
      -----------------------------------------------------------------------
      declare
         Chain : Descriptor_Vectors.Vector;
      begin
         Chain.Append
           ((Name     => To_Unbounded_String ("Pkg"),
             Kind     => Namespace,
             Overload => 0));
         Chain.Append
           ((Name     => To_Unbounded_String ("My_Type"),
             Kind     => Type_Descriptor,
             Overload => 0));
         Check
           ("Build_Symbol manual chain",
            Build_Symbol (Alr_Ctx, Chain),
            "scip-ada alr my_project . Pkg/My_Type#",
            P, F);
      end;

      -----------------------------------------------------------------------
      --  45. Determinism: same entity produces identical symbol
      -----------------------------------------------------------------------
      declare
         E : constant Entity_Def := Make_Entity ("Foo", Procedure_Entity);
         S1 : constant String :=
           To_Symbol_String (E, Alr_Ctx, Hello_Parent);
         S2 : constant String :=
           To_Symbol_String (E, Alr_Ctx, Hello_Parent);
      begin
         Check
           ("Determinism (same entity -> same symbol)",
            S1, S2, P, F);
      end;

      -----------------------------------------------------------------------
      --  46. Modular integer type
      -----------------------------------------------------------------------
      Check
        ("Modular integer type",
         To_Symbol_String
           (Make_Entity ("Byte", Modular_Integer_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Byte#",
         P, F);

      -----------------------------------------------------------------------
      --  47. Decimal fixed type
      -----------------------------------------------------------------------
      Check
        ("Decimal fixed type",
         To_Symbol_String
           (Make_Entity ("Money", Decimal_Fixed_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Money#",
         P, F);

      -----------------------------------------------------------------------
      --  48. Ordinary fixed type
      -----------------------------------------------------------------------
      Check
        ("Ordinary fixed type",
         To_Symbol_String
           (Make_Entity ("Angle", Ordinary_Fixed_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Angle#",
         P, F);

      -----------------------------------------------------------------------
      --  49. Class_Wide_Subtype
      -----------------------------------------------------------------------
      Check
        ("Class wide subtype",
         To_Symbol_String
           (Make_Entity ("CW", Class_Wide_Subtype),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/CW#",
         P, F);

      -----------------------------------------------------------------------
      --  50. Class_Wide_Type
      -----------------------------------------------------------------------
      Check
        ("Class wide type",
         To_Symbol_String
           (Make_Entity ("Base_CW", Class_Wide_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Base_CW#",
         P, F);

      -----------------------------------------------------------------------
      --  51. Entry body
      -----------------------------------------------------------------------
      Check
        ("Entry body",
         To_Symbol_String (Make_Entity ("Guard", Entry_Body),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Guard().",
         P, F);

      -----------------------------------------------------------------------
      --  52. Access object
      -----------------------------------------------------------------------
      Check
        ("Access object",
         To_Symbol_String (Make_Entity ("Ref", Access_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Ref.",
         P, F);

      -----------------------------------------------------------------------
      --  53. Record type (untagged)
      -----------------------------------------------------------------------
      Check
        ("Record type (untagged)",
         To_Symbol_String (Make_Entity ("Rec", Record_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Rec#",
         P, F);

      -----------------------------------------------------------------------
      --  54. Make_Symbol backward compat
      -----------------------------------------------------------------------
      Check
        ("Make_Symbol backward-compat",
         Make_Symbol ("test_pkg", "Greet"),
         "scip-ada . test_pkg . Greet/",
         P, F);

      Passed := P;
      Failed := F;
   end Run;

end Test_SCIP_Symbols;
