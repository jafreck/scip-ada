--  Test suite for SCIP_Ada.ALI.Parser

with SCIP_Ada.Tests;

package Test_ALI_Parser is
   procedure Test_Basic (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Generics (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Tagged_Types (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Overloaded (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Operators (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Renaming (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Continuation (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Gnat_Sample (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Gnat_Sample_Main (T : in out SCIP_Ada.Tests.Fixture);
   procedure Test_Missing_File (T : in out SCIP_Ada.Tests.Fixture);
end Test_ALI_Parser;
