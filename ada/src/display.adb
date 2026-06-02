with Ada.Strings.Unbounded;
with Glib;
with Glib.Main;
with Gtk.Drawing_Area;
with Gtk.Window;
--
with Base_Types;
with Board_Pkg;
with Board_Pkg.Initialize;
with Cairo_Utilities;
with Debug;
with Display_Buttons;
with Population;
--
use type Ada.Strings.Unbounded.Unbounded_String;
use type Base_Types.Column_Count_T;
use type Base_Types.Row_Count_T;
use type Board_Pkg.Cell_T;
use type Glib.Gdouble;
use type Glib.Gint;
use type Glib.Guint;
use type Glib.Main.G_Source_Id;
use type Gtk.Drawing_Area.Gtk_Drawing_Area;
use type Gtk.Window.Gtk_Window;

package body Display is

   package Asu renames Ada.Strings.Unbounded;

   Global_Board : Board_Pkg.Board_T := Board_Pkg.Empty_Board;

   -- determine cell colors based on user-selected color
   procedure Initialize_Colors
     (Alive_Color : out Cairo_Utilities.Color_T;
      Dead_Color  : out Cairo_Utilities.Color_T) is
   begin
      Alive_Color := Display_Buttons.Selected_Color;
      Dead_Color  := Cairo_Utilities.Complementary_Color (Alive_Color);
      -- if the three values are similar, the complement is going to be almost
      -- the same, making it hard to distinguish
      if abs (Alive_Color.Red - Alive_Color.Blue) < 0.05
        and then abs (Alive_Color.Red - Alive_Color.Green) < 0.05
      then
         if Dead_Color.Red < 0.5
         then
            Dead_Color.Red := Dead_Color.Red + 0.4;
         else
            Dead_Color.Red := Dead_Color.Red - 0.4;
         end if;
      end if;
   end Initialize_Colors;

   -- create a cell at the specified location with the specified color
   procedure Create_Cell
     (Board_Row    : in Base_Types.Row_T;
      Board_Column : in Base_Types.Column_T;
      Color        : in Cairo_Utilities.Color_T) is
      Scale : constant Glib.Guint := Display_Buttons.Scale_Value;
      -- convert board row/column to appropriate coordinates
      Row : constant Glib.Gdouble :=
        Glib.Gdouble (Scale * Glib.Guint (Board_Row));
      Column : constant Glib.Gdouble :=
        Glib.Gdouble (Scale * Glib.Guint (Board_Column));
      -- determine height and width of cell
      Height : constant Glib.Guint := Scale * 9 / 10;
      Width  : constant Glib.Guint := Scale * 9 / 10;
   begin
      -- draw box around coordinates with appropriate size and color
      Cairo_Utilities.Draw_Box
        (Center_X => Column,
         Center_Y => Row,
         Height   => Glib.Gdouble (Height),
         Width    => Glib.Gdouble (Width),
         Color    => Color);
   end Create_Cell;

   -- redraw window
   procedure Refresh is
   begin
      Gtk.Window.Queue_Draw (Global_Main_Window);
   end Refresh;

   Global_Timer : Glib.Main.G_Source_Id;

   -- update timer based on button value
   procedure Update_Timer is
      Timer : constant Glib.Guint := Display_Buttons.Timer_Value_In_Msec;
   begin
      -- remove old timer if it is there
      if Global_Timer /= Glib.Main.No_Source_Id
      then
         Glib.Main.Remove (Global_Timer);
      end if;
      -- set new timer based on button value
      Global_Timer := Glib.Main.Timeout_Add (Timer, Update'Access);
   end Update_Timer;

   -- set size of window based on size of board
   procedure Set_Size
     (Rows    : Base_Types.Row_Count_T;
      Columns : Base_Types.Column_Count_T) is
   begin
      -- make sure drawing area is set
      if Global_Drawing_Area /= null
      then
         declare
            -- get user-specified scaling factor
            Scale : constant Display_Buttons.Scale_Value_T :=
              Display_Buttons.Scale_Value;
            -- get current drawing area width/height
            Current_Width : constant Glib.Gint :=
              Global_Drawing_Area.Get_Allocated_Width;
            Current_Height : constant Glib.Gint :=
              Global_Drawing_Area.Get_Allocated_Height;
            -- get width/height we need to draw board
            Requested_Width : constant Glib.Gint :=
              Glib.Gint (Columns) * Glib.Gint (Scale);
            Requested_Height : constant Glib.Gint :=
              Glib.Gint (Rows) * Glib.Gint (Scale);
         begin
            -- if board is to short or narrow
            if Requested_Width > Current_Width
              or else Requested_Height > Current_Height
            then
               -- ask for more than we need so we don't keep resizing
               Gtk.Drawing_Area.Set_Size_Request
                 (Global_Drawing_Area, Requested_Width * 3 / 2,
                  Requested_Height * 3 / 2);
            end if;
         end;
      end if;
   end Set_Size;

   -- update the board values
   procedure Update_Board (Anything_Alive : out Boolean) is
      Alive_Color, Dead_Color : Cairo_Utilities.Color_T;
      Color                   : Cairo_Utilities.Color_T;
   begin
      Anything_Alive := False;
      Cairo_Utilities.Clear_Surface;
      -- set size of board based on used rows/columns
      Set_Size
        (Rows    => Global_Board.Rows,
         Columns => Global_Board.Columns);
      -- set cell colors based on user-specified color
      Initialize_Colors (Alive_Color, Dead_Color);
      -- for each cell
      for R in 1 .. Global_Board.Rows
      loop
         for C in 1 .. Global_Board.Columns
         loop
            -- set color based on state of the cell
            if Board_Pkg.Get_State (Global_Board, R, C) = Board_Pkg.Alive
            then
               Color := Alive_Color;
            else
               Color := Dead_Color;
            end if;
            -- create a cell of the necessary color
            Create_Cell (R, C, Color);
         end loop;
      end loop;
      -- if board is populated
      if Global_Board.Rows > 0 and Global_Board.Columns > 0
      then
         -- update cell states
         Population.Generate (Global_Board, Anything_Alive);
      end if;
      Refresh;
   end Update_Board;

   Global_Last_Filename : Asu.Unbounded_String := Asu.Null_Unbounded_String;

   -- update board based on specified file change OR current board display
   function Update return Boolean is
      Filename : constant String := Display_Buttons.Filename;
      Ret_Val  : Boolean         := True;
   begin
      -- only if window has been initialized
      if Global_Main_Window /= null
      then
         -- if specified filename has changed
         if Filename /= Asu.To_String (Global_Last_Filename)
         then
            -- save filename
            Global_Last_Filename := Asu.To_Unbounded_String (Filename);
            -- Reset board and load file
            Board_Pkg.Clear (Global_Board);
            Board_Pkg.Initialize.Populate_From_File (Global_Board, Filename);
         end if;
         -- reset timer
         Update_Timer;
         -- if the board is active, update the board
         if Global_Last_Filename /= Asu.Null_Unbounded_String
           and then Global_Board.Rows > 0 and then Global_Board.Columns > 0
         then
            Update_Board (Ret_Val);
         end if;
      end if;
      return Ret_Val;
   end Update;

   -- start timer
   procedure Initialize is
   begin
      Debug.Print ("Display.Initialize");
      Update_Timer;
   end Initialize;

end Display;
