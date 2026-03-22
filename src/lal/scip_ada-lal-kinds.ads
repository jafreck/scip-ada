--  SCIP_Ada.LAL.Kinds — extract fine-grained symbol kinds from source
--
--  Uses libadalang AST to identify type definitions that need more
--  specific SCIP SymbolInformation.Kind values than ALI can provide:
--    Interface types   → Interface (21)
--    Abstract types    → Class (7) with "abstract" display name
--    Access types      → Type (54)
--    Discriminated     → Struct (49) or Class (7)

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Kinds is

   use Ada.Strings.Unbounded;

   type Kind_Override_Info is record
      Entity_Name  : Unbounded_String;
      Line         : Positive;
      Kind_Value   : Natural;         --  SCIP kind integer value
      Display_Name : Unbounded_String; --  Override display name
   end record;

   package Kind_Override_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Kind_Override_Info);

   --  Extract kind overrides for type declarations in the source.
   function Extract_Kind_Overrides
     (Source_Path : String) return Kind_Override_Vectors.Vector;

end SCIP_Ada.LAL.Kinds;
