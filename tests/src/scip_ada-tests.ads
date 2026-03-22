with AUnit.Test_Fixtures;

package SCIP_Ada.Tests is

   type Fixture is new AUnit.Test_Fixtures.Test_Fixture with null record;

   overriding procedure Set_Up (T : in out Fixture);
   overriding procedure Tear_Down (T : in out Fixture);

end SCIP_Ada.Tests;