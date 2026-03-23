with AUnit.Test_Caller;
with Test_ALI_Parser;
with Test_ALI_Types;
with Test_Project;
with Test_SCIP_Emitter;
with Test_SCIP_Mapping;
with Test_SCIP_Symbols;

package body SCIP_Ada.Tests.Suite is

    package Caller is new AUnit.Test_Caller (SCIP_Ada.Tests.Fixture);

    function Suite return Access_Test_Suite is
         Result : constant Access_Test_Suite := AUnit.Test_Suites.New_Suite;
    begin
         Result.Add_Test
        (Caller.Create
           ("ALI Types Uppercase Entities",
            Test_ALI_Types.Test_Entity_Uppercase'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Types Lowercase Entities",
            Test_ALI_Types.Test_Entity_Lowercase'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Types Special Entities",
            Test_ALI_Types.Test_Entity_Special_Characters'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Types Lowercase References",
            Test_ALI_Types.Test_Reference_Lowercase'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Types Uppercase References",
            Test_ALI_Types.Test_Reference_Uppercase'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Types Invalid Entities",
            Test_ALI_Types.Test_Invalid_Entity_Characters'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Types Invalid References",
            Test_ALI_Types.Test_Invalid_Reference_Characters'Access));

         Result.Add_Test
        (Caller.Create ("ALI Parser Basic", Test_ALI_Parser.Test_Basic'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Generics", Test_ALI_Parser.Test_Generics'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Tagged Types",
            Test_ALI_Parser.Test_Tagged_Types'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Overloaded",
            Test_ALI_Parser.Test_Overloaded'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Operators",
            Test_ALI_Parser.Test_Operators'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Renaming",
            Test_ALI_Parser.Test_Renaming'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Continuation",
            Test_ALI_Parser.Test_Continuation'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser GNAT Sample",
            Test_ALI_Parser.Test_Gnat_Sample'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser GNAT Sample Main",
            Test_ALI_Parser.Test_Gnat_Sample_Main'Access));

         Result.Add_Test
        (Caller.Create
           ("ALI Parser Missing File",
            Test_ALI_Parser.Test_Missing_File'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Emitter Creates Output",
            Test_SCIP_Emitter.Test_Emit_Creates_Non_Empty_File'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Emitter Metadata Tag",
            Test_SCIP_Emitter.Test_Output_Starts_With_Metadata_Tag'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Emitter Tool Name",
            Test_SCIP_Emitter.Test_Output_Contains_Tool_Name'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Emitter Relative Path",
            Test_SCIP_Emitter.Test_Output_Contains_Relative_Path'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Emitter Entity Name",
            Test_SCIP_Emitter.Test_Output_Contains_Entity_Name'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Emitter Empty ALI",
            Test_SCIP_Emitter.Test_Emit_Empty_ALI_Creates_Output'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Symbols Core Kinds",
            Test_SCIP_Symbols.Test_Core_Symbol_Kinds'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Symbols Additional Kinds",
            Test_SCIP_Symbols.Test_Additional_Entity_Kinds'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Symbols Descriptor Helpers",
            Test_SCIP_Symbols.Test_Descriptor_Helpers'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Symbols Remaining Types",
            Test_SCIP_Symbols.Test_Remaining_Type_And_Object_Kinds'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Symbols Name Escaping",
            Test_SCIP_Symbols.Test_Name_Escaping'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Mapping Kind Mapping",
            Test_SCIP_Mapping.Test_Kind_Mapping'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Mapping Kind Values",
            Test_SCIP_Mapping.Test_Kind_Values'Access));

         Result.Add_Test
        (Caller.Create
           ("SCIP Mapping Role Mapping",
            Test_SCIP_Mapping.Test_Role_Mapping'Access));

         Result.Add_Test
        (Caller.Create
           ("Project Discover GPR",
            Test_Project.Test_Discover_GPR'Access));

         Result.Add_Test
        (Caller.Create
           ("Project Discover Directory",
            Test_Project.Test_Discover_Directory'Access));

         Result.Add_Test
        (Caller.Create
           ("Project Resolve Source Path",
            Test_Project.Test_Resolve_Source_Path'Access));

         Result.Add_Test
        (Caller.Create
           ("Project Default Source Dirs",
            Test_Project.Test_Default_Source_Dirs'Access));

         return Result;
    end Suite;

end SCIP_Ada.Tests.Suite;