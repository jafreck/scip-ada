package body SCIP_Ada.LAL.Signatures is

   function Extract_Signatures
     (Source_Path : String) return Signature_Vectors.Vector
   is
      pragma Unreferenced (Source_Path);
   begin
      return Signature_Vectors.Empty_Vector;
   end Extract_Signatures;

end SCIP_Ada.LAL.Signatures;
