with AUnit.Test_Caller;
with AUnit.Test_Info; use AUnit.Test_Info;

package body SCIP_Ada.Tests.Suite is

   package Caller is new AUnit.Test_Caller (SCIP_Ada.Tests.Fixture);

   function Suite return Access_Test_Suite is
      Result : constant Access_Test_Suite := AUnit.Test_Suites.New_Suite;
   begin
      Result.Add_Test
        (Caller.Create
           (Name         => "ALI Types",
            Test_Package => "SCIP_Ada.Tests",
            Test_File    => "tests/src/scip_ada-tests.ads",
            Location     =>
              (Tested_File   => new String'("src/scip_ada-ali-types.ads"),
               Tested_Line   => 1,
               Tested_Column => 1,
               Tested_Name   => new String'("SCIP_Ada.ALI.Types")),
            Suffix       => null,
            Test         => Run_ALI_Types'Access));

      Result.Add_Test
        (Caller.Create
           (Name         => "ALI Parser",
            Test_Package => "SCIP_Ada.Tests",
            Test_File    => "tests/src/scip_ada-tests.ads",
            Location     =>
              (Tested_File   => new String'("src/scip_ada-ali-parser.ads"),
               Tested_Line   => 1,
               Tested_Column => 1,
               Tested_Name   => new String'("SCIP_Ada.ALI.Parser")),
            Suffix       => null,
            Test         => Run_ALI_Parser'Access));

      Result.Add_Test
        (Caller.Create
           (Name         => "SCIP Emitter",
            Test_Package => "SCIP_Ada.Tests",
            Test_File    => "tests/src/scip_ada-tests.ads",
            Location     =>
              (Tested_File   => new String'("src/scip_ada-scip-emitter.ads"),
               Tested_Line   => 1,
               Tested_Column => 1,
               Tested_Name   => new String'("SCIP_Ada.SCIP.Emitter")),
            Suffix       => null,
            Test         => Run_SCIP_Emitter'Access));

      Result.Add_Test
        (Caller.Create
           (Name         => "SCIP Symbols",
            Test_Package => "SCIP_Ada.Tests",
            Test_File    => "tests/src/scip_ada-tests.ads",
            Location     =>
              (Tested_File   => new String'("src/scip_ada-scip-symbols.ads"),
               Tested_Line   => 1,
               Tested_Column => 1,
               Tested_Name   => new String'("SCIP_Ada.SCIP.Symbols")),
            Suffix       => null,
            Test         => Run_SCIP_Symbols'Access));

      Result.Add_Test
        (Caller.Create
           (Name         => "SCIP Mapping",
            Test_Package => "SCIP_Ada.Tests",
            Test_File    => "tests/src/scip_ada-tests.ads",
            Location     =>
              (Tested_File   => new String'("src/scip_ada-scip-mapping.ads"),
               Tested_Line   => 1,
               Tested_Column => 1,
               Tested_Name   => new String'("SCIP_Ada.SCIP.Mapping")),
            Suffix       => null,
            Test         => Run_SCIP_Mapping'Access));

      Result.Add_Test
        (Caller.Create
           (Name         => "Project",
            Test_Package => "SCIP_Ada.Tests",
            Test_File    => "tests/src/scip_ada-tests.ads",
            Location     =>
              (Tested_File   => new String'("src/scip_ada-project.ads"),
               Tested_Line   => 1,
               Tested_Column => 1,
               Tested_Name   => new String'("SCIP_Ada.Project")),
            Suffix       => null,
            Test         => Run_Project'Access));

      return Result;
   end Suite;

end SCIP_Ada.Tests.Suite;