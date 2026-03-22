with AUnit.Test_Fixtures;

package SCIP_Ada.Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   procedure Run_ALI_Types (T : in out Fixture);
   procedure Run_ALI_Parser (T : in out Fixture);
   procedure Run_SCIP_Emitter (T : in out Fixture);
   procedure Run_SCIP_Symbols (T : in out Fixture);
   procedure Run_SCIP_Mapping (T : in out Fixture);
   procedure Run_Project (T : in out Fixture);

end SCIP_Ada.Tests;