with Gdk.Event;
with Glib.Main;
with Gtk.Box;
with Gtk.Button;
with Gtk.Drawing_Area;
with Gtk.Enums;
with Gtk.Frame;
with Gtk.Main;
with Gtk.Scrolled_Window;
with Gtk.Window;
with Gtkada.Handlers;

with Callbacks;
with Display;
with Display_Buttons;
with Cairo_Utilities;

use type Gdk.Event.Gdk_Event_Mask;

procedure Main with
   Spark_Mode is
   Win      : Gtk.Window.Gtk_Window renames Display.Main_Window;
   Frame    : Gtk.Frame.Gtk_Frame;
   Da       : Gtk.Drawing_Area.Gtk_Drawing_Area renames Display.Drawing_Area;
   Main_Box : Gtk.Box.Gtk_Vbox;

begin
   --  Initialize GtkAda.
   Gtk.Main.Init;

   -- create a top level window
   Gtk.Window.Gtk_New (Win);
   Win.Set_Title ("Drawing Area");
   -- set the border width of the window
   Win.Set_Border_Width (8);
   -- connect the "destroy" signal
   Win.On_Destroy (Callbacks.Main_Quit'Access);

   Gtk.Box.Gtk_New_Vbox (Main_Box);
   Win.Add (Main_Box);
   Gtk.Box.Pack_Start
     (In_Box => Main_Box, Child => Display_Buttons.Widget (Win),
      Expand => False);

   -- create a frame
   Gtk.Frame.Gtk_New (Frame);
   Main_Box.Add (Frame);

   Gtk.Drawing_Area.Gtk_New (Da);
   -- set a minimum size
   Display.Set_Size (500, 100);
   Frame.Add (Da);

   -- Signals used to handle the backing surface
   Da.On_Draw (Callbacks.Draw_Cb'Access);
   Da.On_Configure_Event (Callbacks.Configure_Event_Cb'Access);

   Display.Initialize (Timeout_Msec => 2000);

   -- Now that we are done packing our widgets, we show them all in one go,
   -- by calling Win.Show_All. This call recursively calls Show on all widgets
   -- that are contained in the window, directly or indirectly.
   Win.Show_All;

   -- All GTK applications must have a Gtk.Main.Main. Control ends here and
   -- waits for an event to occur (like a key press or a mouse event), until
   -- Gtk.Main.Main_Quit is called.
   Gtk.Main.Main;
end Main;
