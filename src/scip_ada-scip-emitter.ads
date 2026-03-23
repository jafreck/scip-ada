--  SCIP_Ada.SCIP.Emitter — SCIP protobuf writer
--
--  Takes parsed ALI data and emits SCIP-format index output.

with Ada.Strings.Unbounded;
with Ada.Containers.Indefinite_Hashed_Maps;
with Ada.Containers.Vectors;
with Ada.Strings.Hash;
with SCIP_Ada.ALI.Types;
with SCIP_Ada.Project;
with SCIP_Ada.SCIP.Symbols;

package SCIP_Ada.SCIP.Emitter is

   --  Emit an SCIP index for a single ALI file to the specified output path.
   procedure Emit
     (ALI_Data    : SCIP_Ada.ALI.Types.ALI_File;
      Output_Path : String;
      Project_Root : String);

   --  Array of parsed ALI files for batch emission
   type ALI_File_Array is
     array (Positive range <>) of SCIP_Ada.ALI.Types.ALI_File;

   ---------------------------------------------------------------------------
   --  Enrichment_Map — maps (file, line) to a signature string
   --  Key format: "file_path:line_number"
   ---------------------------------------------------------------------------

   package Signature_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => String,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   ---------------------------------------------------------------------------
   --  Relationship entries for the enrichment map
   ---------------------------------------------------------------------------

   type SCIP_Relationship_Entry is record
      File_Path          : Ada.Strings.Unbounded.Unbounded_String;
      Line               : Positive;
      Entity_Name        : Ada.Strings.Unbounded.Unbounded_String;
      Target_Symbol      : Ada.Strings.Unbounded.Unbounded_String;
      Is_Implementation  : Boolean;
      Is_Type_Definition : Boolean;
   end record;

   package Relationship_Entry_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => SCIP_Relationship_Entry);

   ---------------------------------------------------------------------------
   --  Kind override maps — maps (file, line) to a SCIP kind integer value
   ---------------------------------------------------------------------------

   package Kind_Override_Maps is new Ada.Containers.Indefinite_Hashed_Maps
     (Key_Type        => String,
      Element_Type    => Natural,
      Hash            => Ada.Strings.Hash,
      Equivalent_Keys => "=");

   type Enrichment_Map is tagged record
      Signatures             : Signature_Maps.Map;
      Doc_Comments            : Signature_Maps.Map;
      Relationships           : Relationship_Entry_Vectors.Vector;
      Kind_Overrides          : Kind_Override_Maps.Map;
      Display_Name_Overrides  : Signature_Maps.Map;
      Pkg_Context            : SCIP_Ada.SCIP.Symbols.Symbol_Context;
   end record;

   function Empty_Enrichment return Enrichment_Map;

   procedure Add_Signature
     (Map       : in out Enrichment_Map;
      File_Path : String;
      Line      : Positive;
      Sig       : String);

   function Lookup_Signature
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return String;
   --  Returns "" if no signature found.

   procedure Add_Doc_Comment
     (Map       : in out Enrichment_Map;
      File_Path : String;
      Line      : Positive;
      Comment   : String);

   function Lookup_Doc_Comment
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return String;
   --  Returns "" if no doc comment found.

   procedure Add_Relationship
     (Map                : in out Enrichment_Map;
      File_Path          : String;
      Line               : Positive;
      Entity_Name        : String;
      Target_Symbol      : String;
      Is_Implementation  : Boolean;
      Is_Type_Definition : Boolean);

   procedure Add_Kind_Override
     (Map       : in out Enrichment_Map;
      File_Path : String;
      Line      : Positive;
      Kind      : Natural);

   function Lookup_Kind_Override
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return Integer;
   --  Returns -1 if no override found.

   procedure Add_Display_Name_Override
     (Map          : in out Enrichment_Map;
      File_Path    : String;
      Line         : Positive;
      Display_Name : String);

   function Lookup_Display_Name_Override
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return String;
   --  Returns "" if no override found.

   --  Emit a combined SCIP index from multiple parsed ALI files.
   procedure Emit_Index
     (ALI_Files    : ALI_File_Array;
      Output_Path  : String;
      Project_Root : String);

   --  Emit a combined SCIP index with enrichment data.
   procedure Emit_Index
     (ALI_Files    : ALI_File_Array;
      Output_Path  : String;
      Project_Root : String;
      Enrichment   : Enrichment_Map);

   --  Emit a combined SCIP index with enrichment data and source-dir
   --  filtering.  Only files whose resolved path is under one of
   --  Source_Dirs (relative to Project_Root) produce Document entries;
   --  definitions in other files go to Index.external_symbols instead.
   procedure Emit_Index
     (ALI_Files    : ALI_File_Array;
      Output_Path  : String;
      Project_Root : String;
      Enrichment   : Enrichment_Map;
      Source_Dirs  : SCIP_Ada.Project.String_Vectors.Vector);

end SCIP_Ada.SCIP.Emitter;
