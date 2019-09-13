with Glib;
with Gtk.Widget;
with Gtk.Window;
package Display_Buttons with
   Spark_Mode is

   function Widget
     (Main_Window : Gtk.Window.Gtk_Window)
     return Gtk.Widget.Gtk_Widget;

   function Update return Boolean;

   function Timer_Value return Glib.Guint;
   function Filename return String;

   function Scale_Value return Glib.Guint;

end Display_Buttons;
