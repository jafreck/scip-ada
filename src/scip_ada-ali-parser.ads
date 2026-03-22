--  SCIP_Ada.ALI.Parser — Parse .ali files into ALI data model

with SCIP_Ada.ALI.Types;

package SCIP_Ada.ALI.Parser is

   --  Parse an ALI file at the given path.
   --  Raises Ada.IO_Exceptions.Name_Error if the file does not exist.
   function Parse (Path : String) return Types.ALI_File;

end SCIP_Ada.ALI.Parser;
