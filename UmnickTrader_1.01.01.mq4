//+------------------------------------------------------------------+
//|                                                 UmnickTrader.mq4 |
//|                              © 2009 Umnick. All rights reserved. |
//|                                            http://www.umnick.com |
//+------------------------------------------------------------------+
#property copyright "© 2009 Umnick. All rights reserved."
#property link      "http://www.umnick.com"

//---- input parameters
extern double       StopBase=0.0170;

extern bool marketOrderOn = false;                // включить режим открытия сделок по рынку
extern double spred = 0.0005;                     // размер спрэда
extern int slippage = 200;                        // проскальзывание в пунктах
extern double absAmount = 0.1;                    // абсолютный размер лота

int currentBuySell = 1;
double pricePrev = 0;
double equityPrev = 0;

bool isOpenPosition = false;
double arrayProfit[8];
double arrayLoss[8];
int currentIndex = 0;
double drawDown = 0;
double maxProfit = 0;
string currentIdOrder = "1";

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
{
 int i;
 
 for( i=0; i<8; i++ ) {
  arrayProfit[i] = 0;
  arrayLoss[i] = 0;  
 }
 
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
 string action = "";
 double limit = StopBase, stop = StopBase;
 double sumProfit = 0., sumLoss = 0.;
 int i;
 
// if(Bars<100 || IsTradeAllowed()==false) return;
 CalcDrawDown( currentIdOrder );
 if( NextBar() == true ) {
  // разрешение на анализ при открытии следующей позиции
  if( GetCountOpenOrders() == 0 ) {
   // открытых позиций нет - проверяем результат последней сделки
   double resultTransaction = AccountEquity()-equityPrev;
   equityPrev = AccountEquity();
   if( isOpenPosition == true ) {
    // позиция была открыта - закрылась
    isOpenPosition = false;
    if( resultTransaction > 0 ) {
     // последняя сделка прибыльная
     arrayProfit[currentIndex] = maxProfit-spred*3;
     arrayLoss[currentIndex] = StopBase+spred*7;
    }
    else {
     // последняя сделка убыточная
     arrayProfit[currentIndex] = StopBase-spred*3;
     arrayLoss[currentIndex] = drawDown+spred*7;
     // изменяем направление сделок
     currentBuySell = -currentBuySell;
    }
    if( currentIndex+1 < 8 )
     currentIndex = currentIndex+1;
    else
     currentIndex = 0;
   }
   // вычисляем лимиты и стопы
   sumProfit = 0.;
   sumLoss = 0.;
   for( i=0; i<8; i++ ) {
    sumProfit = sumProfit+arrayProfit[i];
    sumLoss = sumLoss+arrayLoss[i];
   }
   if( sumProfit > StopBase/2 )
    limit = sumProfit/8;
   if( sumLoss > StopBase/2 )
    stop = sumLoss/8;
   // открываем новую позицию
   if( currentBuySell == 1 )
    action = "Buy";
   else
    action = "Sell";
   ActionPosition( action, currentIdOrder, absAmount, limit, stop );
   if( GetCountOpenOrders() > 0 ) {
    // позиция открылась
    isOpenPosition = true;
    maxProfit = 0;
    drawDown = 0;
   }
  }
 }
 return(0);
}
//+------------------------------------------------------------------+


bool NextBar()
{
 bool rt = false;
 double price = (Open[1]+High[1]+Low[1]+Close[1])/4;
 if( MathAbs(price-pricePrev) >= StopBase ) {
  pricePrev = price;
  rt = true;
 }
 return(rt);
}

int GetCountOpenOrders()
{
 return(OrdersTotal());
}

void CalcDrawDown( string idSignal )
{
 int j, order, typeOrder;
 double openPrice = 0;
 
 for( j=0; j<OrdersTotal(); j++) {
  if( OrderSelect( j, SELECT_BY_POS, MODE_TRADES ) ) {
   if( Symbol() == OrderSymbol() && idSignal == OrderComment()  ) {
    typeOrder = OrderType();
    openPrice = OrderOpenPrice();
    if( typeOrder == OP_BUY ) {
     RefreshRates();
     if( maxProfit < High[0]-openPrice )
      maxProfit = High[0]-openPrice;
     if( drawDown < openPrice-Low[0] )
      drawDown = openPrice-Low[0];
    }
    if( typeOrder == OP_SELL ) {
     RefreshRates();
     if( maxProfit < openPrice-Low[0] )
      maxProfit = openPrice-Low[0];
     if( drawDown < High[0]-openPrice )
      drawDown = High[0]-openPrice;
    }       
   }
  }
 }
}

