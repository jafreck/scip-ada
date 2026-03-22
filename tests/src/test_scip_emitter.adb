with AUnit.Assertions;
with Ada.Streams;
with Ada.Streams.Stream_IO;
with Ada.Strings.Unbounded;
with Ada.Directories;
with SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Emitter;

package body Test_SCIP_Emitter is

   use Ada.Strings.Unbounded;
   use SCIP_Ada.ALI.Types;

   Output_File : constant String := "test_output.scip";

   function Make_Test_ALI return ALI_File is
      AF   : ALI_File;
      Sec  : XRef_Section;
      Ent  : Entity_Def;
      Ref1 : Reference;
   begin
      AF.Files.Append ((Path => To_Unbounded_String ("src/hello.adb")));

      Ent.File_Index := 1;
      Ent.Line       := 3;
      Ent.Column     := 4;
      Ent.Kind       := Procedure_Entity;
      Ent.Name       := To_Unbounded_String ("Hello");

      Ref1.File_Index := 1;
      Ref1.Line       := 10;
      Ref1.Column     := 7;
      Ref1.Kind       := Static_Call;
      Ent.References.Append (Ref1);

      Sec.File_Index := 1;
      Sec.Entities.Append (Ent);
      AF.Sections.Append (Sec);

      return AF;
   end Make_Test_ALI;

   function Read_Output return Ada.Streams.Stream_Element_Array is
      Size : constant Natural :=
        Natural (Ada.Directories.Size (Output_File));
      F    : Ada.Streams.Stream_IO.File_Type;
      Data : Ada.Streams.Stream_Element_Array
        (1 .. Ada.Streams.Stream_Element_Offset (Size));
      Last : Ada.Streams.Stream_Element_Offset;
   begin
      Ada.Streams.Stream_IO.Open
        (F, Ada.Streams.Stream_IO.In_File, Output_File);
      Ada.Streams.Stream_IO.Read (F, Data, Last);
      Ada.Streams.Stream_IO.Close (F);
      return Data (1 .. Last);
   end Read_Output;

   function Contains_Bytes
     (Data   : Ada.Streams.Stream_Element_Array;
      Target : String) return Boolean
   is
      use type Ada.Streams.Stream_Element;
      use type Ada.Streams.Stream_Element_Offset;
   begin
      if Target'Length = 0 then
         return True;
      end if;
      if Data'Length < Target'Length then
         return False;
      end if;
      for I in Data'First ..
        Data'Last - Ada.Streams.Stream_Element_Offset (Target'Length) + 1
      loop
         declare
            Match : Boolean := True;
         begin
            for J in 0 .. Target'Length - 1 loop
               if Data (I + Ada.Streams.Stream_Element_Offset (J)) /=
                 Ada.Streams.Stream_Element
                   (Character'Pos (Target (Target'First + J)))
               then
                  Match := False;
                  exit;
               end if;
            end loop;
            if Match then
               return True;
            end if;
         end;
      end loop;
      return False;
   end Contains_Bytes;

   procedure Write_Test_Output is
      AF : constant ALI_File := Make_Test_ALI;
   begin
      SCIP_Ada.SCIP.Emitter.Emit
        (ALI_Data     => AF,
         Output_Path  => Output_File,
         Project_Root => "file:///test/project");
   end Write_Test_Output;

   procedure Assert_Non_Empty_Output (Message : String) is
   begin
      AUnit.Assertions.Assert
        (Ada.Directories.Exists (Output_File)
         and then Natural (Ada.Directories.Size (Output_File)) > 0,
         Message);
   end Assert_Non_Empty_Output;

   procedure Test_Emit_Creates_Non_Empty_File
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
      AF : constant ALI_File := Make_Test_ALI;
   begin
      SCIP_Ada.SCIP.Emitter.Emit
        (ALI_Data     => AF,
         Output_Path  => Output_File,
         Project_Root => "file:///test/project");
      Assert_Non_Empty_Output ("Emit did not create a non-empty file");
   end Test_Emit_Creates_Non_Empty_File;

   procedure Test_Output_Starts_With_Metadata_Tag
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
      use type Ada.Streams.Stream_Element;
   begin
      Write_Test_Output;
      declare
         D : constant Ada.Streams.Stream_Element_Array := Read_Output;
      begin
         AUnit.Assertions.Assert
           (D'Length > 0
            and then D (D'First) = Ada.Streams.Stream_Element (16#0A#),
            "Output does not start with metadata tag 16#0A#");
      end;
   end Test_Output_Starts_With_Metadata_Tag;

   procedure Test_Output_Contains_Tool_Name
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Write_Test_Output;
      AUnit.Assertions.Assert
        (Contains_Bytes (Read_Output, "scip-ada"),
         "Output does not contain 'scip-ada'");
   end Test_Output_Contains_Tool_Name;

   procedure Test_Output_Contains_Relative_Path
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Write_Test_Output;
      AUnit.Assertions.Assert
        (Contains_Bytes (Read_Output, "src/hello.adb"),
         "Output does not contain the expected relative path");
   end Test_Output_Contains_Relative_Path;

   procedure Test_Output_Contains_Entity_Name
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Write_Test_Output;
      AUnit.Assertions.Assert
        (Contains_Bytes (Read_Output, "Hello"),
         "Output does not contain the expected entity name");
   end Test_Output_Contains_Entity_Name;

   procedure Test_Emit_Empty_ALI_Creates_Output
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
      Empty_AF : ALI_File;
   begin
      SCIP_Ada.SCIP.Emitter.Emit
        (ALI_Data     => Empty_AF,
         Output_Path  => Output_File,
         Project_Root => "file:///empty");
      Assert_Non_Empty_Output
        ("Emit with an empty ALI file did not create output");
   end Test_Emit_Empty_ALI_Creates_Output;

end Test_SCIP_Emitter;
