--  Test suite for SCIP_Ada.SCIP.Symbols
--  Covers all Ada entity kinds, descriptor formatting, local symbols,
--  parent chain resolution, overload disambiguation, and child packages.

with SCIP_Ada.Tests;

package Test_SCIP_Symbols is
    procedure Test_Core_Symbol_Kinds
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Additional_Entity_Kinds
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Descriptor_Helpers
       (T : in out SCIP_Ada.Tests.Fixture);
    procedure Test_Remaining_Type_And_Object_Kinds
       (T : in out SCIP_Ada.Tests.Fixture);
end Test_SCIP_Symbols;
