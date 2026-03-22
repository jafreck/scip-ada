--  SCIP_Ada.LAL.Enricher — stub (no libadalang)

with Ada.Strings.Unbounded;
with SCIP_Ada.LAL.Signatures;
with SCIP_Ada.LAL.Docs;
with SCIP_Ada.LAL.Relationships;
with SCIP_Ada.LAL.Kinds;

package SCIP_Ada.LAL.Enricher is

   use Ada.Strings.Unbounded;

   type Enrichment_Data is record
      Source_Path    : Unbounded_String;
      Sigs           : SCIP_Ada.LAL.Signatures.Signature_Vectors.Vector;
      Doc_Comments   : SCIP_Ada.LAL.Docs.Doc_Vectors.Vector;
      Rels           : SCIP_Ada.LAL.Relationships.Relationship_Vectors.Vector;
      Kind_Overrides : SCIP_Ada.LAL.Kinds.Kind_Override_Vectors.Vector;
   end record;

   function Enrich_File
     (Source_Path : String) return Enrichment_Data;

   function Is_Available return Boolean;

end SCIP_Ada.LAL.Enricher;
