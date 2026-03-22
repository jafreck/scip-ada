package body SCIP_Ada.LAL.Enricher is

   function Enrich_File
     (Source_Path : String) return Enrichment_Data
   is
   begin
      return
        (Source_Path    => To_Unbounded_String (Source_Path),
         Sigs           => Signatures.Extract_Signatures (Source_Path),
         Doc_Comments   => Docs.Extract_Docs (Source_Path),
         Rels           => Relationships.Extract_Relationships (Source_Path),
         Kind_Overrides => Kinds.Extract_Kind_Overrides (Source_Path));
   end Enrich_File;

   function Is_Available return Boolean is
   begin
      return True;
   end Is_Available;

end SCIP_Ada.LAL.Enricher;
