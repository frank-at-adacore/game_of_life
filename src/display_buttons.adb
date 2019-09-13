with Ada.Strings.Unbounded;
with Glib;
with Gtk.Button;
with Gtk.File_Chooser;
with Gtk.File_Chooser_Button;
with Gtk.Hbutton_Box;
with Gtk.Spin_Button;
with Gtkada.Handlers;
--
with Callbacks;
with Debug;
--
use type Gtk.File_Chooser_Button.Gtk_File_Chooser_Button;
use type Gtk.Spin_Button.Gtk_Spin_Button;
use type Glib.Gdouble;

package body Display_Buttons with
   Spark_Mode
is

   package Asu renames Ada.Strings.Unbounded;

   Global_File_Chooser : Gtk.File_Chooser_Button.Gtk_File_Chooser_Button;
   Global_Timer_Button : Gtk.Spin_Button.Gtk_Spin_Button;
   Global_Scale_Button : Gtk.Spin_Button.Gtk_Spin_Button;

   function Quit_Button
     (Main_Window : Gtk.Window.Gtk_Window)
     return Gtk.Button.Gtk_Button is
      Button : Gtk.Button.Gtk_Button;
   begin
      Gtk.Button.Gtk_New (Button, "Quit");
      Gtkada.Handlers.Widget_Callback.Object_Connect
        (Button, "clicked",
         Gtkada.Handlers.Widget_Callback.To_Marshaller
           (Callbacks.Main_Quit'Access),
         Main_Window);
      return Button;
   end Quit_Button;

   procedure Create_File_Chooser_Button is
   begin
      Global_File_Chooser :=
        Gtk.File_Chooser_Button.Gtk_File_Chooser_Button_New
          ("Select starting file", Gtk.File_Chooser.Action_Open);
      Global_File_Chooser.Set_Width_Chars (80);
      Global_File_Chooser.Set_Tooltip_Text ( "Select file containing initial setup");
   end Create_File_Chooser_Button;

   procedure Create_Timer_Button is
   begin
      Global_Timer_Button :=
        Gtk.Spin_Button.Gtk_Spin_Button_New_With_Range (0.1, 10.0, 0.1);
      Global_Timer_Button.Set_Tooltip_Text ( "Time (in seconds) between generations" );
   end Create_Timer_Button;
   function Timer_Value return Glib.Guint is
   begin
      if Global_Timer_Button = null
      then
         return 1000;
      else
         declare
            Value : Glib.Gdouble;
         begin
            Value := Global_Timer_Button.Get_Value;
            -- CodePeer warning: value * 1000 > guint'last
            return Glib.Guint (Value * 1000.0);
         end;
      end if;
   end Timer_Value;

   procedure Create_Scale_Button is
   begin
      Global_Scale_Button :=
        Gtk.Spin_Button.Gtk_Spin_Button_New_With_Range (1.0, 100.0, 1.0);
      Global_Scale_Button.Set_Value (50.0);
      Global_Scale_Button.Set_Tooltip_Text ( "Scaling factor for cells (1..100)" );
   end Create_Scale_Button;
   function Scale_Value return Glib.Guint is
   begin
      if Global_Scale_Button = null
      then
         return 50;
      else
         declare
            Value : Glib.Gdouble;
         begin
            Value := Global_Scale_Button.Get_Value;
            -- CodePeer warning: value > guint'last
            return Glib.Guint (Value);
         end;
      end if;
   end Scale_Value;

   function Widget
     (Main_Window : Gtk.Window.Gtk_Window)
     return Gtk.Widget.Gtk_Widget is
      Hbox : Gtk.Hbutton_Box.Gtk_Hbutton_Box;
   begin
      Hbox := Gtk.Hbutton_Box.Gtk_Hbutton_Box_New;
      Create_File_Chooser_Button;
      Create_Timer_Button;
      Create_Scale_Button;
      Hbox.Add (Global_File_Chooser);
      Hbox.Add (Global_Timer_Button);
      Hbox.Add (Global_Scale_Button);
      Hbox.Add (Quit_Button (Main_Window));
      Hbox.Set_Vexpand_Set (True);
      Hbox.Set_Vexpand (False);
      return Gtk.Widget.Gtk_Widget (Hbox);
   end Widget;

   function Filename return String is
   begin
      if Global_File_Chooser /= null
      then
         return Global_File_Chooser.Get_Filename;
      end if;
      return "";
   end Filename;

   Global_Last_Filename : Asu.Unbounded_String := Asu.Null_Unbounded_String;
   function Update return Boolean is
   begin
      if Filename /= Asu.To_String (Global_Last_Filename)
      then
         Global_Last_Filename := Asu.To_Unbounded_String (Filename);
      end if;
      return True;
   end Update;

end Display_Buttons;
