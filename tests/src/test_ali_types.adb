with AUnit.Assertions;
with SCIP_Ada.ALI.Types;

package body Test_ALI_Types is

   use SCIP_Ada.ALI.Types;

   procedure Assert_Entity
     (C        : Character;
      Expected : Entity_Kind)
   is
      Result : Entity_Kind;
   begin
      Result := To_Entity_Kind (C);
      AUnit.Assertions.Assert
        (Result = Expected,
         "To_Entity_Kind('" & C & "') = " &
         Entity_Kind'Image (Result) & ", expected " &
         Entity_Kind'Image (Expected));
   exception
      when others =>
         AUnit.Assertions.Assert
           (False,
            "To_Entity_Kind('" & C & "') raised an unexpected exception");
   end Assert_Entity;

   procedure Assert_Reference
     (C        : Character;
      Expected : Ref_Kind)
   is
      Result : Ref_Kind;
   begin
      Result := To_Ref_Kind (C);
      AUnit.Assertions.Assert
        (Result = Expected,
         "To_Ref_Kind('" & C & "') = " &
         Ref_Kind'Image (Result) & ", expected " &
         Ref_Kind'Image (Expected));
   exception
      when others =>
         AUnit.Assertions.Assert
           (False,
            "To_Ref_Kind('" & C & "') raised an unexpected exception");
   end Assert_Reference;

   procedure Assert_Invalid_Entity (C : Character) is
      Dummy : Entity_Kind;
   begin
      Dummy := To_Entity_Kind (C);
      AUnit.Assertions.Assert
        (False,
         "To_Entity_Kind('" & C &
         "') should raise Constraint_Error but returned " &
         Entity_Kind'Image (Dummy));
   exception
      when Constraint_Error =>
         null;
      when others =>
         AUnit.Assertions.Assert
           (False,
            "To_Entity_Kind('" & C &
            "') raised the wrong exception (expected Constraint_Error)");
   end Assert_Invalid_Entity;

   procedure Assert_Invalid_Reference (C : Character) is
      Dummy : Ref_Kind;
   begin
      Dummy := To_Ref_Kind (C);
      AUnit.Assertions.Assert
        (False,
         "To_Ref_Kind('" & C &
         "') should raise Constraint_Error but returned " &
         Ref_Kind'Image (Dummy));
   exception
      when Constraint_Error =>
         null;
      when others =>
         AUnit.Assertions.Assert
           (False,
            "To_Ref_Kind('" & C &
            "') raised the wrong exception (expected Constraint_Error)");
   end Assert_Invalid_Reference;

   procedure Test_Entity_Uppercase
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Entity ('A', Array_Type);
      Assert_Entity ('B', Boolean_Type);
      Assert_Entity ('C', Component);
      Assert_Entity ('D', Decimal_Fixed_Type);
      Assert_Entity ('E', Enumeration_Type);
      Assert_Entity ('F', Float_Type);
      Assert_Entity ('G', Generic_Package);
      Assert_Entity ('H', Abstract_Type);
      Assert_Entity ('I', Integer_Type);
      Assert_Entity ('J', Class_Wide_Subtype);
      Assert_Entity ('K', Package_Entity);
      Assert_Entity ('L', Label);
      Assert_Entity ('M', Modular_Integer_Type);
      Assert_Entity ('N', Named_Number);
      Assert_Entity ('O', Ordinary_Fixed_Type);
      Assert_Entity ('P', Access_Type);
      Assert_Entity ('Q', Block_Label);
      Assert_Entity ('R', Tagged_Record_Type);
      Assert_Entity ('S', Subtype_Entity);
      Assert_Entity ('T', Task_Type);
      Assert_Entity ('U', Procedure_Entity);
      Assert_Entity ('V', Function_Entity);
      Assert_Entity ('W', Formal_Procedure);
      Assert_Entity ('X', Formal_Function);
      Assert_Entity ('Y', Entry_Entity);
   end Test_Entity_Uppercase;

   procedure Test_Entity_Lowercase
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Entity ('a', Array_Object);
      Assert_Entity ('b', Loop_Block_Label);
      Assert_Entity ('c', Class_Wide_Type);
      Assert_Entity ('d', Decimal_Fixed_Object);
      Assert_Entity ('e', Exception_Entity);
      Assert_Entity ('f', Float_Object);
      Assert_Entity ('g', Generic_Procedure);
      Assert_Entity ('h', Generic_Function);
      Assert_Entity ('i', Integer_Object);
      Assert_Entity ('j', Class_Wide_Object);
      Assert_Entity ('k', Generic_Package_Instantiation);
      Assert_Entity ('l', Label_On_Begin);
      Assert_Entity ('m', Modular_Integer_Object);
      Assert_Entity ('n', Enumeration_Literal);
      Assert_Entity ('o', Ordinary_Fixed_Object);
      Assert_Entity ('p', Access_Object);
      Assert_Entity ('q', Label_On_Block);
      Assert_Entity ('r', Record_Type);
      Assert_Entity ('s', String_Object);
      Assert_Entity ('t', Task_Object);
      Assert_Entity ('u', Procedure_Instantiation);
      Assert_Entity ('v', Function_Instantiation);
      Assert_Entity ('w', Protected_Object);
      Assert_Entity ('x', Abstract_Procedure);
      Assert_Entity ('y', Entry_Body);
      Assert_Entity ('z', Abstract_Function);
   end Test_Entity_Lowercase;

   procedure Test_Entity_Special_Characters
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Entity ('+', Generic_Formal_Type);
      Assert_Entity ('*', Private_Generic_Formal_Type);
   end Test_Entity_Special_Characters;

   procedure Test_Reference_Lowercase
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Reference ('b', Body_Ref);
      Assert_Reference ('c', Completion_Ref);
      Assert_Reference ('d', Dispatching_Call);
      Assert_Reference ('e', End_Of_Spec);
      Assert_Reference ('i', Implicit_Ref);
      Assert_Reference ('l', Label_On_End);
      Assert_Reference ('m', Modification_Ref);
      Assert_Reference ('o', Own_Ref);
      Assert_Reference ('p', Primitive_Op_Ref);
      Assert_Reference ('r', Reference_Ref);
      Assert_Reference ('s', Static_Call);
      Assert_Reference ('t', End_Of_Body);
      Assert_Reference ('w', With_Ref);
      Assert_Reference ('x', Type_Extension_Ref);
      Assert_Reference ('z', Formal_Generic_Actual);
   end Test_Reference_Lowercase;

   procedure Test_Reference_Uppercase
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Reference ('D', Discriminant_Ref);
      Assert_Reference ('E', First_Private_Entity);
      Assert_Reference ('H', Abstract_Type_Ref);
      Assert_Reference ('P', Overriding_Primitive);
      Assert_Reference ('R', Dispatching_Ref);
   end Test_Reference_Uppercase;

   procedure Test_Invalid_Entity_Characters
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Invalid_Entity ('0');
      Assert_Invalid_Entity ('Z');
      Assert_Invalid_Entity ('#');
      Assert_Invalid_Entity (' ');
      Assert_Invalid_Entity ('!');
   end Test_Invalid_Entity_Characters;

   procedure Test_Invalid_Reference_Characters
     (T : in out SCIP_Ada.Tests.Fixture)
   is
      pragma Unreferenced (T);
   begin
      Assert_Invalid_Reference ('A');
      Assert_Invalid_Reference ('0');
      Assert_Invalid_Reference ('#');
      Assert_Invalid_Reference (' ');
      Assert_Invalid_Reference ('q');
   end Test_Invalid_Reference_Characters;

end Test_ALI_Types;
