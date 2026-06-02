with Cairo;
with Gdk.Window;
with Glib;
with Gtkada.Style;

use type Cairo.Cairo_Surface;
use type Glib.Gdouble;
package body Cairo_Utilities is

   Global_Surface : Cairo.Cairo_Surface;

   -- create a drawing surface from specified widget
   procedure Create_Surface_From_Widget
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) is
   begin
      Global_Surface :=
        Gdk.Window.Create_Similar_Surface
          (Widget.Get_Window, Cairo.Cairo_Content_Color,
           Widget.Get_Allocated_Width, Widget.Get_Allocated_Height);
   end Create_Surface_From_Widget;

   -- reset the drawing surface to the specified color
   procedure Clear_Surface (Color : in Color_T := Color_White) is
      Context : Cairo.Cairo_Context;
   begin
      Context := Cairo.Create (Global_Surface);
      Cairo.Set_Source_Rgba
        (Cr    => Context,
         Red   => Color.Red,
         Green => Color.Green,
         Blue  => Color.Blue,
         Alpha => Color.Alpha);
      Cairo.Paint (Context);
      Cairo.Destroy (Context);
   end Clear_Surface;

   -- remove drawing surface
   procedure Destroy_Surface is
   begin
      if Is_Initialized
      then
         Cairo.Surface_Destroy (Global_Surface);
      end if;
   end Destroy_Surface;

   -- specify drawing surface contents
   procedure Set_Source
     (Context  : in Cairo.Cairo_Context;
      Origin_X : in Glib.Gdouble := 0.0;
      Origin_Y : in Glib.Gdouble := 0.0) is
   begin
      Cairo.Set_Source_Surface (Context, Global_Surface, Origin_X, Origin_Y);
   end Set_Source;

   -- check if surface has been created
   function Is_Initialized return Boolean is
     (Global_Surface /= Cairo.Null_Surface);

   -- perform drawing actions
   procedure Paint (Context : in Cairo.Cairo_Context) is
   begin
      Cairo.Paint (Context);
   end Paint;

   -- convert local color format to GDK version
   function Convert
     (Color : Color_T)
     return Gdk.Rgba.Gdk_Rgba is
      Ret_Val : Gdk.Rgba.Gdk_Rgba;
   begin
      Ret_Val.Red   := Color.Red;
      Ret_Val.Green := Color.Green;
      Ret_Val.Blue  := Color.Blue;
      Ret_Val.Alpha := Color.Alpha;
      return Ret_Val;
   end Convert;

   -- convert GDK color to local version
   function Convert
     (Color : Gdk.Rgba.Gdk_Rgba)
     return Color_T is
      Ret_Val : Color_T := Color_White;
   begin
      if Color.Red in Cairo.Color_Range
      then
         Ret_Val.Red := Color.Red;
      end if;
      if Color.Green in Cairo.Color_Range
      then
         Ret_Val.Green := Color.Green;
      end if;
      if Color.Blue in Cairo.Color_Range
      then
         Ret_Val.Blue := Color.Blue;
      end if;
      if Color.Alpha in Cairo.Color_Range
      then
         Ret_Val.Alpha := Color.Alpha;
      end if;
      return Ret_Val;
   end Convert;

   -- determine inverse of specified color
   function Complementary_Color
     (Color : Color_T)
     return Color_T is
      Full_Color : Gdk.Rgba.Gdk_Rgba;
   begin
      Full_Color.Red   := Color.Red;
      Full_Color.Green := Color.Green;
      Full_Color.Blue  := Color.Blue;
      Full_Color.Alpha := Color.Alpha;
      return Convert (Gtkada.Style.Complementary (Full_Color));
   end Complementary_Color;

   -- draw box around X/Y coordinate with specified color
   procedure Draw_Box
     (Center_X : Glib.Gdouble;
      Center_Y : Glib.Gdouble;
      Height   : Glib.Gdouble := 1.0;
      Width    : Glib.Gdouble := 1.0;
      Color    : Color_T      := Color_Black) is
      Context : Cairo.Cairo_Context;
   begin
      Context := Cairo.Create (Global_Surface);
      Cairo.Set_Source_Rgba
        (Cr    => Context,
         Red   => Color.Red,
         Green => Color.Green,
         Blue  => Color.Blue,
         Alpha => Color.Alpha);
      Cairo.Rectangle
        (Context, Center_X - Width / 2.0, Center_Y - Height / 2.0, Width,
         Height);
      Cairo.Fill (Context);
      Cairo.Destroy (Context);
   end Draw_Box;

end Cairo_Utilities;
