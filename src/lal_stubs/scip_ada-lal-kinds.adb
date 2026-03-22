package body SCIP_Ada.LAL.Kinds is

   function Extract_Kind_Overrides
     (Source_Path : String) return Kind_Override_Vectors.Vector
   is
      pragma Unreferenced (Source_Path);
   begin
      return Kind_Override_Vectors.Empty_Vector;
   end Extract_Kind_Overrides;

end SCIP_Ada.LAL.Kinds;
