with Ada.Strings.Fixed;

package body SCIP_Ada.SCIP.Symbols is

   use SCIP_Ada.ALI.Types;

   ---------------------------------------------------------------------------
   --  Escape_Space — double-space escape for manager/package/version fields
   ---------------------------------------------------------------------------

   function Escape_Space (Value : String) return String is
      Result : Unbounded_String;
   begin
      for C of Value loop
         if C = ' ' then
            Append (Result, "  ");
         else
            Append (Result, C);
         end if;
      end loop;
      return To_String (Result);
   end Escape_Space;

   ---------------------------------------------------------------------------
   --  Escape_Name — backtick-wrap descriptor names with special characters
   ---------------------------------------------------------------------------

   function Needs_Backtick_Escape (Name : String) return Boolean is
   begin
      for C of Name loop
         if not (C in 'A' .. 'Z' | 'a' .. 'z' | '0' .. '9' | '_') then
            return True;
         end if;
      end loop;
      return False;
   end Needs_Backtick_Escape;

   function Escape_Name (Name : String) return String is
      Result : Unbounded_String;
   begin
      if not Needs_Backtick_Escape (Name) then
         return Name;
      end if;
      Append (Result, '`');
      for C of Name loop
         if C = '`' then
            Append (Result, "``");
         else
            Append (Result, C);
         end if;
      end loop;
      Append (Result, '`');
      return To_String (Result);
   end Escape_Name;

   ---------------------------------------------------------------------------
   --  Make_Context
   ---------------------------------------------------------------------------

   function Make_Context
     (Manager      : String;
      Package_Name : String;
      Version      : String := ".") return Symbol_Context
   is
   begin
      return
        (Manager      => To_Unbounded_String (Manager),
         Package_Name => To_Unbounded_String (Package_Name),
         Version      => To_Unbounded_String (Version));
   end Make_Context;

   ---------------------------------------------------------------------------
   --  Entity_To_Descriptor_Kind
   ---------------------------------------------------------------------------

   function Entity_To_Descriptor_Kind
     (Kind : Entity_Kind) return Descriptor_Kind
   is
   begin
      case Kind is
         --  Package / namespace entities
         when Package_Entity
            | Generic_Package
            | Generic_Package_Instantiation =>
            return Namespace;

         --  Type entities (upper-case type characters + some lower-case)
         when Array_Type
            | Boolean_Type
            | Decimal_Fixed_Type
            | Enumeration_Type
            | Float_Type
            | Abstract_Type
            | Integer_Type
            | Class_Wide_Subtype
            | Modular_Integer_Type
            | Ordinary_Fixed_Type
            | Access_Type
            | Tagged_Record_Type
            | Subtype_Entity
            | Task_Type
            | Class_Wide_Type
            | Record_Type =>
            return Type_Descriptor;

         --  Subprogram entities → Method
         when Procedure_Entity
            | Function_Entity
            | Formal_Procedure
            | Formal_Function
            | Generic_Procedure
            | Generic_Function
            | Procedure_Instantiation
            | Function_Instantiation
            | Abstract_Procedure
            | Abstract_Function
            | Entry_Entity
            | Entry_Body =>
            return Method;

         --  Generic formal type parameters
         when Generic_Formal_Type
            | Private_Generic_Formal_Type =>
            return Type_Parameter;

         --  Object / variable / constant entities → Term
         when Component
            | Named_Number
            | Array_Object
            | Decimal_Fixed_Object
            | Exception_Entity
            | Float_Object
            | Integer_Object
            | Class_Wide_Object
            | Modular_Integer_Object
            | Enumeration_Literal
            | Ordinary_Fixed_Object
            | Access_Object
            | String_Object
            | Task_Object
            | Protected_Object =>
            return Term;

         --  Labels → Term (no special SCIP descriptor for labels)
         when Label
            | Block_Label
            | Loop_Block_Label
            | Label_On_Begin
            | Label_On_Block =>
            return Term;
      end case;
   end Entity_To_Descriptor_Kind;

   ---------------------------------------------------------------------------
   --  Format_Descriptor
   ---------------------------------------------------------------------------

   function Format_Descriptor (D : Descriptor) return String is
      N : constant String := Escape_Name (To_String (D.Name));
   begin
      case D.Kind is
         when Namespace =>
            return N & "/";
         when Type_Descriptor =>
            return N & "#";
         when Term =>
            return N & ".";
         when Method =>
            if D.Overload > 0 then
               declare
                  Img : constant String :=
                    Ada.Strings.Fixed.Trim
                      (Natural'Image (D.Overload),
                       Ada.Strings.Left);
               begin
                  return N & "(+" & Img & ").";
               end;
            else
               return N & "().";
            end if;
         when Type_Parameter =>
            return "[" & N & "]";
         when Parameter =>
            return "(" & N & ")";
         when Meta =>
            return N & ":";
         when Macro =>
            return N & "!";
      end case;
   end Format_Descriptor;

   ---------------------------------------------------------------------------
   --  Build_Symbol
   ---------------------------------------------------------------------------

   function Build_Symbol
     (Context     : Symbol_Context;
      Descriptors : Descriptor_Vectors.Vector) return String
   is
      Result : Unbounded_String;
   begin
      Append (Result, Scheme);
      Append (Result, " ");
      Append (Result, Escape_Space (To_String (Context.Manager)));
      Append (Result, " ");
      Append (Result, Escape_Space (To_String (Context.Package_Name)));
      Append (Result, " ");
      Append (Result, Escape_Space (To_String (Context.Version)));
      Append (Result, " ");

      for D of Descriptors loop
         Append (Result, Format_Descriptor (D));
      end loop;

      return To_String (Result);
   end Build_Symbol;

   ---------------------------------------------------------------------------
   --  To_Symbol_String
   ---------------------------------------------------------------------------

   function To_Symbol_String
     (Entity  : Entity_Def;
      Context : Symbol_Context;
      Parents : Descriptor_Vectors.Vector :=
        Descriptor_Vectors.Empty_Vector) return String
   is
      Desc_Kind : constant Descriptor_Kind :=
        Entity_To_Descriptor_Kind (Entity.Kind);
      Chain     : Descriptor_Vectors.Vector := Parents;
   begin
      Chain.Append
        ((Name     => Entity.Name,
          Kind     => Desc_Kind,
          Overload => 0));
      return Build_Symbol (Context, Chain);
   end To_Symbol_String;

   ---------------------------------------------------------------------------
   --  To_Local_Symbol
   ---------------------------------------------------------------------------

   function To_Local_Symbol (Local_Id : Positive) return String is
   begin
      return "local " &
        Ada.Strings.Fixed.Trim (Positive'Image (Local_Id), Ada.Strings.Left);
   end To_Local_Symbol;

   ---------------------------------------------------------------------------
   --  Make_Symbol (backward-compatible stub)
   ---------------------------------------------------------------------------

   function Make_Symbol
     (Package_Name : String;
      Entity_Name  : String;
      Descriptor   : String := "") return String
   is
      pragma Unreferenced (Descriptor);
      Ctx   : constant Symbol_Context := Make_Context (".", Package_Name);
      Ent   : Entity_Def;
      Chain : Descriptor_Vectors.Vector;
   begin
      Ent.Name := To_Unbounded_String (Entity_Name);
      Ent.Kind := Package_Entity;
      Chain.Append
        ((Name     => Ent.Name,
          Kind     => Namespace,
          Overload => 0));
      return Build_Symbol (Ctx, Chain);
   end Make_Symbol;

end SCIP_Ada.SCIP.Symbols;
