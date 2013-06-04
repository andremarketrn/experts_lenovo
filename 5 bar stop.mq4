//+------------------------------------------------------------------+
//|                                                   5 bar stop.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

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
int start()
  {
  double Bar1_Length = 0; 
  Bar1_Length = MathAbs((High[1] - Low[1])*10000);
  Comment("the length of the last bar in the chart was ", Bar1_Length, " pips");
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+