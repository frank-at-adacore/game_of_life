with Base_Types;
use type Base_Types.Row_Count_T;
use type Base_Types.Column_Count_T;
package Board_Pkg with
   Spark_Mode
is

   type Board_T is tagged private;
   type Cell_T is (Alive, Dead);

   function Rows
     (Board : Board_T)
     return Base_Types.Row_Count_T;
   function Columns
     (Board : Board_T)
     return Base_Types.Column_Count_T;

   procedure Set_State
     (Board  : in out Board_T;
      Row    : in     Base_Types.Row_T;
      Column : in     Base_Types.Column_T;
      State  : in     Cell_T) with
      Post => Get_State (Board, Row, Column) = State;

   function Get_State
     (Board  : in Board_T;
      Row    : in Base_Types.Row_T;
      Column : in Base_Types.Column_T)
     return Cell_T;

   function "="
     (Left, Right : Board_T)
     return Boolean;

   procedure Clear (Board : out Board_T) with
      Post => Board.Rows = 0 and then Board.Columns = 0;

private

   Word_Size    : constant := 32;
   Max_Segments : constant := (Base_Types.Max_Columns / Word_Size) + 1;

   type Boolean_T is new Boolean with
      Size => 1;
   type Bit_Index_T is mod Word_Size;
   type Row_Segment_T is array (Bit_Index_T) of Boolean_T with
      Size => Word_Size;
   pragma PACK (Row_Segment_T);
   type Segment_Index_T is mod Max_Segments;
   type Actual_Row_T is array (Segment_Index_T) of Row_Segment_T;
   type Matrix_T is array (Base_Types.Row_T) of Actual_Row_T;
   type Board_T is tagged record
      Matrix         : Matrix_T := (others => (others => (others => False)));
      Actual_Rows    : Base_Types.Row_Count_T    := 0;
      Actual_Columns : Base_Types.Column_Count_T := 0;
   end record;

   function Segment_Index
     (Column : Base_Types.Column_T)
     return Segment_Index_T is
     (Segment_Index_T (Integer (Column) / Max_Segments));
   function Bit_Index
     (Column : Base_Types.Column_T)
     return Bit_Index_T is (Bit_Index_T (Integer (Column) rem Max_Segments));

   function Rows
     (Board : Board_T)
     return Base_Types.Row_Count_T is (Board.Actual_Rows);
   function Columns
     (Board : Board_T)
     return Base_Types.Column_Count_T is (Board.Actual_Columns);

   function "="
     (Left, Right : Board_T)
     return Boolean is
     (if Left.Rows /= Right.Rows then False
      elsif Left.Columns /= Right.Columns then False
      elsif Left.Rows = 0 and Right.Rows = 0 then True
      else
        (for all R in 1 .. Left.Rows =>
           (for all C in 1 .. Left.Columns =>
              Left.Matrix (R) (Segment_Index (C)) (Bit_Index (C)) =
              Right.Matrix (R) (Segment_Index (C)) (Bit_Index (C)))));

   function Get_State
     (Board  : in Board_T;
      Row    : in Base_Types.Row_T;
      Column : in Base_Types.Column_T)
     return Cell_T is
     (if Row > Board.Rows or else Column > Board.Columns then Dead
      elsif Board.Matrix (Row) (Segment_Index (Column)) (Bit_Index (Column))
      then Alive
      else Dead);

end Board_Pkg;
