with Ada.Text_IO;
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

   procedure Cleanup is
   begin
      if Ada.Directories.Exists (Output_File) then
         Ada.Directories.Delete_File (Output_File);
      end if;
   end Cleanup;

   procedure Run (Passed : out Natural; Failed : out Natural) is
      AF : constant ALI_File := Make_Test_ALI;
   begin
      Passed := 0;
      Failed := 0;
      Cleanup;

      --  Test 1: Emit creates non-empty file
      begin
         SCIP_Ada.SCIP.Emitter.Emit
           (ALI_Data     => AF,
            Output_Path  => Output_File,
            Project_Root => "file:///test/project");

         if Ada.Directories.Exists (Output_File)
           and then Natural (Ada.Directories.Size (Output_File)) > 0
         then
            Ada.Text_IO.Put_Line ("    PASS: Emit creates non-empty file");
            Passed := Passed + 1;
         else
            Ada.Text_IO.Put_Line
              ("    FAIL: Emit did not create file or file is empty");
            Failed := Failed + 1;
         end if;
      exception
         when others =>
            Ada.Text_IO.Put_Line ("    FAIL: Emit raised exception");
            Failed := Failed + 1;
      end;

      --  Test 2: Output starts with metadata tag 0x0A
      declare
         use type Ada.Streams.Stream_Element;
         D : constant Ada.Streams.Stream_Element_Array := Read_Output;
      begin
         if D'Length > 0
           and then D (D'First) = Ada.Streams.Stream_Element (16#0A#)
         then
            Ada.Text_IO.Put_Line
              ("    PASS: Output starts with metadata tag 0x0A");
            Passed := Passed + 1;
         else
            Ada.Text_IO.Put_Line
              ("    FAIL: Output does not start with metadata tag");
            Failed := Failed + 1;
         end if;
      exception
         when others =>
            Ada.Text_IO.Put_Line
              ("    FAIL: Could not read output for tag check");
            Failed := Failed + 1;
      end;

      --  Test 3: Output contains "scip-ada" tool name
      begin
         if Contains_Bytes (Read_Output, "scip-ada") then
            Ada.Text_IO.Put_Line
              ("    PASS: Output contains 'scip-ada' tool name");
            Passed := Passed + 1;
         else
            Ada.Text_IO.Put_Line
              ("    FAIL: Output does not contain 'scip-ada'");
            Failed := Failed + 1;
         end if;
      exception
         when others =>
            Ada.Text_IO.Put_Line
              ("    FAIL: Exception searching for tool name");
            Failed := Failed + 1;
      end;

      --  Test 4: Output contains relative path
      begin
         if Contains_Bytes (Read_Output, "src/hello.adb") then
            Ada.Text_IO.Put_Line
              ("    PASS: Output contains 'src/hello.adb' path");
            Passed := Passed + 1;
         else
            Ada.Text_IO.Put_Line
              ("    FAIL: Output does not contain expected path");
            Failed := Failed + 1;
         end if;
      exception
         when others =>
            Ada.Text_IO.Put_Line
              ("    FAIL: Exception searching for path");
            Failed := Failed + 1;
      end;

      --  Test 5: Output contains "Hello" entity name
      begin
         if Contains_Bytes (Read_Output, "Hello") then
            Ada.Text_IO.Put_Line
              ("    PASS: Output contains 'Hello' entity name");
            Passed := Passed + 1;
         else
            Ada.Text_IO.Put_Line
              ("    FAIL: Output does not contain 'Hello'");
            Failed := Failed + 1;
         end if;
      exception
         when others =>
            Ada.Text_IO.Put_Line
              ("    FAIL: Exception searching for entity name");
            Failed := Failed + 1;
      end;

      --  Test 6: Emit with empty ALI still creates output
      begin
         Cleanup;
         declare
            Empty_AF : ALI_File;
         begin
            SCIP_Ada.SCIP.Emitter.Emit
              (ALI_Data     => Empty_AF,
               Output_Path  => Output_File,
               Project_Root => "file:///empty");

            if Ada.Directories.Exists (Output_File)
              and then Natural (Ada.Directories.Size (Output_File)) > 0
            then
               Ada.Text_IO.Put_Line
                 ("    PASS: Emit with empty ALI creates output");
               Passed := Passed + 1;
            else
               Ada.Text_IO.Put_Line
                 ("    FAIL: Emit with empty ALI failed");
               Failed := Failed + 1;
            end if;
         end;
      exception
         when others =>
            Ada.Text_IO.Put_Line
              ("    FAIL: Emit with empty ALI raised exception");
            Failed := Failed + 1;
      end;

      Cleanup;
   end Run;

end Test_SCIP_Emitter;
