package Base_Types with
   SPARK_Mode
is

   Max_Columns : constant := 1_000;
   Max_Rows    : constant := 1_000;

   -- count allows 0; subtype is an array index
   type Row_Count_T is range -1 .. Max_Rows + 2;
   subtype Row_T is Row_Count_T range 1 .. Row_Count_T'Last - 2;

   -- count allows 0; subtype is an array index
   type Column_Count_T is range -1 .. Max_Columns + 2;
   subtype Column_T is Column_Count_T range 1 .. Column_Count_T'Last - 2;

   -- get next row if possible, otherwise use this row
   function Succ
     (Index : Row_Count_T)
      return Row_T is
     (if Index in Row_T and Index < Row_T'Last then Index + 1
      else Row_T'Last);

      -- get next column if possible, otherwise use this column
   function Succ
     (Index : Column_Count_T)
      return Column_T is
     (if Index in Column_T and Index < Column_T'Last then Index + 1
      else Column_T'Last);

end Base_Types;
