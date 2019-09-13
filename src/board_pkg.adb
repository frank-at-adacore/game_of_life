package body Board_Pkg with
   Spark_Mode
is

   procedure Set_State
     (Board  : in out Board_T;
      Row    : in     Base_Types.Row_T;
      Column : in     Base_Types.Column_T;
      State  : in     Cell_T) with
      -- CodePeer: says redundant conversion?
      Refined_Post => Board.Matrix (Row) (Segment_Index (Column))
        (Bit_Index (Column)) =
      Boolean_T (State = Alive) and
      Board.Rows = Base_Types.Row_Count_T'Max (Board.Rows, Row) and
      Board.Columns = Base_Types.Column_Count_T'Max (Board.Columns, Column)
   is
      Segment : Segment_Index_T := Segment_Index (Column);
      Bit     : Bit_Index_T     := Bit_Index (Column);
   begin
      Board.Matrix (Row) (Segment) (Bit) := Boolean_T (State = Alive);
      Board.Actual_Rows := Base_Types.Row_Count_T'Max (Board.Actual_Rows, Row);
      Board.Actual_Columns               :=
        Base_Types.Column_Count_T'Max (Board.Actual_Columns, Column);
   end Set_State;

   procedure Clear (Board : out Board_T) is
      Empty_Board : Board_T;
   begin
      Board := Empty_Board;
   end Clear;
end Board_Pkg;
