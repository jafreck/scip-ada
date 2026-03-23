--  SCIP_Ada.LAL.Relationships — extract tagged type hierarchies
--
--  Given an Ada source file, extracts parent/child relationships
--  for tagged types (inheritance, interface implementation).

with Ada.Strings.Unbounded;
with Ada.Containers.Vectors;

package SCIP_Ada.LAL.Relationships is

   use Ada.Strings.Unbounded;

   type Relationship_Kind is
     (Extends,          --  tagged type extends parent
      Implements,       --  type implements interface
      Overrides);       --  subprogram overrides base operation

   type Relationship_Info is record
      Child_Name   : Unbounded_String;
      Child_Line   : Positive;
      Parent_Name  : Unbounded_String;
      Parent_Scope : Unbounded_String;  --  dot-separated scope chain
      Kind         : Relationship_Kind;
   end record;

   package Relationship_Vectors is new Ada.Containers.Vectors
     (Index_Type   => Positive,
      Element_Type => Relationship_Info);

   --  Extract type hierarchy relationships from the source.
   function Extract_Relationships
     (Source_Path : String) return Relationship_Vectors.Vector;

end SCIP_Ada.LAL.Relationships;
