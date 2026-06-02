with Gtk.Drawing_Area;
with Gtk.Window;

with Base_Types;
package Display is

   -- global display objects
   Global_Main_Window  : Gtk.Window.Gtk_Window             := null;
   Global_Drawing_Area : Gtk.Drawing_Area.Gtk_Drawing_Area := null;

   -- update timer based on button value
   procedure Update_Timer;

   -- any initialization processing
   procedure Initialize;

   -- update board based on specified file change OR current board display
   function Update return Boolean;

   -- set
   procedure Set_Size
     (Rows    : Base_Types.Row_Count_T;
      Columns : Base_Types.Column_Count_T);

end Display;
