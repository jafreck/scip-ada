with Libadalang.Analysis;
with Libadalang.Common;
with Ada.Strings.Unbounded;

package body SCIP_Ada.LAL.Relationships is

   use Ada.Strings.Unbounded;
   use Libadalang.Analysis;
   use Libadalang.Common;

   function W (S : Wide_Wide_String) return String is
      Result : String (1 .. S'Length);
   begin
      for I in S'Range loop
         if Wide_Wide_Character'Pos (S (I)) < 128 then
            Result (I - S'First + 1) :=
              Character'Val (Wide_Wide_Character'Pos (S (I)));
         else
            Result (I - S'First + 1) := '?';
         end if;
      end loop;
      return Result;
   end W;

   procedure Collect_Relationships
     (Node   : Ada_Node'Class;
      Result : in out Relationship_Vectors.Vector);

   procedure Collect_Relationships
     (Node   : Ada_Node'Class;
      Result : in out Relationship_Vectors.Vector)
   is
   begin
      if Node.Is_Null then
         return;
      end if;

      case Node.Kind is
         when Ada_Type_Decl =>
            declare
               TD   : constant Type_Decl := Node.As_Type_Decl;
               Def  : constant Type_Def := TD.F_Type_Def;
               Name : constant Defining_Name := TD.F_Name;
            begin
               if not Def.Is_Null
                 and then not Name.Is_Null
                 and then Def.Kind = Ada_Derived_Type_Def
               then
                  declare
                     DTD    : constant Derived_Type_Def :=
                       Def.As_Derived_Type_Def;
                     Parent : constant Subtype_Indication :=
                       DTD.F_Subtype_Indication;
                  begin
                     if not Parent.Is_Null then
                        Result.Append
                          (Relationship_Info'
                             (Child_Name  =>
                                To_Unbounded_String (W (Name.Text)),
                              Child_Line  =>
                                Positive (Name.Sloc_Range.Start_Line),
                              Parent_Name =>
                                To_Unbounded_String
                                  (W (Parent.F_Name.Text)),
                              Kind        => Extends));
                     end if;
                     if DTD.F_Interfaces.Children_Count > 0 then
                        for I in 1 .. DTD.F_Interfaces.Children_Count
                        loop
                           declare
                              Iface : constant Ada_Node :=
                                DTD.F_Interfaces.Child (I);
                           begin
                              if not Iface.Is_Null then
                                 Result.Append
                                   (Relationship_Info'
                                      (Child_Name  =>
                                         To_Unbounded_String
                                           (W (Name.Text)),
                                       Child_Line  =>
                                         Positive
                                           (Name.Sloc_Range.Start_Line),
                                       Parent_Name =>
                                         To_Unbounded_String
                                           (W (Iface.Text)),
                                       Kind        => Implements));
                              end if;
                           end;
                        end loop;
                     end if;
                  end;
               end if;
            end;
         when Ada_Subp_Decl =>
            declare
               SD   : constant Subp_Decl := Node.As_Subp_Decl;
               OI   : constant Overriding_Node := SD.F_Overriding;
            begin
               if not OI.Is_Null
                 and then OI.Kind = Ada_Overriding_Overriding
               then
                  declare
                     Spec : constant Subp_Spec := SD.F_Subp_Spec;
                     Name : constant Defining_Name := Spec.F_Subp_Name;
                  begin
                     if not Name.Is_Null then
                        Result.Append
                          (Relationship_Info'
                             (Child_Name  =>
                                To_Unbounded_String (W (Name.Text)),
                              Child_Line  =>
                                Positive (Name.Sloc_Range.Start_Line),
                              Parent_Name =>
                                To_Unbounded_String (W (Name.Text)),
                              Kind        => Overrides));
                     end if;
                  end;
               end if;
            end;

         when Ada_Subp_Body =>
            declare
               SB   : constant Subp_Body := Node.As_Subp_Body;
               OI   : constant Overriding_Node := SB.F_Overriding;
            begin
               if not OI.Is_Null
                 and then OI.Kind = Ada_Overriding_Overriding
               then
                  declare
                     Spec : constant Subp_Spec := SB.F_Subp_Spec;
                     Name : constant Defining_Name := Spec.F_Subp_Name;
                  begin
                     if not Name.Is_Null then
                        Result.Append
                          (Relationship_Info'
                             (Child_Name  =>
                                To_Unbounded_String (W (Name.Text)),
                              Child_Line  =>
                                Positive (Name.Sloc_Range.Start_Line),
                              Parent_Name =>
                                To_Unbounded_String (W (Name.Text)),
                              Kind        => Overrides));
                     end if;
                  end;
               end if;
            end;

         when others =>
            null;
      end case;

      for I in 1 .. Node.Children_Count loop
         if not Node.Child (I).Is_Null then
            Collect_Relationships (Node.Child (I), Result);
         end if;
      end loop;
   end Collect_Relationships;

   function Extract_Relationships
     (Source_Path : String) return Relationship_Vectors.Vector
   is
      Ctx  : constant Analysis_Context := Create_Context;
      Unit : constant Analysis_Unit :=
        Ctx.Get_From_File (Source_Path);
      Result : Relationship_Vectors.Vector;
   begin
      if not Unit.Root.Is_Null then
         Collect_Relationships (Unit.Root, Result);
      end if;
      return Result;
   end Extract_Relationships;

end SCIP_Ada.LAL.Relationships;
