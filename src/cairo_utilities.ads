with Cairo;
with Glib;
with Gtk.Widget;

package Cairo_Utilities with
   Spark_Mode is
--     function surface return Cairo.Cairo_Surface;

   type Color_T is record
      Red   : Cairo.Color_Range := 0.0;
      Green : Cairo.Color_Range := 0.0;
      Blue  : Cairo.Color_Range := 0.0;
      Alpha : Cairo.Color_Range := 1.0;
   end record;
   Color_Black : constant Color_T := (Alpha => 1.0, others => 0.0);
   Color_White : constant Color_T := (Alpha => 1.0, others => 1.0);
   Color_Red   : constant Color_T := (Red => 1.0, others => <>);
   Color_Blue  : constant Color_T := (Blue => 1.0, others => <>);
   Color_Green : constant Color_T := (Green => 1.0, others => <>);

   procedure Create_Surface_From_Widget
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class);

   procedure Clear_Surface (Color : in Color_T := Color_White);

   procedure Destroy_Surface;

   procedure Set_Source
     (Context  : in Cairo.Cairo_Context;
      Origin_X : in Glib.Gdouble := 0.0;
      Origin_Y : in Glib.Gdouble := 0.0);

   function Is_Initialized return Boolean;

   procedure Paint (Context : in Cairo.Cairo_Context);

   procedure Draw_Box
     (Center_X : Glib.Gdouble;
      Center_Y : Glib.Gdouble;
      Height   : Glib.Gdouble := 1.0;
      Width    : Glib.Gdouble := 1.0;
      Color    : Color_T      := Color_Black);

end Cairo_Utilities;
