with AUnit.Assertions;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with SCIP_Ada.ALI.Types;    use SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Symbols; use SCIP_Ada.SCIP.Symbols;

package body Test_SCIP_Symbols is

   procedure Check
     (Name     : String;
      Got      : String;
      Expected : String)
   is
   begin
      AUnit.Assertions.Assert
        (Got = Expected,
         Name & "; expected """ & Expected & """, got """ & Got & """");
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

   procedure Append_Hello_Parent
     (Parent : in out Descriptor_Vectors.Vector) is
   begin
      Parent.Append
        ((Name     => To_Unbounded_String ("Hello"),
          Kind     => Namespace,
          Overload => 0));
   end Append_Hello_Parent;

   procedure Append_Child_Parent
     (Parent : in out Descriptor_Vectors.Vector) is
   begin
      Parent.Append
        ((Name     => To_Unbounded_String ("Parent"),
          Kind     => Namespace,
          Overload => 0));
      Parent.Append
        ((Name     => To_Unbounded_String ("Child"),
          Kind     => Namespace,
          Overload => 0));
   end Append_Child_Parent;

    procedure Run_Core_Symbol_Kinds is
         Alr_Ctx : constant Symbol_Context :=
            Make_Context ("alr", "my_project", ".");
         Dot_Ctx : constant Symbol_Context :=
            Make_Context (".", "standalone", "1.0.0");
         No_Parents : Descriptor_Vectors.Vector renames
            Descriptor_Vectors.Empty_Vector;
         Hello_Parent : Descriptor_Vectors.Vector;
         Child_Parent : Descriptor_Vectors.Vector;
    begin
         Append_Hello_Parent (Hello_Parent);
         Append_Child_Parent (Child_Parent);

         Check
            ("Package (top-level)",
             To_Symbol_String (Make_Entity ("Hello", Package_Entity),
                                        Alr_Ctx, No_Parents),
             "scip-ada alr my_project . Hello/");
         Check
            ("Procedure in package",
             To_Symbol_String (Make_Entity ("Say_Hello", Procedure_Entity),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Say_Hello().");
         Check
            ("Function in package",
             To_Symbol_String (Make_Entity ("Get_Value", Function_Entity),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Get_Value().");
         Check
            ("Tagged record type",
             To_Symbol_String (Make_Entity ("Greeting", Tagged_Record_Type),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Greeting#");
         Check
            ("Integer type",
             To_Symbol_String (Make_Entity ("Count", Integer_Type),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Count#");
         Check
            ("Integer object",
             To_Symbol_String (Make_Entity ("X", Integer_Object),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/X.");
         Check
            ("Enumeration type",
             To_Symbol_String (Make_Entity ("Color", Enumeration_Type),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Color#");
         Check
            ("Enumeration literal",
             To_Symbol_String (Make_Entity ("Red", Enumeration_Literal),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Red.");
         Check
            ("Component (field)",
             To_Symbol_String (Make_Entity ("Length", Component),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Length.");
         Check
            ("Named number",
             To_Symbol_String (Make_Entity ("Max", Named_Number),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Max.");
         Check
            ("Exception entity",
             To_Symbol_String (Make_Entity ("My_Error", Exception_Entity),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/My_Error.");
         Check
            ("Access type",
             To_Symbol_String (Make_Entity ("Ptr", Access_Type),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/Ptr#");
         Check
            ("Generic package",
             To_Symbol_String (Make_Entity ("Gen_Pkg", Generic_Package),
                                        Alr_Ctx, No_Parents),
             "scip-ada alr my_project . Gen_Pkg/");
         Check
            ("Generic formal type",
             To_Symbol_String (Make_Entity ("Element", Generic_Formal_Type),
                                        Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/[Element]");
         Check
            ("Private generic formal type",
             To_Symbol_String
                (Make_Entity ("Item", Private_Generic_Formal_Type),
                  Alr_Ctx, Hello_Parent),
             "scip-ada alr my_project . Hello/[Item]");
         Check
            ("Child package procedure",
             To_Symbol_String (Make_Entity ("Do_Work", Procedure_Entity),
                                        Alr_Ctx, Child_Parent),
             "scip-ada alr my_project . Parent/Child/Do_Work().");
         Check
            ("Local symbol 1",
             To_Local_Symbol (1),
             "local 1");
         Check
            ("Local symbol 42",
             To_Local_Symbol (42),
             "local 42");
         Check
            ("Standalone GPR package",
             To_Symbol_String (Make_Entity ("Utils", Package_Entity),
                                        Dot_Ctx, No_Parents),
             "scip-ada . standalone 1.0.0 Utils/");
    end Run_Core_Symbol_Kinds;

   procedure Run_Additional_Entity_Kinds is
      Alr_Ctx : constant Symbol_Context :=
        Make_Context ("alr", "my_project", ".");
      Hello_Parent : Descriptor_Vectors.Vector;
   begin
      Append_Hello_Parent (Hello_Parent);

      Check
        ("Subtype entity",
         To_Symbol_String (Make_Entity ("My_Sub", Subtype_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Sub#");
      Check
        ("Task type",
         To_Symbol_String (Make_Entity ("Worker", Task_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Worker#");
      Check
        ("Task object",
         To_Symbol_String (Make_Entity ("My_Worker", Task_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Worker.");
      Check
        ("Entry entity",
         To_Symbol_String (Make_Entity ("Start", Entry_Entity),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Start().");
      Check
        ("Generic procedure",
         To_Symbol_String (Make_Entity ("Gen_Proc", Generic_Procedure),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Gen_Proc().");
      Check
        ("Generic function",
         To_Symbol_String (Make_Entity ("Gen_Func", Generic_Function),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Gen_Func().");
      Check
        ("Abstract procedure",
         To_Symbol_String (Make_Entity ("Do_It", Abstract_Procedure),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Do_It().");
      Check
        ("Abstract function",
         To_Symbol_String (Make_Entity ("Get_It", Abstract_Function),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Get_It().");
      Check
        ("Protected object",
         To_Symbol_String (Make_Entity ("Mutex", Protected_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Mutex.");
      Check
        ("String object",
         To_Symbol_String (Make_Entity ("Msg", String_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Msg.");
      Check
        ("Array type",
         To_Symbol_String (Make_Entity ("Table", Array_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Table#");
      Check
        ("Array object",
         To_Symbol_String (Make_Entity ("Data", Array_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Data.");
      Check
        ("Boolean type",
         To_Symbol_String (Make_Entity ("Flag_Type", Boolean_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Flag_Type#");
      Check
        ("Float type",
         To_Symbol_String (Make_Entity ("Real", Float_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Real#");
      Check
        ("Float object",
         To_Symbol_String (Make_Entity ("Temp", Float_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Temp.");
      Check
        ("Procedure instantiation",
         To_Symbol_String
           (Make_Entity ("My_Swap", Procedure_Instantiation),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Swap().");
      Check
        ("Function instantiation",
         To_Symbol_String
           (Make_Entity ("My_Max", Function_Instantiation),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Max().");
      Check
        ("Generic package instantiation",
         To_Symbol_String
           (Make_Entity ("Int_Lists", Generic_Package_Instantiation),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Int_Lists/");
      Check
        ("Formal procedure",
         To_Symbol_String (Make_Entity ("Action", Formal_Procedure),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Action().");
      Check
        ("Formal function",
         To_Symbol_String (Make_Entity ("Predicate", Formal_Function),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Predicate().");
      Check
        ("Label",
         To_Symbol_String (Make_Entity ("My_Label", Label),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/My_Label.");
      Check
        ("Block label",
         To_Symbol_String (Make_Entity ("Blk", Block_Label),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Blk.");
   end Run_Additional_Entity_Kinds;

   procedure Run_Descriptor_Helpers is
      Alr_Ctx : constant Symbol_Context :=
        Make_Context ("alr", "my_project", ".");
      Hello_Parent : Descriptor_Vectors.Vector;
   begin
      Append_Hello_Parent (Hello_Parent);

      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Put"),
            Kind     => Method,
            Overload => 3);
      begin
         Check
           ("Method descriptor with overload",
            Format_Descriptor (D),
            "Put(+3).");
      end;

      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Item"),
            Kind     => Parameter,
            Overload => 0);
      begin
         Check
           ("Parameter descriptor",
            Format_Descriptor (D),
            "(Item)");
      end;

      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Info"),
            Kind     => Meta,
            Overload => 0);
      begin
         Check
           ("Meta descriptor",
            Format_Descriptor (D),
            "Info:");
      end;

      declare
         D : constant Descriptor :=
           (Name     => To_Unbounded_String ("Expand"),
            Kind     => Macro,
            Overload => 0);
      begin
         Check
           ("Macro descriptor",
            Format_Descriptor (D),
            "Expand!");
      end;

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
            "scip-ada alr my_project . Pkg/My_Type#");
      end;

      declare
         E  : constant Entity_Def := Make_Entity ("Foo", Procedure_Entity);
         S1 : constant String := To_Symbol_String (E, Alr_Ctx, Hello_Parent);
         S2 : constant String := To_Symbol_String (E, Alr_Ctx, Hello_Parent);
      begin
         Check
           ("Determinism (same entity -> same symbol)",
            S1, S2);
      end;

      Check
        ("Make_Symbol backward-compat",
         Make_Symbol ("test_pkg", "Greet"),
         "scip-ada . test_pkg . Greet/");
   end Run_Descriptor_Helpers;

   procedure Run_Remaining_Type_And_Object_Kinds is
      Alr_Ctx : constant Symbol_Context :=
        Make_Context ("alr", "my_project", ".");
      Hello_Parent : Descriptor_Vectors.Vector;
   begin
      Append_Hello_Parent (Hello_Parent);

      Check
        ("Modular integer type",
         To_Symbol_String
           (Make_Entity ("Byte", Modular_Integer_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Byte#");
      Check
        ("Decimal fixed type",
         To_Symbol_String
           (Make_Entity ("Money", Decimal_Fixed_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Money#");
      Check
        ("Ordinary fixed type",
         To_Symbol_String
           (Make_Entity ("Angle", Ordinary_Fixed_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Angle#");
      Check
        ("Class wide subtype",
         To_Symbol_String
           (Make_Entity ("CW", Class_Wide_Subtype),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/CW#");
      Check
        ("Class wide type",
         To_Symbol_String
           (Make_Entity ("Base_CW", Class_Wide_Type),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Base_CW#");
      Check
        ("Entry body",
         To_Symbol_String (Make_Entity ("Guard", Entry_Body),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Guard().");
      Check
        ("Access object",
         To_Symbol_String (Make_Entity ("Ref", Access_Object),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Ref.");
      Check
        ("Record type (untagged)",
         To_Symbol_String (Make_Entity ("Rec", Record_Type),
                           Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/Rec#");
   end Run_Remaining_Type_And_Object_Kinds;

   procedure Test_Core_Symbol_Kinds
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Run_Core_Symbol_Kinds;
   end Test_Core_Symbol_Kinds;

   procedure Test_Additional_Entity_Kinds
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Run_Additional_Entity_Kinds;
   end Test_Additional_Entity_Kinds;

   procedure Test_Descriptor_Helpers
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Run_Descriptor_Helpers;
   end Test_Descriptor_Helpers;

   procedure Test_Remaining_Type_And_Object_Kinds
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Run_Remaining_Type_And_Object_Kinds;
   end Test_Remaining_Type_And_Object_Kinds;

   procedure Run_Name_Escaping is
      Alr_Ctx : constant Symbol_Context :=
        Make_Context ("alr", "my_project", ".");
      Hello_Parent : Descriptor_Vectors.Vector;
   begin
      Append_Hello_Parent (Hello_Parent);

      --  Plain name: no escaping needed
      Check
        ("Plain name no escaping",
         Format_Descriptor
           ((Name     => To_Unbounded_String ("Hello"),
             Kind     => Term,
             Overload => 0)),
         "Hello.");

      --  Name with space: backtick-wrapped
      Check
        ("Name with space",
         Format_Descriptor
           ((Name     => To_Unbounded_String ("My Name"),
             Kind     => Term,
             Overload => 0)),
         "`My Name`.");

      --  Name with backtick: backtick-wrapped, internal backtick doubled
      Check
        ("Name with backtick",
         Format_Descriptor
           ((Name     => To_Unbounded_String ("has`tick"),
             Kind     => Term,
             Overload => 0)),
         "`has``tick`.");

      --  Operator symbol "+": contains quotes, needs backtick wrapping
      Check
        ("Operator + descriptor",
         Format_Descriptor
           ((Name     => To_Unbounded_String ("""+"""),
             Kind     => Method,
             Overload => 0)),
         "`""+""`().");

      --  Operator in full symbol string
      Check
        ("Operator + full symbol",
         To_Symbol_String
           (Make_Entity ("""=""", Function_Entity),
            Alr_Ctx, Hello_Parent),
         "scip-ada alr my_project . Hello/`""=""`().");
   end Run_Name_Escaping;

   procedure Test_Name_Escaping
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Run_Name_Escaping;
   end Test_Name_Escaping;

end Test_SCIP_Symbols;
