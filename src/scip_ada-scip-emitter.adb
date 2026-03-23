with Ada.Streams.Stream_IO;
with Ada.Strings.Fixed;
with Ada.Directories;
with Ada.Containers.Vectors;
with SCIP_Ada.SCIP.Protobuf;
with SCIP_Ada.SCIP.Mapping;

package body SCIP_Ada.SCIP.Emitter is

   use SCIP_Ada.ALI.Types;
   use SCIP_Ada.SCIP.Protobuf;
   use Ada.Strings.Unbounded;

   ---------------------------------------------------------------------------
   --  Enrichment_Map operations
   ---------------------------------------------------------------------------

   function Make_Key (File_Path : String; Line : Positive) return String is
      Line_Img : constant String :=
        Ada.Strings.Fixed.Trim (Positive'Image (Line),
                                Ada.Strings.Left);
   begin
      return File_Path & ":" & Line_Img;
   end Make_Key;

   function Empty_Enrichment return Enrichment_Map is
   begin
      return
        (Signatures             => Signature_Maps.Empty_Map,
         Doc_Comments            => Signature_Maps.Empty_Map,
         Relationships           =>
           Relationship_Entry_Vectors.Empty_Vector,
         Kind_Overrides          =>
           Kind_Override_Maps.Empty_Map,
         Display_Name_Overrides  =>
           Signature_Maps.Empty_Map,
         Pkg_Context            =>
           Symbols.Make_Context (".", ".", "."));
   end Empty_Enrichment;

   procedure Add_Signature
     (Map       : in out Enrichment_Map;
      File_Path : String;
      Line      : Positive;
      Sig       : String)
   is
      Key : constant String := Make_Key (File_Path, Line);
   begin
      if not Map.Signatures.Contains (Key) then
         Map.Signatures.Insert (Key, Sig);
      end if;
   end Add_Signature;

   function Lookup_Signature
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return String
   is
      Key : constant String := Make_Key (File_Path, Line);
      use Signature_Maps;
      C : constant Cursor := Map.Signatures.Find (Key);
   begin
      if C /= No_Element then
         return Element (C);
      end if;
      return "";
   end Lookup_Signature;

   procedure Add_Doc_Comment
     (Map       : in out Enrichment_Map;
      File_Path : String;
      Line      : Positive;
      Comment   : String)
   is
      Key : constant String := Make_Key (File_Path, Line);
   begin
      if not Map.Doc_Comments.Contains (Key) then
         Map.Doc_Comments.Insert (Key, Comment);
      end if;
   end Add_Doc_Comment;

   function Lookup_Doc_Comment
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return String
   is
      Key : constant String := Make_Key (File_Path, Line);
      use Signature_Maps;
      C : constant Cursor := Map.Doc_Comments.Find (Key);
   begin
      if C /= No_Element then
         return Element (C);
      end if;
      return "";
   end Lookup_Doc_Comment;

   procedure Add_Relationship
     (Map                : in out Enrichment_Map;
      File_Path          : String;
      Line               : Positive;
      Entity_Name        : String;
      Target_Symbol      : String;
      Is_Implementation  : Boolean;
      Is_Type_Definition : Boolean)
   is
      FP : constant Unbounded_String :=
        To_Unbounded_String (File_Path);
      EN : constant Unbounded_String :=
        To_Unbounded_String (Entity_Name);
      TS : constant Unbounded_String :=
        To_Unbounded_String (Target_Symbol);
   begin
      --  Check for duplicates before appending
      for Existing of Map.Relationships loop
         if Existing.File_Path = FP
           and then Existing.Line = Line
           and then Existing.Entity_Name = EN
           and then Existing.Target_Symbol = TS
         then
            return;  --  already recorded
         end if;
      end loop;
      Map.Relationships.Append
        (SCIP_Relationship_Entry'
           (File_Path          => FP,
            Line               => Line,
            Entity_Name        => EN,
            Target_Symbol      => TS,
            Is_Implementation  => Is_Implementation,
            Is_Type_Definition => Is_Type_Definition));
   end Add_Relationship;

   procedure Add_Kind_Override
     (Map       : in out Enrichment_Map;
      File_Path : String;
      Line      : Positive;
      Kind      : Natural)
   is
      Key : constant String := Make_Key (File_Path, Line);
   begin
      if not Map.Kind_Overrides.Contains (Key) then
         Map.Kind_Overrides.Insert (Key, Kind);
      end if;
   end Add_Kind_Override;

   function Lookup_Kind_Override
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return Integer
   is
      Key : constant String := Make_Key (File_Path, Line);
      use Kind_Override_Maps;
      C : constant Cursor := Map.Kind_Overrides.Find (Key);
   begin
      if C /= No_Element then
         return Integer (Element (C));
      end if;
      return -1;
   end Lookup_Kind_Override;

   procedure Add_Display_Name_Override
     (Map          : in out Enrichment_Map;
      File_Path    : String;
      Line         : Positive;
      Display_Name : String)
   is
      Key : constant String := Make_Key (File_Path, Line);
   begin
      if not Map.Display_Name_Overrides.Contains (Key) then
         Map.Display_Name_Overrides.Insert (Key, Display_Name);
      end if;
   end Add_Display_Name_Override;

   function Lookup_Display_Name_Override
     (Map       : Enrichment_Map;
      File_Path : String;
      Line      : Positive) return String
   is
      Key : constant String := Make_Key (File_Path, Line);
      use Signature_Maps;
      C : constant Cursor := Map.Display_Name_Overrides.Find (Key);
   begin
      if C /= No_Element then
         return Element (C);
      end if;
      return "";
   end Lookup_Display_Name_Override;

   ---------------------------------------------------------------------------
   --  Helpers for encoding SCIP protobuf messages
   ---------------------------------------------------------------------------

   function Encode_Tool_Info return Byte_Buffer is
      TI : Byte_Buffer;
   begin
      Encode_String_Field (TI, Tool_Info_Name_Field, "scip-ada");
      Encode_String_Field (TI, Tool_Info_Version_Field, SCIP_Ada.Version);
      return TI;
   end Encode_Tool_Info;

   function Encode_Metadata (Root : String) return Byte_Buffer is
      Meta : Byte_Buffer;
      TI   : constant Byte_Buffer := Encode_Tool_Info;
   begin
      Encode_Submessage_Field (Meta, Metadata_Tool_Info_Field, TI);
      Encode_String_Field (Meta, Metadata_Project_Root_Field, Root);
      Encode_Varint_Field (Meta, Metadata_Text_Encoding_Field, 1);  --  UTF8
      return Meta;
   end Encode_Metadata;

   function Encode_Occurrence
     (Line_1   : Positive;
      Col_1    : Positive;
      Name_Len : Natural;
      Symbol   : String;
      Role     : Natural) return Byte_Buffer
   is
      Occ : Byte_Buffer;
      --  Convert ALI 1-indexed to SCIP 0-indexed
      Rng : constant Integer_Array (1 .. 3) :=
        (Line_1 - 1, Col_1 - 1, Col_1 - 1 + Name_Len);
   begin
      Encode_Packed_Int32_Field (Occ, Occurrence_Range_Field, Rng);
      if Symbol'Length > 0 then
         Encode_String_Field (Occ, Occurrence_Symbol_Field, Symbol);
      end if;
      if Role > 0 then
         Encode_Varint_Field (Occ, Occurrence_Symbol_Roles_Field, Role);
      end if;
      return Occ;
   end Encode_Occurrence;

   function Encode_Signature_Documentation
     (Signature : String) return Byte_Buffer
   is
      Doc : Byte_Buffer;
   begin
      Encode_String_Field (Doc, Document_Language_Field, "ada");
      Encode_String_Field (Doc, Document_Text_Field, Signature);
      return Doc;
   end Encode_Signature_Documentation;

   function Encode_Symbol_Info
     (Symbol_Str    : String;
      Kind          : Mapping.SCIP_Symbol_Kind;
      Display_Name  : String;
      Signature     : String := "";
      Doc_Comment   : String := "";
      Kind_Override : Integer := -1;
      Display_Name_Override : String := "") return Byte_Buffer
   is
      SI : Byte_Buffer;
      Kind_Val : Natural;
      Actual_DN : constant String :=
        (if Display_Name_Override'Length > 0
         then Display_Name_Override
         else Display_Name);
   begin
      Encode_String_Field (SI, Symbol_Info_Symbol_Field, Symbol_Str);
      if Signature'Length > 0 then
         declare
            Sig_Doc : constant Byte_Buffer :=
              Encode_Signature_Documentation (Signature);
         begin
            Encode_Submessage_Field
              (SI,
               Symbol_Info_Signature_Documentation_Field,
               Sig_Doc);
         end;
      end if;
      if Doc_Comment'Length > 0 then
         --  Non-code documentation belongs in the documentation array.
         Encode_String_Field
           (SI, Symbol_Info_Documentation_Field, Doc_Comment);
      end if;
      if Kind_Override >= 0 then
         Kind_Val := Natural (Kind_Override);
      else
         Kind_Val := Mapping.Kind_Value (Kind);
      end if;
      Encode_Varint_Field
        (SI, Symbol_Info_Kind_Field, Kind_Val);
      if Actual_DN'Length > 0 then
         Encode_String_Field
           (SI, Symbol_Info_Display_Name_Field, Actual_DN);
      end if;
      return SI;
   end Encode_Symbol_Info;

   ---------------------------------------------------------------------------
   --  Emit — main entry point
   ---------------------------------------------------------------------------

   procedure Emit
     (ALI_Data     : SCIP_Ada.ALI.Types.ALI_File;
      Output_Path  : String;
      Project_Root : String)
   is
      Index_Buf : Byte_Buffer;
      Meta      : constant Byte_Buffer := Encode_Metadata (Project_Root);
      Ctx       : constant Symbols.Symbol_Context :=
        Symbols.Make_Context
          (Manager      => ".",
           Package_Name => ".",
           Version      => ".");
   begin
      --  Metadata
      Encode_Submessage_Field (Index_Buf, Index_Metadata_Field, Meta);

      --  One Document per source file
      for File_Idx in 1 .. Integer (ALI_Data.Files.Length) loop
         declare
            Doc         : Byte_Buffer;
            Has_Content : Boolean := False;
            Rel_Path    : constant String :=
              To_String (ALI_Data.Files.Element (File_Idx).Path);
         begin
            Encode_String_Field
              (Doc, Document_Relative_Path_Field, Rel_Path);
            Encode_String_Field
              (Doc, Document_Language_Field, "ada");

            --  Scan all sections/entities for occurrences in this file
            for Sec of ALI_Data.Sections loop
               for Entity of Sec.Entities loop
                  declare
                     Name    : constant String := To_String (Entity.Name);
                     Sym_Str : constant String :=
                       Symbols.To_Symbol_String (Entity, Ctx);
                     Kind    : constant Mapping.SCIP_Symbol_Kind :=
                       Mapping.To_SCIP_Kind (Entity.Kind);
                  begin
                     --  Definition occurrence
                     if Entity.File_Index = File_Idx then
                        declare
                           Occ : constant Byte_Buffer :=
                             Encode_Occurrence
                               (Entity.Line, Entity.Column,
                                Name'Length, Sym_Str,
                                Symbol_Role_Definition);
                        begin
                           Encode_Submessage_Field
                             (Doc, Document_Occurrences_Field, Occ);
                           Has_Content := True;
                        end;

                        --  SymbolInformation for this entity
                        declare
                           SI : constant Byte_Buffer :=
                             Encode_Symbol_Info (Sym_Str, Kind, Name);
                        begin
                           Encode_Submessage_Field
                             (Doc, Document_Symbols_Field, SI);
                        end;
                     end if;

                     --  Reference occurrences in this file
                     for Ref of Entity.References loop
                        if Ref.File_Index = File_Idx then
                           declare
                              Role : constant Natural :=
                                Mapping.To_SCIP_Role (Ref.Kind);
                              Occ  : constant Byte_Buffer :=
                                Encode_Occurrence
                                  (Ref.Line, Ref.Column,
                                   Name'Length, Sym_Str, Role);
                           begin
                              Encode_Submessage_Field
                                (Doc, Document_Occurrences_Field, Occ);
                              Has_Content := True;
                           end;
                        end if;
                     end loop;
                  end;
               end loop;
            end loop;

            if Has_Content then
               Encode_Submessage_Field
                 (Index_Buf, Index_Documents_Field, Doc);
            end if;
         end;
      end loop;

      --  Write protobuf binary to file
      declare
         use Ada.Streams.Stream_IO;
         F : File_Type;
      begin
         Create (F, Out_File, Output_Path);
         Write (F, Data (Index_Buf));
         Close (F);
      end;
   end Emit;

   ---------------------------------------------------------------------------
   --  Is_Project_File — check if a resolved relative path is a project file
   --
   --  After Resolve_Source_Path:
   --   - Project files get a project-relative path (e.g. "src/hello.ads")
   --     because they were found under a Source_Dir.
   --   - External files keep their bare ALI name (e.g. "ada.ads",
   --     "system.ads", "a-textio.ads") because they were not found.
   --
   --  Strategy: try to find the file relative to Project_Root.  If that
   --  fails (--ali-dir mode where root = obj/), fall back to checking
   --  whether the path contains a directory separator — resolved
   --  project files always do (e.g. "src/foo.ads") while bare runtime
   --  names never do (e.g. "a-textio.ads").
   ---------------------------------------------------------------------------

   function Is_Project_File
     (Rel_Path     : String;
      Project_Root : String) return Boolean
   is
      use Ada.Directories;
   begin
      if Rel_Path'Length = 0 then
         return False;
      end if;
      --  Absolute paths are never project-local
      if Rel_Path (Rel_Path'First) = '/' then
         return False;
      end if;

      --  Primary check: does the file exist under Project_Root?
      declare
         Root : constant String :=
           (if Project_Root'Length > 0
              and then Project_Root (Project_Root'Last) /= '/'
            then Project_Root & "/"
            else Project_Root);
         Full : constant String := Root & Rel_Path;
      begin
         if Exists (Full) then
            return True;
         end if;
      exception
         when others => null;
      end;

      --  Fallback: resolved project files always contain '/' because
      --  Resolve_Source_Path prepends the source-dir subdirectory
      --  (e.g. "src/foo.ads").  Bare runtime names (e.g. "ada.ads",
      --  "a-textio.ads") never contain a separator.
      for I in Rel_Path'Range loop
         if Rel_Path (I) = '/' then
            return True;
         end if;
      end loop;

      return False;
   end Is_Project_File;

   ---------------------------------------------------------------------------
   --  Encode_ALI_Documents — encode Document submessages for one ALI file
   ---------------------------------------------------------------------------

   procedure Encode_ALI_Documents
     (Index_Buf    : in out Byte_Buffer;
      ALI_Data     : SCIP_Ada.ALI.Types.ALI_File;
      Project_Root : String;
      Enrichment   : Enrichment_Map)
   is
      pragma Unreferenced (Project_Root);
      Ctx : constant Symbols.Symbol_Context := Enrichment.Pkg_Context;
   begin
      for File_Idx in 1 .. Integer (ALI_Data.Files.Length) loop
         declare
            Doc         : Byte_Buffer;
            Has_Content : Boolean := False;
            Rel_Path    : constant String :=
              To_String (ALI_Data.Files.Element (File_Idx).Path);
         begin
            Encode_String_Field
              (Doc, Document_Relative_Path_Field, Rel_Path);
            Encode_String_Field
              (Doc, Document_Language_Field, "ada");

            for Sec of ALI_Data.Sections loop
               for Entity of Sec.Entities loop
                  declare
                     Name    : constant String := To_String (Entity.Name);
                     Sym_Str : constant String :=
                       Symbols.To_Symbol_String (Entity, Ctx);
                     Kind    : constant Mapping.SCIP_Symbol_Kind :=
                       Mapping.To_SCIP_Kind (Entity.Kind);
                  begin
                     if Entity.File_Index = File_Idx then
                        declare
                           Occ : constant Byte_Buffer :=
                             Encode_Occurrence
                               (Entity.Line, Entity.Column,
                                Name'Length, Sym_Str,
                                Symbol_Role_Definition);
                        begin
                           Encode_Submessage_Field
                             (Doc, Document_Occurrences_Field, Occ);
                           Has_Content := True;
                        end;

                        --  Look up enrichment data for this entity
                        declare
                           Sig : constant String :=
                             Lookup_Signature
                               (Enrichment, Rel_Path, Entity.Line);
                           Doc_Cmt : constant String :=
                             Lookup_Doc_Comment
                               (Enrichment, Rel_Path, Entity.Line);
                           KO : constant Integer :=
                             Lookup_Kind_Override
                               (Enrichment, Rel_Path, Entity.Line);
                           DN_Ovr : constant String :=
                             Lookup_Display_Name_Override
                               (Enrichment, Rel_Path, Entity.Line);
                           SI  : Byte_Buffer :=
                             Encode_Symbol_Info
                               (Sym_Str, Kind, Name, Sig, Doc_Cmt,
                                Kind_Override         => KO,
                                Display_Name_Override => DN_Ovr);
                        begin
                           --  Append relationships for this entity
                           for Rel of Enrichment.Relationships loop
                              if To_String (Rel.File_Path) = Rel_Path
                                and then Rel.Line = Entity.Line
                                and then To_String (Rel.Entity_Name) = Name
                              then
                                 declare
                                    Rel_Buf : Byte_Buffer;
                                 begin
                                    Encode_String_Field
                                      (Rel_Buf,
                                       Relationship_Symbol_Field,
                                       To_String (Rel.Target_Symbol));
                                    if Rel.Is_Implementation then
                                       Encode_Varint_Field
                                         (Rel_Buf,
                                          Relationship_Is_Implementation_Field,
                                          1);
                                    end if;
                                    if Rel.Is_Type_Definition then
                                       Encode_Varint_Field
                                         (Rel_Buf,
                                          Relationship_Is_Type_Definition_Field,
                                          1);
                                    end if;
                                    Encode_Submessage_Field
                                      (SI,
                                       Symbol_Info_Relationships_Field,
                                       Rel_Buf);
                                 end;
                              end if;
                           end loop;
                           Encode_Submessage_Field
                             (Doc, Document_Symbols_Field, SI);
                        end;
                     end if;

                     for Ref of Entity.References loop
                        if Ref.File_Index = File_Idx then
                           declare
                              Role : constant Natural :=
                                Mapping.To_SCIP_Role (Ref.Kind);
                              Occ  : constant Byte_Buffer :=
                                Encode_Occurrence
                                  (Ref.Line, Ref.Column,
                                   Name'Length, Sym_Str, Role);
                           begin
                              Encode_Submessage_Field
                                (Doc, Document_Occurrences_Field, Occ);
                              Has_Content := True;
                           end;
                        end if;
                     end loop;
                  end;
               end loop;
            end loop;

            if Has_Content then
               Encode_Submessage_Field
                 (Index_Buf, Index_Documents_Field, Doc);
            end if;
         end;
      end loop;
   end Encode_ALI_Documents;

   ---------------------------------------------------------------------------
   --  Emit_Index — emit a combined SCIP index from multiple ALI files
   ---------------------------------------------------------------------------

   procedure Emit_Index
     (ALI_Files    : ALI_File_Array;
      Output_Path  : String;
      Project_Root : String)
   is
   begin
      Emit_Index (ALI_Files, Output_Path, Project_Root, Empty_Enrichment);
   end Emit_Index;

   procedure Emit_Index
     (ALI_Files    : ALI_File_Array;
      Output_Path  : String;
      Project_Root : String;
      Enrichment   : Enrichment_Map)
   is
      Index_Buf : Byte_Buffer;
      Meta      : constant Byte_Buffer := Encode_Metadata (Project_Root);
   begin
      Encode_Submessage_Field (Index_Buf, Index_Metadata_Field, Meta);

      for ALI_Data of ALI_Files loop
         Encode_ALI_Documents (Index_Buf, ALI_Data, Project_Root, Enrichment);
      end loop;

      declare
         use Ada.Streams.Stream_IO;
         F : File_Type;
      begin
         Create (F, Out_File, Output_Path);
         Write (F, Data (Index_Buf));
         Close (F);
      end;
   end Emit_Index;

   ---------------------------------------------------------------------------
   --  Emit_Index with source-dir filtering
   --
   --  Only files that exist under Source_Dirs (relative to Project_Root)
   --  produce Document entries.  Definitions in external files (GNAT
   --  runtime, dependency libraries) go to Index.external_symbols.
   --  Documents are deduplicated: if multiple ALI files reference the
   --  same source file, only one Document is emitted containing the
   --  union of all occurrences.
   ---------------------------------------------------------------------------

   procedure Emit_Index
     (ALI_Files    : ALI_File_Array;
      Output_Path  : String;
      Project_Root : String;
      Enrichment   : Enrichment_Map;
      Source_Dirs  : SCIP_Ada.Project.String_Vectors.Vector)
   is
      pragma Unreferenced (Source_Dirs);

      Index_Buf : Byte_Buffer;
      Meta      : constant Byte_Buffer :=
        Encode_Metadata (Project_Root);

      --  Deduplication maps (persisted across all ALI files).
      Seen_Docs     : Signature_Maps.Map;
      Seen_External : Signature_Maps.Map;

      Ctx : constant Symbols.Symbol_Context := Enrichment.Pkg_Context;

      --  Return the resolved relative path for file index FI
      --  inside ALI file A, or "" if FI is out of range.
      function File_Path_For
        (A  : SCIP_Ada.ALI.Types.ALI_File;
         FI : Natural) return String
      is
      begin
         if FI in 1 .. Natural (A.Files.Length) then
            return To_String (A.Files.Element (FI).Path);
         end if;
         return "";
      end File_Path_For;

      --  Encode relationships attached to an entity into a
      --  SymbolInformation buffer.
      procedure Append_Relationships
        (SI        : in out Byte_Buffer;
         Rel_Path  : String;
         Line      : Positive;
         Name      : String)
      is
      begin
         for R of Enrichment.Relationships loop
            if To_String (R.File_Path) = Rel_Path
              and then R.Line = Line
              and then To_String (R.Entity_Name) = Name
            then
               declare
                  RB : Byte_Buffer;
               begin
                  Encode_String_Field
                    (RB, Relationship_Symbol_Field,
                     To_String (R.Target_Symbol));
                  if R.Is_Implementation then
                     Encode_Varint_Field
                       (RB,
                        Relationship_Is_Implementation_Field,
                        1);
                  end if;
                  if R.Is_Type_Definition then
                     Encode_Varint_Field
                       (RB,
                        Relationship_Is_Type_Definition_Field,
                        1);
                  end if;
                  Encode_Submessage_Field
                    (SI,
                     Symbol_Info_Relationships_Field,
                     RB);
               end;
            end if;
         end loop;
      end Append_Relationships;

      --  Build the Document for Rel_Path by scanning ALL
      --  ALI files for definitions and references that land
      --  in that file.  Deduplicates via Seen_Occ.
      procedure Build_Document (Rel_Path : String) is
         Doc         : Byte_Buffer;
         Has_Content : Boolean := False;
         Seen_Occ    : Signature_Maps.Map;
      begin
         Encode_String_Field
           (Doc, Document_Relative_Path_Field, Rel_Path);
         Encode_String_Field
           (Doc, Document_Language_Field, "ada");

         for A of ALI_Files loop
            for Sec of A.Sections loop
               for Entity of Sec.Entities loop
                  declare
                     EP   : constant String :=
                       File_Path_For (A, Entity.File_Index);
                     Name : constant String :=
                       To_String (Entity.Name);
                     Sym  : constant String :=
                       Symbols.To_Symbol_String (Entity, Ctx);
                     Kind : constant Mapping.SCIP_Symbol_Kind :=
                       Mapping.To_SCIP_Kind (Entity.Kind);
                  begin
                     --  Definition in this document
                     if EP = Rel_Path then
                        declare
                           Def_Key : constant String :=
                             "D:" & Sym;
                        begin
                           if not Seen_Occ.Contains (Def_Key) then
                              Seen_Occ.Insert (Def_Key, "");

                              --  Definition occurrence
                              declare
                                 Occ : constant Byte_Buffer :=
                                   Encode_Occurrence
                                     (Entity.Line,
                                      Entity.Column,
                                      Name'Length, Sym,
                                      Symbol_Role_Definition);
                              begin
                                 Encode_Submessage_Field
                                   (Doc,
                                    Document_Occurrences_Field,
                                    Occ);
                                 Has_Content := True;
                              end;

                              --  SymbolInformation w/ enrichment
                              declare
                                 Sig : constant String :=
                                   Lookup_Signature
                                     (Enrichment, Rel_Path,
                                      Entity.Line);
                                 DC : constant String :=
                                   Lookup_Doc_Comment
                                     (Enrichment, Rel_Path,
                                      Entity.Line);
                                 KO : constant Integer :=
                                   Lookup_Kind_Override
                                     (Enrichment, Rel_Path,
                                      Entity.Line);
                                 DN : constant String :=
                                   Lookup_Display_Name_Override
                                     (Enrichment, Rel_Path,
                                      Entity.Line);
                                 SI : Byte_Buffer :=
                                   Encode_Symbol_Info
                                     (Sym, Kind, Name,
                                      Sig, DC, KO, DN);
                              begin
                                 Append_Relationships
                                   (SI, Rel_Path,
                                    Entity.Line, Name);
                                 Encode_Submessage_Field
                                   (Doc,
                                    Document_Symbols_Field,
                                    SI);
                              end;
                           end if;
                        end;
                     end if;

                     --  References in this document
                     for Ref of Entity.References loop
                        declare
                           RP : constant String :=
                             File_Path_For
                               (A, Ref.File_Index);
                        begin
                           if RP = Rel_Path then
                              declare
                                 Ref_Key : constant String :=
                                   "R:" & Sym & ":"
                                   & Positive'Image (Ref.Line)
                                   & ":"
                                   & Positive'Image (Ref.Column);
                              begin
                                 if not Seen_Occ.Contains
                                          (Ref_Key)
                                 then
                                    Seen_Occ.Insert (Ref_Key, "");
                                    declare
                                       Role : constant Natural :=
                                         Mapping.To_SCIP_Role
                                           (Ref.Kind);
                                       Occ : constant Byte_Buffer :=
                                         Encode_Occurrence
                                           (Ref.Line, Ref.Column,
                                            Name'Length, Sym,
                                            Role);
                                    begin
                                       Encode_Submessage_Field
                                         (Doc,
                                          Document_Occurrences_Field,
                                          Occ);
                                       Has_Content := True;
                                    end;
                                 end if;
                              end;
                           end if;
                        end;
                     end loop;
                  end;
               end loop;
            end loop;
         end loop;

         if Has_Content then
            Encode_Submessage_Field
              (Index_Buf, Index_Documents_Field, Doc);
         end if;
      end Build_Document;

   begin
      Encode_Submessage_Field
        (Index_Buf, Index_Metadata_Field, Meta);

      --  Pass 1: collect all unique project-local file paths, then sort
      --  and emit for deterministic output ordering.
      declare
         Sorted_Docs : SCIP_Ada.Project.String_Vectors.Vector;
      begin
         for ALI_Data of ALI_Files loop
            for F_Idx in 1 .. Natural (ALI_Data.Files.Length) loop
               declare
                  Rel_Path : constant String :=
                    To_String (ALI_Data.Files.Element (F_Idx).Path);
               begin
                  if Is_Project_File (Rel_Path, Project_Root)
                    and then not Seen_Docs.Contains (Rel_Path)
                  then
                     Seen_Docs.Insert (Rel_Path, "");
                     Sorted_Docs.Append
                       (To_Unbounded_String (Rel_Path));
                  end if;
               end;
            end loop;
         end loop;

         declare
            package Doc_Sort is new
              SCIP_Ada.Project.String_Vectors.Generic_Sorting ("<");
         begin
            Doc_Sort.Sort (Sorted_Docs);
         end;

         for Doc_Path of Sorted_Docs loop
            Build_Document (To_String (Doc_Path));
         end loop;
      end;

      --  Pass 2: collect external symbols (definitions in
      --  non-project files).  Collect first, sort by symbol string,
      --  then emit for deterministic output ordering.
      declare
         type Ext_Entry is record
            Sym  : Unbounded_String;
            Name : Unbounded_String;
            Kind : Mapping.SCIP_Symbol_Kind;
         end record;
         package Ext_Vectors is new Ada.Containers.Vectors
           (Positive, Ext_Entry);
         function "<" (L, R : Ext_Entry) return Boolean is
           (L.Sym < R.Sym);
         package Ext_Sort is new Ext_Vectors.Generic_Sorting ("<");
         Ext_Syms : Ext_Vectors.Vector;
      begin
         for ALI_Data of ALI_Files loop
            for Sec of ALI_Data.Sections loop
               for Entity of Sec.Entities loop
                  declare
                     EP : constant String :=
                       File_Path_For (ALI_Data, Entity.File_Index);
                  begin
                     if EP'Length > 0
                       and then not Is_Project_File
                                      (EP, Project_Root)
                     then
                        declare
                           Sym : constant String :=
                             Symbols.To_Symbol_String
                               (Entity, Ctx);
                        begin
                           if not Seen_External.Contains (Sym)
                           then
                              Seen_External.Insert (Sym, "");
                              Ext_Syms.Append
                                ((Sym  =>
                                    To_Unbounded_String (Sym),
                                  Name =>
                                    Entity.Name,
                                  Kind =>
                                    Mapping.To_SCIP_Kind
                                      (Entity.Kind)));
                           end if;
                        end;
                     end if;
                  end;
               end loop;
            end loop;
         end loop;

         Ext_Sort.Sort (Ext_Syms);

         for E of Ext_Syms loop
            declare
               SI : constant Byte_Buffer :=
                 Encode_Symbol_Info
                   (To_String (E.Sym),
                    E.Kind,
                    To_String (E.Name));
            begin
               Encode_Submessage_Field
                 (Index_Buf,
                  Index_External_Symbols_Field,
                  SI);
            end;
         end loop;
      end;

      --  Write protobuf binary to file
      declare
         use Ada.Streams.Stream_IO;
         F : File_Type;
      begin
         Create (F, Out_File, Output_Path);
         Write (F, Data (Index_Buf));
         Close (F);
      end;
   end Emit_Index;

end SCIP_Ada.SCIP.Emitter;
