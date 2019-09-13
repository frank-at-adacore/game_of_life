package Base_Types with
   Spark_Mode
is

   Max_Columns : constant := 1000;
   Max_Rows    : constant := 1000;

   -- count allows 0; subtype is an array index
   type Row_Count_T is range -1 .. Max_Rows + 2;
   subtype Row_T is Row_Count_T range 1 .. Row_Count_T'Last - 2;

   -- count allows 0; subtype is an array index
   type Column_Count_T is range -1 .. Max_Columns + 2;
   subtype Column_T is Column_Count_T range 1 .. Column_Count_T'Last - 2;

   -- Function that will always return a valid value for 'pred
   generic
      type Index_T is range <>;
   function Safe_Pred
     (Index : Index_T)
     return Index_T with
      Post =>
      (if Index > Index_T'First then Safe_Pred'Result = Index - 1
       else Safe_Pred'Result = Index_T'First);
   function Safe_Pred
     (Index : Index_T)
     return Index_T is
     (if Index > Index_T'First then Index - 1 else Index_T'First);

   -- Function that will always return a valid value for 'succ
   generic
      type Index_T is range <>;
   function Safe_Succ
     (Index : Index_T)
     return Index_T with
      Post =>
      (if Index < Index_T'Last then Safe_Succ'Result = Index + 1
       else Safe_Succ'Result = Index_T'Last);
   function Safe_Succ
     (Index : Index_T)
     return Index_T is
     (if Index < Index_T'Last then Index + 1 else Index_T'Last);

   -- get previous row if possible, otherwise use this row
   function Pred is new Safe_Pred (Row_T);
   -- get next row if possible, otherwise use this row
   function Succ is new Safe_Succ (Row_T);

   -- get previous column if possible, otherwise use this column
   function Pred is new Safe_Pred (Column_T);
   -- get next column if possible, otherwise use this column
   function Succ is new Safe_Succ (Column_T);

end Base_Types;
