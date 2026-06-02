with Gdk.Rgba;
with Glib;
with Gtk.Button;
with Gtk.Color_Button;
with Gtk.File_Chooser;
with Gtk.File_Chooser_Button;
with Gtk.Grid;
with Gtk.Label;
with Gtk.Spin_Button;
with Gtkada.Handlers;
--
with Callbacks;
with Debug;
--
use type Gtk.Color_Button.Gtk_Color_Button;
use type Gtk.File_Chooser_Button.Gtk_File_Chooser_Button;
use type Gtk.Grid.Gtk_Grid;
use type Gtk.Spin_Button.Gtk_Spin_Button;
use type Glib.Gdouble;

package body Display_Buttons is

   -- button objects
   Global_File_Chooser : Gtk.File_Chooser_Button.Gtk_File_Chooser_Button;
   Global_Timer_Button : Gtk.Spin_Button.Gtk_Spin_Button;
   Global_Scale_Button : Gtk.Spin_Button.Gtk_Spin_Button;
   Global_Color_Button : Gtk.Color_Button.Gtk_Color_Button;

   -- create a 'quit' button
   function Quit_Button
     (Main_Window : Gtk.Window.Gtk_Window)
     return Gtk.Button.Gtk_Button is
      Button : Gtk.Button.Gtk_Button;
   begin
      Gtk.Button.Gtk_New (Button, "Quit");
      -- connect button to 'quit' callback
      Gtkada.Handlers.Widget_Callback.Object_Connect
        (Button, "clicked",
         Gtkada.Handlers.Widget_Callback.To_Marshaller
           (Callbacks.Main_Quit'Access),
         Main_Window);
      return Button;
   end Quit_Button;

   -- return file specified by chooser
   function Filename return String is
   begin
      if Global_File_Chooser /= null
      then
         return Global_File_Chooser.Get_Filename;
      end if;
      return ""; -- no file selected
   end Filename;

   -- create file chooser button
   procedure Create_File_Chooser_Button (Success : out Boolean) is
   begin
      Success := False;
      Global_File_Chooser :=
        Gtk.File_Chooser_Button.Gtk_File_Chooser_Button_New
          ("Select starting file", Gtk.File_Chooser.Action_Open);
      -- if button is created
      if Global_File_Chooser /= null
      then
         -- set size of button and add tooltip
         Success := True;
         Gtk.File_Chooser_Button.Set_Width_Chars (Global_File_Chooser, 80);
         Gtk.File_Chooser_Button.Set_Tooltip_Text
           (Global_File_Chooser, "Select file containing initial setup");
      end if;
   end Create_File_Chooser_Button;

   -- create timer button
   procedure Create_Timer_Button (Success : out Boolean) is
   begin
               Success := False;
      Global_Timer_Button :=
        Gtk.Spin_Button.Gtk_Spin_Button_New_With_Range (0.1, 10.0, 0.1);
      -- if button was created
      if Global_Timer_Button /= null
      then
         -- set default value for button and add tooltip
         Success := True;
         Gtk.Spin_Button.Set_Value (Global_Timer_Button, 0.5);
         Gtk.Spin_Button.Set_Tooltip_Text
           (Global_Timer_Button, "Time (in seconds) between generations");
      end if;
   end Create_Timer_Button;

   -- Timer button displays in seconds, but we need it in milliseconds, so this
   -- function will query the button and return an appropriate value
   function Timer_Value_In_Msec return Timer_Value_In_Msec_T is
      Ret_Val : Glib.Guint := 500;
   begin
      -- make sure button has been created
      if Global_Timer_Button /= null
      then
         declare
            -- button value is floating point
            Seconds : constant Glib.Gdouble := Global_Timer_Button.Get_Value;
         begin
            -- if the button value is in range
            if Seconds >= Glib.Gdouble (Timer_Value_In_Msec_T'First) / 1_000.0
              and then Seconds <=
                Glib.Gdouble (Timer_Value_In_Msec_T'Last) / 1_000.0
            then
               -- convert the button value from floating point seconds to
               -- integer milliseconds
               Ret_Val := Glib.Guint (Seconds * 1_000.0);
            end if;
         end;
      end if;
      return Ret_Val;
   end Timer_Value_In_Msec;

   -- create scaling factor button
   procedure Create_Scale_Button (Success : out Boolean) with
      Global => Global_Scale_Button
   is
   begin
      Success := False;
      -- create button
      Global_Scale_Button :=
        Gtk.Spin_Button.Gtk_Spin_Button_New_With_Range (5.0, 100.0, 1.0);
      -- if successful
      if Global_Scale_Button /= null
      then
         -- set default value and add tooltip
         Success := True;
         Gtk.Spin_Button.Set_Value (Global_Scale_Button, 25.0);
         Gtk.Spin_Button.Set_Tooltip_Text
           (Global_Scale_Button, "Scaling factor for cells (5..100)");
      end if;
   end Create_Scale_Button;

   -- get scaling factor
   function Scale_Value return Scale_Value_T is
      Ret_Val : Scale_Value_T := 25;
   begin
      -- if button was created
      if Global_Scale_Button /= null
      then
         declare
            Value : Glib.Gdouble;
         begin
            Value := Global_Scale_Button.Get_Value;
            -- if button value is in range
            if Value >= Glib.Gdouble (Scale_Value_T'First)
              and then Value <= Glib.Gdouble (Scale_Value_T'Last)
            then
               -- return integer value of floating point scale
               Ret_Val := Glib.Guint (Value);
            end if;
         end;
      end if;
      return Ret_Val;
   end Scale_Value;

   -- get selected color value
   function Selected_Color return Cairo_Utilities.Color_T is
      Selected : Gdk.Rgba.Gdk_Rgba := Gdk.Rgba.Black_Rgba;
   begin
      -- if button was created
      if Global_Color_Button /= null
      then
         -- get selected color
         Gtk.Color_Button.Get_Rgba (Global_Color_Button, Selected);
      end if;
      -- return color converted into our own format
      return Cairo_Utilities.Convert (Selected);
   end Selected_Color;

   -- create color button
   procedure Create_Color_Button (Success : out Boolean) is
   begin
      Success := False;
      Global_Color_Button := Gtk.Color_Button.Gtk_Color_Button_New;
      -- if button was created
      if Global_Color_Button /= null
      then
         -- set default color value and add tooltip
         Success := True;
         Gtk.Color_Button.Set_Rgba
           (Global_Color_Button,
            Cairo_Utilities.Convert (Cairo_Utilities.Color_Green));
         Gtk.Color_Button.Set_Tooltip_Text
           (Global_Color_Button, "Color of 'live' cells");
      end if;

   end Create_Color_Button;

   -- create widget containing buttons
   procedure Create_Widget
     (Main_Window : in     Gtk.Window.Gtk_Window;
      Widget      :    out Gtk.Widget.Gtk_Widget) is
      Grid    : Gtk.Grid.Gtk_Grid;
      Success : Boolean;
   begin
      -- create a grid to contain the buttons
      Grid := Gtk.Grid.Gtk_Grid_New;
      -- if grid was created
      if Grid /= null
      then
         -- create each of the buttons as long as we're successful
         Create_File_Chooser_Button (Success);
         if Success
         then
            Create_Timer_Button (Success);
         end if;
         if Success
         then
            Create_Scale_Button (Success);
         end if;
         if Success
         then
            Create_Color_Button (Success);
         end if;
         -- if everthing has succeeded
         if Success
         then
            -- add button labels to the grid
            Gtk.Grid.Attach
              (Grid, Gtk.Label.Gtk_Label_New ("Starting file"), 0, 0, 3, 1);
            pragma ANNOTATE (Codepeer, Intentional, "access check",
               "gtk issue");
            Gtk.Grid.Attach
              (Grid, Gtk.Label.Gtk_Label_New ("Delay timer"), 3, 0, 1, 1);
            pragma ANNOTATE (Codepeer, Intentional, "access check",
               "gtk issue");
            Gtk.Grid.Attach
              (Grid, Gtk.Label.Gtk_Label_New ("Scale"), 4, 0, 1, 1);
            pragma ANNOTATE (Codepeer, Intentional, "access check",
               "gtk issue");
            Gtk.Grid.Attach
              (Grid, Gtk.Label.Gtk_Label_New ("Cell color"), 5, 0, 1, 1);
            pragma ANNOTATE (Codepeer, Intentional, "access check",
               "gtk issue");
            Gtk.Grid.Attach
              (Grid, Gtk.Label.Gtk_Label_New ("      "), 6, 0, 1, 1);
            pragma ANNOTATE (Codepeer, Intentional, "access check",
               "gtk issue");

            -- add buttons to the grid
            Gtk.Grid.Attach (Grid, Global_File_Chooser, 0, 1, 3, 1);
            Gtk.Grid.Attach (Grid, Global_Timer_Button, 3, 1, 1, 1);
            Gtk.Grid.Attach (Grid, Global_Scale_Button, 4, 1, 1, 1);
            Gtk.Grid.Attach (Grid, Global_Color_Button, 5, 1, 1, 1);
            Gtk.Grid.Attach (Grid, Quit_Button (Main_Window), 7, 1, 1, 1);
            pragma ANNOTATE (Codepeer, Intentional, "access check",
               "gtk issue");

            -- do not let grid grow vertically
            Gtk.Grid.Set_Vexpand_Set (Grid, True);
            Gtk.Grid.Set_Vexpand (Grid, False);
         end if;
         Widget := Gtk.Widget.Gtk_Widget (Grid);
      end if;
   end Create_Widget;

end Display_Buttons;
