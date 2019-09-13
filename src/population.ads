with Base_Types;
with Board_Pkg;
use type Base_Types.Row_Count_T;
use type Base_Types.Column_Count_T;
package Population with
   Spark_Mode
is

   -- create a new board based on the state of the old board Still_Alive is
   -- TRUE if any cell remains alive
   procedure Generate
     (Board       : in out Board_Pkg.Board_T;
      Still_Alive :    out Boolean) with
      Pre => Board.Rows > 0 and then Board.Columns > 0;

end Population;
