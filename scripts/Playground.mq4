// The script is created to test out some of my trading ideas

//+------------------------------------------------------------------+
//|                                                   Playground.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
// I use first CAP letters in functions like: Bar_Length
// I use small letters in variables       like: bar_length

#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//----------------------------------- VARIOUS FUNCTIONS ----------------------------------------------------------

bool TrailStopActivation() //Function determines if it's been more than X min after position was open. It is what turns the stop on
   {
   int timesinceopen, lagtime; // timesinceopen is used to determine milliseconds after the order been open
   timesinceopen = TimeCurrent()-OrderOpenTime(); //difference between open time and current time in Seconds
   lagtime = 60*30; // variable which determines how soon after order has been open stop should start trailing
   if (timesinceopen > lagtime) return(true); // determines if it's been more than x min passed since order was open
   return(false);
   }

double Bar_Length(int barnumber)// Determines the bar length by barnumber
   {
   double bar_length; // function defining variable
   bar_length =NormalizeDouble((High[barnumber]-Low[barnumber]),Digits);
   return(bar_length); 
   }   
   
   //------------------------------------- THREE BAR STOP FUNCTIONS-------------------------------------------------  
double FiveBarLengthAverage() // Calculates the average length of the last 5 bars. Used to determinie if stop is going to be switched into one bar stop Mode
   {
   int i, barnumber=2; // This is where it starts to count the bars lengthes
   double fivebarsum, fivebarlenghtaverage; // суммарна€ длина баров и средн€€ их длины 
      for(i=2; i<7; i++) // начинает считать со второго (предпоследнего бара) и заканчивает 6ым.
      {
      barnumber=i;
      fivebarsum = fivebarsum + Bar_Length(barnumber);
      }
   fivebarlenghtaverage = fivebarsum/5;
   return(fivebarlenghtaverage); // возвращает значение средней в функцию 
    }
    
double Highest_High() //вычисл€ет значение последнего пика в р€ду из последних 12 баров. (можно было бы массивом воспользоватьс€, но€ пока не знаю как это делаетс€)
   {
   int i, h_h_barNO;
   double highest_high=High[1]; // здесь € присваиваю пику макс значение последнего бара что бы с чем то сравнивать
   for (i=1;i<13;i++)
      {if (highest_high<High[i]) highest_high = High[i];}
      h_h_barNO=i; // не пон€тно зачем € использую это переменную мне кажетс€ без нее можно обойтись
      return(highest_high);
   }
   
int Highest_High_Bar_NO() //возвр. номер бара с наивысшим пиком из последних 12 ти
   {
   int i, h_h_barNO;
   double highest_high=High[1];
   for (i=1;i<13;i++)
      {
      if (highest_high<High[i]) 
         {highest_high = High[i]; h_h_barNO=i;}
      }
      return(h_h_barNO);
   }
   
int Third_Low_NO() //возвр номер бара с 3им нижним низом. ѕод него и подт€гиваетс€ стоп
   {
   int HH = iHighest(string Symbol(), 0, MODE_HIGH, 10, 0), i=0, second_low_NO, third_low_NO;
   double first_low, second_low, third_low;
   
      first_low=Low[HH];
      i= HH;
      while (Low[i]>=first_low) i++;
      second_low_NO= i; second_low = Low[second_low_NO];
      while (Low[i] >= second_low ) i++;
      third_low_NO = i; third_low = Low[third_low_NO];  
      return(third_low_NO);    
   }
                   // «то определ€юща€ функци€ бычего стопа если последний бар небыл гиперактивным
double Third_Low() // от бара с наивысшим пиком мы начинаем считать 3 бар с нижним значением
   {
   int i=iHighest(string Symbol(), 0, MODE_HIGH, 10, 0), second_low_NO, third_low_NO;
   double first_low, second_low, third_low;
   
      first_low=Low[i];
      //i= Highest_High_Bar_NO();
      while (Low[i]>=first_low) i++;
      second_low_NO= i; second_low = Low[second_low_NO];
      while (Low[i] >= second_low ) i++;
      third_low_NO = i; third_low = Low[third_low_NO];     
      return(third_low);    
   }
   
   void DrawAllColor2(int third_low_no)
{
   datetime dt;
   dt = iTime(Symbol(), PERIOD_H1, third_low_no);
      ObjectCreate("Purple", OBJ_VLINE, 0, dt , 0);  // нарисовали вертикальную линию
      ObjectSet( "Purple", OBJPROP_COLOR, 256);     // установили цвет линии
   
}
   
 
//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
int HH = iHighest(Symbol(), 0, MODE_HIGH, 10, 0);// и написав всю хуйню вверху € нащЄл вот такую функцию что бы не паритс€
int third_low_no = iLowest(Symbol(), 0, MODE_LOW, 10, HH);
double third_low = Low[Third_Low_NO()]-50*Point;
DrawAllColor2(HH);
//int third_low_no = Third_Low_NO();
//ObjectCreate("highLine",OBJ_HLINE,0,0,third_low);
  
  Alert("The stop at this point the number of the third low bar would be ", third_low_no);
  Alert("The stop at this point would be at ", third_low ); 
     return(0);
  }
//+------------------------------------------------------------------+


