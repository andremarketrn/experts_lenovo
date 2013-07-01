//+------------------------------------------------------------------+
//|                                                   5 bar stop.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//Returns the lenght of the N bar where N is passed into the method as an argument. It is the fist bar by default
double BarLength(int bar_number = 1){
  double bar_length = 0; 
  bar_length = MathAbs((High[1] - Low[1])*10000);
  return(bar_length);
  }

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start() {
  
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+