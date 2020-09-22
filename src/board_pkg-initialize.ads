package Board_Pkg.Initialize with
   Spark_Mode
is

   -- subprogram that reads board data from a file
   procedure Populate_From_File
     (Board    :    out Board_T;
      Filename : in     String);

end Board_Pkg.Initialize;
