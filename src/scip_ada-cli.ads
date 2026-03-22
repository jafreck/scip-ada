--  SCIP_Ada.CLI — Command-line argument parsing

package SCIP_Ada.CLI is

   --  Parse command-line arguments and execute the requested action.
   procedure Run;

   --  Returns True if the last Run completed without errors.
   function Success return Boolean;

end SCIP_Ada.CLI;
