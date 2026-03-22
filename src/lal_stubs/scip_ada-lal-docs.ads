--  SCIP_Ada.LAL.Docs — stub (no libadalang)

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Docs is

   use Ada.Strings.Unbounded;

   type Doc_Info is record
      Entity_Name : Unbounded_String;
      Line        : Positive;
      Doc_Comment : Unbounded_String;
   end record;

   package Doc_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Doc_Info);

   function Extract_Docs
     (Source_Path : String) return Doc_Vectors.Vector;

end SCIP_Ada.LAL.Docs;
