--  SCIP_Ada.LAL.Signatures — stub (no libadalang)

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Signatures is

   use Ada.Strings.Unbounded;

   type Signature_Info is record
      Entity_Name    : Unbounded_String;
      Line           : Positive;
      Column         : Positive := 1;
      Full_Signature : Unbounded_String;
   end record;

   package Signature_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Signature_Info);

   function Extract_Signatures
     (Source_Path : String) return Signature_Vectors.Vector;

end SCIP_Ada.LAL.Signatures;
