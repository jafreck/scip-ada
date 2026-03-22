--  Test suite for SCIP_Ada.ALI.Types

with SCIP_Ada.Tests;

package Test_ALI_Types is
    procedure Test_Entity_Uppercase
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Entity_Lowercase
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Entity_Special_Characters
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Reference_Lowercase
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Reference_Uppercase
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Invalid_Entity_Characters
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Invalid_Reference_Characters
       (T : in out SCIP_Ada.Tests.Fixture);
end Test_ALI_Types;
