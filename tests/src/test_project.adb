with AUnit.Assertions;
with Ada.Strings.Unbounded;
with SCIP_Ada.Project;

package body Test_Project is

   use Ada.Strings.Unbounded;
   use SCIP_Ada.Project;

   Fixtures : constant String := "tests/fixtures/";

   procedure Assert_Eq_Nat
     (Actual   : Natural;
      Expected : Natural;
      Label    : String)
   is
   begin
      AUnit.Assertions.Assert
        (Actual = Expected,
         Label & ": got" & Natural'Image (Actual) &
         ", expected" & Natural'Image (Expected));
   end Assert_Eq_Nat;

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

   procedure Test_Discover_GPR (T : in out SCIP_Ada.Tests.Fixture) is
      pragma Unreferenced (T);
      GPR  : constant String := Fixtures & "project_fixture/test_project.gpr";
      Info : constant Project_Info := Discover_From_GPR (GPR);
   begin
      AUnit.Assertions.Assert
        (To_String (Info.Project_Name),
         "Test_Project",
         "gpr: project name");

      declare
         Root   : constant String := To_String (Info.Project_Root);
         Suffix : constant String := "project_fixture";
      begin
         AUnit.Assertions.Assert
           (Root'Length >= Suffix'Length
            and then Root (Root'Last - Suffix'Length + 1 .. Root'Last) =
              Suffix,
            "gpr: project root ends with project_fixture");
      end;

      Assert_Eq_Nat (Natural (Info.Source_Dirs.Length), 2,
                     "gpr: source_dirs count");
      AUnit.Assertions.Assert
        (Has_Suffix (Info.Source_Dirs, "src"), "gpr: has src dir");
      AUnit.Assertions.Assert
        (Has_Suffix (Info.Source_Dirs, "lib"), "gpr: has lib dir");

      Assert_Eq_Nat (Natural (Info.ALI_Files.Length), 2,
                     "gpr: ali file count");
      AUnit.Assertions.Assert
        (Has_Suffix (Info.ALI_Files, "main.ali"),
         "gpr: has main.ali");
      AUnit.Assertions.Assert
        (Has_Suffix (Info.ALI_Files, "utils.ali"),
         "gpr: has utils.ali");
   end Test_Discover_GPR;

   procedure Test_Discover_Directory
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
      Dir  : constant String := Fixtures & "project_fixture/obj";
      Info : constant Project_Info := Discover_From_Directory (Dir);
   begin
      AUnit.Assertions.Assert
        (To_String (Info.Project_Name),
         "obj",
         "dir: project name");
      Assert_Eq_Nat (Natural (Info.ALI_Files.Length), 2,
                     "dir: ali file count");
      AUnit.Assertions.Assert
        (Has_Suffix (Info.ALI_Files, "main.ali"),
         "dir: has main.ali");
      AUnit.Assertions.Assert
        (Has_Suffix (Info.ALI_Files, "utils.ali"),
         "dir: has utils.ali");
   end Test_Discover_Directory;

   procedure Test_Resolve_Source_Path
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
      GPR  : constant String := Fixtures & "project_fixture/test_project.gpr";
      Info : constant Project_Info := Discover_From_GPR (GPR);
   begin
      AUnit.Assertions.Assert
        (Resolve_Source_Path (Info, "main.ads"),
         "src/main.ads",
         "resolve: main.ads -> src/main.ads");
      AUnit.Assertions.Assert
        (Resolve_Source_Path (Info, "utils.ads"),
         "lib/utils.ads",
         "resolve: utils.ads -> lib/utils.ads");
      AUnit.Assertions.Assert
        (Resolve_Source_Path (Info, "nonexistent.ads"),
         "nonexistent.ads",
         "resolve: nonexistent.ads unchanged");
   end Test_Resolve_Source_Path;

   procedure Test_Default_Source_Dirs
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
      Dir  : constant String := Fixtures;
      Info : constant Project_Info := Discover_From_Directory (Dir);
   begin
      Assert_Eq_Nat (Natural (Info.Source_Dirs.Length), 1,
                     "default: source_dirs count");
      AUnit.Assertions.Assert
        (Natural (Info.ALI_Files.Length) >= 1,
         "default: found ali files in fixtures dir");
   end Test_Default_Source_Dirs;

end Test_Project;
