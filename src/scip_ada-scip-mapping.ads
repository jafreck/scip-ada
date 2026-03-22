--  SCIP_Ada.SCIP.Mapping — ALI entity/reference kind to SCIP kind mapping

with SCIP_Ada.ALI.Types;

package SCIP_Ada.SCIP.Mapping is

   --  SCIP SymbolInformation.Kind values (subset used for Ada mapping)
   type SCIP_Symbol_Kind is
     (SCIP_Unspecified,
      SCIP_Class,
      SCIP_Constant,
      SCIP_Enum,
      SCIP_EnumMember,
      SCIP_Field,
      SCIP_Function,
      SCIP_Interface,
      SCIP_Method,
      SCIP_Namespace,
      SCIP_Struct,
      SCIP_Type,
      SCIP_TypeParameter,
      SCIP_Variable);

   --  Map ALI entity kind to SCIP symbol kind
   function To_SCIP_Kind
     (Kind : SCIP_Ada.ALI.Types.Entity_Kind) return SCIP_Symbol_Kind;

   --  Return the SCIP integer value for a symbol kind
   function Kind_Value (Kind : SCIP_Symbol_Kind) return Natural;

   --  Map ALI reference kind to SCIP SymbolRole bitmask value
   function To_SCIP_Role
     (Kind : SCIP_Ada.ALI.Types.Ref_Kind) return Natural;

end SCIP_Ada.SCIP.Mapping;
