--  Test suite for SCIP_Ada.Project

with SCIP_Ada.Tests;

package Test_Project is
   procedure Test_Discover_GPR (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Discover_Directory (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Resolve_Source_Path (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Default_Source_Dirs (T : in out SCIP_Ada.Tests.Fixture);
end Test_Project;
