with Ada.Text_Io;
package body Debug with
   Spark_Mode is

   procedure Print (Str : String) is
   begin
      if Turn_On
      then
         Ada.Text_Io.Put_Line (Str);
      end if;
   end Print;

end Debug;
