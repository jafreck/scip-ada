with Ada.Strings.Fixed;
with Libadalang.Analysis;
with Libadalang.Common;

package body SCIP_Ada.LAL.Docs is

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

   --  Strip the comment prefix ("-- ", "--!", "--- ", etc.) from a line.
   function Strip_Comment_Prefix (Line : String) return String is
      S : constant String := Ada.Strings.Fixed.Trim
        (Line, Ada.Strings.Both);
   begin
      if S'Length >= 3 and then S (S'First .. S'First + 2) = "---" then
         return Ada.Strings.Fixed.Trim
           (S (S'First + 3 .. S'Last), Ada.Strings.Left);
      elsif S'Length >= 3 and then S (S'First .. S'First + 2) = "--!" then
         return Ada.Strings.Fixed.Trim
           (S (S'First + 3 .. S'Last), Ada.Strings.Left);
      elsif S'Length >= 2 and then S (S'First .. S'First + 1) = "--" then
         return Ada.Strings.Fixed.Trim
           (S (S'First + 2 .. S'Last), Ada.Strings.Left);
      end if;
      return S;
   end Strip_Comment_Prefix;

   --  Extract leading comment text by walking backward from a node's
   --  first token through comment/whitespace trivia tokens.
   function Extract_Leading_Comment
     (Node : Ada_Node'Class) return Unbounded_String
   is
      Tok : Token_Reference := Token_Start (Node);
      --  Collect comment lines in reverse order, then reverse them
      type Line_Array is
        array (1 .. 200) of Unbounded_String;
      Lines : Line_Array;
      Count : Natural := 0;
   begin
      --  Move to the token before the declaration's first token
      Tok := Previous (Tok);

      --  Walk backward through trivia (comments and whitespace)
      while Tok /= No_Token and then Is_Trivia (Tok) loop
         declare
            TD   : constant Token_Data_Type := Data (Tok);
            TK   : constant Token_Kind := Kind (TD);
         begin
            if TK = Ada_Comment then
               declare
                  Raw : constant String := W (Text (Tok));
                  Stripped : constant String :=
                    Strip_Comment_Prefix (Raw);
               begin
                  Count := Count + 1;
                  Lines (Count) := To_Unbounded_String (Stripped);
               end;
            elsif TK = Ada_Whitespace then
               --  Check for blank lines (multiple newlines = paragraph break)
               declare
                  WS : constant String := W (Text (Tok));
                  NL_Count : Natural := 0;
               begin
                  for C of WS loop
                     if C = ASCII.LF then
                        NL_Count := NL_Count + 1;
                     end if;
                  end loop;
                  --  A blank line (2+ newlines) means the comments above
                  --  are not part of this declaration's doc
                  if NL_Count > 1 then
                     exit;
                  end if;
               end;
            else
               exit;  --  non-trivia token found, stop
            end if;
         end;
         Tok := Previous (Tok);
      end loop;

      if Count = 0 then
         return Null_Unbounded_String;
      end if;

      --  Reverse the collected lines (they're in reverse order)
      declare
         Result : Unbounded_String;
      begin
         for I in reverse 1 .. Count loop
            if I < Count then
               Append (Result, ASCII.LF);
            end if;
            Append (Result, Lines (I));
         end loop;
         return Result;
      end;
   end Extract_Leading_Comment;

   procedure Collect_Docs
     (Node   : Ada_Node'Class;
      Result : in out Doc_Vectors.Vector);

   procedure Collect_Docs
     (Node   : Ada_Node'Class;
      Result : in out Doc_Vectors.Vector)
   is
   begin
      if Node.Is_Null then
         return;
      end if;

      case Node.Kind is
         when Ada_Subp_Decl | Ada_Subp_Body | Ada_Type_Decl |
              Ada_Object_Decl | Ada_Package_Decl | Ada_Package_Body |
              Ada_Generic_Package_Decl | Ada_Generic_Subp_Decl |
              Ada_Subtype_Decl | Ada_Number_Decl |
              Ada_Exception_Decl | Ada_Package_Renaming_Decl |
              Ada_Generic_Package_Instantiation |
              Ada_Generic_Subp_Instantiation =>
            declare
               Name_Node : constant Defining_Name :=
                 Node.As_Basic_Decl.P_Defining_Name;
            begin
               if not Name_Node.Is_Null then
                  declare
                     Doc_Text : constant Unbounded_String :=
                       Extract_Leading_Comment (Node);
                  begin
                     if Length (Doc_Text) > 0 then
                        Result.Append
                          (Doc_Info'
                             (Entity_Name =>
                                To_Unbounded_String
                                  (W (Name_Node.Text)),
                              Line        =>
                                Positive
                                  (Name_Node.Sloc_Range.Start_Line),
                              Doc_Comment => Doc_Text));
                     end if;
                  end;
               end if;
            exception
               when others =>
                  null;
            end;
         when others =>
            null;
      end case;

      for I in 1 .. Node.Children_Count loop
         if not Node.Child (I).Is_Null then
            Collect_Docs (Node.Child (I), Result);
         end if;
      end loop;
   end Collect_Docs;

   function Extract_Docs
     (Source_Path : String) return Doc_Vectors.Vector
   is
      Ctx  : constant Analysis_Context := Create_Context;
      Unit : constant Analysis_Unit :=
        Ctx.Get_From_File (Source_Path);
      Result : Doc_Vectors.Vector;
   begin
      if not Unit.Root.Is_Null then
         Collect_Docs (Unit.Root, Result);
      end if;
      return Result;
   end Extract_Docs;

end SCIP_Ada.LAL.Docs;
