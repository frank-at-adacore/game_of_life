with Board_Pkg;
with Board_Pkg.Neighbors;
use type Board_Pkg.Board_T;
use type Board_Pkg.Cell_T;
package body Population with
   Spark_Mode
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

   function New_Cell_State
     (Board  : Board_Pkg.Board_T;
      Row    : Base_Types.Row_T;
      Column : Base_Types.Column_T)
     return Board_Pkg.Cell_T is
     (Alive_Or_Dead
        (Board.Get_State (Row, Column),
         Board_Pkg.Neighbors.Alive_Count (Board, Row, Column))) with
      Pre => Board.Rows > 0 and then Board.Columns > 0
      and then Row <= Board.Rows + 1 and then Column <= Board.Columns - 1
      and then Base_Types.Pred (Row) <= Board.Rows
      and then Base_Types.Pred (Column) <= Board.Columns
      and then Base_Types.Succ (Row) <= Board.Rows + 2
      and then Base_Types.Succ (Column) <= Board.Columns + 2
      and then Base_Types.Pred (Row) <= Base_Types.Succ (Row)
      and then Base_Types.Pred (Column) <= Base_Types.Succ (Column);

   procedure Update_New_Cell
     (Old_Board   : in     Board_Pkg.Board_T;
      New_Board   : in out Board_Pkg.Board_T;
      Row         : in     Base_Types.Row_T;
      Column      : in     Base_Types.Column_T;
      State       : in     Board_Pkg.Cell_T;
      Still_Alive : in out Boolean) with
      Pre  => Old_Board.Rows > 0 and Old_Board.Columns > 0,
      Post =>
      (if State = Board_Pkg.Alive then
         (New_Board.Get_State (Row, Column) = Board_Pkg.Alive
          and then Still_Alive)
       elsif Row <= Old_Board.Rows and Column <= Old_Board.Columns then
         (New_Board.Get_State (Row, Column) = State and
          Still_Alive = Still_Alive'Old)
       else New_Board = New_Board'Old and Still_Alive = Still_Alive'Old);

   procedure Update_New_Cell
   -- if the new state is Alive, then set the cell and indicate the board has
   -- live cells only set a cell to dead if it is within the boundaries of the
   -- existing board (any cell outside the boundaries is dead by definition
     (Old_Board   : in     Board_Pkg.Board_T;
      New_Board   : in out Board_Pkg.Board_T;
      Row         : in     Base_Types.Row_T;
      Column      : in     Base_Types.Column_T;
      State       : in     Board_Pkg.Cell_T;
      Still_Alive : in out Boolean) is
   begin
      if State = Board_Pkg.Alive
      then
         New_Board.Set_State (Row => Row, Column => Column, State => State);
         Still_Alive := True;
      elsif Row <= Old_Board.Rows and then Column <= Old_Board.Columns
      then
         New_Board.Set_State (Row => Row, Column => Column, State => State);
      end if;
   end Update_New_Cell;

   procedure Generate
     (Old_Board   : in     Board_Pkg.Board_T;
      New_Board   : in out Board_Pkg.Board_T;
      Still_Alive :    out Boolean) is
      State : Board_Pkg.Cell_T;
   begin
      Still_Alive := False;
      for R in 1 .. Base_Types.Succ (Old_Board.Rows)
      loop
         pragma ASSERT (R <= Old_Board.Rows + 1);
         for C in 1 .. Base_Types.Succ (Old_Board.Columns)
         loop
            pragma ASSERT (C <= Old_Board.Columns + 1);
            State := New_Cell_State (Old_Board, R, C);
            Update_New_Cell (Old_Board, New_Board, R, C, State, Still_Alive);
         end loop;
      end loop;

   end Generate;

end Population;
