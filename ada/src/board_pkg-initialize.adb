with Ada.Text_IO;
package body Board_Pkg.Initialize with
   SPARK_Mode
is

   subtype String_Length_T is
     Natural range 0 .. Natural (Base_Types.Column_T'Last);
   subtype String_Index_T is String_Length_T range 1 .. String_Length_T'Last;
   subtype Constrained_String_T is String (1 .. String_Index_T'Last);

   -- Convert a string of blanks and non-blanks into cell states (any non-blank
   -- means cell is alive)
   procedure Add_Row
     (Board  : in out Board_T;
      Row    : in     Base_Types.Row_T;
      Str    : in     Constrained_String_T;
      Length :        String_Length_T) is
   begin
      for Column in 1 .. Length
      loop
         Set_State
           (Board  => Board,
            Row    => Row,
            Column => Base_Types.Column_T (Column),
            State  => (if Str (Column) = ' ' then Dead else Alive));
      end loop;
   end Add_Row;

   -- read from specified file
   procedure Populate_From_File
     (Board    :    out Board_T;
      Filename : in     String) is
      File   : Ada.Text_IO.File_Type;
      Str    : Constrained_String_T;
      Length : String_Length_T;
      Row    : Base_Types.Row_Count_T := 1;
   begin
      Board.Clear;
      Ada.Text_IO.Open (File, Ada.Text_IO.In_File, Filename);
      while not Ada.Text_IO.End_Of_File (File) and then Row in Base_Types.Row_T
      loop
         exit when Row = Base_Types.Row_Count_T'Last;
         Ada.Text_IO.Get_Line (File, Str, Length);
         pragma Annotate (Codepeer, Intentional, "range check",
            "string length will never be > 1000");
         Add_Row (Board, Row, Str, Length);
         Row := Row + 1;
      end loop;
      Ada.Text_IO.Close (File);
   end Populate_From_File;

end Board_Pkg.Initialize;
