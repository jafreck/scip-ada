with AUnit.Assertions;
with SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Mapping;

package body Test_SCIP_Mapping is

   use SCIP_Ada.ALI.Types;
   use SCIP_Ada.SCIP.Mapping;

   procedure Check_Kind
     (Name     : String;
      Got      : SCIP_Symbol_Kind;
      Expected : SCIP_Symbol_Kind)
   is
   begin
      AUnit.Assertions.Assert
        (Got = Expected,
         Name & " -- got " & SCIP_Symbol_Kind'Image (Got) &
         ", expected " & SCIP_Symbol_Kind'Image (Expected));
   end Check_Kind;

   procedure Check_Natural
     (Name     : String;
      Got      : Natural;
      Expected : Natural)
   is
   begin
      AUnit.Assertions.Assert
        (Got = Expected,
         Name & " -- got" & Natural'Image (Got) &
         ", expected" & Natural'Image (Expected));
   end Check_Natural;

   procedure Test_Kind_Mapping (T : in out SCIP_Ada.Tests.Fixture) is
      pragma Unreferenced (T);
   begin
      Check_Kind ("Package_Entity -> Namespace",
                  To_SCIP_Kind (Package_Entity), SCIP_Namespace);
      Check_Kind ("Generic_Package -> Namespace",
                  To_SCIP_Kind (Generic_Package), SCIP_Namespace);
      Check_Kind ("Generic_Package_Instantiation -> Namespace",
                  To_SCIP_Kind (Generic_Package_Instantiation),
                  SCIP_Namespace);

      Check_Kind ("Procedure_Entity -> Function",
                  To_SCIP_Kind (Procedure_Entity), SCIP_Function);
      Check_Kind ("Function_Entity -> Function",
                  To_SCIP_Kind (Function_Entity), SCIP_Function);
      Check_Kind ("Generic_Procedure -> Function",
                  To_SCIP_Kind (Generic_Procedure), SCIP_Function);
      Check_Kind ("Generic_Function -> Function",
                  To_SCIP_Kind (Generic_Function), SCIP_Function);
      Check_Kind ("Formal_Procedure -> Function",
                  To_SCIP_Kind (Formal_Procedure), SCIP_Function);
      Check_Kind ("Formal_Function -> Function",
                  To_SCIP_Kind (Formal_Function), SCIP_Function);
      Check_Kind ("Procedure_Instantiation -> Function",
                  To_SCIP_Kind (Procedure_Instantiation), SCIP_Function);
      Check_Kind ("Function_Instantiation -> Function",
                  To_SCIP_Kind (Function_Instantiation), SCIP_Function);
      Check_Kind ("Abstract_Procedure -> Function",
                  To_SCIP_Kind (Abstract_Procedure), SCIP_Function);
      Check_Kind ("Abstract_Function -> Function",
                  To_SCIP_Kind (Abstract_Function), SCIP_Function);

      Check_Kind ("Entry_Entity -> Method",
                  To_SCIP_Kind (Entry_Entity), SCIP_Method);
      Check_Kind ("Entry_Body -> Method",
                  To_SCIP_Kind (Entry_Body), SCIP_Method);

      Check_Kind ("Tagged_Record_Type -> Class",
                  To_SCIP_Kind (Tagged_Record_Type), SCIP_Class);
      Check_Kind ("Abstract_Type -> Class",
                  To_SCIP_Kind (Abstract_Type), SCIP_Class);
      Check_Kind ("Task_Type -> Class",
                  To_SCIP_Kind (Task_Type), SCIP_Class);
      Check_Kind ("Protected_Object -> Class",
                  To_SCIP_Kind (Protected_Object), SCIP_Class);

      Check_Kind ("Record_Type -> Struct",
                  To_SCIP_Kind (Record_Type), SCIP_Struct);

      Check_Kind ("Enumeration_Type -> Enum",
                  To_SCIP_Kind (Enumeration_Type), SCIP_Enum);
      Check_Kind ("Enumeration_Literal -> EnumMember",
                  To_SCIP_Kind (Enumeration_Literal), SCIP_EnumMember);

      Check_Kind ("Component -> Field",
                  To_SCIP_Kind (Component), SCIP_Field);

      Check_Kind ("Named_Number -> Constant",
                  To_SCIP_Kind (Named_Number), SCIP_Constant);

      Check_Kind ("Generic_Formal_Type -> TypeParameter",
                  To_SCIP_Kind (Generic_Formal_Type), SCIP_TypeParameter);
      Check_Kind ("Private_Generic_Formal_Type -> TypeParameter",
                  To_SCIP_Kind (Private_Generic_Formal_Type),
                  SCIP_TypeParameter);

      Check_Kind ("Array_Type -> Type",
                  To_SCIP_Kind (Array_Type), SCIP_Type);
      Check_Kind ("Boolean_Type -> Type",
                  To_SCIP_Kind (Boolean_Type), SCIP_Type);
      Check_Kind ("Decimal_Fixed_Type -> Type",
                  To_SCIP_Kind (Decimal_Fixed_Type), SCIP_Type);
      Check_Kind ("Float_Type -> Type",
                  To_SCIP_Kind (Float_Type), SCIP_Type);
      Check_Kind ("Integer_Type -> Type",
                  To_SCIP_Kind (Integer_Type), SCIP_Type);
      Check_Kind ("Modular_Integer_Type -> Type",
                  To_SCIP_Kind (Modular_Integer_Type), SCIP_Type);
      Check_Kind ("Ordinary_Fixed_Type -> Type",
                  To_SCIP_Kind (Ordinary_Fixed_Type), SCIP_Type);
      Check_Kind ("Access_Type -> Type",
                  To_SCIP_Kind (Access_Type), SCIP_Type);
      Check_Kind ("Class_Wide_Subtype -> Type",
                  To_SCIP_Kind (Class_Wide_Subtype), SCIP_Type);
      Check_Kind ("Class_Wide_Type -> Type",
                  To_SCIP_Kind (Class_Wide_Type), SCIP_Type);
      Check_Kind ("Subtype_Entity -> Type",
                  To_SCIP_Kind (Subtype_Entity), SCIP_Type);

      Check_Kind ("Array_Object -> Variable",
                  To_SCIP_Kind (Array_Object), SCIP_Variable);
      Check_Kind ("Decimal_Fixed_Object -> Variable",
                  To_SCIP_Kind (Decimal_Fixed_Object), SCIP_Variable);
      Check_Kind ("Float_Object -> Variable",
                  To_SCIP_Kind (Float_Object), SCIP_Variable);
      Check_Kind ("Integer_Object -> Variable",
                  To_SCIP_Kind (Integer_Object), SCIP_Variable);
      Check_Kind ("Modular_Integer_Object -> Variable",
                  To_SCIP_Kind (Modular_Integer_Object), SCIP_Variable);
      Check_Kind ("Ordinary_Fixed_Object -> Variable",
                  To_SCIP_Kind (Ordinary_Fixed_Object), SCIP_Variable);
      Check_Kind ("Access_Object -> Variable",
                  To_SCIP_Kind (Access_Object), SCIP_Variable);
      Check_Kind ("String_Object -> Variable",
                  To_SCIP_Kind (String_Object), SCIP_Variable);
      Check_Kind ("Class_Wide_Object -> Variable",
                  To_SCIP_Kind (Class_Wide_Object), SCIP_Variable);
      Check_Kind ("Task_Object -> Variable",
                  To_SCIP_Kind (Task_Object), SCIP_Variable);
      Check_Kind ("Exception_Entity -> Variable",
                  To_SCIP_Kind (Exception_Entity), SCIP_Variable);
      Check_Kind ("Label -> Variable",
                  To_SCIP_Kind (Label), SCIP_Variable);
      Check_Kind ("Loop_Block_Label -> Variable",
                  To_SCIP_Kind (Loop_Block_Label), SCIP_Variable);
      Check_Kind ("Block_Label -> Variable",
                  To_SCIP_Kind (Block_Label), SCIP_Variable);
      Check_Kind ("Label_On_Begin -> Variable",
                  To_SCIP_Kind (Label_On_Begin), SCIP_Variable);
      Check_Kind ("Label_On_Block -> Variable",
                  To_SCIP_Kind (Label_On_Block), SCIP_Variable);
   end Test_Kind_Mapping;

   procedure Test_Kind_Values (T : in out SCIP_Ada.Tests.Fixture) is
      pragma Unreferenced (T);
   begin
      Check_Natural ("Kind_Value Unspecified = 0",
                     Kind_Value (SCIP_Unspecified), 0);
      Check_Natural ("Kind_Value Class = 7",
                     Kind_Value (SCIP_Class), 7);
      Check_Natural ("Kind_Value Constant = 8",
                     Kind_Value (SCIP_Constant), 8);
      Check_Natural ("Kind_Value Enum = 11",
                     Kind_Value (SCIP_Enum), 11);
      Check_Natural ("Kind_Value EnumMember = 12",
                     Kind_Value (SCIP_EnumMember), 12);
      Check_Natural ("Kind_Value Field = 15",
                     Kind_Value (SCIP_Field), 15);
      Check_Natural ("Kind_Value Function = 17",
                     Kind_Value (SCIP_Function), 17);
      Check_Natural ("Kind_Value Interface = 21",
                     Kind_Value (SCIP_Interface), 21);
      Check_Natural ("Kind_Value Method = 26",
                     Kind_Value (SCIP_Method), 26);
      Check_Natural ("Kind_Value Namespace = 30",
                     Kind_Value (SCIP_Namespace), 30);
      Check_Natural ("Kind_Value Struct = 49",
                     Kind_Value (SCIP_Struct), 49);
      Check_Natural ("Kind_Value Type = 54",
                     Kind_Value (SCIP_Type), 54);
      Check_Natural ("Kind_Value TypeParameter = 58",
                     Kind_Value (SCIP_TypeParameter), 58);
      Check_Natural ("Kind_Value Variable = 61",
                     Kind_Value (SCIP_Variable), 61);
   end Test_Kind_Values;

   procedure Test_Role_Mapping (T : in out SCIP_Ada.Tests.Fixture) is
      pragma Unreferenced (T);
   begin
      Check_Natural ("Body_Ref -> Definition",
                     To_SCIP_Role (Body_Ref), 1);
      Check_Natural ("Completion_Ref -> Definition",
                     To_SCIP_Role (Completion_Ref), 1);
      Check_Natural ("Own_Ref -> Definition",
                     To_SCIP_Role (Own_Ref), 1);

      Check_Natural ("With_Ref -> Import",
                     To_SCIP_Role (With_Ref), 2);

      Check_Natural ("Modification_Ref -> WriteAccess",
                     To_SCIP_Role (Modification_Ref), 4);

      Check_Natural ("Reference_Ref -> ReadAccess",
                     To_SCIP_Role (Reference_Ref), 8);
      Check_Natural ("Static_Call -> ReadAccess",
                     To_SCIP_Role (Static_Call), 8);
      Check_Natural ("Dispatching_Call -> ReadAccess",
                     To_SCIP_Role (Dispatching_Call), 8);
      Check_Natural ("Dispatching_Ref -> ReadAccess",
                     To_SCIP_Role (Dispatching_Ref), 8);
      Check_Natural ("Implicit_Ref -> ReadAccess",
                     To_SCIP_Role (Implicit_Ref), 8);
      Check_Natural ("Primitive_Op_Ref -> ReadAccess",
                     To_SCIP_Role (Primitive_Op_Ref), 8);
      Check_Natural ("Type_Extension_Ref -> ReadAccess",
                     To_SCIP_Role (Type_Extension_Ref), 8);
      Check_Natural ("Formal_Generic_Actual -> ReadAccess",
                     To_SCIP_Role (Formal_Generic_Actual), 8);
      Check_Natural ("Discriminant_Ref -> ReadAccess",
                     To_SCIP_Role (Discriminant_Ref), 8);
      Check_Natural ("First_Private_Entity -> ReadAccess",
                     To_SCIP_Role (First_Private_Entity), 8);
      Check_Natural ("Abstract_Type_Ref -> ReadAccess",
                     To_SCIP_Role (Abstract_Type_Ref), 8);
      Check_Natural ("Overriding_Primitive -> ReadAccess",
                     To_SCIP_Role (Overriding_Primitive), 8);
      Check_Natural ("End_Of_Spec -> ReadAccess",
                     To_SCIP_Role (End_Of_Spec), 8);
      Check_Natural ("End_Of_Body -> ReadAccess",
                     To_SCIP_Role (End_Of_Body), 8);
      Check_Natural ("Label_On_End -> ReadAccess",
                     To_SCIP_Role (Label_On_End), 8);
   end Test_Role_Mapping;

end Test_SCIP_Mapping;
