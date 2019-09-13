with Glib;
with Gtk.Widget;
with Gtk.Window;

with Cairo_Utilities;
package Display_Buttons is

   subtype Timer_Value_In_Msec_T is Glib.Guint range 1 .. 10_000;
   subtype Scale_Value_T is Glib.Guint range 1 .. 200;

   -- create widget containing buttons
   procedure Create_Widget
     (Main_Window : in     Gtk.Window.Gtk_Window;
      Widget      :    out Gtk.Widget.Gtk_Widget);

      -- Timer button displays in seconds, but we need it in milliseconds, so
      -- this function will query the button and return an appropriate value
   function Timer_Value_In_Msec return Timer_Value_In_Msec_T;

   -- return file specified by chooser
   function Filename return String;

   -- get scaling factor
   function Scale_Value return Scale_Value_T;

   -- get selected color value
   function Selected_Color return Cairo_Utilities.Color_T;

end Display_Buttons;
