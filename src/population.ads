with Base_Types;
with Board_Pkg;
use type Base_Types.Row_Count_T;
use type Base_Types.Column_Count_T;
package Population with
   Spark_Mode
is

   procedure Generate
     (Old_Board   : in     Board_Pkg.Board_T;
      New_Board   : in out Board_Pkg.Board_T;
      Still_Alive :    out Boolean) with
      Pre => Old_Board.Rows > 0 and then Old_Board.Columns > 0;

end Population;
