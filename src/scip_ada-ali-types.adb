package body SCIP_Ada.ALI.Types is

   function To_Entity_Kind (C : Character) return Entity_Kind is
   begin
      case C is
         when 'A' => return Array_Type;
         when 'B' => return Boolean_Type;
         when 'C' => return Component;
         when 'D' => return Decimal_Fixed_Type;
         when 'E' => return Enumeration_Type;
         when 'F' => return Float_Type;
         when 'G' => return Generic_Package;
         when 'H' => return Abstract_Type;
         when 'I' => return Integer_Type;
         when 'J' => return Class_Wide_Subtype;
         when 'K' => return Package_Entity;
         when 'L' => return Label;
         when 'M' => return Modular_Integer_Type;
         when 'N' => return Named_Number;
         when 'O' => return Ordinary_Fixed_Type;
         when 'P' => return Access_Type;
         when 'Q' => return Block_Label;
         when 'R' => return Tagged_Record_Type;
         when 'S' => return Subtype_Entity;
         when 'T' => return Task_Type;
         when 'U' => return Procedure_Entity;
         when 'V' => return Function_Entity;
         when 'W' => return Formal_Procedure;
         when 'X' => return Formal_Function;
         when 'Y' => return Entry_Entity;
         when 'a' => return Array_Object;
         when 'b' => return Loop_Block_Label;
         when 'c' => return Class_Wide_Type;
         when 'd' => return Decimal_Fixed_Object;
         when 'e' => return Exception_Entity;
         when 'f' => return Float_Object;
         when 'g' => return Generic_Procedure;
         when 'h' => return Generic_Function;
         when 'i' => return Integer_Object;
         when 'j' => return Class_Wide_Object;
         when 'k' => return Generic_Package_Instantiation;
         when 'l' => return Label_On_Begin;
         when 'm' => return Modular_Integer_Object;
         when 'n' => return Enumeration_Literal;
         when 'o' => return Ordinary_Fixed_Object;
         when 'p' => return Access_Object;
         when 'q' => return Label_On_Block;
         when 'r' => return Record_Type;
         when 's' => return String_Object;
         when 't' => return Task_Object;
         when 'u' => return Procedure_Instantiation;
         when 'v' => return Function_Instantiation;
         when 'w' => return Protected_Object;
         when 'x' => return Abstract_Procedure;
         when 'y' => return Entry_Body;
         when 'z' => return Abstract_Function;
         when '+' => return Generic_Formal_Type;
         when '*' => return Private_Generic_Formal_Type;
         when others =>
            raise Constraint_Error with
              "Invalid entity type character: '" & C & "'";
      end case;
   end To_Entity_Kind;

   function To_Ref_Kind (C : Character) return Ref_Kind is
   begin
      case C is
         when 'b' => return Body_Ref;
         when 'c' => return Completion_Ref;
         when 'd' => return Dispatching_Call;
         when 'e' => return End_Of_Spec;
         when 'i' => return Implicit_Ref;
         when 'l' => return Label_On_End;
         when 'm' => return Modification_Ref;
         when 'o' => return Own_Ref;
         when 'p' => return Primitive_Op_Ref;
         when 'r' => return Reference_Ref;
         when 's' => return Static_Call;
         when 't' => return End_Of_Body;
         when 'w' => return With_Ref;
         when 'x' => return Type_Extension_Ref;
         when 'z' => return Formal_Generic_Actual;
         when 'D' => return Discriminant_Ref;
         when 'E' => return First_Private_Entity;
         when 'H' => return Abstract_Type_Ref;
         when 'P' => return Overriding_Primitive;
         when 'R' => return Dispatching_Ref;
         when others =>
            raise Constraint_Error with
              "Invalid reference type character: '" & C & "'";
      end case;
   end To_Ref_Kind;

end SCIP_Ada.ALI.Types;
