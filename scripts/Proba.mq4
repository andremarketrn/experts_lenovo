//+------------------------------------------------------------------+
//|                                                        Proba.mq4 |
//|                      Copyright � 2010, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2010, MetaQuotes Software Corp."
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
           Print("������ ����� ����� ", pos, " � ������ �������� �������");
           // ������ ���-�� � ���� ��������
         }
       else
           Print("������ ", GetLastError(), " ��� ������ ������ ����� ", pos);
     }
   return(0);
  }
//+------------------------------------------------------------------+