with Ada.Strings.Unbounded;

package body SCIP_Ada.LAL.Enricher is

   use Ada.Strings.Unbounded;

   function Enrich_File
     (Source_Path : String) return Enrichment_Data
   is
   begin
      return
        (Source_Path    => To_Unbounded_String (Source_Path),
         Sigs           => Signatures.Signature_Vectors.Empty_Vector,
         Doc_Comments   => Docs.Doc_Vectors.Empty_Vector,
         Rels           => Relationships.Relationship_Vectors.Empty_Vector,
         Kind_Overrides => Kinds.Kind_Override_Vectors.Empty_Vector);
   end Enrich_File;

   function Is_Available return Boolean is
   begin
      return False;
   end Is_Available;

end SCIP_Ada.LAL.Enricher;
