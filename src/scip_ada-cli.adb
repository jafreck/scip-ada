with Ada.Text_IO;
with Ada.Command_Line;
with Ada.Strings.Unbounded;
with Ada.Strings.Fixed;
with Ada.Directories;
with Ada.Exceptions;
with SCIP_Ada.Project;
with SCIP_Ada.ALI.Parser;
with SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Emitter;
with SCIP_Ada.SCIP.Symbols;
with SCIP_Ada.LAL.Enricher;
with SCIP_Ada.LAL.Relationships;

package body SCIP_Ada.CLI is

   use Ada.Text_IO;
   use Ada.Command_Line;
   use Ada.Strings.Unbounded;

   Run_Success : Boolean := True;

   type Verbosity_Level is (Quiet, Normal, Verbose);

   package Exclude_Vectors renames SCIP_Ada.Project.String_Vectors;

   ---------------------------------------------------------------------------
   --  Logging helpers — write to Standard_Error
   ---------------------------------------------------------------------------

   procedure Log_Error (Msg : String) is
   begin
      Put_Line (Standard_Error, "error: " & Msg);
   end Log_Error;

   procedure Log_Info (Level : Verbosity_Level; Msg : String) is
   begin
      if Level >= Normal then
         Put_Line (Standard_Error, Msg);
      end if;
   end Log_Info;

   procedure Log_Verbose (Level : Verbosity_Level; Msg : String) is
   begin
      if Level = Verbose then
         Put_Line (Standard_Error, Msg);
      end if;
   end Log_Verbose;

   ---------------------------------------------------------------------------
   --  Usage text
   ---------------------------------------------------------------------------

   procedure Print_Usage is
   begin
      Put_Line ("Usage: scip_ada <command> [OPTIONS]");
      New_Line;
      Put_Line ("SCIP indexer for Ada/SPARK projects (v" &
                SCIP_Ada.Version & ")");
      New_Line;
      Put_Line ("Commands:");
      Put_Line ("  index    Index an Ada project and produce index.scip");
      Put_Line ("  version  Print version information");
      New_Line;
      Put_Line ("Run 'scip_ada <command> --help' for command-specific help.");
   end Print_Usage;

   procedure Print_Index_Usage is
   begin
      Put_Line ("Usage: scip_ada index [OPTIONS]");
      New_Line;
      Put_Line ("Index an Ada project and produce a SCIP index file.");
      New_Line;
      Put_Line ("Options:");
      Put_Line ("  --project, -p <file.gpr>  " &
                "GPR project file to index");
      Put_Line ("  --ali-dir, -d <path>      " &
                "Directory containing .ali files");
      Put_Line ("  --output, -o <path>       " &
                "Output file (default: index.scip)");
      Put_Line ("  --verbose                 " &
                "Show detailed progress information");
      Put_Line ("  --quiet, -q               " &
                "Suppress all output except errors");
      Put_Line ("  --exclude <pattern>       " &
                "Exclude files matching pattern (repeatable)");
      Put_Line ("  --no-enrich               " &
                "Skip libadalang enrichment pass");
      Put_Line ("  --package-manager <name>  " &
                "Package manager (e.g., alire, gpr)");
      Put_Line ("  --package-name <name>     " &
                "Package/crate name (default: GPR project name)");
      Put_Line ("  --package-version <ver>   " &
                "Package version (default: 0.0.0)");
      Put_Line ("  --help, -h                " &
                "Show this help message");
      New_Line;
      Put_Line ("Either --project or --ali-dir must be specified.");
   end Print_Index_Usage;

   procedure Print_Version is
   begin
      Put_Line ("scip_ada " & SCIP_Ada.Version);
   end Print_Version;

   ---------------------------------------------------------------------------
   --  Exclude pattern matching
   ---------------------------------------------------------------------------

   function Is_Excluded
     (Path     : String;
      Excludes : Exclude_Vectors.Vector) return Boolean
   is
      use Ada.Strings.Fixed;
   begin
      for Pattern of Excludes loop
         if Index (Path, To_String (Pattern)) > 0 then
            return True;
         end if;
      end loop;
      return False;
   end Is_Excluded;

   ---------------------------------------------------------------------------
   --  Index subcommand
   ---------------------------------------------------------------------------

   procedure Run_Index is
      Project_Path : Unbounded_String := Null_Unbounded_String;
      ALI_Dir_Path : Unbounded_String := Null_Unbounded_String;
      Output_Path  : Unbounded_String := To_Unbounded_String ("index.scip");
      Level        : Verbosity_Level := Normal;
      Excludes     : Exclude_Vectors.Vector;
      Do_Enrich    : Boolean := SCIP_Ada.LAL.Enricher.Is_Available;
      Pkg_Manager  : Unbounded_String := Null_Unbounded_String;
      Pkg_Name     : Unbounded_String := Null_Unbounded_String;
      Pkg_Version  : Unbounded_String := Null_Unbounded_String;

      I : Positive := 2;  --  skip "index" subcommand
   begin
      --  Parse arguments
      while I <= Argument_Count loop
         declare
            Arg : constant String := Argument (I);
         begin
            if Arg = "--help" or else Arg = "-h" then
               Print_Index_Usage;
               return;

            elsif Arg = "--project" or else Arg = "-p" then
               if I = Argument_Count then
                  Log_Error ("--project requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               Project_Path := To_Unbounded_String (Argument (I));

            elsif Arg = "--ali-dir" or else Arg = "-d" then
               if I = Argument_Count then
                  Log_Error ("--ali-dir requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               ALI_Dir_Path := To_Unbounded_String (Argument (I));

            elsif Arg = "--output" or else Arg = "-o" then
               if I = Argument_Count then
                  Log_Error ("--output requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               Output_Path := To_Unbounded_String (Argument (I));

            elsif Arg = "--verbose" then
               Level := Verbose;

            elsif Arg = "--quiet" or else Arg = "-q" then
               Level := Quiet;

            elsif Arg = "--exclude" then
               if I = Argument_Count then
                  Log_Error ("--exclude requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               Excludes.Append (To_Unbounded_String (Argument (I)));

            elsif Arg = "--enrich" then
               Do_Enrich := True;

            elsif Arg = "--no-enrich" then
               Do_Enrich := False;

            elsif Arg = "--package-manager" then
               if I = Argument_Count then
                  Log_Error ("--package-manager requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               Pkg_Manager := To_Unbounded_String (Argument (I));

            elsif Arg = "--package-name" then
               if I = Argument_Count then
                  Log_Error ("--package-name requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               Pkg_Name := To_Unbounded_String (Argument (I));

            elsif Arg = "--package-version" then
               if I = Argument_Count then
                  Log_Error ("--package-version requires an argument");
                  Run_Success := False;
                  return;
               end if;
               I := I + 1;
               Pkg_Version := To_Unbounded_String (Argument (I));

            else
               Log_Error ("unknown option: " & Arg);
               Run_Success := False;
               return;
            end if;
         end;
         I := I + 1;
      end loop;

      --  Validate: need exactly one of --project or --ali-dir
      if Project_Path = Null_Unbounded_String
        and then ALI_Dir_Path = Null_Unbounded_String
      then
         Log_Error ("either --project or --ali-dir must be specified");
         New_Line (Standard_Error);
         Print_Index_Usage;
         Run_Success := False;
         return;
      end if;

      if Project_Path /= Null_Unbounded_String
        and then ALI_Dir_Path /= Null_Unbounded_String
      then
         Log_Error ("--project and --ali-dir are mutually exclusive");
         Run_Success := False;
         return;
      end if;

      --  Discover project
      declare
         Info : SCIP_Ada.Project.Project_Info;
      begin
         if Project_Path /= Null_Unbounded_String then
            declare
               GPR : constant String := To_String (Project_Path);
            begin
               if not Ada.Directories.Exists (GPR) then
                  Log_Error ("project file not found: " & GPR);
                  Run_Success := False;
                  return;
               end if;
               Log_Verbose (Level, "Discovering project from: " & GPR);
               Info := SCIP_Ada.Project.Discover_From_GPR (GPR);
            end;
         else
            declare
               Dir : constant String := To_String (ALI_Dir_Path);
            begin
               if not Ada.Directories.Exists (Dir) then
                  Log_Error ("directory not found: " & Dir);
                  Run_Success := False;
                  return;
               end if;
               Log_Verbose (Level, "Discovering ALI files in: " & Dir);
               Info := SCIP_Ada.Project.Discover_From_Directory (Dir);
            end;
         end if;

         Log_Verbose (Level, "Project: " & To_String (Info.Project_Name));
         Log_Verbose (Level, "Found" &
                      Natural'Image (Natural (Info.ALI_Files.Length)) &
                      " ALI file(s)");

         if Info.ALI_Files.Is_Empty then
            Log_Error ("no .ali files found");
            Run_Success := False;
            return;
         end if;

         --  Default package identity from project.
         --  Prefer alire.toml metadata when available; fall back to
         --  the GPR project name.
         if Pkg_Name = Null_Unbounded_String
           and then Info.Alire_Name /= Null_Unbounded_String
         then
            Pkg_Name := Info.Alire_Name;
            if Pkg_Manager = Null_Unbounded_String then
               Pkg_Manager := To_Unbounded_String ("alire");
            end if;
            if Pkg_Version = Null_Unbounded_String
              and then Info.Alire_Version /= Null_Unbounded_String
            then
               Pkg_Version := Info.Alire_Version;
            end if;
         elsif Pkg_Name = Null_Unbounded_String
           and then Info.Project_Name /= Null_Unbounded_String
         then
            Pkg_Name := Info.Project_Name;
         end if;
         if Pkg_Manager = Null_Unbounded_String then
            Pkg_Manager := To_Unbounded_String (".");
         end if;
         if Pkg_Name = Null_Unbounded_String then
            Pkg_Name := To_Unbounded_String (".");
         end if;
         if Pkg_Version = Null_Unbounded_String then
            Pkg_Version := To_Unbounded_String (".");
         end if;

         --  Filter excluded files
         declare
            use SCIP_Ada.Project.String_Vectors;
            Filtered : SCIP_Ada.Project.String_Vectors.Vector;
         begin
            for ALI_Path of Info.ALI_Files loop
               if not Is_Excluded (To_String (ALI_Path), Excludes) then
                  Filtered.Append (ALI_Path);
               else
                  Log_Verbose (Level,
                               "Excluding: " & To_String (ALI_Path));
               end if;
            end loop;
            Info.ALI_Files := Filtered;
         end;

         if Info.ALI_Files.Is_Empty then
            Log_Error ("all .ali files were excluded");
            Run_Success := False;
            return;
         end if;

         --  Parse ALI files
         declare
            use SCIP_Ada.SCIP.Emitter;
            ALI_Count   : constant Natural :=
              Natural (Info.ALI_Files.Length);
            Parsed      : ALI_File_Array (1 .. ALI_Count);
            Parse_Count : Natural := 0;
            Fail_Count  : Natural := 0;
         begin
            for Idx in 1 .. ALI_Count loop
               declare
                  Path : constant String :=
                    To_String (Info.ALI_Files.Element (Idx));
               begin
                  Log_Verbose (Level, "Parsing: " & Path);
                  Parsed (Idx) :=
                    SCIP_Ada.ALI.Parser.Parse (Path);

                  --  Resolve source paths relative to project
                  for F_Idx in 1 ..
                    Natural (Parsed (Idx).Files.Length)
                  loop
                     declare
                        Old_Path : constant String :=
                          To_String
                            (Parsed (Idx).Files.Element (F_Idx).Path);
                        New_Path : constant String :=
                          SCIP_Ada.Project.Resolve_Source_Path
                            (Info, Old_Path);
                        Entry_Copy : SCIP_Ada.ALI.Types.File_Entry :=
                          Parsed (Idx).Files.Element (F_Idx);
                     begin
                        Entry_Copy.Path :=
                          To_Unbounded_String (New_Path);
                        Parsed (Idx).Files.Replace_Element
                          (F_Idx, Entry_Copy);
                     end;
                  end loop;

                  Parse_Count := Parse_Count + 1;
               exception
                  when E : others =>
                     Log_Error ("failed to parse: " & Path &
                                " (" &
                                Ada.Exceptions.Exception_Message (E) &
                                ")");
                     Fail_Count := Fail_Count + 1;
               end;
            end loop;

            if Parse_Count = 0 then
               Log_Error ("no ALI files could be parsed");
               Run_Success := False;
               return;
            end if;

            --  Run LAL enrichment pass if enabled
            if Do_Enrich then
               Log_Verbose (Level, "Running enrichment pass...");
               declare
                  Enrich_Count : Natural := 0;
                  Enrich_Map   : SCIP_Ada.SCIP.Emitter.Enrichment_Map :=
                    SCIP_Ada.SCIP.Emitter.Empty_Enrichment;
               begin
                  for Idx in Parsed'Range loop
                     for F_Idx in 1 ..
                       Natural (Parsed (Idx).Files.Length)
                     loop
                        declare
                           Src_Path : constant String :=
                             To_String
                               (Parsed (Idx).Files.Element
                                  (F_Idx).Path);
                           Full_Path : constant String :=
                             (if Ada.Directories.Exists (Src_Path)
                              then Src_Path
                              else To_String (Info.Project_Root) &
                                   "/" & Src_Path);
                        begin
                           if Ada.Directories.Exists (Full_Path) then
                              declare
                                 Data : constant
                                   SCIP_Ada.LAL.Enricher
                                     .Enrichment_Data :=
                                   SCIP_Ada.LAL.Enricher.Enrich_File
                                     (Full_Path);
                              begin
                                 --  Wire signatures into enrichment map
                                 for Sig of Data.Sigs loop
                                    Enrich_Map.Add_Signature
                                      (Src_Path,
                                       Sig.Line,
                                       To_String (Sig.Full_Signature));
                                 end loop;
                                 --  Wire doc comments into enrichment map
                                 for DC of Data.Doc_Comments loop
                                    Enrich_Map.Add_Doc_Comment
                                      (Src_Path,
                                       DC.Line,
                                       To_String (DC.Doc_Comment));
                                 end loop;
                                 --  Wire relationships into enrichment map
                                 for Rel of Data.Rels loop
                                    declare
                                       use SCIP_Ada.SCIP.Symbols;
                                       Ctx   : constant Symbol_Context :=
                                         Make_Context
                                           (To_String (Pkg_Manager),
                                            To_String (Pkg_Name),
                                            To_String (Pkg_Version));
                                       Chain : Descriptor_Vectors.Vector;
                                    begin
                                       --  Build scope descriptors from
                                       --  Parent_Scope if available.
                                       if Length (Rel.Parent_Scope) > 0
                                       then
                                          declare
                                             Scope : constant String :=
                                               To_String
                                                 (Rel.Parent_Scope);
                                             Start : Positive :=
                                               Scope'First;
                                             Dot   : Natural;
                                          begin
                                             loop
                                                Dot :=
                                                  Ada.Strings.Fixed.Index
                                                    (Scope
                                                       (Start
                                                        .. Scope'Last),
                                                     ".");
                                                if Dot > 0 then
                                                   Chain.Append
                                                     ((Name =>
                                                         To_Unbounded_String
                                                           (Scope
                                                              (Start
                                                               .. Dot - 1)),
                                                       Kind =>
                                                         Namespace,
                                                       Overload => 0));
                                                   Start := Dot + 1;
                                                else
                                                   --  Last segment is
                                                   --  the type scope.
                                                   Chain.Append
                                                     ((Name =>
                                                         To_Unbounded_String
                                                           (Scope
                                                              (Start
                                                               .. Scope
                                                                    'Last)),
                                                       Kind =>
                                                         Type_Descriptor,
                                                       Overload => 0));
                                                   exit;
                                                end if;
                                             end loop;
                                          end;
                                       end if;

                                       case Rel.Kind is
                                          when SCIP_Ada.LAL.Relationships
                                                 .Extends
                                             | SCIP_Ada.LAL.Relationships
                                                 .Implements =>
                                             Chain.Append
                                               ((Name     =>
                                                   Rel.Parent_Name,
                                                 Kind     =>
                                                   Type_Descriptor,
                                                 Overload => 0));
                                             Enrich_Map.Add_Relationship
                                               (Src_Path,
                                                Rel.Child_Line,
                                                To_String
                                                  (Rel.Child_Name),
                                                Build_Symbol (Ctx, Chain),
                                                Is_Implementation  => False,
                                                Is_Type_Definition => True);
                                          when SCIP_Ada.LAL.Relationships
                                                 .Overrides =>
                                             Chain.Append
                                               ((Name     =>
                                                   Rel.Parent_Name,
                                                 Kind     => Method,
                                                 Overload => 0));
                                             Enrich_Map.Add_Relationship
                                               (Src_Path,
                                                Rel.Child_Line,
                                                To_String
                                                  (Rel.Child_Name),
                                                Build_Symbol (Ctx, Chain),
                                                Is_Implementation  => True,
                                                Is_Type_Definition => False);
                                       end case;
                                    end;
                                 end loop;
                                 --  Wire kind overrides into enrichment map
                                 for KO of Data.Kind_Overrides loop
                                    Enrich_Map.Add_Kind_Override
                                      (Src_Path,
                                       KO.Line,
                                       KO.Kind_Value);
                                    if Ada.Strings.Unbounded.Length
                                         (KO.Display_Name) > 0
                                    then
                                       Enrich_Map.Add_Display_Name_Override
                                         (Src_Path,
                                          KO.Line,
                                          To_String (KO.Display_Name));
                                    end if;
                                 end loop;
                                 Enrich_Count := Enrich_Count + 1;
                                 Log_Verbose
                                   (Level,
                                    "Enriched: " & Src_Path &
                                    " (" &
                                    Ada.Strings.Fixed.Trim
                                      (Natural'Image
                                         (Natural (Data.Sigs.Length)),
                                       Ada.Strings.Left) &
                                    " signatures," &
                                    Natural'Image
                                      (Natural (Data.Doc_Comments.Length)) &
                                    " doc comments," &
                                    Natural'Image
                                      (Natural (Data.Rels.Length)) &
                                    " relationships," &
                                    Natural'Image
                                      (Natural
                                         (Data.Kind_Overrides.Length)) &
                                    " kind overrides)");
                              end;
                           end if;
                        exception
                           when E : others =>
                              Log_Verbose
                                (Level,
                                 "Enrichment failed for " &
                                 Src_Path & ": " &
                                 Ada.Exceptions.Exception_Message
                                   (E));
                        end;
                     end loop;
                  end loop;
                  Log_Verbose (Level,
                               "Enriched" &
                               Natural'Image (Enrich_Count) &
                               " source file(s)");

                  --  Emit SCIP index with enrichment
                  Enrich_Map.Pkg_Context :=
                    SCIP_Ada.SCIP.Symbols.Make_Context
                      (To_String (Pkg_Manager),
                       To_String (Pkg_Name),
                       To_String (Pkg_Version));
                  declare
                     Out_File : constant String :=
                       To_String (Output_Path);
                     Root     : constant String :=
                       To_String (Info.Project_Root);
                     Valid    : ALI_File_Array (1 .. Parse_Count);
                     V_Idx   : Natural := 0;
                  begin
                     for Idx in Parsed'Range loop
                        if not Parsed (Idx).Files.Is_Empty then
                           V_Idx := V_Idx + 1;
                           Valid (V_Idx) := Parsed (Idx);
                        end if;
                     end loop;

                     Log_Verbose
                       (Level, "Emitting SCIP index to: " & Out_File);
                     Emit_Index
                       (ALI_Files    => Valid (1 .. V_Idx),
                        Output_Path  => Out_File,
                        Project_Root => Root,
                        Enrichment   => Enrich_Map,
                        Source_Dirs  => Info.Source_Dirs);
                  end;
               end;
            else
               Log_Verbose (Level, "Enrichment disabled");

               --  Emit SCIP index without enrichment
               declare
                  No_Enrich : SCIP_Ada.SCIP.Emitter.Enrichment_Map :=
                    Empty_Enrichment;
                  Out_File : constant String := To_String (Output_Path);
                  Root     : constant String :=
                    To_String (Info.Project_Root);
                  Valid    : ALI_File_Array (1 .. Parse_Count);
                  V_Idx   : Natural := 0;
               begin
                  No_Enrich.Pkg_Context :=
                    SCIP_Ada.SCIP.Symbols.Make_Context
                      (To_String (Pkg_Manager),
                       To_String (Pkg_Name),
                       To_String (Pkg_Version));
                  for Idx in Parsed'Range loop
                     if not Parsed (Idx).Files.Is_Empty then
                        V_Idx := V_Idx + 1;
                        Valid (V_Idx) := Parsed (Idx);
                     end if;
                  end loop;

                  Log_Verbose
                    (Level, "Emitting SCIP index to: " & Out_File);
                  Emit_Index
                    (ALI_Files    => Valid (1 .. V_Idx),
                     Output_Path  => Out_File,
                     Project_Root => Root,
                     Enrichment   => No_Enrich,
                     Source_Dirs  => Info.Source_Dirs);
               end;
            end if;

            Log_Info (Level, "Indexed" &
                      Natural'Image (Parse_Count) & " file(s) -> " &
                      To_String (Output_Path));
            if Fail_Count > 0 then
               Log_Info (Level, "Warning:" &
                         Natural'Image (Fail_Count) &
                         " file(s) failed to parse");
            end if;
         end;
      end;
   end Run_Index;

   ---------------------------------------------------------------------------
   --  Main entry point
   ---------------------------------------------------------------------------

   procedure Run is
   begin
      Run_Success := True;

      if Argument_Count = 0 then
         Print_Usage;
         return;
      end if;

      declare
         Cmd : constant String := Argument (1);
      begin
         if Cmd = "index" then
            Run_Index;
         elsif Cmd = "version" then
            Print_Version;
         elsif Cmd = "--help" or else Cmd = "-h" then
            Print_Usage;
         elsif Cmd = "--version" or else Cmd = "-v" then
            Print_Version;
         else
            Log_Error ("unknown command: " & Cmd);
            New_Line (Standard_Error);
            Print_Usage;
            Run_Success := False;
         end if;
      end;
   end Run;

   function Success return Boolean is
   begin
      return Run_Success;
   end Success;

end SCIP_Ada.CLI;
