package body Board_Pkg with
   SPARK_Mode
is

   -- updated postcondition: if we're calling this function on a row/column,
   -- then update the used rows/columns based on the input values if necessary
   procedure Set_State
     (Board  : in out Board_T;
      Row    : in     Base_Types.Row_T;
      Column : in     Base_Types.Column_T;
      State  : in     Cell_T) with
      Refined_Post => Board.Matrix (Row) (Column) = State and
      (if Row > Board'Old.Actual_Rows then Board.Actual_Rows = Row
       else Board'Old.Actual_Rows = Board.Actual_Rows) and
      (if Column > Board'Old.Actual_Columns then Board.Actual_Columns = Column
       else Board'Old.Actual_Columns = Board.Actual_Columns)
   is
   begin
      -- set cell to new state
      Board.Matrix (Row) (Column) := State;
      -- update used rows/columns to ensure this row/column is included
      if Row > Board.Actual_Rows
      then
         Board.Actual_Rows := Row;
      end if;
      if Column >= Board.Actual_Columns
      then
         Board.Actual_Columns := Column;
      end if;
   end Set_State;

   -- reset board
   procedure Clear (Board : out Board_T) is
   begin
      Board := Empty_Board;
   end Clear;

   function "="
     (Left, Right : Board_T)
      return Boolean is
   begin
      if Left.Rows /= Right.Rows
      then
         return False;
      elsif Left.Columns /= Right.Columns
      then
         return False;
      elsif Left.Rows = 0 and then Right.Rows = 0
      then
         return True;
      elsif Left.Rows in Matrix_T'Range
      then
         for R in 1 .. Left.Rows
         loop
            if Left.Columns in Left.Matrix (R)'Range
            then
               for C in 1 .. Left.Columns
               loop
                  if Left.Matrix (R) (C) /= Right.Matrix (R) (C)
                  then
                     return False;
                  end if;
               end loop;
            else
               return False;
            end if;
         end loop;
         return True;
      else
         return False;
      end if;
   end "=";

end Board_Pkg;
