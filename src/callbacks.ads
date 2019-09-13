with Cairo;
with Gdk.Event;
with Gtk.Widget;

package Callbacks with
   Spark_Mode is

   procedure Main_Quit (Self : access Gtk.Widget.Gtk_Widget_Record'Class);

   function Draw_Cb
     (Self : access Gtk.Widget.Gtk_Widget_Record'Class;
      Cr   : Cairo.Cairo_Context)
     return Boolean;

   -- Create a new surface of the appropriate size to store our scribbles
   function Configure_Event_Cb
     (Self  : access Gtk.Widget.Gtk_Widget_Record'Class;
      Event : Gdk.Event.Gdk_Event_Configure)
     return Boolean;

end Callbacks;
