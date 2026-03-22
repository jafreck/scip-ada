with Libadalang.Analysis;
with Libadalang.Common;
with Ada.Strings.Unbounded;

package body SCIP_Ada.LAL.Signatures is

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

   procedure Collect_Signatures
     (Node   : Ada_Node'Class;
      Result : in out Signature_Vectors.Vector);

   ---------------------------------------------------------------------------
   --  Format_Params — produce parameter + return type portion of signature
   ---------------------------------------------------------------------------

   function Format_Params (Spec : Subp_Spec'Class) return String is
      Buf : Unbounded_String;
   begin
      if not Spec.F_Subp_Params.Is_Null then
         Append (Buf, " (");
         declare
            Params : constant Param_Spec_List :=
              Spec.F_Subp_Params.F_Params;
            First  : Boolean := True;
         begin
            for I in 1 .. Params.Children_Count loop
               declare
                  P : constant Param_Spec := Params.Child (I).As_Param_Spec;
               begin
                  if not First then
                     Append (Buf, "; ");
                  end if;
                  First := False;
                  declare
                     Names : constant Defining_Name_List := P.F_Ids;
                     Name_First : Boolean := True;
                  begin
                     for J in 1 .. Names.Children_Count loop
                        if not Name_First then
                           Append (Buf, ", ");
                        end if;
                        Name_First := False;
                        Append (Buf, W (Names.Child (J).Text));
                     end loop;
                  end;
                  Append (Buf, " : ");
                  if P.F_Mode /= Ada_Mode_Default then
                     Append (Buf, W (P.F_Mode.Text) & " ");
                  end if;
                  if not P.F_Type_Expr.Is_Null then
                     Append (Buf, W (P.F_Type_Expr.Text));
                  end if;
               end;
            end loop;
         end;
         Append (Buf, ")");
      end if;
      if not Spec.F_Subp_Returns.Is_Null then
         Append (Buf, " return ");
         Append (Buf, W (Spec.F_Subp_Returns.Text));
      end if;
      return To_String (Buf);
   end Format_Params;

   ---------------------------------------------------------------------------
   --  Format_Generic_Formals — produce generic formal parameter text
   ---------------------------------------------------------------------------

   function Format_Generic_Formals (Decl : Generic_Subp_Decl'Class)
     return String
   is
      Buf    : Unbounded_String;
      Formals : constant Ada_Node := Decl.F_Formal_Part.As_Ada_Node;
      First  : Boolean := True;
   begin
      if Formals.Is_Null then
         return "";
      end if;
      Append (Buf, "generic");
      for I in 1 .. Formals.Children_Count loop
         declare
            Child : constant Ada_Node := Formals.Child (I);
         begin
            if not Child.Is_Null then
               if not First then
                  Append (Buf, ";");
               end if;
               First := False;
               Append (Buf, " ");
               Append (Buf, W (Child.Text));
            end if;
         end;
      end loop;
      Append (Buf, " ");
      return To_String (Buf);
   end Format_Generic_Formals;

   ---------------------------------------------------------------------------
   --  Build_Full_Signature — combine prefix + name + params into full sig
   ---------------------------------------------------------------------------

   procedure Add_Subp_Signature
     (Spec_Node : Subp_Spec'Class;
      Prefix    : String;
      Result    : in out Signature_Vectors.Vector)
   is
   begin
      if Spec_Node.Is_Null then
         return;
      end if;
      declare
         Name_Node : constant Defining_Name := Spec_Node.F_Subp_Name;
      begin
         if Name_Node.Is_Null then
            return;
         end if;
         declare
            Name    : constant String := W (Name_Node.Text);
            Params  : constant String := Format_Params (Spec_Node);
            Full    : constant String := Prefix & Name & Params;
         begin
            Result.Append
              (Signature_Info'
                 (Entity_Name    => To_Unbounded_String (Name),
                  Line           =>
                    Positive (Name_Node.Sloc_Range.Start_Line),
                  Column         =>
                    Positive (Name_Node.Sloc_Range.Start_Column),
                  Full_Signature => To_Unbounded_String (Full)));
         end;
      end;
   end Add_Subp_Signature;

   ---------------------------------------------------------------------------
   --  Subp_Kind_Prefix — "procedure " or "function " based on return type
   ---------------------------------------------------------------------------

   function Subp_Kind_Prefix (Spec : Subp_Spec'Class) return String is
   begin
      if not Spec.F_Subp_Returns.Is_Null then
         return "function ";
      else
         return "procedure ";
      end if;
   end Subp_Kind_Prefix;

   ---------------------------------------------------------------------------
   --  Collect_Signatures — recursive tree walker
   ---------------------------------------------------------------------------

   procedure Collect_Signatures
     (Node   : Ada_Node'Class;
      Result : in out Signature_Vectors.Vector)
   is
   begin
      if Node.Is_Null then
         return;
      end if;

      case Node.Kind is
         when Ada_Subp_Decl =>
            Add_Subp_Signature
              (Node.As_Subp_Decl.F_Subp_Spec,
               Subp_Kind_Prefix (Node.As_Subp_Decl.F_Subp_Spec),
               Result);

         when Ada_Subp_Body =>
            Add_Subp_Signature
              (Node.As_Subp_Body.F_Subp_Spec,
               Subp_Kind_Prefix (Node.As_Subp_Body.F_Subp_Spec),
               Result);

         when Ada_Expr_Function =>
            Add_Subp_Signature
              (Node.As_Expr_Function.F_Subp_Spec,
               "function ",
               Result);

         when Ada_Abstract_Subp_Decl =>
            Add_Subp_Signature
              (Node.As_Abstract_Subp_Decl.F_Subp_Spec,
               Subp_Kind_Prefix
                 (Node.As_Abstract_Subp_Decl.F_Subp_Spec),
               Result);

         when Ada_Generic_Subp_Decl =>
            --  Generic subprogram: prepend formal parameters
            declare
               GD       : constant Generic_Subp_Decl :=
                 Node.As_Generic_Subp_Decl;
               Inner    : constant Generic_Subp_Internal :=
                 GD.F_Subp_Decl;
               Spec_N   : constant Subp_Spec := Inner.F_Subp_Spec;
               Prefix   : constant String :=
                 Format_Generic_Formals (GD) &
                 Subp_Kind_Prefix (Spec_N);
            begin
               Add_Subp_Signature (Spec_N, Prefix, Result);
            end;

         when Ada_Null_Subp_Decl =>
            Add_Subp_Signature
              (Node.As_Null_Subp_Decl.F_Subp_Spec,
               Subp_Kind_Prefix (Node.As_Null_Subp_Decl.F_Subp_Spec),
               Result);

         when others =>
            null;
      end case;

      for I in 1 .. Node.Children_Count loop
         if not Node.Child (I).Is_Null then
            Collect_Signatures (Node.Child (I), Result);
         end if;
      end loop;
   end Collect_Signatures;

   ---------------------------------------------------------------------------
   --  Extract_Signatures — public entry point
   ---------------------------------------------------------------------------

   function Extract_Signatures
     (Source_Path : String) return Signature_Vectors.Vector
   is
      Ctx  : constant Analysis_Context := Create_Context;
      Unit : constant Analysis_Unit :=
        Ctx.Get_From_File (Source_Path);
      Result : Signature_Vectors.Vector;
   begin
      if not Unit.Root.Is_Null then
         Collect_Signatures (Unit.Root, Result);
      end if;
      return Result;
   end Extract_Signatures;

end SCIP_Ada.LAL.Signatures;
