with Ada.Command_Line;
with SCIP_Ada.CLI;

procedure SCIP_Ada.Main is
begin
   SCIP_Ada.CLI.Run;

   if not SCIP_Ada.CLI.Success then
      Ada.Command_Line.Set_Exit_Status (Ada.Command_Line.Failure);
   end if;
end SCIP_Ada.Main;
