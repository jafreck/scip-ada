with Ada.Command_Line;

with AUnit; use AUnit;
with AUnit.Reporter.Text;
with AUnit.Run;

with SCIP_Ada.Tests.Suite;

procedure Test_Runner is
   function Runner is new AUnit.Run.Test_Runner_With_Status
     (SCIP_Ada.Tests.Suite.Suite);

   Reporter : AUnit.Reporter.Text.Text_Reporter;
begin
   if Runner (Reporter) /= Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end Test_Runner;
