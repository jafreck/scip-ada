--  Test suite for SCIP_Ada.SCIP.Mapping
--  Exhaustive tests for Entity_Kind → SCIP_Symbol_Kind and Ref_Kind → Role

with SCIP_Ada.Tests;

package Test_SCIP_Mapping is
   procedure Test_Kind_Mapping (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Kind_Values (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Role_Mapping (T : in out SCIP_Ada.Tests.Fixture);
end Test_SCIP_Mapping;
