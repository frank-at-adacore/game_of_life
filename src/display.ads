with Glib;
with Gtk.Drawing_Area;
with Gtk.Window;

package Display with
   Spark_Mode is

   Main_Window  : Gtk.Window.Gtk_Window             := null;
   Drawing_Area : Gtk.Drawing_Area.Gtk_Drawing_Area := null;

   procedure Initialize
     (Filename     : in String := "";
      Timeout_Msec : in Glib.Guint);

   function Update return Boolean;

   procedure Set_Size
     (Width  : glib.gint;
      Height : glib.gint);

end Display;
