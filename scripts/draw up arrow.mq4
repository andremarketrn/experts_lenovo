//+------------------------------------------------------------------+
//|                                                draw up arrow.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+

int start()
  {
//----
 
ObjectCreate("MyLineOpenPosition", OBJ_ARROW, 0, Time[7], Time[6]);
ObjectSet("MyLineOpenPosition", OBJPROP_STYLE, STYLE_SOLID);
ObjectSet("MyLineOpenPosition", OBJPROP_RAY, False);
ObjectSet("MyLineOpenPosition",OBJPROP_WIDTH,3);
ObjectSet("MyLineOpenPosition", OBJPROP_COLOR, Yellow);
 
//----
   return(0);
  }
//+------------------------------------------------------------------+

//void DrawArrowUp(string ArrowName,double LinePrice,color LineColor)
//{
//ObjectCreate(ArrowName, OBJ_ARROW, 0, Time[0], LinePrice); //draw an up arrow
//ObjectSet(ArrowName, OBJPROP_STYLE, STYLE_SOLID);
//ObjectSet(ArrowName, OBJPROP_ARROWCODE, SYMBOL_ARROWUP);
//ObjectSet(ArrowName, OBJPROP_COLOR,LineColor);
//}