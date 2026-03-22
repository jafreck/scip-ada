with AUnit.Assertions; use AUnit.Assertions;

with Test_ALI_Parser;
with Test_ALI_Types;
with Test_Project;
with Test_SCIP_Emitter;
with Test_SCIP_Mapping;
with Test_SCIP_Symbols;

package body SCIP_Ada.Tests is

   procedure Assert_Suite_Success
     (Suite_Name : String;
      Passed     : Natural;
      Failed     : Natural)
   is
   begin
      Assert
        (Failed = 0,
         Suite_Name & " failed with" & Natural'Image (Failed) &
         " failing checks and" & Natural'Image (Passed) &
         " passing checks");
   end Assert_Suite_Success;

   procedure Run_ALI_Types (T : in out Fixture) is
      pragma Unreferenced (T);
      Passed : Natural;
      Failed : Natural;
   begin
      Test_ALI_Types.Run (Passed, Failed);
      Assert_Suite_Success ("ALI Types", Passed, Failed);
   end Run_ALI_Types;

   procedure Run_ALI_Parser (T : in out Fixture) is
      pragma Unreferenced (T);
      Passed : Natural;
      Failed : Natural;
   begin
      Test_ALI_Parser.Run (Passed, Failed);
      Assert_Suite_Success ("ALI Parser", Passed, Failed);
   end Run_ALI_Parser;

   procedure Run_SCIP_Emitter (T : in out Fixture) is
      pragma Unreferenced (T);
      Passed : Natural;
      Failed : Natural;
   begin
      Test_SCIP_Emitter.Run (Passed, Failed);
      Assert_Suite_Success ("SCIP Emitter", Passed, Failed);
   end Run_SCIP_Emitter;

   procedure Run_SCIP_Symbols (T : in out Fixture) is
      pragma Unreferenced (T);
      Passed : Natural;
      Failed : Natural;
   begin
      Test_SCIP_Symbols.Run (Passed, Failed);
      Assert_Suite_Success ("SCIP Symbols", Passed, Failed);
   end Run_SCIP_Symbols;

   procedure Run_SCIP_Mapping (T : in out Fixture) is
      pragma Unreferenced (T);
      Passed : Natural;
      Failed : Natural;
   begin
      Test_SCIP_Mapping.Run (Passed, Failed);
      Assert_Suite_Success ("SCIP Mapping", Passed, Failed);
   end Run_SCIP_Mapping;

   procedure Run_Project (T : in out Fixture) is
      pragma Unreferenced (T);
      Passed : Natural;
      Failed : Natural;
   begin
      Test_Project.Run (Passed, Failed);
      Assert_Suite_Success ("Project", Passed, Failed);
   end Run_Project;

end SCIP_Ada.Tests;