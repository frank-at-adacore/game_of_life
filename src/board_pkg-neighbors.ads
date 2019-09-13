with Base_Types;

package Board_Pkg.Neighbors with
   Spark_Mode
is

   function Alive_Count
     (Board  : Board_T;
      Row    : Base_Types.Row_T;
      Column : Base_Types.Column_T)
     return Integer
with pre => board.rows > 0 and board.columns > 0;

end Board_Pkg.Neighbors;
