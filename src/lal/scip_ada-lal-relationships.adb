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

   --  Walk up parent nodes to build a dot-separated scope chain.
   --  Returns e.g. "Shapes.Shape" for a method inside type Shape
   --  in package Shapes.
   function Build_Scope_Chain (Node : Ada_Node'Class) return String is
      Result  : Unbounded_String;
      Current : Ada_Node := Node.Parent;
   begin
      while not Current.Is_Null loop
         case Current.Kind is
            when Ada_Package_Decl =>
               declare
                  PD : constant Package_Decl :=
                    Current.As_Package_Decl;
                  PN : constant Defining_Name := PD.F_Package_Name;
               begin
                  if not PN.Is_Null then
                     if Length (Result) > 0 then
                        Result :=
                          To_Unbounded_String (W (PN.Text))
                          & "." & Result;
                     else
                        Result := To_Unbounded_String (W (PN.Text));
                     end if;
                  end if;
               end;
            when Ada_Package_Body =>
               declare
                  PB : constant Package_Body :=
                    Current.As_Package_Body;
                  PN : constant Defining_Name :=
                    PB.F_Package_Name;
               begin
                  if not PN.Is_Null then
                     if Length (Result) > 0 then
                        Result :=
                          To_Unbounded_String (W (PN.Text))
                          & "." & Result;
                     else
                        Result := To_Unbounded_String (W (PN.Text));
                     end if;
                  end if;
               end;
            when Ada_Type_Decl =>
               declare
                  TD : constant Type_Decl := Current.As_Type_Decl;
                  TN : constant Defining_Name := TD.F_Name;
               begin
                  if not TN.Is_Null then
                     if Length (Result) > 0 then
                        Result :=
                          To_Unbounded_String (W (TN.Text))
                          & "." & Result;
                     else
                        Result := To_Unbounded_String (W (TN.Text));
                     end if;
                  end if;
               end;
            when others =>
               null;
         end case;
         Current := Current.Parent;
      end loop;
      return To_String (Result);
   end Build_Scope_Chain;

   --  Try to resolve a Name node to its declaration and build the
   --  scope chain from that declaration.  Returns empty string on
   --  any failure.
   function Resolve_Scope (N : Name'Class) return String is
   begin
      declare
         Decl : constant Basic_Decl := N.P_Referenced_Decl;
      begin
         if Decl.Is_Null then
            return "";
         end if;
         return Build_Scope_Chain (Decl.As_Ada_Node);
      end;
   exception
      when others =>
         return "";
   end Resolve_Scope;

   --  Try to resolve the base subprogram declarations for an
   --  overriding subprogram and return (Parent_Name, Parent_Scope).
   --  Falls back to (own name, "") on any failure.
   procedure Resolve_Override_Target
     (Subp_Node    : Basic_Decl'Class;
      Own_Name     : String;
      Parent_Name  : out Unbounded_String;
      Parent_Scope : out Unbounded_String)
   is
   begin
      Parent_Name  := To_Unbounded_String (Own_Name);
      Parent_Scope := Null_Unbounded_String;

      --  Try to find the base declaration via P_Base_Subp_Declarations
      declare
         Bases : constant Basic_Decl_Array :=
           Subp_Node.P_Base_Subp_Declarations;
      begin
         if Bases'Length > 0 then
            for B of Bases loop
               --  Skip the node itself: we want the base, not self
               if B /= Basic_Decl (Subp_Node) then
                  declare
                     Base_Name : constant Defining_Name :=
                       B.P_Defining_Name;
                  begin
                     if not Base_Name.Is_Null then
                        Parent_Name :=
                          To_Unbounded_String (W (Base_Name.Text));
                        Parent_Scope :=
                          To_Unbounded_String
                            (Build_Scope_Chain (B.As_Ada_Node));
                     end if;
                  end;
                  exit;  --  use first non-self base
               end if;
            end loop;
         end if;
      end;
   exception
      when others =>
         null;  --  keep fallback values
   end Resolve_Override_Target;

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
                        declare
                           P_Name : constant String :=
                             W (Parent.F_Name.Text);
                           P_Scope : Unbounded_String :=
                             Null_Unbounded_String;
                        begin
                           --  Try to resolve the parent type's scope
                           begin
                              P_Scope := To_Unbounded_String
                                (Resolve_Scope (Parent.F_Name));
                           exception
                              when others => null;
                           end;
                           Result.Append
                             (Relationship_Info'
                                (Child_Name   =>
                                   To_Unbounded_String (W (Name.Text)),
                                 Child_Line   =>
                                   Positive
                                     (Name.Sloc_Range.Start_Line),
                                 Parent_Name  =>
                                   To_Unbounded_String (P_Name),
                                 Parent_Scope => P_Scope,
                                 Kind         => Extends));
                        end;
                     end if;
                     if DTD.F_Interfaces.Children_Count > 0 then
                        for I in 1 .. DTD.F_Interfaces.Children_Count
                        loop
                           declare
                              Iface : constant Ada_Node :=
                                DTD.F_Interfaces.Child (I);
                           begin
                              if not Iface.Is_Null then
                                 declare
                                    I_Scope : Unbounded_String :=
                                      Null_Unbounded_String;
                                 begin
                                    begin
                                       I_Scope :=
                                         To_Unbounded_String
                                           (Resolve_Scope
                                              (Iface.As_Name));
                                    exception
                                       when others => null;
                                    end;
                                    Result.Append
                                      (Relationship_Info'
                                         (Child_Name   =>
                                            To_Unbounded_String
                                              (W (Name.Text)),
                                          Child_Line   =>
                                            Positive
                                              (Name.Sloc_Range
                                                 .Start_Line),
                                          Parent_Name  =>
                                            To_Unbounded_String
                                              (W (Iface.Text)),
                                          Parent_Scope => I_Scope,
                                          Kind         => Implements));
                                 end;
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
                        declare
                           P_Name  : Unbounded_String;
                           P_Scope : Unbounded_String;
                        begin
                           Resolve_Override_Target
                             (SD.As_Basic_Decl,
                              W (Name.Text),
                              P_Name, P_Scope);
                           Result.Append
                             (Relationship_Info'
                                (Child_Name   =>
                                   To_Unbounded_String
                                     (W (Name.Text)),
                                 Child_Line   =>
                                   Positive
                                     (Name.Sloc_Range.Start_Line),
                                 Parent_Name  => P_Name,
                                 Parent_Scope => P_Scope,
                                 Kind         => Overrides));
                        end;
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
                        declare
                           P_Name  : Unbounded_String;
                           P_Scope : Unbounded_String;
                        begin
                           Resolve_Override_Target
                             (SB.As_Basic_Decl,
                              W (Name.Text),
                              P_Name, P_Scope);
                           Result.Append
                             (Relationship_Info'
                                (Child_Name   =>
                                   To_Unbounded_String
                                     (W (Name.Text)),
                                 Child_Line   =>
                                   Positive
                                     (Name.Sloc_Range.Start_Line),
                                 Parent_Name  => P_Name,
                                 Parent_Scope => P_Scope,
                                 Kind         => Overrides));
                        end;
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
