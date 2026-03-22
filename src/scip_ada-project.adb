with Ada.Directories;
with Ada.Strings.Fixed;
with Ada.Text_IO;
with Ada.Characters.Handling;

package body SCIP_Ada.Project is

   use Ada.Strings.Fixed;
   use Ada.Directories;

   ---------------------------------------------------------------------------
   --  Internal helpers
   ---------------------------------------------------------------------------

   function Normalize_Path (Path : String) return String is
      Result : String := Path;
   begin
      for I in Result'Range loop
         if Result (I) = '\' then
            Result (I) := '/';
         end if;
      end loop;
      --  Strip trailing slash
      if Result'Length > 1
        and then Result (Result'Last) = '/'
      then
         return Result (Result'First .. Result'Last - 1);
      end if;
      return Result;
   end Normalize_Path;

   function Is_Absolute_Path (Path : String) return Boolean is
   begin
      if Path'Length = 0 then
         return False;
      end if;
      --  Unix absolute
      if Path (Path'First) = '/' then
         return True;
      end if;
      --  Windows drive letter (e.g. C:/ or C:\)
      if Path'Length >= 3
        and then Path (Path'First + 1) = ':'
        and then (Path (Path'First + 2) = '/'
                  or else Path (Path'First + 2) = '\')
      then
         return True;
      end if;
      return False;
   end Is_Absolute_Path;

   function Ensure_Trailing_Sep (Path : String) return String is
   begin
      if Path'Length = 0 then
         return "/";
      elsif Path (Path'Last) = '/' then
         return Path;
      else
         return Path & "/";
      end if;
   end Ensure_Trailing_Sep;

   function Make_Absolute (Base, Relative : String) return String is
      Norm : constant String := Normalize_Path (Relative);
   begin
      if Is_Absolute_Path (Norm) then
         return Norm;
      end if;
      return Normalize_Path (Ensure_Trailing_Sep (Base) & Norm);
   end Make_Absolute;

   function To_Full (Path : String) return String is
   begin
      return Ada.Directories.Full_Name (Path);
   end To_Full;

   ---------------------------------------------------------------------------
   --  GPR line parsing helpers
   ---------------------------------------------------------------------------

   function Strip (S : String) return String is
      First : Natural := S'First;
      Last  : Natural := S'Last;
   begin
      while First <= Last
        and then (S (First) = ' ' or else S (First) = ASCII.HT)
      loop
         First := First + 1;
      end loop;
      while Last >= First
        and then (S (Last) = ' ' or else S (Last) = ASCII.HT)
      loop
         Last := Last - 1;
      end loop;
      if First > Last then
         return "";
      end if;
      return S (First .. Last);
   end Strip;

   function To_Lower (S : String) return String is
   begin
      return Ada.Characters.Handling.To_Lower (S);
   end To_Lower;

   --  Extract a quoted string value from a GPR "for Attr use ""value"";"
   --  Returns the value without quotes, or "" if not found.
   function Extract_Quoted (Line : String) return String is
      Q1 : Natural;
      Q2 : Natural;
   begin
      Q1 := Index (Line, """");
      if Q1 = 0 then
         return "";
      end if;
      Q2 := Index (Line (Q1 + 1 .. Line'Last), """");
      if Q2 = 0 then
         return "";
      end if;
      return Line (Q1 + 1 .. Q2 - 1);
   end Extract_Quoted;

   --  Extract all quoted strings from a parenthesized list:
   --    ("src/", "lib/")  ->  ["src/", "lib/"]
   --  Handles multi-line accumulation.
   procedure Extract_String_List
     (Line   : String;
      Result : in out String_Vectors.Vector;
      Done   : out Boolean)
   is
      Pos : Natural := Line'First;
      Q1, Q2 : Natural;
   begin
      Done := Index (Line, ";") > 0;
      loop
         Q1 := Index (Line (Pos .. Line'Last), """");
         exit when Q1 = 0;
         Q2 := Index (Line (Q1 + 1 .. Line'Last), """");
         exit when Q2 = 0;
         Result.Append (To_Unbounded_String (Line (Q1 + 1 .. Q2 - 1)));
         Pos := Q2 + 1;
      end loop;
   end Extract_String_List;

   ---------------------------------------------------------------------------
   --  Lightweight GPR parser
   ---------------------------------------------------------------------------

   procedure Parse_GPR
     (GPR_Path    : String;
      Object_Dir  : out Unbounded_String;
      Source_Dirs : out String_Vectors.Vector;
      Proj_Name   : out Unbounded_String)
   is
      use Ada.Text_IO;

      File          : File_Type;
      In_Source_Dirs : Boolean := False;
      Done          : Boolean;
   begin
      Object_Dir  := To_Unbounded_String (".");
      Proj_Name   := Null_Unbounded_String;

      Open (File, In_File, GPR_Path);
      while not End_Of_File (File) loop
         declare
            Raw  : constant String := Get_Line (File);
            Line : constant String := Strip (Raw);
            Low  : constant String := To_Lower (Line);
         begin
            --  Accumulating Source_Dirs across multiple lines
            if In_Source_Dirs then
               Extract_String_List (Line, Source_Dirs, Done);
               In_Source_Dirs := not Done;

            --  "project Foo is" — extract project name
            elsif Low'Length > 8
              and then Low (Low'First .. Low'First + 7) = "project "
            then
               declare
                  Rest : constant String :=
                    Strip (Line (Line'First + 8 .. Line'Last));
                  Sp : constant Natural := Index (Rest, " ");
               begin
                  if Sp > 0 then
                     Proj_Name :=
                       To_Unbounded_String (Rest (Rest'First .. Sp - 1));
                  end if;
               end;

            --  "for Object_Dir use ""obj"";"
            elsif Index (Low, "for object_dir use") > 0 then
               declare
                  Val : constant String := Extract_Quoted (Line);
               begin
                  if Val'Length > 0 then
                     Object_Dir := To_Unbounded_String (Val);
                  end if;
               end;

            --  "for Source_Dirs use (..."
            elsif Index (Low, "for source_dirs use") > 0 then
               Extract_String_List (Line, Source_Dirs, Done);
               In_Source_Dirs := not Done;
            end if;
         end;
      end loop;
      Close (File);

      --  Default Source_Dirs if none specified
      if Source_Dirs.Is_Empty then
         Source_Dirs.Append (To_Unbounded_String ("."));
      end if;
   end Parse_GPR;

   ---------------------------------------------------------------------------
   --  Find all .ali files in a directory (non-recursive)
   ---------------------------------------------------------------------------

   procedure Find_ALI_In_Dir
     (Dir    : String;
      Result : in Out String_Vectors.Vector)
   is
      Search    : Search_Type;
      Dir_Entry : Directory_Entry_Type;
   begin
      if not Exists (Dir) or else Kind (Dir) /= Ada.Directories.Directory then
         return;
      end if;
      Start_Search (Search, Dir, "*.ali", (Ordinary_File => True,
                                           others => False));
      while More_Entries (Search) loop
         Get_Next_Entry (Search, Dir_Entry);
         Result.Append
           (To_Unbounded_String (Full_Name (Dir_Entry)));
      end loop;
      End_Search (Search);
   end Find_ALI_In_Dir;

   ---------------------------------------------------------------------------
   --  Find all .ali files recursively
   ---------------------------------------------------------------------------

   procedure Find_ALI_Recursive
     (Dir    : String;
      Result : in out String_Vectors.Vector)
   is
      Search    : Search_Type;
      Dir_Entry : Directory_Entry_Type;
   begin
      if not Exists (Dir) or else Kind (Dir) /= Ada.Directories.Directory then
         return;
      end if;

      --  First, collect .ali files in this directory
      Find_ALI_In_Dir (Dir, Result);

      --  Then recurse into subdirectories
      Start_Search (Search, Dir, "", (Ada.Directories.Directory => True,
                                      others => False));
      while More_Entries (Search) loop
         Get_Next_Entry (Search, Dir_Entry);
         declare
            Name : constant String := Simple_Name (Dir_Entry);
         begin
            if Name /= "." and then Name /= ".." then
               Find_ALI_Recursive (Full_Name (Dir_Entry), Result);
            end if;
         end;
      end loop;
      End_Search (Search);
   end Find_ALI_Recursive;

   ---------------------------------------------------------------------------
   --  Discover_From_GPR
   ---------------------------------------------------------------------------

   function Discover_From_GPR (GPR_Path : String) return Project_Info is
      Info       : Project_Info;
      Object_Dir : Unbounded_String;
      Abs_GPR    : constant String := To_Full (GPR_Path);
      GPR_Dir    : constant String :=
        Normalize_Path (Containing_Directory (Abs_GPR));
   begin
      Parse_GPR (Abs_GPR, Object_Dir, Info.Source_Dirs, Info.Project_Name);
      Info.Project_Root := To_Unbounded_String (GPR_Dir);

      --  Resolve Source_Dirs to absolute paths
      for I in 1 .. Natural (Info.Source_Dirs.Length) loop
         declare
            Rel : constant String := To_String (Info.Source_Dirs (Positive (I)));
            Abs_Path : constant String := Make_Absolute (GPR_Dir, Rel);
         begin
            Info.Source_Dirs.Replace_Element
              (Positive (I), To_Unbounded_String (Abs_Path));
         end;
      end loop;

      --  Find .ali files in the (resolved) Object_Dir
      declare
         Abs_Obj : constant String :=
           Make_Absolute (GPR_Dir, To_String (Object_Dir));
      begin
         Find_ALI_In_Dir (Abs_Obj, Info.ALI_Files);
      end;

      return Info;
   end Discover_From_GPR;

   ---------------------------------------------------------------------------
   --  Discover_From_Directory
   ---------------------------------------------------------------------------

   function Discover_From_Directory (Dir_Path : String) return Project_Info is
      Info    : Project_Info;
      Abs_Dir : constant String := Normalize_Path (To_Full (Dir_Path));
   begin
      Info.Project_Name := To_Unbounded_String
        (Simple_Name (Abs_Dir));
      Info.Project_Root := To_Unbounded_String (Abs_Dir);
      Info.Source_Dirs.Append (To_Unbounded_String (Abs_Dir));

      Find_ALI_Recursive (Abs_Dir, Info.ALI_Files);

      return Info;
   end Discover_From_Directory;

   ---------------------------------------------------------------------------
   --  Resolve_Source_Path
   ---------------------------------------------------------------------------

   function Resolve_Source_Path
     (Info      : Project_Info;
      ALI_Path  : String) return String
   is
      Root : constant String :=
        Ensure_Trailing_Sep (To_String (Info.Project_Root));
   begin
      --  Try each source dir; if the file exists there, return
      --  a project-relative path.
      for Dir of Info.Source_Dirs loop
         declare
            Candidate : constant String :=
              Ensure_Trailing_Sep (To_String (Dir)) & ALI_Path;
         begin
            if Exists (Candidate) then
               declare
                  Full : constant String := Normalize_Path (To_Full (Candidate));
               begin
                  --  Make project-relative if it starts with Root
                  if Full'Length >= Root'Length
                    and then Full (Full'First .. Full'First + Root'Length - 1)
                             = Root
                  then
                     return Full (Full'First + Root'Length .. Full'Last);
                  end if;
                  return Full;
               end;
            end if;
         end;
      end loop;

      --  Not found in any source dir; return as-is
      return ALI_Path;
   end Resolve_Source_Path;

end SCIP_Ada.Project;
