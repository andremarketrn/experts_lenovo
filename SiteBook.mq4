//--------------------------------------------------------------------
// simple.mq4
// function designed to learn MQL4.
//--------------------------------------------------------------------
int Count=0;                                    // global variable
//--------------------------------------------------------------------
int init()                                      // ????. ?-?? init()
   {
   Comment ("сработала функция init() при запуске"); // ?????????
   return;                                      // ????? ?? init()
   }   
//--------------------------------------------------------------------
int start()                                     // ????. ?-?? start()
   {
   
   double bar_length=0;
   bar_length = High[1]-Low[1];
   Comment ("длина последнего бара была =",bar_length);
   
   double Mid_Point=0;
   double Shadow_Length=0;
   
   Shadow_Length = MathAbs((Open[1] - Close[1])*10000); 
   Mid_Point = Low[1]+ bar_length/2;
   if (Open[1]>= Mid_Point && Close[1]>= Mid_Point)
      {
      Comment ("Long - можно срубить ", bar_length*10000," пипок по лёгкому, shadow length is ", Shadow_Length);
      }
      else
       {
       if (Open[1]<= Mid_Point && Close[1]<= Mid_Point) 
         {
         Comment ("short position is expected, by the way the shadow length is", Shadow_Length);
         }
         else 
         {
         Comment ("the last bar was worthless.... waiting for something good to come");
         
         }
       }
      
    
   return;                                      // ????? ?? start()
   }
//--------------------------------------------------------------------
int deinit()                                    // ????. ?-?? deinit()
   {
   Comment ("сработала функция deinit() при выгрузке");   // ?????????
   return;                                      // ????? ?? deinit()
   }
//--------------------------------------------------------------------


