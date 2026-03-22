with Ada.Text_IO;
with SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Mapping;

package body Test_SCIP_Mapping is

   use SCIP_Ada.ALI.Types;
   use SCIP_Ada.SCIP.Mapping;

   procedure Check
     (Name     : String;
      Got      : SCIP_Symbol_Kind;
      Expected : SCIP_Symbol_Kind;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      if Got = Expected then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: " & Name & " -- got " &
            SCIP_Symbol_Kind'Image (Got) & ", expected " &
            SCIP_Symbol_Kind'Image (Expected));
      end if;
   end Check;

   procedure Check_Role
     (Name     : String;
      Got      : Natural;
      Expected : Natural;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      if Got = Expected then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: " & Name & " -- got" &
            Natural'Image (Got) & ", expected" &
            Natural'Image (Expected));
      end if;
   end Check_Role;

   procedure Check_Value
     (Name     : String;
      Got      : Natural;
      Expected : Natural;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      if Got = Expected then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: " & Name & " -- got" &
            Natural'Image (Got) & ", expected" &
            Natural'Image (Expected));
      end if;
   end Check_Value;

   procedure Run (Passed : out Natural; Failed : out Natural) is
   begin
      Passed := 0;
      Failed := 0;

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Packages -> Namespace
      -----------------------------------------------------------------------
      Check ("Package_Entity -> Namespace",
             To_SCIP_Kind (Package_Entity), SCIP_Namespace,
             Passed, Failed);
      Check ("Generic_Package -> Namespace",
             To_SCIP_Kind (Generic_Package), SCIP_Namespace,
             Passed, Failed);
      Check ("Generic_Package_Instantiation -> Namespace",
             To_SCIP_Kind (Generic_Package_Instantiation), SCIP_Namespace,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Subprograms -> Function
      -----------------------------------------------------------------------
      Check ("Procedure_Entity -> Function",
             To_SCIP_Kind (Procedure_Entity), SCIP_Function,
             Passed, Failed);
      Check ("Function_Entity -> Function",
             To_SCIP_Kind (Function_Entity), SCIP_Function,
             Passed, Failed);
      Check ("Generic_Procedure -> Function",
             To_SCIP_Kind (Generic_Procedure), SCIP_Function,
             Passed, Failed);
      Check ("Generic_Function -> Function",
             To_SCIP_Kind (Generic_Function), SCIP_Function,
             Passed, Failed);
      Check ("Formal_Procedure -> Function",
             To_SCIP_Kind (Formal_Procedure), SCIP_Function,
             Passed, Failed);
      Check ("Formal_Function -> Function",
             To_SCIP_Kind (Formal_Function), SCIP_Function,
             Passed, Failed);
      Check ("Procedure_Instantiation -> Function",
             To_SCIP_Kind (Procedure_Instantiation), SCIP_Function,
             Passed, Failed);
      Check ("Function_Instantiation -> Function",
             To_SCIP_Kind (Function_Instantiation), SCIP_Function,
             Passed, Failed);
      Check ("Abstract_Procedure -> Function",
             To_SCIP_Kind (Abstract_Procedure), SCIP_Function,
             Passed, Failed);
      Check ("Abstract_Function -> Function",
             To_SCIP_Kind (Abstract_Function), SCIP_Function,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Entries -> Method
      -----------------------------------------------------------------------
      Check ("Entry_Entity -> Method",
             To_SCIP_Kind (Entry_Entity), SCIP_Method,
             Passed, Failed);
      Check ("Entry_Body -> Method",
             To_SCIP_Kind (Entry_Body), SCIP_Method,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Tagged record / abstract / task / protected -> Class
      -----------------------------------------------------------------------
      Check ("Tagged_Record_Type -> Class",
             To_SCIP_Kind (Tagged_Record_Type), SCIP_Class,
             Passed, Failed);
      Check ("Abstract_Type -> Class",
             To_SCIP_Kind (Abstract_Type), SCIP_Class,
             Passed, Failed);
      Check ("Task_Type -> Class",
             To_SCIP_Kind (Task_Type), SCIP_Class,
             Passed, Failed);
      Check ("Protected_Object -> Class",
             To_SCIP_Kind (Protected_Object), SCIP_Class,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Untagged record -> Struct
      -----------------------------------------------------------------------
      Check ("Record_Type -> Struct",
             To_SCIP_Kind (Record_Type), SCIP_Struct,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Enumeration
      -----------------------------------------------------------------------
      Check ("Enumeration_Type -> Enum",
             To_SCIP_Kind (Enumeration_Type), SCIP_Enum,
             Passed, Failed);
      Check ("Enumeration_Literal -> EnumMember",
             To_SCIP_Kind (Enumeration_Literal), SCIP_EnumMember,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Field
      -----------------------------------------------------------------------
      Check ("Component -> Field",
             To_SCIP_Kind (Component), SCIP_Field,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Named number -> Constant
      -----------------------------------------------------------------------
      Check ("Named_Number -> Constant",
             To_SCIP_Kind (Named_Number), SCIP_Constant,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Generic formal types -> TypeParameter
      -----------------------------------------------------------------------
      Check ("Generic_Formal_Type -> TypeParameter",
             To_SCIP_Kind (Generic_Formal_Type), SCIP_TypeParameter,
             Passed, Failed);
      Check ("Private_Generic_Formal_Type -> TypeParameter",
             To_SCIP_Kind (Private_Generic_Formal_Type), SCIP_TypeParameter,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Type declarations -> Type
      -----------------------------------------------------------------------
      Check ("Array_Type -> Type",
             To_SCIP_Kind (Array_Type), SCIP_Type,
             Passed, Failed);
      Check ("Boolean_Type -> Type",
             To_SCIP_Kind (Boolean_Type), SCIP_Type,
             Passed, Failed);
      Check ("Decimal_Fixed_Type -> Type",
             To_SCIP_Kind (Decimal_Fixed_Type), SCIP_Type,
             Passed, Failed);
      Check ("Float_Type -> Type",
             To_SCIP_Kind (Float_Type), SCIP_Type,
             Passed, Failed);
      Check ("Integer_Type -> Type",
             To_SCIP_Kind (Integer_Type), SCIP_Type,
             Passed, Failed);
      Check ("Modular_Integer_Type -> Type",
             To_SCIP_Kind (Modular_Integer_Type), SCIP_Type,
             Passed, Failed);
      Check ("Ordinary_Fixed_Type -> Type",
             To_SCIP_Kind (Ordinary_Fixed_Type), SCIP_Type,
             Passed, Failed);
      Check ("Access_Type -> Type",
             To_SCIP_Kind (Access_Type), SCIP_Type,
             Passed, Failed);
      Check ("Class_Wide_Subtype -> Type",
             To_SCIP_Kind (Class_Wide_Subtype), SCIP_Type,
             Passed, Failed);
      Check ("Class_Wide_Type -> Type",
             To_SCIP_Kind (Class_Wide_Type), SCIP_Type,
             Passed, Failed);
      Check ("Subtype_Entity -> Type",
             To_SCIP_Kind (Subtype_Entity), SCIP_Type,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Kind: Objects / exceptions / labels -> Variable
      -----------------------------------------------------------------------
      Check ("Array_Object -> Variable",
             To_SCIP_Kind (Array_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Decimal_Fixed_Object -> Variable",
             To_SCIP_Kind (Decimal_Fixed_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Float_Object -> Variable",
             To_SCIP_Kind (Float_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Integer_Object -> Variable",
             To_SCIP_Kind (Integer_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Modular_Integer_Object -> Variable",
             To_SCIP_Kind (Modular_Integer_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Ordinary_Fixed_Object -> Variable",
             To_SCIP_Kind (Ordinary_Fixed_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Access_Object -> Variable",
             To_SCIP_Kind (Access_Object), SCIP_Variable,
             Passed, Failed);
      Check ("String_Object -> Variable",
             To_SCIP_Kind (String_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Class_Wide_Object -> Variable",
             To_SCIP_Kind (Class_Wide_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Task_Object -> Variable",
             To_SCIP_Kind (Task_Object), SCIP_Variable,
             Passed, Failed);
      Check ("Exception_Entity -> Variable",
             To_SCIP_Kind (Exception_Entity), SCIP_Variable,
             Passed, Failed);
      Check ("Label -> Variable",
             To_SCIP_Kind (Label), SCIP_Variable,
             Passed, Failed);
      Check ("Loop_Block_Label -> Variable",
             To_SCIP_Kind (Loop_Block_Label), SCIP_Variable,
             Passed, Failed);
      Check ("Block_Label -> Variable",
             To_SCIP_Kind (Block_Label), SCIP_Variable,
             Passed, Failed);
      Check ("Label_On_Begin -> Variable",
             To_SCIP_Kind (Label_On_Begin), SCIP_Variable,
             Passed, Failed);
      Check ("Label_On_Block -> Variable",
             To_SCIP_Kind (Label_On_Block), SCIP_Variable,
             Passed, Failed);

      -----------------------------------------------------------------------
      --  Kind_Value: check SCIP integer values
      -----------------------------------------------------------------------
      Check_Value ("Kind_Value Unspecified = 0",
                   Kind_Value (SCIP_Unspecified), 0, Passed, Failed);
      Check_Value ("Kind_Value Class = 7",
                   Kind_Value (SCIP_Class), 7, Passed, Failed);
      Check_Value ("Kind_Value Constant = 8",
                   Kind_Value (SCIP_Constant), 8, Passed, Failed);
      Check_Value ("Kind_Value Enum = 11",
                   Kind_Value (SCIP_Enum), 11, Passed, Failed);
      Check_Value ("Kind_Value EnumMember = 12",
                   Kind_Value (SCIP_EnumMember), 12, Passed, Failed);
      Check_Value ("Kind_Value Field = 15",
                   Kind_Value (SCIP_Field), 15, Passed, Failed);
      Check_Value ("Kind_Value Function = 17",
                   Kind_Value (SCIP_Function), 17, Passed, Failed);
      Check_Value ("Kind_Value Interface = 21",
                   Kind_Value (SCIP_Interface), 21, Passed, Failed);
      Check_Value ("Kind_Value Method = 26",
                   Kind_Value (SCIP_Method), 26, Passed, Failed);
      Check_Value ("Kind_Value Namespace = 30",
                   Kind_Value (SCIP_Namespace), 30, Passed, Failed);
      Check_Value ("Kind_Value Struct = 49",
                   Kind_Value (SCIP_Struct), 49, Passed, Failed);
      Check_Value ("Kind_Value Type = 54",
                   Kind_Value (SCIP_Type), 54, Passed, Failed);
      Check_Value ("Kind_Value TypeParameter = 58",
                   Kind_Value (SCIP_TypeParameter), 58, Passed, Failed);
      Check_Value ("Kind_Value Variable = 61",
                   Kind_Value (SCIP_Variable), 61, Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Role: Definition (bitmask 1)
      -----------------------------------------------------------------------
      Check_Role ("Body_Ref -> Definition",
                  To_SCIP_Role (Body_Ref), 1, Passed, Failed);
      Check_Role ("Completion_Ref -> Definition",
                  To_SCIP_Role (Completion_Ref), 1, Passed, Failed);
      Check_Role ("Own_Ref -> Definition",
                  To_SCIP_Role (Own_Ref), 1, Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Role: Import (bitmask 2)
      -----------------------------------------------------------------------
      Check_Role ("With_Ref -> Import",
                  To_SCIP_Role (With_Ref), 2, Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Role: WriteAccess (bitmask 4)
      -----------------------------------------------------------------------
      Check_Role ("Modification_Ref -> WriteAccess",
                  To_SCIP_Role (Modification_Ref), 4, Passed, Failed);

      -----------------------------------------------------------------------
      --  To_SCIP_Role: ReadAccess (bitmask 8)
      -----------------------------------------------------------------------
      Check_Role ("Reference_Ref -> ReadAccess",
                  To_SCIP_Role (Reference_Ref), 8, Passed, Failed);
      Check_Role ("Static_Call -> ReadAccess",
                  To_SCIP_Role (Static_Call), 8, Passed, Failed);
      Check_Role ("Dispatching_Call -> ReadAccess",
                  To_SCIP_Role (Dispatching_Call), 8, Passed, Failed);
      Check_Role ("Dispatching_Ref -> ReadAccess",
                  To_SCIP_Role (Dispatching_Ref), 8, Passed, Failed);
      Check_Role ("Implicit_Ref -> ReadAccess",
                  To_SCIP_Role (Implicit_Ref), 8, Passed, Failed);
      Check_Role ("Primitive_Op_Ref -> ReadAccess",
                  To_SCIP_Role (Primitive_Op_Ref), 8, Passed, Failed);
      Check_Role ("Type_Extension_Ref -> ReadAccess",
                  To_SCIP_Role (Type_Extension_Ref), 8, Passed, Failed);
      Check_Role ("Formal_Generic_Actual -> ReadAccess",
                  To_SCIP_Role (Formal_Generic_Actual), 8, Passed, Failed);
      Check_Role ("Discriminant_Ref -> ReadAccess",
                  To_SCIP_Role (Discriminant_Ref), 8, Passed, Failed);
      Check_Role ("First_Private_Entity -> ReadAccess",
                  To_SCIP_Role (First_Private_Entity), 8, Passed, Failed);
      Check_Role ("Abstract_Type_Ref -> ReadAccess",
                  To_SCIP_Role (Abstract_Type_Ref), 8, Passed, Failed);
      Check_Role ("Overriding_Primitive -> ReadAccess",
                  To_SCIP_Role (Overriding_Primitive), 8, Passed, Failed);
      Check_Role ("End_Of_Spec -> ReadAccess",
                  To_SCIP_Role (End_Of_Spec), 8, Passed, Failed);
      Check_Role ("End_Of_Body -> ReadAccess",
                  To_SCIP_Role (End_Of_Body), 8, Passed, Failed);
      Check_Role ("Label_On_End -> ReadAccess",
                  To_SCIP_Role (Label_On_End), 8, Passed, Failed);
   end Run;

end Test_SCIP_Mapping;
