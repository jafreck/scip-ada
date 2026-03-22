package body SCIP_Ada.SCIP.Mapping is

   function To_SCIP_Kind
     (Kind : SCIP_Ada.ALI.Types.Entity_Kind) return SCIP_Symbol_Kind
   is
      use SCIP_Ada.ALI.Types;
   begin
      case Kind is
         --  Packages → Namespace
         when Package_Entity
            | Generic_Package
            | Generic_Package_Instantiation    => return SCIP_Namespace;

         --  Subprograms → Function
         when Procedure_Entity
            | Function_Entity
            | Generic_Procedure
            | Generic_Function
            | Formal_Procedure
            | Formal_Function
            | Procedure_Instantiation
            | Function_Instantiation
            | Abstract_Procedure
            | Abstract_Function                => return SCIP_Function;

         --  Entries → Method
         when Entry_Entity
            | Entry_Body                       => return SCIP_Method;

         --  Tagged record / abstract / task / protected → Class
         when Tagged_Record_Type
            | Abstract_Type
            | Task_Type
            | Protected_Object                 => return SCIP_Class;

         --  Untagged record → Struct
         when Record_Type                      => return SCIP_Struct;

         --  Enumeration
         when Enumeration_Type                 => return SCIP_Enum;
         when Enumeration_Literal              => return SCIP_EnumMember;

         --  Record field / discriminant → Field
         when Component                        => return SCIP_Field;

         --  Named number → Constant
         when Named_Number                     => return SCIP_Constant;

         --  Generic formal type → TypeParameter
         when Generic_Formal_Type
            | Private_Generic_Formal_Type      => return SCIP_TypeParameter;

         --  Type declarations → Type
         when Array_Type
            | Boolean_Type
            | Decimal_Fixed_Type
            | Float_Type
            | Integer_Type
            | Modular_Integer_Type
            | Ordinary_Fixed_Type
            | Access_Type
            | Class_Wide_Subtype
            | Class_Wide_Type
            | Subtype_Entity                   => return SCIP_Type;

         --  Objects, exceptions, labels → Variable
         when Array_Object
            | Decimal_Fixed_Object
            | Float_Object
            | Integer_Object
            | Modular_Integer_Object
            | Ordinary_Fixed_Object
            | Access_Object
            | String_Object
            | Class_Wide_Object
            | Task_Object
            | Exception_Entity
            | Label
            | Loop_Block_Label
            | Block_Label
            | Label_On_Begin
            | Label_On_Block                   => return SCIP_Variable;
      end case;
   end To_SCIP_Kind;

   function Kind_Value (Kind : SCIP_Symbol_Kind) return Natural is
   begin
      --  Values from SCIP protobuf schema: SymbolInformation.Kind enum
      case Kind is
         when SCIP_Unspecified   => return 0;
         when SCIP_Class         => return 7;
         when SCIP_Constant      => return 8;
         when SCIP_Enum          => return 11;
         when SCIP_EnumMember    => return 12;
         when SCIP_Field         => return 15;
         when SCIP_Function      => return 17;
         when SCIP_Interface     => return 21;
         when SCIP_Method        => return 26;
         when SCIP_Namespace     => return 30;
         when SCIP_Struct        => return 49;
         when SCIP_Type          => return 54;
         when SCIP_TypeParameter => return 58;
         when SCIP_Variable      => return 61;
      end case;
   end Kind_Value;

   function To_SCIP_Role
     (Kind : SCIP_Ada.ALI.Types.Ref_Kind) return Natural
   is
      use SCIP_Ada.ALI.Types;
   begin
      case Kind is
         --  Definitions
         when Body_Ref
            | Completion_Ref
            | Own_Ref                          => return 1;  --  Definition

         --  Import
         when With_Ref                         => return 2;  --  Import

         --  Write access
         when Modification_Ref                 => return 4;  --  WriteAccess

         --  Read access (all other reference kinds)
         when Reference_Ref
            | Static_Call
            | Dispatching_Call
            | Dispatching_Ref
            | Implicit_Ref
            | Primitive_Op_Ref
            | Type_Extension_Ref
            | Formal_Generic_Actual
            | Discriminant_Ref
            | First_Private_Entity
            | Abstract_Type_Ref
            | Overriding_Primitive
            | End_Of_Spec
            | End_Of_Body
            | Label_On_End                     => return 8;  --  ReadAccess
      end case;
   end To_SCIP_Role;

end SCIP_Ada.SCIP.Mapping;
