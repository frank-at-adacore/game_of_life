with Board_Pkg;
with Board_Pkg.Neighbors;
use type Board_Pkg.Cell_T;
package body Population with
   SPARK_Mode
is

   Give_Birth : constant := 3;
   Too_Few    : constant := 1;
   Too_Many   : constant := 4;

   -- if current state is dead then
   --    if number of neighbors indicates birth then return Alive
   --    else return current state
   -- else (current state is alive )
   --    if there are too few or too many neighbors then return Dead
   --    else return current state
   function Alive_Or_Dead
     (State     : Board_Pkg.Cell_T;
      Neighbors : Integer)
      return Board_Pkg.Cell_T is
     (if State = Board_Pkg.Dead then
        (if Neighbors = Give_Birth then Board_Pkg.Alive else State)
      else
        (if Neighbors <= Too_Few or else Neighbors >= Too_Many then
           Board_Pkg.Dead
         else State));

-- determine state of cell at position row/column
   function New_Cell_State
     (Board  : Board_Pkg.Board_T;
      Row    : Base_Types.Row_T;
      Column : Base_Types.Column_T)
      return Board_Pkg.Cell_T is
     (Alive_Or_Dead
        (Board.Get_State (Row, Column),
         Board_Pkg.Neighbors.Alive_Count (Board, Row, Column))) with
      Pre => Board.Rows > 0 and Board.Columns > 0;

      -- create a new board based on the state of the old board Still_Alive is
      -- TRUE if any cell remains alive
   procedure Generate
     (Board       : in out Board_Pkg.Board_T;
      Still_Alive :    out Boolean) is
      -- copy incoming board to indicate original state
      Old_Board         : constant Board_Pkg.Board_T := Board;
      State             : Board_Pkg.Cell_T;
      Last_Row_To_Check : constant Base_Types.Row_T  :=
        Base_Types.Succ (Old_Board.Rows);
      Last_Column_To_Check : constant Base_Types.Column_T :=
        Base_Types.Succ (Old_Board.Columns);
   begin
      Still_Alive := False;
      -- reset output board to ampty
      Board := Board_Pkg.Empty_Board;
      -- we don't just loop over existing rows, because alive cells at the edge
      -- of the board can great new cells in the row or column just past the
      -- edge - so we need to check those rows/columns as well
      for R in 1 .. Last_Row_To_Check
      loop
         for C in 1 .. Last_Column_To_Check
         loop
            -- determine state of cell based on neighbors in the old board
            State := New_Cell_State (Old_Board, R, C);
            -- if the state is Alive we will update the board (this may cause
            -- the board to grow) if the cell is Dead, we only update the board
            -- if the row/column is in the old range - we don't want the board
            -- to grow for a dead cell
            if State = Board_Pkg.Alive
              or else (R <= Old_Board.Rows and then C <= Old_Board.Columns)
            then
               Board.Set_State
                 (Row    => R,
                  Column => C,
                  State  => State);
               -- update flag indicating if anything is alive
               Still_Alive := Still_Alive or else State = Board_Pkg.Alive;
            end if;
         end loop;
      end loop;

   end Generate;

end Population;
