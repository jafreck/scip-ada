--  SCIP_Ada.SCIP.Protobuf — Minimal protobuf wire-format encoder
--
--  Implements the subset of Protocol Buffers binary encoding needed for
--  the SCIP schema: varint, length-delimited fields, and the message
--  types Index, Metadata, Document, Occurrence, SymbolInformation,
--  and Relationship.
--
--  Reference: https://protobuf.dev/programming-guides/encoding/

with Ada.Streams;

package SCIP_Ada.SCIP.Protobuf is

   --  A byte buffer for accumulating encoded protobuf output
   subtype Byte is Ada.Streams.Stream_Element;
   subtype Byte_Offset is Ada.Streams.Stream_Element_Offset;

   type Byte_Buffer is tagged private;

   --  Initialize / reset a buffer
   procedure Clear (Buf : in out Byte_Buffer);

   --  Return the current length in bytes
   function Length (Buf : Byte_Buffer) return Natural;

   --  Return the raw bytes
   function Data (Buf : Byte_Buffer) return Ada.Streams.Stream_Element_Array;

   ---------------------------------------------------------------------------
   --  Low-level wire-format encoding
   ---------------------------------------------------------------------------

   --  Encode a varint (unsigned LEB128)
   procedure Encode_Varint
     (Buf   : in out Byte_Buffer;
      Value : Natural);

   --  Encode a field tag (field_number << 3 | wire_type)
   --  Wire types: 0 = varint, 2 = length-delimited
   procedure Encode_Tag
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Wire_Type    : Natural);

   --  Encode a varint field: tag + varint value
   procedure Encode_Varint_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : Natural);

   --  Encode a length-delimited field: tag + length + raw bytes
   procedure Encode_Bytes_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : Ada.Streams.Stream_Element_Array);

   --  Encode a string field: tag + length + UTF-8 string bytes
   procedure Encode_String_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : String);

   --  Encode a submessage field: tag + length + submessage bytes
   procedure Encode_Submessage_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Sub          : Byte_Buffer);

   --  Encode a signed int32 as a varint (using zigzag encoding)
   procedure Encode_Sint32
     (Buf   : in out Byte_Buffer;
      Value : Integer);

   --  Encode a signed int32 field
   procedure Encode_Sint32_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : Integer);

   type Integer_Array is array (Positive range <>) of Integer;

   --  Encode a packed repeated int32 field
   procedure Encode_Packed_Int32_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Values       : Integer_Array);

   ---------------------------------------------------------------------------
   --  SCIP field numbers (from scip.proto)
   --
   --  These correspond to the protobuf field numbers in the SCIP schema.
   ---------------------------------------------------------------------------

   --  Index message (top-level)
   Index_Metadata_Field      : constant := 1;
   Index_Documents_Field     : constant := 2;
   Index_External_Symbols_Field : constant := 3;

   --  Metadata message
   Metadata_Version_Field          : constant := 1;
   Metadata_Tool_Info_Field        : constant := 2;
   Metadata_Project_Root_Field     : constant := 3;
   Metadata_Text_Encoding_Field    : constant := 4;

   --  ToolInfo message
   Tool_Info_Name_Field    : constant := 1;
   Tool_Info_Version_Field : constant := 2;
   Tool_Info_Arguments_Field : constant := 3;

   --  Document message
   Document_Language_Field       : constant := 4;
   Document_Relative_Path_Field  : constant := 1;
   Document_Occurrences_Field    : constant := 2;
   Document_Symbols_Field        : constant := 3;
   Document_Text_Field           : constant := 5;

   --  Occurrence message
   Occurrence_Range_Field                : constant := 1;
   Occurrence_Symbol_Field               : constant := 2;
   Occurrence_Symbol_Roles_Field         : constant := 3;
   Occurrence_Override_Documentation_Field : constant := 4;
   Occurrence_Syntax_Kind_Field          : constant := 5;
   Occurrence_Diagnostics_Field          : constant := 6;

   --  SymbolInformation message
   Symbol_Info_Symbol_Field         : constant := 1;
   Symbol_Info_Documentation_Field  : constant := 3;
   Symbol_Info_Relationships_Field  : constant := 4;
   Symbol_Info_Kind_Field           : constant := 5;
   Symbol_Info_Display_Name_Field   : constant := 6;
   Symbol_Info_Signature_Documentation_Field : constant := 7;

   --  Relationship message
   Relationship_Symbol_Field    : constant := 1;
   Relationship_Is_Reference_Field   : constant := 2;
   Relationship_Is_Implementation_Field : constant := 3;
   Relationship_Is_Type_Definition_Field : constant := 4;
   Relationship_Is_Definition_Field : constant := 5;

   --  SymbolRole values (bitmask)
   Symbol_Role_Definition       : constant := 1;
   Symbol_Role_Import           : constant := 2;
   Symbol_Role_Write_Access     : constant := 4;
   Symbol_Role_Read_Access      : constant := 8;
   Symbol_Role_Generated        : constant := 16;
   Symbol_Role_Test             : constant := 32;
   Symbol_Role_Forward_Definition : constant := 64;

private

   package SEA renames Ada.Streams;

   type Byte_Array_Access is access SEA.Stream_Element_Array;

   type Byte_Buffer is tagged record
      Store    : Byte_Array_Access := null;
      Used     : Natural := 0;
      Capacity : Natural := 0;
   end record;

   procedure Ensure_Capacity
     (Buf      : in out Byte_Buffer;
      Required : Natural);

   procedure Append
     (Buf  : in out Byte_Buffer;
      B    : Byte);

   procedure Append
     (Buf  : in out Byte_Buffer;
      Data : SEA.Stream_Element_Array);

end SCIP_Ada.SCIP.Protobuf;
