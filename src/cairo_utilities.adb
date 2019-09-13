with Cairo;
with Gdk.Window;
with Glib;

with Debug;

use type Cairo.Cairo_Surface;
use type Glib.Gdouble;
package body Cairo_Utilities with
   Spark_Mode is

   Global_Surface : Cairo.Cairo_Surface;
   function Surface return Cairo.Cairo_Surface is (Global_Surface);

   procedure Create_Surface_From_Widget
     (Widget : access Gtk.Widget.Gtk_Widget_Record'Class) is
   begin
--        Debug.Print ("create_surface_from_widget");
      Global_Surface :=
        Gdk.Window.Create_Similar_Surface
          (Widget.Get_Window, Cairo.Cairo_Content_Color,
           Widget.Get_Allocated_Width, Widget.Get_Allocated_Height);
   end Create_Surface_From_Widget;

   procedure Clear_Surface (Color : in Color_T := Color_White) is
      Context : Cairo.Cairo_Context;
   begin
      Context := Cairo.Create (Global_Surface);
      Cairo.Set_Source_Rgba
        (Cr   => Context, Red => Color.Red, Green => Color.Green,
         Blue => Color.Blue, Alpha => Color.Alpha);
      Cairo.Paint (Context);
      Cairo.Destroy (Context);
   end Clear_Surface;

   procedure Destroy_Surface is
   begin
      if Is_Initialized
      then
         Cairo.Surface_Destroy (Global_Surface);
      end if;
   end Destroy_Surface;

   procedure Set_Source
     (Context  : in Cairo.Cairo_Context;
      Origin_X : in Glib.Gdouble := 0.0;
      Origin_Y : in Glib.Gdouble := 0.0) is
   begin
      Cairo.Set_Source_Surface (Context, Global_Surface, Origin_X, Origin_Y);
   end Set_Source;

   function Is_Initialized return Boolean is
     (Global_Surface /= Cairo.Null_Surface);

   procedure Paint (Context : in Cairo.Cairo_Context) is
   begin
      Cairo.Paint (Context);
   end Paint;

   procedure Draw_Box
     (Center_X : Glib.Gdouble;
      Center_Y : Glib.Gdouble;
      Height   : Glib.Gdouble := 1.0;
      Width    : Glib.Gdouble := 1.0;
      Color    : Color_T      := Color_Black) is
      Context : Cairo.Cairo_Context;
   begin
--        debug.print("draw_box at " & center_x'img & center_y'img );
      Context := Cairo.Create (Global_Surface);
      Cairo.Set_Source_Rgba
        (Cr   => Context, Red => Color.Red, Green => Color.Green,
         Blue => Color.Blue, Alpha => Color.Alpha);
      Cairo.Rectangle
        (Context, Center_X - Width / 2.0, Center_Y - Height / 2.0, Width,
         Height);
      Cairo.Fill (Context);
      Cairo.Destroy (Context);
   end Draw_Box;

end Cairo_Utilities;
