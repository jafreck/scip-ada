with Ada.Text_IO;
with SCIP_Ada.ALI.Types;

package body Test_ALI_Types is

   use SCIP_Ada.ALI.Types;

   Verbose : constant Boolean := False;

   procedure Check_Entity
     (C        : Character;
      Expected : Entity_Kind;
      Passed   : in out Natural;
      Failed   : in Out Natural)
   is
      Result : Entity_Kind;
   begin
      Result := To_Entity_Kind (C);
      if Result = Expected then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: To_Entity_Kind('" & C & "') = " &
            Entity_Kind'Image (Result) & ", expected " &
            Entity_Kind'Image (Expected));
      end if;
   exception
      when others =>
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: To_Entity_Kind('" & C & "') raised exception");
   end Check_Entity;

   procedure Check_Ref
     (C        : Character;
      Expected : Ref_Kind;
      Passed   : in out Natural;
      Failed   : in Out Natural)
   is
      Result : Ref_Kind;
   begin
      Result := To_Ref_Kind (C);
      if Result = Expected then
         Passed := Passed + 1;
      else
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: To_Ref_Kind('" & C & "') = " &
            Ref_Kind'Image (Result) & ", expected " &
            Ref_Kind'Image (Expected));
      end if;
   exception
      when others =>
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: To_Ref_Kind('" & C & "') raised exception");
   end Check_Ref;

   procedure Check_Entity_Invalid
     (C      : Character;
      Passed : in Out Natural;
      Failed : in Out Natural)
   is
      Dummy : Entity_Kind;
   begin
      Dummy := To_Entity_Kind (C);
      --  Should not reach here
      Failed := Failed + 1;
      Ada.Text_IO.Put_Line
        ("  FAIL: To_Entity_Kind('" & C &
         "') should raise Constraint_Error but returned " &
         Entity_Kind'Image (Dummy));
   exception
      when Constraint_Error =>
         Passed := Passed + 1;
      when others =>
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: To_Entity_Kind('" & C &
            "') raised wrong exception (expected Constraint_Error)");
   end Check_Entity_Invalid;

   procedure Check_Ref_Invalid
     (C      : Character;
      Passed : in Out Natural;
      Failed : in Out Natural)
   is
      Dummy : Ref_Kind;
   begin
      Dummy := To_Ref_Kind (C);
      Failed := Failed + 1;
      Ada.Text_IO.Put_Line
        ("  FAIL: To_Ref_Kind('" & C &
         "') should raise Constraint_Error but returned " &
         Ref_Kind'Image (Dummy));
   exception
      when Constraint_Error =>
         Passed := Passed + 1;
      when others =>
         Failed := Failed + 1;
         Ada.Text_IO.Put_Line
           ("  FAIL: To_Ref_Kind('" & C &
            "') raised wrong exception (expected Constraint_Error)");
   end Check_Ref_Invalid;

   procedure Run (Passed : out Natural; Failed : out Natural) is
   begin
      Passed := 0;
      Failed := 0;

      -----------------------------------------------------------------------
      --  Entity type character coverage (upper case)
      -----------------------------------------------------------------------
      Check_Entity ('A', Array_Type, Passed, Failed);
      Check_Entity ('B', Boolean_Type, Passed, Failed);
      Check_Entity ('C', Component, Passed, Failed);
      Check_Entity ('D', Decimal_Fixed_Type, Passed, Failed);
      Check_Entity ('E', Enumeration_Type, Passed, Failed);
      Check_Entity ('F', Float_Type, Passed, Failed);
      Check_Entity ('G', Generic_Package, Passed, Failed);
      Check_Entity ('H', Abstract_Type, Passed, Failed);
      Check_Entity ('I', Integer_Type, Passed, Failed);
      Check_Entity ('J', Class_Wide_Subtype, Passed, Failed);
      Check_Entity ('K', Package_Entity, Passed, Failed);
      Check_Entity ('L', Label, Passed, Failed);
      Check_Entity ('M', Modular_Integer_Type, Passed, Failed);
      Check_Entity ('N', Named_Number, Passed, Failed);
      Check_Entity ('O', Ordinary_Fixed_Type, Passed, Failed);
      Check_Entity ('P', Access_Type, Passed, Failed);
      Check_Entity ('Q', Block_Label, Passed, Failed);
      Check_Entity ('R', Tagged_Record_Type, Passed, Failed);
      Check_Entity ('S', Subtype_Entity, Passed, Failed);
      Check_Entity ('T', Task_Type, Passed, Failed);
      Check_Entity ('U', Procedure_Entity, Passed, Failed);
      Check_Entity ('V', Function_Entity, Passed, Failed);
      Check_Entity ('W', Formal_Procedure, Passed, Failed);
      Check_Entity ('X', Formal_Function, Passed, Failed);
      Check_Entity ('Y', Entry_Entity, Passed, Failed);

      -----------------------------------------------------------------------
      --  Entity type character coverage (lower case)
      -----------------------------------------------------------------------
      Check_Entity ('a', Array_Object, Passed, Failed);
      Check_Entity ('b', Loop_Block_Label, Passed, Failed);
      Check_Entity ('c', Class_Wide_Type, Passed, Failed);
      Check_Entity ('d', Decimal_Fixed_Object, Passed, Failed);
      Check_Entity ('e', Exception_Entity, Passed, Failed);
      Check_Entity ('f', Float_Object, Passed, Failed);
      Check_Entity ('g', Generic_Procedure, Passed, Failed);
      Check_Entity ('h', Generic_Function, Passed, Failed);
      Check_Entity ('i', Integer_Object, Passed, Failed);
      Check_Entity ('j', Class_Wide_Object, Passed, Failed);
      Check_Entity ('k', Generic_Package_Instantiation, Passed, Failed);
      Check_Entity ('l', Label_On_Begin, Passed, Failed);
      Check_Entity ('m', Modular_Integer_Object, Passed, Failed);
      Check_Entity ('n', Enumeration_Literal, Passed, Failed);
      Check_Entity ('o', Ordinary_Fixed_Object, Passed, Failed);
      Check_Entity ('p', Access_Object, Passed, Failed);
      Check_Entity ('q', Label_On_Block, Passed, Failed);
      Check_Entity ('r', Record_Type, Passed, Failed);
      Check_Entity ('s', String_Object, Passed, Failed);
      Check_Entity ('t', Task_Object, Passed, Failed);
      Check_Entity ('u', Procedure_Instantiation, Passed, Failed);
      Check_Entity ('v', Function_Instantiation, Passed, Failed);
      Check_Entity ('w', Protected_Object, Passed, Failed);
      Check_Entity ('x', Abstract_Procedure, Passed, Failed);
      Check_Entity ('y', Entry_Body, Passed, Failed);
      Check_Entity ('z', Abstract_Function, Passed, Failed);

      -----------------------------------------------------------------------
      --  Entity type character coverage (special characters)
      -----------------------------------------------------------------------
      Check_Entity ('+', Generic_Formal_Type, Passed, Failed);
      Check_Entity ('*', Private_Generic_Formal_Type, Passed, Failed);

      -----------------------------------------------------------------------
      --  Reference type character coverage (lower case)
      -----------------------------------------------------------------------
      Check_Ref ('b', Body_Ref, Passed, Failed);
      Check_Ref ('c', Completion_Ref, Passed, Failed);
      Check_Ref ('d', Dispatching_Call, Passed, Failed);
      Check_Ref ('e', End_Of_Spec, Passed, Failed);
      Check_Ref ('i', Implicit_Ref, Passed, Failed);
      Check_Ref ('l', Label_On_End, Passed, Failed);
      Check_Ref ('m', Modification_Ref, Passed, Failed);
      Check_Ref ('o', Own_Ref, Passed, Failed);
      Check_Ref ('p', Primitive_Op_Ref, Passed, Failed);
      Check_Ref ('r', Reference_Ref, Passed, Failed);
      Check_Ref ('s', Static_Call, Passed, Failed);
      Check_Ref ('t', End_Of_Body, Passed, Failed);
      Check_Ref ('w', With_Ref, Passed, Failed);
      Check_Ref ('x', Type_Extension_Ref, Passed, Failed);
      Check_Ref ('z', Formal_Generic_Actual, Passed, Failed);

      -----------------------------------------------------------------------
      --  Reference type character coverage (upper case)
      -----------------------------------------------------------------------
      Check_Ref ('D', Discriminant_Ref, Passed, Failed);
      Check_Ref ('E', First_Private_Entity, Passed, Failed);
      Check_Ref ('H', Abstract_Type_Ref, Passed, Failed);
      Check_Ref ('P', Overriding_Primitive, Passed, Failed);
      Check_Ref ('R', Dispatching_Ref, Passed, Failed);

      -----------------------------------------------------------------------
      --  Invalid entity characters → Constraint_Error
      -----------------------------------------------------------------------
      Check_Entity_Invalid ('0', Passed, Failed);
      Check_Entity_Invalid ('Z', Passed, Failed);
      Check_Entity_Invalid ('#', Passed, Failed);
      Check_Entity_Invalid (' ', Passed, Failed);
      Check_Entity_Invalid ('!', Passed, Failed);

      -----------------------------------------------------------------------
      --  Invalid reference characters → Constraint_Error
      -----------------------------------------------------------------------
      Check_Ref_Invalid ('A', Passed, Failed);
      Check_Ref_Invalid ('0', Passed, Failed);
      Check_Ref_Invalid ('#', Passed, Failed);
      Check_Ref_Invalid (' ', Passed, Failed);
      Check_Ref_Invalid ('q', Passed, Failed);

      if Verbose then
         Ada.Text_IO.Put_Line
           ("  ALI Types:" & Natural'Image (Passed) & " passed," &
            Natural'Image (Failed) & " failed");
      end if;
   end Run;

end Test_ALI_Types;
