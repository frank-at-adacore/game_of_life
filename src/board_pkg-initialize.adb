with Ada.Text_Io;
package body Board_Pkg.Initialize with
   Spark_Mode
is

   procedure Add_Row
     (Board : in out Board_T;
      Row   : in     Base_Types.Row_T;
      Str   : in     String) is
   begin
      -- CodePeer: confused about the loop limit
      for I in
        1 .. Integer'Min (Integer (Base_Types.Column_T'Last), Str'Length)
      loop
         Board.Set_State
           (Row, Base_Types.Column_T (I),
            (if Str (I - Str'First + 1) = ' ' then Dead else Alive));
      end loop;
   end Add_Row;

   procedure Populate_From_User (Board : in out Board_T) is
      Row : Base_Types.Row_Count_T := Board.Rows;
   begin
      Ada.Text_Io.Put_Line ("Any non-blank character is 'live'");
      Ada.Text_Io.Put_Line ("('~' in the first column ends input)");
      loop
         exit when Row = Base_Types.Row_Count_T'Last;
         Row := Row + 1;
         declare
            Str : constant String := Ada.Text_Io.Get_Line;
         begin
            if Str'Length > 0 and then Str (Str'First) = '~'
            then
               exit;
            end if;
            Add_Row (Board, Row, Str);
         end;
      end loop;
   end Populate_From_User;

   procedure Populate_From_File
     (Board    : in out Board_T;
      Filename : in     String) is
      File : Ada.Text_Io.File_Type;
      Row  : Base_Types.Row_Count_T := Board.Rows;

   begin
      Ada.Text_Io.Open (File, Ada.Text_Io.In_File, Filename);
      while not Ada.Text_Io.End_Of_File (File)
      loop
         exit when Row = Base_Types.Row_Count_T'Last;
         Row := Row + 1;
         declare
            Line : constant String := Ada.Text_Io.Get_Line (File);
         begin
            Add_Row (Board, Row, Line);
         end;
      end loop;
      Ada.Text_Io.Close (File);
   end Populate_From_File;

end Board_Pkg.Initialize;
