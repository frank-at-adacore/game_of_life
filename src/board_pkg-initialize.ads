package Board_Pkg.Initialize with
   Spark_Mode is

   procedure Populate_From_User (Board : in out Board_T);
   procedure Populate_From_File
     (Board    : in out Board_T;
      Filename : in     String);

end Board_Pkg.Initialize;
