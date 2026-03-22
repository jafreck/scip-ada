with Ada.Text_IO;
with Ada.Strings.Unbounded;

package body SCIP_Ada.ALI.Parser is

   use Ada.Text_IO;
   use Ada.Strings.Unbounded;
   use Types;

   ---------------------------------------------------------------------------
   --  Character classification helpers
   ---------------------------------------------------------------------------

   function Is_Digit (C : Character) return Boolean is
     (C in '0' .. '9');

   function Is_Letter (C : Character) return Boolean is
     (C in 'A' .. 'Z' | 'a' .. 'z');

   function Is_Entity_Type_Char (C : Character) return Boolean is
     (Is_Letter (C) or else C = '+' or else C = '*');

   function Is_Ref_Kind_Char (C : Character) return Boolean is
     (C in 'b' | 'c' | 'd' | 'e' | 'i' | 'l' | 'm' | 'o' | 'p' |
           'r' | 's' | 't' | 'w' | 'x' | 'z' |
           'D' | 'E' | 'H' | 'P' | 'R');

   ---------------------------------------------------------------------------
   --  Parse_Natural — read a decimal integer, advance Pos past the digits.
   --  Pre: Line(Pos) is a digit.
   ---------------------------------------------------------------------------

   procedure Parse_Natural
     (Line  : String;
      Pos   : in out Natural;
      Value : out Natural)
   is
   begin
      Value := 0;
      while Pos <= Line'Last and then Is_Digit (Line (Pos)) loop
         Value := Value * 10 +
           (Character'Pos (Line (Pos)) - Character'Pos ('0'));
         Pos := Pos + 1;
      end loop;
   end Parse_Natural;

   ---------------------------------------------------------------------------
   --  Skip_Brackets — skip past balanced [...] or {...}, advancing Pos.
   ---------------------------------------------------------------------------

   procedure Skip_Brackets
     (Line    : String;
      Pos     : in out Natural;
      Open_Ch : Character;
      Close_Ch : Character)
   is
      Depth : Natural := 1;
   begin
      Pos := Pos + 1;  --  skip opening bracket
      while Pos <= Line'Last and then Depth > 0 loop
         if Line (Pos) = Open_Ch then
            Depth := Depth + 1;
         elsif Line (Pos) = Close_Ch then
            Depth := Depth - 1;
         end if;
         Pos := Pos + 1;
      end loop;
   end Skip_Brackets;

   ---------------------------------------------------------------------------
   --  Parse_D_Line — parse a D (dependency) line
   --  Format: D source-file-name timestamp checksum [unit-name] [line:file]
   ---------------------------------------------------------------------------

   procedure Parse_D_Line
     (Line  : String;
      Files : in out File_Entry_Vectors.Vector)
   is
      Pos : Natural := Line'First + 2;   --  skip "D "
      Start : constant Natural := Pos;
   begin
      --  File name ends at next space, tab, or end-of-line
      while Pos <= Line'Last
        and then Line (Pos) /= ' '
        and then Line (Pos) /= Character'Val (9)
      loop
         Pos := Pos + 1;
      end loop;
      Files.Append ((Path => To_Unbounded_String (Line (Start .. Pos - 1))));
   end Parse_D_Line;

   ---------------------------------------------------------------------------
   --  Parse_X_Header — parse an X (cross-reference section) header
   --  Format: X file-number source-file-name
   ---------------------------------------------------------------------------

   procedure Parse_X_Header
     (Line     : String;
      File_Idx : out Positive)
   is
      Pos : Natural := Line'First + 2;   --  skip "X "
      Val : Natural;
   begin
      Parse_Natural (Line, Pos, Val);
      File_Idx := Positive (Val);
   end Parse_X_Header;

   ---------------------------------------------------------------------------
   --  Parse_References — parse space-separated reference entries.
   --  Format per ref: [file|]line ref_kind col [{inst}] [[inst]]
   ---------------------------------------------------------------------------

   procedure Parse_References
     (Line         : String;
      Pos          : in out Natural;
      Current_File : Positive;
      Refs         : in out Reference_Vectors.Vector)
   is
      File_Idx  : Positive;
      Line_Num  : Natural;
      Col_Num   : Natural;
      Kind_Char : Character;
   begin
      loop
         --  Skip whitespace
         while Pos <= Line'Last and then Line (Pos) = ' ' loop
            Pos := Pos + 1;
         end loop;
         exit when Pos > Line'Last;

         --  Skip generic instantiation / annotation brackets
         if Line (Pos) = '{' then
            Skip_Brackets (Line, Pos, '{', '}');
         elsif Line (Pos) = '[' then
            Skip_Brackets (Line, Pos, '[', ']');
         elsif Line (Pos) = '<' then
            while Pos <= Line'Last and then Line (Pos) /= '>' loop
               Pos := Pos + 1;
            end loop;
            if Pos <= Line'Last then
               Pos := Pos + 1;
            end if;
         elsif Is_Digit (Line (Pos)) then
            --  Parse [file|]line ref_kind col
            File_Idx := Current_File;
            Parse_Natural (Line, Pos, Line_Num);

            if Pos <= Line'Last and then Line (Pos) = '|' then
               --  Cross-file reference: number was file index
               File_Idx := Line_Num;
               Pos := Pos + 1;
               Parse_Natural (Line, Pos, Line_Num);
            end if;

            --  Next must be a ref-kind character
            if Pos <= Line'Last and then Is_Ref_Kind_Char (Line (Pos)) then
               Kind_Char := Line (Pos);
               Pos := Pos + 1;
               Parse_Natural (Line, Pos, Col_Num);

               --  Skip optional instantiation info attached to this ref
               while Pos <= Line'Last
                 and then Line (Pos) in '{' | '[' | '<'
               loop
                  if Line (Pos) = '{' then
                     Skip_Brackets (Line, Pos, '{', '}');
                  elsif Line (Pos) = '[' then
                     Skip_Brackets (Line, Pos, '[', ']');
                  elsif Line (Pos) = '<' then
                     while Pos <= Line'Last and then Line (Pos) /= '>' loop
                        Pos := Pos + 1;
                     end loop;
                     if Pos <= Line'Last then
                        Pos := Pos + 1;
                     end if;
                  end if;
               end loop;

               if Line_Num > 0 and then Col_Num > 0 then
                  Refs.Append
                    ((File_Index => File_Idx,
                      Line       => Line_Num,
                      Column     => Col_Num,
                      Kind       => To_Ref_Kind (Kind_Char)));
               end if;
            else
               --  Not a valid ref kind, skip token
               while Pos <= Line'Last and then Line (Pos) /= ' ' loop
                  Pos := Pos + 1;
               end loop;
            end if;
         else
            --  Unknown token, skip it
            while Pos <= Line'Last and then Line (Pos) /= ' ' loop
               Pos := Pos + 1;
            end loop;
         end if;
      end loop;
   end Parse_References;

   ---------------------------------------------------------------------------
   --  Classify_Xref_Line — determine whether a line starting with a digit
   --  is an entity definition or a reference continuation.
   --
   --  Entity def pattern:  line_digits type_char col_digits (* | ' ' name)
   --  Reference pattern:   line_digits ref_kind col_digits [more refs...]
   --
   --  The key disambiguation: entity defs have a name (letter or '"') after
   --  the column, separated by '*' (library-level) or ' '.
   ---------------------------------------------------------------------------

   function Is_Entity_Def_Line (Line : String) return Boolean is
      P   : Natural := Line'First;
      Num : Natural;
   begin
      if P > Line'Last or else not Is_Digit (Line (P)) then
         return False;
      end if;
      Parse_Natural (Line, P, Num);
      if P > Line'Last or else not Is_Entity_Type_Char (Line (P)) then
         return False;
      end if;
      P := P + 1;
      if P > Line'Last or else not Is_Digit (Line (P)) then
         return False;
      end if;
      Parse_Natural (Line, P, Num);
      if P > Line'Last then
         return False;
      end if;
      --  Library-level: '*' before name
      if Line (P) = '*' then
         return True;
      end if;
      --  Non-library-level: space then name (letter or '"' or '_')
      if Line (P) = ' ' and then P + 1 <= Line'Last then
         return Line (P + 1) in 'A' .. 'Z' | 'a' .. 'z' | '"' | '_';
      end if;
      return False;
   end Is_Entity_Def_Line;

   ---------------------------------------------------------------------------
   --  Parse_Entity_Def — parse a full entity definition line.
   --  Format: line type col[*] name[=renaming] [{inst}] [refs...]
   ---------------------------------------------------------------------------

   procedure Parse_Entity_Def
     (Line         : String;
      Current_File : Positive;
      Ent          : out Entity_Def)
   is
      Pos       : Natural := Line'First;
      Line_Num  : Natural;
      Col_Num   : Natural;
      Kind_Char : Character;
      Lib_Level : Boolean := False;
   begin
      Ent := (File_Index       => Current_File,
              Line             => 1,
              Column           => 1,
              Kind             => Array_Type,
              Name             => Null_Unbounded_String,
              Is_Library_Level => False,
              References       => Reference_Vectors.Empty_Vector);

      --  1. Line number
      Parse_Natural (Line, Pos, Line_Num);
      Ent.Line := Positive (Line_Num);

      --  2. Entity kind character
      Kind_Char := Line (Pos);
      Ent.Kind := To_Entity_Kind (Kind_Char);
      Pos := Pos + 1;

      --  3. Column number
      Parse_Natural (Line, Pos, Col_Num);
      Ent.Column := Positive (Col_Num);

      --  4. Library-level indicator
      if Pos <= Line'Last and then Line (Pos) = '*' then
         Lib_Level := True;
         Pos := Pos + 1;
      elsif Pos <= Line'Last and then Line (Pos) = ' ' then
         Pos := Pos + 1;
      end if;
      Ent.Is_Library_Level := Lib_Level;

      --  5. Entity name
      if Pos <= Line'Last and then Line (Pos) = '"' then
         --  Operator symbol: read until matching closing quote
         declare
            Start : constant Natural := Pos;
         begin
            Pos := Pos + 1;
            while Pos <= Line'Last and then Line (Pos) /= '"' loop
               Pos := Pos + 1;
            end loop;
            if Pos <= Line'Last then
               Pos := Pos + 1;  --  skip closing quote
            end if;
            Ent.Name := To_Unbounded_String (Line (Start .. Pos - 1));
         end;
      else
         --  Regular name: ends at space, '=', '{', '[', '<', or EOL
         declare
            Start : constant Natural := Pos;
         begin
            while Pos <= Line'Last
              and then Line (Pos) not in ' ' | '=' | '{' | '[' | '<'
            loop
               Pos := Pos + 1;
            end loop;
            Ent.Name := To_Unbounded_String (Line (Start .. Pos - 1));
         end;
      end if;

      --  6. Skip renaming (=name)
      if Pos <= Line'Last and then Line (Pos) = '=' then
         Pos := Pos + 1;
         if Pos <= Line'Last and then Line (Pos) = '"' then
            Pos := Pos + 1;
            while Pos <= Line'Last and then Line (Pos) /= '"' loop
               Pos := Pos + 1;
            end loop;
            if Pos <= Line'Last then
               Pos := Pos + 1;
            end if;
         else
            while Pos <= Line'Last and then Line (Pos) /= ' ' loop
               Pos := Pos + 1;
            end loop;
         end if;
      end if;

      --  7. Skip generic instantiation info
      while Pos <= Line'Last and then Line (Pos) in '{' | '[' loop
         if Line (Pos) = '{' then
            Skip_Brackets (Line, Pos, '{', '}');
         elsif Line (Pos) = '[' then
            Skip_Brackets (Line, Pos, '[', ']');
         end if;
      end loop;

      --  8. Parse inline references (rest of line)
      Parse_References (Line, Pos, Current_File, Ent.References);
   end Parse_Entity_Def;

   ---------------------------------------------------------------------------
   --  Parse — main entry point.  Reads an .ali file and returns the model.
   ---------------------------------------------------------------------------

   function Parse (Path : String) return Types.ALI_File is
      F               : File_Type;
      Result          : ALI_File;
      In_Xref         : Boolean := False;
      Current_Section : XRef_Section;
      Current_Entity  : Entity_Def;
      Has_Section     : Boolean := False;
      Has_Entity      : Boolean := False;
      Section_File    : Positive := 1;
   begin
      Open (F, In_File, Path);

      while not End_Of_File (F) loop
         declare
            Line : constant String := Get_Line (F);
         begin
            if Line'Length = 0 then
               null;  --  skip blank lines

            elsif Line'Length >= 2
              and then Line (Line'First) = 'D'
              and then Line (Line'First + 1) = ' '
            then
               Parse_D_Line (Line, Result.Files);

            elsif Line'Length >= 2
              and then Line (Line'First) = 'X'
              and then Line (Line'First + 1) = ' '
            then
               --  Finish previous entity/section
               if Has_Entity then
                  Current_Section.Entities.Append (Current_Entity);
                  Has_Entity := False;
               end if;
               if Has_Section then
                  Result.Sections.Append (Current_Section);
               end if;

               --  Start new cross-reference section
               Parse_X_Header (Line, Section_File);
               Current_Section :=
                 (File_Index => Section_File,
                  Entities   => Entity_Def_Vectors.Empty_Vector);
               Has_Section := True;
               In_Xref := True;

            elsif In_Xref and then Line'Length > 0 then
               if Line (Line'First) = '.' then
                  --  Continuation line (starts with '.')
                  if Has_Entity then
                     declare
                        Pos : Natural := Line'First + 1;
                     begin
                        Parse_References
                          (Line, Pos, Section_File,
                           Current_Entity.References);
                     end;
                  end if;

               elsif Is_Digit (Line (Line'First)) then
                  if Is_Entity_Def_Line (Line) then
                     --  New entity definition
                     if Has_Entity then
                        Current_Section.Entities.Append (Current_Entity);
                     end if;
                     Parse_Entity_Def (Line, Section_File, Current_Entity);
                     Has_Entity := True;
                  else
                     --  Reference continuation (digits but not entity def)
                     if Has_Entity then
                        declare
                           Pos : Natural := Line'First;
                        begin
                           Parse_References
                             (Line, Pos, Section_File,
                              Current_Entity.References);
                        end;
                     end if;
                  end if;
               end if;
            end if;
         end;
      end loop;

      --  Flush final entity/section
      if Has_Entity then
         Current_Section.Entities.Append (Current_Entity);
      end if;
      if Has_Section then
         Result.Sections.Append (Current_Section);
      end if;

      Close (F);
      return Result;
   end Parse;

end SCIP_Ada.ALI.Parser;
