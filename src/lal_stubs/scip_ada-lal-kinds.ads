--  SCIP_Ada.LAL.Kinds — stub (no libadalang)

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Kinds is

   use Ada.Strings.Unbounded;

   type Kind_Override_Info is record
      Entity_Name  : Unbounded_String;
      Line         : Positive;
      Kind_Value   : Natural;
      Display_Name : Unbounded_String;
   end record;

   package Kind_Override_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Kind_Override_Info);

   function Extract_Kind_Overrides
     (Source_Path : String) return Kind_Override_Vectors.Vector;

end SCIP_Ada.LAL.Kinds;
