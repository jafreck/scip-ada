with Ada.Directories;

package body SCIP_Ada.Tests is

   Output_File : constant String := "test_output.scip";

   procedure Cleanup is
   begin
      if Ada.Directories.Exists (Output_File) then
         Ada.Directories.Delete_File (Output_File);
      end if;
   end Cleanup;

   overriding procedure Set_Up (T : in out Fixture) is
      pragma Unreferenced (T);
   begin
      Cleanup;
   end Set_Up;

   overriding procedure Tear_Down (T : in out Fixture) is
      pragma Unreferenced (T);
   begin
      Cleanup;
   end Tear_Down;

end SCIP_Ada.Tests;