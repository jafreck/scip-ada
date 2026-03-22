--  SCIP_Ada.LAL.Docs — extract documentation comments from source
--
--  Given an Ada source file, extracts leading comments for declarations
--  (the Ada equivalent of doc-comments).

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Docs is

   use Ada.Strings.Unbounded;

   type Doc_Info is record
      Entity_Name : Unbounded_String;
      Line        : Positive;
      Doc_Comment : Unbounded_String;  --  concatenated comment text
   end record;

   package Doc_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Doc_Info);

   --  Extract documentation comments for all declarations in the source.
   function Extract_Docs
     (Source_Path : String) return Doc_Vectors.Vector;

end SCIP_Ada.LAL.Docs;
