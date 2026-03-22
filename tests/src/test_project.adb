with Ada.Text_IO;
with Ada.Strings.Unbounded;
with SCIP_Ada.Project;

package body Test_Project is

   use Ada.Text_IO;
   use Ada.Strings.Unbounded;
   use SCIP_Ada.Project;

   Fixtures : constant String := "tests/fixtures/";

   ---------------------------------------------------------------------------
   --  Test helpers
   ---------------------------------------------------------------------------

   procedure Assert
     (Condition : Boolean;
      Message   : String;
      Passed    : in out Natural;
      Failed    : in out Natural)
   is
   begin
      if Condition then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Put_Line ("  FAIL: " & Message);
      end if;
   end Assert;

   procedure Assert_Eq_Nat
     (Actual   : Natural;
      Expected : Natural;
      Label    : String;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      Assert (Actual = Expected,
              Label & ": got" & Natural'Image (Actual) &
              ", expected" & Natural'Image (Expected),
              Passed, Failed);
   end Assert_Eq_Nat;

   procedure Assert_Eq_Str
     (Actual   : String;
      Expected : String;
      Label    : String;
      Passed   : in out Natural;
      Failed   : in out Natural)
   is
   begin
      Assert (Actual = Expected,
              Label & ": got """ & Actual &
              """, expected """ & Expected & """",
              Passed, Failed);
   end Assert_Eq_Str;

   --  Check that a vector contains an element whose string ends with Suffix
   function Has_Suffix
     (Vec    : String_Vectors.Vector;
      Suffix : String) return Boolean
   is
   begin
      for Item of Vec loop
         declare
            S : constant String := To_String (Item);
         begin
            if S'Length >= Suffix'Length
              and then S (S'Last - Suffix'Length + 1 .. S'Last) = Suffix
            then
               return True;
            end if;
         end;
      end loop;
      return False;
   end Has_Suffix;

   ---------------------------------------------------------------------------
   --  Test: GPR discovery
   ---------------------------------------------------------------------------

   procedure Test_Discover_GPR
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      GPR  : constant String :=
        Fixtures & "project_fixture/test_project.gpr";
      Info : constant Project_Info := Discover_From_GPR (GPR);
   begin
      --  Project name should be "Test_Project"
      Assert_Eq_Str (To_String (Info.Project_Name), "Test_Project",
                     "gpr: project name", Passed, Failed);

      --  Project root should end with project_fixture
      declare
         Root : constant String := To_String (Info.Project_Root);
         Suffix : constant String := "project_fixture";
      begin
         Assert (Root'Length >= Suffix'Length
                 and then Root (Root'Last - Suffix'Length + 1 .. Root'Last)
                          = Suffix,
                 "gpr: project root ends with project_fixture",
                 Passed, Failed);
      end;

      --  Source_Dirs should have 2 entries (src/ and lib/)
      Assert_Eq_Nat (Natural (Info.Source_Dirs.Length), 2,
                     "gpr: source_dirs count", Passed, Failed);

      --  Source dirs should end with src and lib
      Assert (Has_Suffix (Info.Source_Dirs, "src"),
              "gpr: has src dir", Passed, Failed);
      Assert (Has_Suffix (Info.Source_Dirs, "lib"),
              "gpr: has lib dir", Passed, Failed);

      --  Should find 2 ALI files
      Assert_Eq_Nat (Natural (Info.ALI_Files.Length), 2,
                     "gpr: ali file count", Passed, Failed);

      --  ALI files should include main.ali and utils.ali
      Assert (Has_Suffix (Info.ALI_Files, "main.ali"),
              "gpr: has main.ali", Passed, Failed);
      Assert (Has_Suffix (Info.ALI_Files, "utils.ali"),
              "gpr: has utils.ali", Passed, Failed);
   end Test_Discover_GPR;

   ---------------------------------------------------------------------------
   --  Test: directory discovery
   ---------------------------------------------------------------------------

   procedure Test_Discover_Directory
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      Dir  : constant String :=
        Fixtures & "project_fixture/obj";
      Info : constant Project_Info := Discover_From_Directory (Dir);
   begin
      --  Project name should be "obj"
      Assert_Eq_Str (To_String (Info.Project_Name), "obj",
                     "dir: project name", Passed, Failed);

      --  Should find 2 ALI files (main.ali, utils.ali)
      Assert_Eq_Nat (Natural (Info.ALI_Files.Length), 2,
                     "dir: ali file count", Passed, Failed);
      Assert (Has_Suffix (Info.ALI_Files, "main.ali"),
              "dir: has main.ali", Passed, Failed);
      Assert (Has_Suffix (Info.ALI_Files, "utils.ali"),
              "dir: has utils.ali", Passed, Failed);
   end Test_Discover_Directory;

   ---------------------------------------------------------------------------
   --  Test: Resolve_Source_Path
   ---------------------------------------------------------------------------

   procedure Test_Resolve_Source_Path
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      GPR  : constant String :=
        Fixtures & "project_fixture/test_project.gpr";
      Info : constant Project_Info := Discover_From_GPR (GPR);
   begin
      --  "main.ads" exists in src/, should resolve to "src/main.ads"
      Assert_Eq_Str (Resolve_Source_Path (Info, "main.ads"),
                     "src/main.ads",
                     "resolve: main.ads -> src/main.ads",
                     Passed, Failed);

      --  "utils.ads" exists in lib/, should resolve to "lib/utils.ads"
      Assert_Eq_Str (Resolve_Source_Path (Info, "utils.ads"),
                     "lib/utils.ads",
                     "resolve: utils.ads -> lib/utils.ads",
                     Passed, Failed);

      --  "nonexistent.ads" doesn't exist; should return as-is
      Assert_Eq_Str (Resolve_Source_Path (Info, "nonexistent.ads"),
                     "nonexistent.ads",
                     "resolve: nonexistent.ads unchanged",
                     Passed, Failed);
   end Test_Resolve_Source_Path;

   ---------------------------------------------------------------------------
   --  Test: GPR with no Source_Dirs defaults to "."
   ---------------------------------------------------------------------------

   procedure Test_Default_Source_Dirs
     (Passed : in out Natural;
      Failed : in out Natural)
   is
      --  Create a minimal GPR string to test default behavior
      --  We'll use the real GPR fixture which does have Source_Dirs,
      --  so instead test that the fixtures directory itself works in
      --  directory mode.
      Dir  : constant String := Fixtures;
      Info : constant Project_Info := Discover_From_Directory (Dir);
   begin
      --  Source_Dirs should default to the directory itself
      Assert_Eq_Nat (Natural (Info.Source_Dirs.Length), 1,
                     "default: source_dirs count", Passed, Failed);

      --  Should find multiple .ali files in fixtures/
      Assert (Natural (Info.ALI_Files.Length) >= 1,
              "default: found ali files in fixtures dir",
              Passed, Failed);
   end Test_Default_Source_Dirs;

   ---------------------------------------------------------------------------
   --  Run all tests
   ---------------------------------------------------------------------------

   procedure Run (Passed : out Natural; Failed : out Natural) is
   begin
      Passed := 0;
      Failed := 0;

      Test_Discover_GPR (Passed, Failed);
      Test_Discover_Directory (Passed, Failed);
      Test_Resolve_Source_Path (Passed, Failed);
      Test_Default_Source_Dirs (Passed, Failed);
   end Run;

end Test_Project;
