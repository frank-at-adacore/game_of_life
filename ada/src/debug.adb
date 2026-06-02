with Ada.Text_Io;
package body Debug with
   Spark_Mode
is

   -- controls whether we actuall print the debug string
   Turn_On : constant Boolean := False;

   -- print STR somewhere we can see it
   procedure Print (Str : String) is
   begin
      if Turn_On
      then
         Ada.Text_Io.Put_Line (Str);
      end if;
   end Print;

end Debug;
