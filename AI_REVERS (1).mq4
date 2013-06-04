//+------------------------------------------------------------------+
//|                                 ArtificialIntelligenceRevers.mq4 |
//|                               Copyright й 2006, Yury V. Reshetov |
//|                                Modifed by   Leonid553            |
//|                                  http://www.tradersforum.net.ru/ | 
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "Copyright й 2006, Yury V. Reshetov ICQ:282715499"
 #property link      "http://reshetov.xnet.uz/"
//---- input parameters
extern int    x1 = 88;
extern int    x2 = 172;
extern int    x3 = 39;
extern int    x4 = 172;
// StopLoss level
extern double sl = 50;
extern double lots = 0.1;
extern int    MagicNumber = 808;
static int prevtime = 0;
static int spread = 3;
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
     Comment(perceptron());   
// Ждем, когда сформируется новая свеча
// Если появляется новая свеча, то проверяем возможность сделки 
if(Time[0] == prevtime) 
       return(0);
   prevtime = Time[0];
//----
   if(IsTradeAllowed()) 
     {
       spread = MarketInfo(Symbol(), MODE_SPREAD);
     } 
   else 
     {
       prevtime = Time[1];
       return(0);
     }
   int ticket = -1;
   // check for opened position
   // сопровождение открытой позиции :
   int total = OrdersTotal();   
   for(int i = 0; i < total; i++) 
     {
       OrderSelect(i, SELECT_BY_POS, MODE_TRADES); 
       // check for symbol & magic number
        //проверяем символ и магик-номер
  if(OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber) 
         {
           int prevticket = OrderTicket();
           // long position is opened
           if(OrderType() == OP_BUY) 
              // если открыта длинная позиция и ...
             {
               // check profit 
   // и текущий профит больше величины =(стоплосс плюс спред) и ...
         if(Bid > (OrderStopLoss() + (sl * 2  + spread) * Point)) 
                 {               
                   if(perceptron() > 0) 
                     { 
      // перцептрон больше нуля , то переворачиваемся в Селл
                       // reverse
         ticket = OrderSend(Symbol(), OP_SELL, lots * 2, Bid, 3, 
                         Ask + sl * Point, 0, "AI", MagicNumber, 
                                          0, Red); 
                       Sleep(30000);
                       if(ticket < 0) 
                         {
                           prevtime = Time[1];
                         } 
                       else 
                         {
                           OrderCloseBy(ticket, prevticket, Blue);   
                         }
                     } 
                   else 
//если перцептрон меньше нуля, то подтягиваем стоплосс 
                     { 
                       // trailing stop
                       if(!OrderModify(OrderTicket(), OrderOpenPrice(), 
                          Bid - sl * Point, 0, 0, Blue)) 
                         {
                           Sleep(30000);
                           prevtime = Time[1];
                         }
                     }
                 }  
               // short position is opened
             } 
           else 
             {
               // если открыта короткая позиция и ...
               // check profit 
           if(Ask < (OrderStopLoss() - (sl * 2 + spread) * Point)) 
                 {
        // текущий профит больше величины =(стоплосс плюс спред) и ...
                   if(perceptron() < 0) 
                     { 
             // перцептрон меньше нуля, то переворачиваемся в Бай
                       // reverse
             ticket = OrderSend(Symbol(), OP_BUY, lots * 2, Ask, 3, 
                           Bid - sl * Point, 0, "AI", MagicNumber,
                                          0, Blue); 
                       Sleep(30000);
                       if(ticket < 0) 
                         {
                           prevtime = Time[1];
                         } 
                       else 
                         {
                           OrderCloseBy(ticket, prevticket, Blue);   
                         }
                     } 
                   else 
//если перцептрон больше нуля то подтягиваем стоплосс 
                     { 
                       // trailing stop
                       if(!OrderModify(OrderTicket(), OrderOpenPrice(), 
                          Ask + sl * Point, 0, 0, Blue)) 
                         {
                           Sleep(30000);
                           prevtime = Time[1];
                         }  
                     }
                 }  
             }
           // exit
           return(0);
         }
     }
//********************************************************************
   // check for long or short position possibility
   // изначальный вход в рынок:
 
   if(perceptron() < 0) 
     { 
        // если перцептрон меньше нуля, то открываем длинную позицию :
       //long
 ticket = OrderSend(Symbol(), OP_BUY, lots, Ask, 3, Bid - sl * Point, 0, 
                      "AI", MagicNumber, 0, Blue); 
       if(ticket < 0) 
         {
           Sleep(30000);
           prevtime = Time[1];
         }
     } 
   else 
      // если перцептрон больше нуля, то открываем короткую позицию:
     { 
       // short
ticket = OrderSend(Symbol(), OP_SELL, lots, Bid, 3, Ask + sl * Point, 0, 
                      "AI", MagicNumber, 0, Red); 
       if(ticket < 0) 
         {
           Sleep(30000);
           prevtime = Time[1];
         }
     }
//--- exit
   return(0);
  }
//+------------------------------------------------------------------+
//|  The PERCEPRRON - a perceiving and recognizing function          |
//+------------------------------------------------------------------+
double perceptron() 
  {
   double w1 = x1 - 100.0;
   double w2 = x2 - 100.0;
   double w3 = x3 - 100.0;
   double w4 = x4 - 100.0;
   double a1 = iAC(Symbol(), 0, 0);
   double a2 = iAC(Symbol(), 0, 7);
   double a3 = iAC(Symbol(), 0, 14);
   double a4 = iAC(Symbol(), 0, 21);
   return (w1 * a1 + w2 * a2 + w3 * a3 + w4 * a4);
  }
//+------------------------------------------------------------------+}