void ActionPosition( string action, string idSignal, double amount, double limit, double stop )
{
 bool result;
 int i, j, order, typeOrder;
 double price = 0.;
 
   if( action == "Buy" ) {
    // покупаем
    for( i=0; i<7; i++ ) {
     if( IsTradeAllowed() ) {
      RefreshRates();
      if( marketOrderOn == false )
       order = OrderSend( Symbol(), OP_BUY, amount, Ask, slippage, Ask-stop-spred, Ask+limit, idSignal, 0, 0, CLR_NONE );
      else {
       // открываемся по цене рынка
       order = OrderSend( Symbol(), OP_BUY, amount, Ask, slippage, 0, 0, idSignal, 0, 0, CLR_NONE );
       if( order > 0 ) {
        OrderSelect( order, SELECT_BY_TICKET );
        OrderModify( order, OrderOpenPrice(), Ask-stop-spred, Ask+limit, 0, CLR_NONE );
       }
      }
      if( order <= 0 )
       Print("Ошибка: ",GetLastError());  
      else {
       Print( "Купили "+Symbol()+" id="+idSignal+" stop="+stop+" limit="+limit+" amount="+amount );
       PlaySound("ok.wav");
       return( 0 );
      }
     }       
     Sleep( 10000 );
    }   
    Print( "Ошибка открытия позиции "+Symbol()+" id="+idSignal+" stop="+stop+" limit="+limit );
    PlaySound( "disconnect.wav" );
   }
   else
   if( action == "BuyClose" ) {
    // закрываем покупку
    for( j=0; j<OrdersTotal(); j++) {
     if( OrderSelect( j, SELECT_BY_POS, MODE_TRADES ) ) {
      if( Symbol() == OrderSymbol() && idSignal == OrderComment()  ) {
       typeOrder = OrderType();
       if( typeOrder == OP_BUY ) {
        for( i=0; i<7; i++ ) {
         if( IsTradeAllowed() ) {
          RefreshRates();
          if( typeOrder == OP_BUY )
           price = Bid;
          else
           price = Ask;
          result = OrderClose( OrderTicket(), OrderLots(), price, slippage, CLR_NONE );
          if( !result )
           Print("Ошибка: ",GetLastError());  
          else {
           Print( "закрыли покупку "+Symbol()+" id="+idSignal );
           PlaySound("ok.wav");
           return( 0 );
          }
         }
         Sleep( 10000 );
        }
       }       
      }
     }   
    }
    Print( "Ошибка закрытия позиции "+Symbol()+" id="+idSignal );
    PlaySound( "disconnect.wav" );
   }
   else
   if( action == "Sell" ) {
    // продаём
    for( i=0; i<7; i++ ) {
     if( IsTradeAllowed() ) {
      RefreshRates();
      if( marketOrderOn == false )
       order = OrderSend( Symbol(), OP_SELL, amount, Bid, slippage, Bid+stop+spred, Bid-limit, idSignal, 0, 0, CLR_NONE );
      else {
       // открываемся по цене рынка
       order = OrderSend( Symbol(), OP_SELL, amount, Bid, slippage, 0, 0, idSignal, 0, 0, CLR_NONE );
       if( order > 0 ) {
        OrderSelect( order, SELECT_BY_TICKET );
        OrderModify( order, OrderOpenPrice(), Bid+stop+spred, Bid-limit, 0, CLR_NONE );
       }
      }
      if( order <= 0 )
       Print("Ошибка: ",GetLastError());  
      else {
       Print( "Продали "+Symbol()+" id="+idSignal+" stop="+stop+" limit="+limit+" amount="+amount );
       PlaySound("ok.wav");
       return( 0 );
      }
     }       
     Sleep( 10000 );
    }   
    Print( "Ошибка открытия позиции "+Symbol()+" id="+idSignal+" stop="+stop+" limit="+limit );
    PlaySound( "disconnect.wav" );
   }
   else
   if( action == "SellClose" ) {
    // закрываем продажу
    for( j=0; j<OrdersTotal(); j++) {
     if( OrderSelect( j, SELECT_BY_POS, MODE_TRADES ) ) {
      if( Symbol() == OrderSymbol() && idSignal == OrderComment() ) {
       typeOrder = OrderType();
       if( typeOrder == OP_SELL ) {
        for( i=0; i<7; i++ ) {
         if( IsTradeAllowed() ) {
          RefreshRates();
          if( typeOrder == OP_SELL )
           price = Ask;
          else
           price = Bid;
          result = OrderClose( OrderTicket(), OrderLots(), price, slippage, CLR_NONE );
          if( !result )
           Print("Ошибка: ",GetLastError());  
          else {
           Print( "закрыли продажу "+Symbol()+" id="+idSignal );
           PlaySound("ok.wav");
           return( 0 );
          }
         }
         Sleep( 10000 );
        }
       }       
      }
     }   
    }
    Print( "Ошибка закрытия позиции "+Symbol()+" id="+idSignal );
    PlaySound( "disconnect.wav" );
   }
}

