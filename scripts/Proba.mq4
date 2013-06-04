//+------------------------------------------------------------------+
//|                                                        Proba.mq4 |
//|                      Copyright © 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2010, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
 int pos;
   int total = HistoryTotal();
   for ( pos = 0; pos<total; pos++ )
     {
       if (OrderSelect(pos, SELECT_BY_POS, MODE_HISTORY) == true)
         {
           Print("Выбран ордер номер ", pos, " в списке закрытых позиций");
           // делаем что-то с этой позицией
         }
       else
           Print("Ошибка ", GetLastError(), " при выборе ордера номер ", pos);
     }
   return(0);
  }
//+------------------------------------------------------------------+