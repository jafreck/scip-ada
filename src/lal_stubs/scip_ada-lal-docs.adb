package body SCIP_Ada.LAL.Docs is

   function Extract_Docs
     (Source_Path : String) return Doc_Vectors.Vector
   is
      pragma Unreferenced (Source_Path);
   begin
      return Doc_Vectors.Empty_Vector;
   end Extract_Docs;

end SCIP_Ada.LAL.Docs;
