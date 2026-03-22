--  SCIP_Ada.LAL.Enricher — main enrichment pass
--
--  Coordinates the LAL enrichment by running signatures, docs, and
--  relationships extraction on each source file discovered by the
--  project, then merging results back into the SCIP index data.

with Ada.Strings.Unbounded;
with SCIP_Ada.LAL.Signatures;
with SCIP_Ada.LAL.Docs;
with SCIP_Ada.LAL.Relationships;
with SCIP_Ada.LAL.Kinds;

package SCIP_Ada.LAL.Enricher is

   use Ada.Strings.Unbounded;

   --  Information extracted for a single source file.
   type Enrichment_Data is record
      Source_Path    : Unbounded_String;
      Sigs           : SCIP_Ada.LAL.Signatures.Signature_Vectors.Vector;
      Doc_Comments   : SCIP_Ada.LAL.Docs.Doc_Vectors.Vector;
      Rels           : SCIP_Ada.LAL.Relationships.Relationship_Vectors.Vector;
      Kind_Overrides : SCIP_Ada.LAL.Kinds.Kind_Override_Vectors.Vector;
   end record;

   --  Enrich a single source file.  Returns the extracted data.
   function Enrich_File
     (Source_Path : String) return Enrichment_Data;

   --  Returns True if the enrichment subsystem is available (i.e.,
   --  built with ENRICH=yes and libadalang is operational).
   function Is_Available return Boolean;

end SCIP_Ada.LAL.Enricher;
