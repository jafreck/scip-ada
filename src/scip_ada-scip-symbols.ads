--  SCIP_Ada.SCIP.Symbols — SCIP symbol string construction
--
--  Builds fully-qualified SCIP symbol strings from Ada entity information.
--  Format: "scip-ada <manager> <package> <version> <descriptors>"

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;
with SCIP_Ada.ALI.Types;

package SCIP_Ada.SCIP.Symbols is

   use Ada.Strings.Unbounded;

   Scheme : constant String := "scip-ada";

   ---------------------------------------------------------------------------
   --  Descriptor_Kind — SCIP descriptor suffix variants
   ---------------------------------------------------------------------------

   type Descriptor_Kind is
     (Namespace,       --  Name/
      Type_Descriptor, --  Name#
      Term,            --  Name.
      Method,          --  Name(overload).
      Type_Parameter,  --  [Name]
      Parameter,       --  (Name)
      Meta,            --  Name:
      Macro);          --  Name!

   ---------------------------------------------------------------------------
   --  Descriptor — one segment in a descriptor chain
   ---------------------------------------------------------------------------

   type Descriptor is record
      Name     : Unbounded_String;
      Kind     : Descriptor_Kind := Term;
      Overload : Natural := 0;  --  For Method descriptors; 0 = no suffix
   end record;

   package Descriptor_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Descriptor);

   ---------------------------------------------------------------------------
   --  Symbol_Context — carries project-level info needed for symbol creation
   ---------------------------------------------------------------------------

   type Symbol_Context is record
      Manager      : Unbounded_String;  --  "alr" or "."
      Package_Name : Unbounded_String;  --  crate/project name
      Version      : Unbounded_String;  --  version string or "."
   end record;

   --  Convenience constructor
   function Make_Context
     (Manager      : String;
      Package_Name : String;
      Version      : String := ".") return Symbol_Context;

   ---------------------------------------------------------------------------
   --  Symbol string construction
   ---------------------------------------------------------------------------

   --  Build a SCIP symbol string from entity definition and context.
   --  Parents is the chain of enclosing scopes from outermost to innermost.
   function To_Symbol_String
     (Entity  : SCIP_Ada.ALI.Types.Entity_Def;
      Context : Symbol_Context;
      Parents : Descriptor_Vectors.Vector :=
        Descriptor_Vectors.Empty_Vector) return String;

   --  Build a local symbol string (file-scoped, not globally addressable).
   function To_Local_Symbol (Local_Id : Positive) return String;

   --  Determine the SCIP descriptor kind for an ALI entity kind.
   function Entity_To_Descriptor_Kind
     (Kind : SCIP_Ada.ALI.Types.Entity_Kind) return Descriptor_Kind;

   --  Format a single descriptor as its SCIP string suffix.
   function Format_Descriptor (D : Descriptor) return String;

   --  Build a complete symbol from context + descriptor chain.
   function Build_Symbol
     (Context     : Symbol_Context;
      Descriptors : Descriptor_Vectors.Vector) return String;

   ---------------------------------------------------------------------------
   --  Backward-compatible helper (kept for other modules)
   ---------------------------------------------------------------------------

   function Make_Symbol
     (Package_Name : String;
      Entity_Name  : String;
      Descriptor   : String := "") return String;

end SCIP_Ada.SCIP.Symbols;
