with Ada.Strings.Unbounded;
with Glib;
with Glib.Main;
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
use type Base_Types.Row_Count_T;
use type Board_Pkg.Cell_T;
use type Glib.Gint;
use type Glib.Guint;

package body Display with
   Spark_Mode
is

   package Asu renames Ada.Strings.Unbounded;

   Max_Generations : constant := 50;
   type Generation_Index_T is mod Max_Generations;
   Global_Board      : array (Generation_Index_T) of Board_Pkg.Board_T;
   Global_Generation : Generation_Index_T := 0;

   procedure Create_Cell
     (Board_Row    : in Base_Types.Row_T;
      Board_Column : in Base_Types.Column_T) is
      Scale : Glib.Guint := Display_Buttons.Scale_Value;
      State : Board_Pkg.Cell_T;

      Row    : Glib.Gdouble := Glib.Gdouble (Scale * Glib.Guint (Board_Row));
      Column : Glib.Gdouble :=
        Glib.Gdouble (Scale * Glib.Guint (Board_Column));
      Height : constant Glib.Guint := Scale * 9 / 10;
      Width  : constant Glib.Guint := Scale * 9 / 10;
      Color  : Cairo_Utilities.Color_T;

   begin
      State :=
        Global_Board (Global_Generation).Get_State (Board_Row, Board_Column);

      if State = Board_Pkg.Alive
      then
         Color := Cairo_Utilities.Color_Green;
      else
         Color := Cairo_Utilities.Color_Black;
      end if;
      Set_Size
        (Width  => Glib.Gint (Column) + Glib.Gint (Width),
         Height => Glib.Gint (Row) + Glib.Gint (Height));
      Cairo_Utilities.Draw_Box
        (Center_X => Column, Center_Y => Row, Height => Glib.Gdouble (Height),
         Width    => Glib.Gdouble (Width), Color => Color);

   end Create_Cell;

   procedure Refresh is
   begin
      Main_Window.Queue_Draw;
   end Refresh;

   Global_Timer_Msec : Integer := -1;
   Global_Timer      : Glib.Main.G_Source_Id;

   procedure Update_Timer (Timeout : in Glib.Guint) is
   begin
      Debug.Print ("Display.Update_Timer" & Timeout'Img);
      if Global_Timer_Msec /= Integer (Timeout)
        and then Global_Timer_Msec <= Integer'Last
      then
         if Global_Timer_Msec > 0
         then
            Glib.Main.Remove (Global_Timer);
         end if;
         Global_Timer_Msec := Integer (Timeout);
         Global_Timer      := Glib.Main.Timeout_Add (Timeout, Update'Access);
      end if;
   end Update_Timer;

   Global_Da_Width         : Glib.Gint := -1;
   Global_Da_Height        : Glib.Gint := -1;
   Global_Requested_Width  : Glib.Gint := -1;
   Global_Requested_Height : Glib.Gint := -1;

   procedure Set_Size
     (Width  : Glib.Gint;
      Height : Glib.Gint) is
   begin
      if Width > Global_Requested_Width
      then
         Global_Requested_Width := 3 * Width / 2;
      end if;
      if Height > Global_Requested_Height
      then
         Global_Requested_Height := 3 * Height / 2;
      end if;
   end Set_Size;

   function Update_Board return Boolean is
      Anything_Alive : Boolean := False;
   begin
      Cairo_Utilities.Clear_Surface;

      if Global_Da_Width < Global_Requested_Width
        or else Global_Da_Height < Global_Requested_Height
      then
         Global_Da_Width  := Global_Requested_Width;
         Global_Da_Height := Global_Requested_Height;
         Drawing_Area.Set_Size_Request (Global_Da_Width, Global_Da_Height);
      end if;

      for R in 1 .. Global_Board (Global_Generation).Rows
      loop
         for C in 1 .. Global_Board (Global_Generation).Columns
         loop
            Create_Cell (R, C);
         end loop;
      end loop;
      if Global_Board (Global_Generation).Rows > 0
      then
         Global_Generation := Global_Generation + 1;
         Population.Generate
           (Global_Board (Global_Generation - 1),
            Global_Board (Global_Generation), Anything_Alive);
      end if;
      Refresh;
      return Anything_Alive;
   end Update_Board;

   Global_Last_Timer    : Glib.Guint           := 0;
   Global_Last_Filename : Asu.Unbounded_String := Asu.Null_Unbounded_String;

   function Update return Boolean is
      Timer    : Glib.Guint      := Display_Buttons.Timer_Value;
      Filename : constant String := Display_Buttons.Filename;
      Ret_Val  : Boolean         := True;
   begin
      if Filename /= Asu.To_String (Global_Last_Filename)
      then
         Global_Last_Filename := Asu.To_Unbounded_String (Filename);
         Global_Last_Timer    := Timer;
         Initialize (Filename, Timer);
      elsif Timer /= Global_Last_Timer
      then
         Global_Last_Timer := Timer;
         Update_Timer (Timer);
      end if;
      if Global_Last_Filename /= Asu.Null_Unbounded_String
      then
         Ret_Val := Update_Board;
      end if;
      return Ret_Val;
   end Update;

   procedure Initialize
     (Filename     : in String := "";
      Timeout_Msec : in Glib.Guint) is
   begin
      Debug.Print ("Display.Initialize " & Filename & Timeout_Msec'Img);
      Update_Timer (Timeout_Msec);
      if Filename'Length > 0
      then
         Board_Pkg.Clear (Global_Board (0));
         Global_Generation := 0;
         Board_Pkg.Initialize.Populate_From_File (Global_Board (0), Filename);
      end if;
   end Initialize;

end Display;
