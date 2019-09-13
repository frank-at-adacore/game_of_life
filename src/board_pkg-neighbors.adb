with Base_Types;
package body Board_Pkg.Neighbors with
   Spark_Mode
is

   subtype Cell_Value_T is Natural range 0 .. 1;
   function Cell_Value
     (Board  : Board_T;
      Row    : Base_Types.Row_Count_T;
      Column : Base_Types.Column_Count_T)
     return Cell_Value_T is
     (if Board.Get_State (Row, Column) = Alive then 1 else 0);

   subtype Column_Value_T is Natural range 0 .. 3;
   function Count_Row_Around_Column
     (Board  : Board_T;
      Row    : Base_Types.Row_Count_T;
      Column : Base_Types.Column_T)
     return Column_Value_T is
     (Cell_Value (Board, Row, Column - 1) + Cell_Value (Board, Row, Column) +
      Cell_Value (Board, Row, Column + 1));

   function Alive_Count
     (Board  : Board_T;
      Row    : Base_Types.Row_T;
      Column : Base_Types.Column_T)
     return Integer is
      Count     : Natural                := 0;
      Row_Index : Base_Types.Row_Count_T := Row;
   begin
      for Offset in Base_Types.Row_Count_T range 1 .. 3
      loop
         pragma LOOP_INVARIANT
           (Count <= Natural (Offset) * Column_Value_T'Last);
         Count :=
           Count +
           Count_Row_Around_Column (Board, Row_Index + Offset - 2, Column);
      end loop;
      return Ret_Val : Integer := Count do
         if Board.Get_State (Row, Column) = Alive
         then
            Ret_Val := Ret_Val - 1;
         end if;
      end return;
   end Alive_Count;

end Board_Pkg.Neighbors;
