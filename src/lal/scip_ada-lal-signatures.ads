--  SCIP_Ada.LAL.Signatures — extract subprogram signatures from source
--
--  Given an Ada source file and a subprogram name/line, returns the
--  full signature string (parameter profile and return type).

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Signatures is

   use Ada.Strings.Unbounded;

   type Signature_Info is record
      Entity_Name    : Unbounded_String;
      Line           : Positive;
      Column         : Positive := 1;
      Full_Signature : Unbounded_String;
      --  e.g. "function Add (X, Y : Integer) return Integer"
   end record;

   package Signature_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Signature_Info);

   --  Extract all subprogram signatures from the given source file.
   function Extract_Signatures
     (Source_Path : String) return Signature_Vectors.Vector;

end SCIP_Ada.LAL.Signatures;
