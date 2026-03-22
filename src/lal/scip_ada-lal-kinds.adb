with Libadalang.Analysis;
with Libadalang.Common;

package body SCIP_Ada.LAL.Kinds is

   use Libadalang.Analysis;
   use Libadalang.Common;

   --  SCIP kind constants
   SCIP_Class     : constant := 7;
   SCIP_Interface : constant := 21;

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

   procedure Collect_Kind_Overrides
     (Node   : Ada_Node'Class;
      Result : in out Kind_Override_Vectors.Vector);

   procedure Collect_Kind_Overrides
     (Node   : Ada_Node'Class;
      Result : in out Kind_Override_Vectors.Vector)
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
               if not Def.Is_Null and then not Name.Is_Null then
                  declare
                     Name_Str : constant String := W (Name.Text);
                     Name_Line : constant Positive :=
                       Positive (Name.Sloc_Range.Start_Line);
                  begin
                     case Def.Kind is
                        --  Interface types → Interface (21)
                        when Ada_Interface_Type_Def =>
                           Result.Append
                             (Kind_Override_Info'
                                (Entity_Name  =>
                                   To_Unbounded_String (Name_Str),
                                 Line         => Name_Line,
                                 Kind_Value   => SCIP_Interface,
                                 Display_Name =>
                                   To_Unbounded_String (Name_Str)));

                        --  Record types: check for abstract tagged
                        when Ada_Record_Type_Def =>
                           declare
                              RTD : constant Record_Type_Def :=
                                Def.As_Record_Type_Def;
                              HA  : constant Abstract_Node :=
                                RTD.F_Has_Abstract;
                           begin
                              if not HA.Is_Null
                                and then HA.Kind = Ada_Abstract_Present
                              then
                                 --  Abstract tagged record → Class
                                 --  with "abstract" display name
                                 Result.Append
                                   (Kind_Override_Info'
                                      (Entity_Name  =>
                                         To_Unbounded_String (Name_Str),
                                       Line         => Name_Line,
                                       Kind_Value   => SCIP_Class,
                                       Display_Name =>
                                         To_Unbounded_String
                                           ("abstract " & Name_Str)));
                              end if;
                           end;

                        --  Derived types: check for abstract
                        when Ada_Derived_Type_Def =>
                           declare
                              DTD : constant Derived_Type_Def :=
                                Def.As_Derived_Type_Def;
                              HA  : constant Abstract_Node :=
                                DTD.F_Has_Abstract;
                           begin
                              if not HA.Is_Null
                                and then HA.Kind = Ada_Abstract_Present
                              then
                                 --  Abstract derived type → Class
                                 --  with "abstract" display name
                                 Result.Append
                                   (Kind_Override_Info'
                                      (Entity_Name  =>
                                         To_Unbounded_String (Name_Str),
                                       Line         => Name_Line,
                                       Kind_Value   => SCIP_Class,
                                       Display_Name =>
                                         To_Unbounded_String
                                           ("abstract " & Name_Str)));
                              end if;
                           end;

                        when others =>
                           null;
                     end case;
                  end;
               end if;
            end;

         when others =>
            null;
      end case;

      for I in 1 .. Node.Children_Count loop
         if not Node.Child (I).Is_Null then
            Collect_Kind_Overrides (Node.Child (I), Result);
         end if;
      end loop;
   end Collect_Kind_Overrides;

   function Extract_Kind_Overrides
     (Source_Path : String) return Kind_Override_Vectors.Vector
   is
      Ctx  : constant Analysis_Context := Create_Context;
      Unit : constant Analysis_Unit :=
        Ctx.Get_From_File (Source_Path);
      Result : Kind_Override_Vectors.Vector;
   begin
      if not Unit.Root.Is_Null then
         Collect_Kind_Overrides (Unit.Root, Result);
      end if;
      return Result;
   end Extract_Kind_Overrides;

end SCIP_Ada.LAL.Kinds;
