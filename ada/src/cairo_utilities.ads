with Cairo;
with Glib;
with Gdk.Rgba;
with Gtk.Widget;

package Cairo_Utilities is

   -- use appropriately limited values for colors
   type Color_T is record
      Red   : Cairo.Color_Range := 0.0;
      Green : Cairo.Color_Range := 0.0;
      Blue  : Cairo.Color_Range := 0.0;
      Alpha : Cairo.Color_Range := 0.0;
   end record;

   -- some simple colors
   Color_Black : constant Color_T := (Alpha => 1.0, others => 0.0);
   Color_White : constant Color_T := (Alpha => 1.0, others => 1.0);
   Color_Red   : constant Color_T := (Alpha => 1.0, Red => 1.0, others => 0.0);
   Color_Blue : constant Color_T := (Alpha => 1.0, Blue => 1.0, others => 0.0);
   Color_Green : constant Color_T :=
     (Alpha => 1.0, Green => 1.0, others => 0.0);

   -- convert between local color type and GDK color type
   function Convert
     (Color : Gdk.Rgba.Gdk_Rgba)
     return Color_T;
   function Convert
     (Color : Color_T)
     return Gdk.Rgba.Gdk_Rgba;

   -- determine inverse of specified color
   function Complementary_Color
     (Color : Color_T)
     return Color_T;

   -- create a drawing surface from specified widget
   procedure Create_Surface_From_Widget
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class);

   -- reset the drawing surface to the specified color
   procedure Clear_Surface (Color : in Color_T := Color_White);

   -- remove drawing surface
   procedure Destroy_Surface;

   -- specify drawing surface contents
   procedure Set_Source
     (Context  : in Cairo.Cairo_Context;
      Origin_X : in Glib.Gdouble := 0.0;
      Origin_Y : in Glib.Gdouble := 0.0);

      -- check if surface has been created
   function Is_Initialized return Boolean;

   -- perform drawing actions
   procedure Paint (Context : in Cairo.Cairo_Context);

   -- draw box around X/Y coordinate with specified color
   procedure Draw_Box
     (Center_X : Glib.Gdouble;
      Center_Y : Glib.Gdouble;
      Height   : Glib.Gdouble := 1.0;
      Width    : Glib.Gdouble := 1.0;
      Color    : Color_T      := Color_Black);

end Cairo_Utilities;
