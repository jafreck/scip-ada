package body SCIP_Ada.LAL.Relationships is

   function Extract_Relationships
     (Source_Path : String) return Relationship_Vectors.Vector
   is
      pragma Unreferenced (Source_Path);
   begin
      return Relationship_Vectors.Empty_Vector;
   end Extract_Relationships;

end SCIP_Ada.LAL.Relationships;
