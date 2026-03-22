--  SCIP_Ada.ALI.Types — Data model for parsed ALI cross-reference data
--
--  Entity and reference type characters are defined by GNAT's lib-writ.ads.

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.ALI.Types is

   use Ada.Strings.Unbounded;

   ---------------------------------------------------------------------------
   --  Entity_Kind — one enum value per entity type character from lib-writ.ads
   --
   --  Upper-case characters denote types; lower-case denote objects/instances
   --  or secondary meanings.
   ---------------------------------------------------------------------------

   type Entity_Kind is
     (--  Upper-case entity type characters
      Array_Type,                   --  'A'
      Boolean_Type,                 --  'B'
      Component,                    --  'C'  record field / discriminant
      Decimal_Fixed_Type,           --  'D'
      Enumeration_Type,             --  'E'
      Float_Type,                   --  'F'
      Generic_Package,              --  'G'
      Abstract_Type,                --  'H'
      Integer_Type,                 --  'I'
      Class_Wide_Subtype,           --  'J'
      Package_Entity,               --  'K'
      Label,                        --  'L'
      Modular_Integer_Type,         --  'M'
      Named_Number,                 --  'N'
      Ordinary_Fixed_Type,          --  'O'
      Access_Type,                  --  'P'
      Block_Label,                  --  'Q'
      Tagged_Record_Type,           --  'R'
      Subtype_Entity,               --  'S'
      Task_Type,                    --  'T'
      Procedure_Entity,             --  'U'
      Function_Entity,              --  'V'
      Formal_Procedure,             --  'W'
      Formal_Function,              --  'X'
      Entry_Entity,                 --  'Y'

      --  Lower-case entity type characters
      Array_Object,                 --  'a'
      Loop_Block_Label,             --  'b'
      Class_Wide_Type,              --  'c'
      Decimal_Fixed_Object,         --  'd'
      Exception_Entity,             --  'e'
      Float_Object,                 --  'f'
      Generic_Procedure,            --  'g'
      Generic_Function,             --  'h'
      Integer_Object,               --  'i'
      Class_Wide_Object,            --  'j'
      Generic_Package_Instantiation, -- 'k'
      Label_On_Begin,               --  'l'
      Modular_Integer_Object,       --  'm'
      Enumeration_Literal,          --  'n'
      Ordinary_Fixed_Object,        --  'o'
      Access_Object,                --  'p'
      Label_On_Block,               --  'q'
      Record_Type,                  --  'r'  untagged record
      String_Object,                --  's'
      Task_Object,                  --  't'
      Procedure_Instantiation,      --  'u'
      Function_Instantiation,       --  'v'
      Protected_Object,             --  'w'
      Abstract_Procedure,           --  'x'
      Entry_Body,                   --  'y'
      Abstract_Function,            --  'z'

      --  Special characters
      Generic_Formal_Type,          --  '+'
      Private_Generic_Formal_Type); --  '*'

   ---------------------------------------------------------------------------
   --  Ref_Kind — one enum value per reference type character from lib-writ.ads
   ---------------------------------------------------------------------------

   type Ref_Kind is
     (Body_Ref,                --  'b'  body entity
      Completion_Ref,          --  'c'  completion of private/incomplete type
      Dispatching_Call,        --  'd'  dispatching call
      End_Of_Spec,             --  'e'  end of spec
      Implicit_Ref,            --  'i'  implicit (generated) reference
      Label_On_End,            --  'l'  label on end line
      Modification_Ref,        --  'm'  modification (assignment target)
      Own_Ref,                 --  'o'  own reference (original definition)
      Primitive_Op_Ref,        --  'p'  primitive operation of type
      Reference_Ref,           --  'r'  simple read reference
      Static_Call,             --  's'  static call
      End_Of_Body,             --  't'  end of body
      With_Ref,                --  'w'  WITH line
      Type_Extension_Ref,      --  'x'  type extension parent reference
      Formal_Generic_Actual,   --  'z'  formal generic actual
      Discriminant_Ref,        --  'D'  discriminant
      First_Private_Entity,    --  'E'  first private entity
      Abstract_Type_Ref,       --  'H'  abstract type
      Overriding_Primitive,    --  'P'  overriding primitive
      Dispatching_Ref);        --  'R'  dispatching call (dispatching ref)

   ---------------------------------------------------------------------------
   --  Conversion functions
   --  Raise Constraint_Error for unmapped characters.
   ---------------------------------------------------------------------------

   function To_Entity_Kind (C : Character) return Entity_Kind;
   function To_Ref_Kind (C : Character) return Ref_Kind;

   ---------------------------------------------------------------------------
   --  File_Entry — mapping from file index to path (from D lines)
   ---------------------------------------------------------------------------

   type File_Entry is record
      Path : Unbounded_String;
   end record;

   package File_Entry_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => File_Entry);

   ---------------------------------------------------------------------------
   --  Reference — one reference to an entity
   ---------------------------------------------------------------------------

   type Reference is record
      File_Index : Positive := 1;
      Line       : Positive := 1;
      Column     : Positive := 1;
      Kind       : Ref_Kind := Reference_Ref;
   end record;

   package Reference_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Reference);

   ---------------------------------------------------------------------------
   --  Entity_Def — one entity definition
   ---------------------------------------------------------------------------

   type Entity_Def is record
      File_Index       : Positive := 1;
      Line             : Positive := 1;
      Column           : Positive := 1;
      Kind             : Entity_Kind := Array_Type;
      Name             : Unbounded_String;
      Is_Library_Level : Boolean := False;
      References       : Reference_Vectors.Vector;
   end record;

   package Entity_Def_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Entity_Def);

   ---------------------------------------------------------------------------
   --  XRef_Section — cross-references for one source file
   ---------------------------------------------------------------------------

   type XRef_Section is record
      File_Index : Positive := 1;
      Entities   : Entity_Def_Vectors.Vector;
   end record;

   package XRef_Section_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => XRef_Section);

   ---------------------------------------------------------------------------
   --  ALI_File — represents one parsed .ali file
   ---------------------------------------------------------------------------

   type ALI_File is record
      Files    : File_Entry_Vectors.Vector;
      Sections : XRef_Section_Vectors.Vector;
   end record;

end SCIP_Ada.ALI.Types;
