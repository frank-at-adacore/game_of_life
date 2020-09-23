with Gtk.Box;
with Gtk.Drawing_Area;
with Gtk.Frame;
with Gtk.Main;
with Gtk.Widget;
with Gtk.Window;

with Callbacks;
with Debug;
with Display;
with Display_Buttons;

use type Gtk.Box.Gtk_Box;
use type Gtk.Drawing_Area.Gtk_Drawing_Area;
use type Gtk.Frame.Gtk_Frame;
use type Gtk.Window.Gtk_Window;
use type Gtk.Widget.Gtk_Widget;

procedure Main is
   Win      : Gtk.Window.Gtk_Window renames Display.Global_Main_Window;
   Frame    : Gtk.Frame.Gtk_Frame;
   Da : Gtk.Drawing_Area.Gtk_Drawing_Area renames Display.Global_Drawing_Area;
   Main_Box : Gtk.Box.Gtk_Vbox;
   Buttons  : Gtk.Widget.Gtk_Widget;

begin
   --  Initialize GtkAda.
   Gtk.Main.Init;

   -- create a top level window
   Gtk.Window.Gtk_New (Win);
   if Win /= null
   then
      Win.Set_Title ("Drawing Area");
      -- set the border width of the window
      Win.Set_Border_Width (8);
      -- connect the "destroy" signal
      Win.On_Destroy (Callbacks.Main_Quit'Access);

      -- create box to contain buttons and board display
      Gtk.Box.Gtk_New_Vbox (Main_Box);
      if Main_Box /= null
      then
         Win.Add (Main_Box);

         -- create widget containing buttons
         Display_Buttons.Create_Widget
           (Main_Window => Win,
            Widget      => Buttons);
         -- if button widget was created, add it to the main window
         if Buttons /= null
         then
            Gtk.Box.Pack_Start
              (In_Box => Main_Box,
               Child  => Buttons,
               Expand => False);

            -- create a frame and drawing area
            Gtk.Frame.Gtk_New (Frame);
            if Frame /= null
            then
               Main_Box.Add (Frame);
               Gtk.Drawing_Area.Gtk_New (Da);
               if Da /= null
               then
                  -- set a minimum size
                  Display.Set_Size
                    (Rows    => 1,
                     Columns => 1);
                  Frame.Add (Da);

                  -- Signals used to handle the backing surface
                  Da.On_Draw (Callbacks.Draw_Cb'Access);
                  Da.On_Configure_Event (Callbacks.Configure_Event_Cb'Access);

                  Display.Initialize;

                  -- Now that we are done packing our widgets, we show them all
                  -- in one go, by calling Win.Show_All. This call recursively
                  -- calls Show on all widgets that are contained in the
                  -- window, directly or indirectly.
                  Win.Show_All;

                  -- All GTK applications must have a Gtk.Main.Main. Control
                  -- ends here and waits for an event to occur (like a key
                  -- press or a mouse event), until Gtk.Main.Main_Quit is
                  -- called.
                  Gtk.Main.Main;

               end if;


            end if;

         end if;

      end if;

   end if;
end Main;
