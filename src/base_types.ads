package Base_Types with
   Spark_Mode
is

   Max_Columns : constant := 1000;
   Max_Rows    : constant := 1000;

   type Row_Count_T is range 0 .. Max_Rows;
   subtype Row_T is Row_Count_T range 1 .. Row_Count_T'Last;

   type Column_Count_T is range 0 .. Max_Columns;
   subtype Column_T is Column_Count_T range 1 .. Column_Count_T'Last;

   generic
      type Index_T is range <>;
   function Safe_Pred
     (Index : Index_T)
     return Index_T with
      Post => (if Index > Index_T'First then safe_pred'result = Index - 1 else safe_pred'result = Index_T'First);
   function Safe_Pred
     (Index : Index_T)
     return Index_T is
     (if Index > Index_T'First then Index - 1 else Index_T'First);

   generic
      type Index_T is range <>;
   function Safe_Succ
     (Index : Index_T)
     return Index_T with
      Post => (if index < Index_T'Last then safe_succ'result = Index + 1 else safe_succ'result = Index_T'Last);
   function Safe_Succ
     (Index : Index_T)
     return Index_T is
     (if Index < Index_T'Last then Index + 1 else Index_T'Last);

   function Pred is new Safe_Pred (Row_T);
   function Succ is new Safe_Succ (Row_T);

   function Pred is new Safe_Pred (Column_T);
   function Succ is new Safe_Succ (Column_T);

end Base_Types;
