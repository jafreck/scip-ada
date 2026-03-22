with Ada.Unchecked_Deallocation;

package body SCIP_Ada.SCIP.Protobuf is

   procedure Free is new Ada.Unchecked_Deallocation
     (SEA.Stream_Element_Array, Byte_Array_Access);

   Initial_Capacity : constant := 256;

   procedure Ensure_Capacity
     (Buf      : in out Byte_Buffer;
      Required : Natural)
   is
      New_Cap  : Natural;
      New_Store : Byte_Array_Access;
   begin
      if Buf.Capacity >= Buf.Used + Required then
         return;
      end if;

      if Buf.Capacity = 0 then
         New_Cap := Natural'Max (Initial_Capacity, Required);
      else
         New_Cap := Buf.Capacity;
         while New_Cap < Buf.Used + Required loop
            New_Cap := New_Cap * 2;
         end loop;
      end if;

      New_Store := new SEA.Stream_Element_Array
        (1 .. SEA.Stream_Element_Offset (New_Cap));

      if Buf.Store /= null then
         New_Store (1 .. SEA.Stream_Element_Offset (Buf.Used)) :=
           Buf.Store (1 .. SEA.Stream_Element_Offset (Buf.Used));
         Free (Buf.Store);
      end if;

      Buf.Store    := New_Store;
      Buf.Capacity := New_Cap;
   end Ensure_Capacity;

   procedure Append
     (Buf  : in out Byte_Buffer;
      B    : Byte)
   is
   begin
      Ensure_Capacity (Buf, 1);
      Buf.Used := Buf.Used + 1;
      Buf.Store (SEA.Stream_Element_Offset (Buf.Used)) := B;
   end Append;

   procedure Append
     (Buf  : in out Byte_Buffer;
      Data : SEA.Stream_Element_Array)
   is
   begin
      if Data'Length = 0 then
         return;
      end if;
      Ensure_Capacity (Buf, Data'Length);
      Buf.Store (SEA.Stream_Element_Offset (Buf.Used + 1) ..
                 SEA.Stream_Element_Offset (Buf.Used + Data'Length)) := Data;
      Buf.Used := Buf.Used + Data'Length;
   end Append;

   procedure Clear (Buf : in out Byte_Buffer) is
   begin
      Buf.Used := 0;
   end Clear;

   function Length (Buf : Byte_Buffer) return Natural is
   begin
      return Buf.Used;
   end Length;

   function Data (Buf : Byte_Buffer) return SEA.Stream_Element_Array is
   begin
      if Buf.Used = 0 then
         return (1 .. 0 => 0);
      end if;
      return Buf.Store (1 .. SEA.Stream_Element_Offset (Buf.Used));
   end Data;

   ---------------------------------------------------------------------------
   --  Wire-format encoding
   ---------------------------------------------------------------------------

   procedure Encode_Varint
     (Buf   : in out Byte_Buffer;
      Value : Natural)
   is
      V : Natural := Value;
   begin
      loop
         if V < 128 then
            Append (Buf, Byte (V));
            exit;
         else
            Append (Buf, Byte ((V mod 128) + 128));
            V := V / 128;
         end if;
      end loop;
   end Encode_Varint;

   procedure Encode_Tag
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Wire_Type    : Natural)
   is
   begin
      Encode_Varint (Buf, Field_Number * 8 + Wire_Type);
   end Encode_Tag;

   procedure Encode_Varint_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : Natural)
   is
   begin
      Encode_Tag (Buf, Field_Number, 0);
      Encode_Varint (Buf, Value);
   end Encode_Varint_Field;

   procedure Encode_Bytes_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : SEA.Stream_Element_Array)
   is
   begin
      Encode_Tag (Buf, Field_Number, 2);
      Encode_Varint (Buf, Value'Length);
      Append (Buf, Value);
   end Encode_Bytes_Field;

   procedure Encode_String_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : String)
   is
      Bytes : SEA.Stream_Element_Array (1 .. Value'Length);
   begin
      for I in Value'Range loop
         Bytes (SEA.Stream_Element_Offset
                  (I - Value'First + 1)) :=
           SEA.Stream_Element (Character'Pos (Value (I)));
      end loop;
      Encode_Bytes_Field (Buf, Field_Number, Bytes);
   end Encode_String_Field;

   procedure Encode_Submessage_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Sub          : Byte_Buffer)
   is
      Sub_Data : constant SEA.Stream_Element_Array := Sub.Data;
   begin
      Encode_Bytes_Field (Buf, Field_Number, Sub_Data);
   end Encode_Submessage_Field;

   procedure Encode_Sint32
     (Buf   : in out Byte_Buffer;
      Value : Integer)
   is
      --  ZigZag encoding: (n << 1) ^ (n >> 31)
      Encoded : Natural;
   begin
      if Value >= 0 then
         Encoded := Value * 2;
      else
         Encoded := (-Value) * 2 - 1;
      end if;
      Encode_Varint (Buf, Encoded);
   end Encode_Sint32;

   procedure Encode_Sint32_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Value        : Integer)
   is
   begin
      Encode_Tag (Buf, Field_Number, 0);
      Encode_Sint32 (Buf, Value);
   end Encode_Sint32_Field;

   procedure Encode_Packed_Int32_Field
     (Buf          : in out Byte_Buffer;
      Field_Number : Positive;
      Values       : Integer_Array)
   is
      Inner : Byte_Buffer;
   begin
      for V of Values loop
         if V >= 0 then
            Encode_Varint (Inner, V);
         else
            Encode_Sint32 (Inner, V);
         end if;
      end loop;
      Encode_Bytes_Field (Buf, Field_Number, Inner.Data);
   end Encode_Packed_Int32_Field;

end SCIP_Ada.SCIP.Protobuf;
