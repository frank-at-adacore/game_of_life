with Base_Types;

package Board_Pkg.Neighbors with
   Spark_Mode
is

   function Alive_Count
     (Board  : Board_T;
      Row    : Base_Types.Row_T;
      Column : Base_Types.Column_T)
     return Integer with
     Pre => Row <= Board.Rows + 1
     and then Column <= Board.Columns + 1
      and then Base_Types.Pred (Row) <= Board.Rows
      and then Base_Types.Succ (Row) <= Board.Rows + 2
      and then Base_Types.Pred (Column) <= Board.Columns
      and then Base_Types.Succ (Column) <= Board.Columns + 2
      and then Base_Types.Pred (Row) <= Base_Types.Succ (Row)
      and then Base_Types.Pred (Column) <= Base_Types.Succ (Column);

private

   function Max_Count
     (First : Base_Types.Column_T;
      Last  : Base_Types.Column_T)
     return Natural is (Natural (Last) - Natural (First) + 1) with
      Pre => First <= Last;

   function Max_Count
     (First : Base_Types.Row_T;
      Last  : Base_Types.Row_T)
     return Natural is (Natural (Last) - Natural (First) + 1) with
      Pre => First <= Last;

   function Count_Columns
     (Board        : Board_T;
      Row          : Base_Types.Row_T;
      First_Column : Base_Types.Column_T;
      Last_Column  : Base_Types.Column_T)
     return Natural is
      -- CodePeer says the matrix is not initialized?

     (if First_Column =
        Last_Column then
        (if Board.Get_State (Row, First_Column) = Alive then 1 else 0)
      else -- first_column < last_column

        (if Board.Get_State (Row, First_Column) = Alive then
           1 + Count_Columns (Board, Row, First_Column + 1, Last_Column)
         else Count_Columns (Board, Row, First_Column + 1, Last_Column))) with
      Pre => Row in 1 .. Board.Rows and then First_Column in 1 .. Board.Columns
      and then Last_Column in 1 .. Board.Columns
      and then First_Column <= Last_Column,
      Post => Count_Columns'Result <= Max_Count (First_Column, Last_Column);

   function Count_Rows
     (Board        : Board_T;
      First_Row    : Base_Types.Row_T;
      Last_Row     : Base_Types.Row_T;
      First_Column : Base_Types.Column_T;
      Last_Column  : Base_Types.Column_T)
     return Natural is
     (if First_Row = Last_Row then
        Count_Columns (Board, First_Row, First_Column, Last_Column)
      else Count_Columns (Board, First_Row, First_Column, Last_Column) +
        Count_Rows
          (Board, First_Row + 1, Last_Row, First_Column, Last_Column)) with
      Pre => First_Row in 1 .. Board.Rows and then Last_Row in 1 .. Board.Rows
      and then First_Row <= Last_Row
      and then First_Column in 1 .. Board.Columns
      and then Last_Column in 1 .. Board.Columns
      and then First_Column <= Last_Column,
      Post => Count_Rows'Result <=
      Max_Count (First_Row, Last_Row) * Max_Count (First_Column, Last_Column);

   function Alive_Count
     (Board  : Board_T;
      Row    : Base_Types.Row_T;
      Column : Base_Types.Column_T)
     return Integer is
     (if Board.Get_State (Row, Column) = Alive then
        Count_Rows
          (Board, Base_Types.Pred (Row), Base_Types.Succ (Row),
           Base_Types.Pred (Column), Base_Types.Succ (Column)) -
        1
      else Count_Rows
          (Board, Base_Types.Pred (Row), Base_Types.Succ (Row),
           Base_Types.Pred (Column), Base_Types.Succ (Column)));

end Board_Pkg.Neighbors;
