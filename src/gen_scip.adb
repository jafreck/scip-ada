with Ada.Strings.Unbounded;
with Ada.Text_IO;
with SCIP_Ada.ALI.Types;
with SCIP_Ada.SCIP.Emitter;
procedure Gen_SCIP is
   use Ada.Strings.Unbounded;
   use SCIP_Ada.ALI.Types;
   AF   : ALI_File;
   Sec  : XRef_Section;
   Ent  : Entity_Def;
   Ent2 : Entity_Def;
   Ref1 : Reference;
   Ref2 : Reference;
begin
   AF.Files.Append ((Path => To_Unbounded_String ("src/greet.ads")));
   AF.Files.Append ((Path => To_Unbounded_String ("src/greet.adb")));
   Ent.File_Index := 1;
   Ent.Line       := 1;
   Ent.Column     := 9;
   Ent.Kind       := Package_Entity;
   Ent.Name       := To_Unbounded_String ("Greet");
   Ref1.File_Index := 2;
   Ref1.Line       := 1;
   Ref1.Column     := 14;
   Ref1.Kind       := Body_Ref;
   Ent.References.Append (Ref1);
   Sec.File_Index := 1;
   Sec.Entities.Append (Ent);
   Ent2.File_Index := 1;
   Ent2.Line       := 3;
   Ent2.Column     := 14;
   Ent2.Kind       := Procedure_Entity;
   Ent2.Name       := To_Unbounded_String ("Say_Hello");
   Ref2.File_Index := 2;
   Ref2.Line       := 5;
   Ref2.Column     := 4;
   Ref2.Kind       := Static_Call;
   Ent2.References.Append (Ref2);
   Sec.Entities.Append (Ent2);
   AF.Sections.Append (Sec);
   SCIP_Ada.SCIP.Emitter.Emit
     (ALI_Data     => AF,
      Output_Path  => "index.scip",
      Project_Root => "file:///test/project");
   Ada.Text_IO.Put_Line ("index.scip generated");
end Gen_SCIP;
