with Cairo;
with Gdk.Event;
with Gtk.Widget;

package Callbacks is

   -- Called when 'quit' is requested
   procedure Main_Quit (Self : access Gtk.Widget.Gtk_Widget_Record'Class);

   -- Redraw the screen from the surface
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
