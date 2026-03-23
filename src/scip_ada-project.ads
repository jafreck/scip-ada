--  SCIP_Ada.Project — GPR / directory discovery
--
--  Discovers Ada projects and their ALI file locations.
--  Supports two modes:
--    1) GPR mode: parse a .gpr file to find Object_Dir and Source_Dirs
--    2) Directory mode: recursively find .ali files in a directory

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.Project is

   use Ada.Strings.Unbounded;

   package String_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Unbounded_String);

   ---------------------------------------------------------------------------
   --  Project_Info — everything needed about a discovered project
   ---------------------------------------------------------------------------

   type Project_Info is record
      Project_Name  : Unbounded_String;
      Project_Root  : Unbounded_String;   --  absolute path to project root
      Source_Dirs   : String_Vectors.Vector;  --  absolute paths
      ALI_Files     : String_Vectors.Vector;  --  absolute paths to .ali files
      Alire_Name    : Unbounded_String;  --  from alire.toml name field
      Alire_Version : Unbounded_String;  --  from alire.toml version field
   end record;

   ---------------------------------------------------------------------------
   --  Discovery entry points
   ---------------------------------------------------------------------------

   --  Parse a .gpr file to extract Object_Dir and Source_Dirs, then find
   --  all .ali files in Object_Dir.
   function Discover_From_GPR (GPR_Path : String) return Project_Info;

   --  Recursively find all .ali files under the given directory.
   --  Source dirs are inferred as the directory itself.
   function Discover_From_Directory (Dir_Path : String) return Project_Info;

   ---------------------------------------------------------------------------
   --  Path resolution helpers
   ---------------------------------------------------------------------------

   --  Resolve a relative path from an ALI D line against the source dirs
   --  in Info.  Returns the project-relative path if found, or the original
   --  path unchanged.
   function Resolve_Source_Path
     (Info      : Project_Info;
      ALI_Path  : String) return String;

   --  Normalize a file path for SCIP output: convert backslashes to
   --  forward slashes and strip Windows drive letter prefixes.
   function Normalize_Path (Path : String) return String;

end SCIP_Ada.Project;
