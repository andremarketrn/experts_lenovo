//+------------------------------------------------------------------+
//|                                     My First Expert.mq4 |
//|                 Copyright � 2006, Andrey Vedikhin |
//|                                http://www.vedikhin.ru |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2006, Andrey Vedikhin"
#property link      "http://www.vedikhin.ru"

#define STATE_SQUARE 0
#define STATE_LONG 1
#define STATE_SHORT 2

//---- input parameters
extern int       MAPeriod=13;
extern double    LotsNumber=1.0;


//---- ���������� ����������
int CurrentState;
int MyOrderTicket;


//+------------------------------------------------------------------+
//| expert initialization function                         |
//+------------------------------------------------------------------+
int init()
  {
//----
   if (iMA(NULL, 0, MAPeriod, 0, MODE_EMA, PRICE_CLOSE, 0) > Close[0]) 
      CurrentState = STATE_SHORT;
   else CurrentState = STATE_LONG;      
   
   MyOrderTicket = 0;
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                      |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                   |
//+------------------------------------------------------------------+
int start()
  {
//----
   int err;
   
   double MA;
   MA = iMA(NULL, 0, MAPeriod, 0, MODE_EMA, PRICE_CLOSE, 0);
   
   if ( CurrentState == STATE_LONG) 
     {
      if (MA > Close[1]) //���������� ������� ���� ���� ��������
        {
         CurrentState = STATE_SHORT;
         
         //���������������� � �������
         
         //---������� �������, ���� ���� �������
         if ( MyOrderTicket != 0)
           {
            if (!OrderClose(MyOrderTicket, LotsNumber, Bid, 3, CLR_NONE))
              {
               err = GetLastError();
               Print("������ ��� �������� �������: ", err);
               return(0);
              }
            MyOrderTicket = 0;
           } 
         RefreshRates();
            
         //--- �������  ������� ���� ������� �������
         
         //--- ������ ������� ������� � �������
         
         //--- �������� �� ������� ��������� �������
         if (!CheckForEnoughMargin()) return(0);
         
         MyOrderTicket = OrderSend(Symbol(), OP_SELL, LotsNumber, Bid, 3, 0, 0, 
                                   NULL, 0, 0, CLR_NONE);
         if (MyOrderTicket<0)
           {
            err = GetLastError();
            Print("������ ��� �������� �������: ", err);
            MyOrderTicket = 0;
           }
        }
     }
   else
     {
      if (MA < Close[1])  //���������� ������� ���� ���� ��������
        {
          CurrentState = STATE_LONG;

         //���������������� � �������
         
         //---������� �������, ���� ���� �������
         if ( MyOrderTicket != 0)
           {
            if (!OrderClose(MyOrderTicket, LotsNumber, Ask, 3, CLR_NONE))
              {
               err = GetLastError();
               Print("������ ��� �������� �������: ", err);
               return(0);
              }
            MyOrderTicket = 0;
           } 
         RefreshRates();
            
         //--- ��������  ������� ���� ������� �������
         
         //--- ������ ������� ������� � �������
         
         //--- �������� �� ������� ��������� �������
         if (!CheckForEnoughMargin()) return(0);
         
         MyOrderTicket = OrderSend(Symbol(), OP_BUY, LotsNumber, Ask, 3, 0, 0, 
                                   NULL, 0, 0, CLR_NONE);
         if (MyOrderTicket<0)
           {
            err = GetLastError();
            Print("������ ��� �������� �������: ", err);
            MyOrderTicket = 0;
           }
        }
     }   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| �������� ������� ��������� �����            |
//+------------------------------------------------------------------+
bool CheckForEnoughMargin()
  {
    if (GetOneLotMargin(Symbol())*LotsNumber<AccountFreeMargin()) return(true); 
    else return(false);
  }
//+-------------------------------------------------------------------+
//| ���������� ����������� ����� �� ���� ���|
//+-------------------------------------------------------------------+
double GetOneLotMargin(string s)
  {
   double p;
   if ((StringSubstr(s, 0, 3) == "EUR")||(StringSubstr(s, 0, 3) == "GBP")||
      (StringSubstr(s, 0, 3) == "AUD")||(StringSubstr(s, 0, 3) == "NZD")) 
     {
      if (!IsTesting()) 
        return(MarketInfo(s, MODE_LOTSIZE)*MarketInfo(StringSubstr(s, 0, 3)+"USD",
                   MODE_BID)/AccountLeverage());
      else 
        {
         p = iClose(StringSubstr(s, 0, 3)+"USD", Period(), 
         iBarShift(StringSubstr(s, 0, 3)+"USD", Period(), CurTime(), true));         
         return(MarketInfo(s, MODE_LOTSIZE)*p/AccountLeverage());
        }     
     }
     
   if (StringSubstr(s, 0, 3) == "USD") 
     return(MarketInfo(s, MODE_LOTSIZE)/AccountLeverage());   
   
   if (s == "CHFJPY")
     {
      p = iClose("USDCHF", Period(), iBarShift("USDCHF", Period(), CurTime(), true)); 
      return(MarketInfo(s, MODE_LOTSIZE)/(AccountLeverage()*p));
     }
   
   return(77777777777777777777777777.0);   
  }
//+------------------------------------------------------------------+