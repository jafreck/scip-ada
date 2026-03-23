--  Test suite for SCIP_Ada.SCIP.Emitter

with SCIP_Ada.Tests;

package Test_SCIP_Emitter is
    procedure Test_Emit_Creates_Non_Empty_File
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Output_Starts_With_Metadata_Tag
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Output_Contains_Tool_Name
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Output_Contains_Relative_Path
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Output_Contains_Entity_Name
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Enriched_Output_Uses_Signature_Documentation
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Emit_Empty_ALI_Creates_Output
       (T : in out SCIP_Ada.Tests.Fixture);
end Test_SCIP_Emitter;
