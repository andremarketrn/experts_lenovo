////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
//                                                GreenTrade.mq4                                                      //
//                                                kozaka@ukr.net                                                      //
//                                                                                                                    //
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

#property copyright "Kozak Andrey"
#property link "Kozaka@ukr.net"


extern int    MA_period = 67;
extern int    RSI_period = 57;
extern int    Tral = 12;
extern int    TakeProfit = 300;
extern int    StopLoss = 300;
extern int    Index_orders = 7;


int init()
{
 GlobalVariableSet("time",Time[0]);
 return;
}


int start()
{
int ticket;
if(Period()==PERIOD_M5 && Symbol() == "EURUSD")
{

 double Ma0 = iMA(NULL,0,MA_period,0,MODE_SMMA,PRICE_MEDIAN,0);
 double Ma5 = iMA(NULL,0,MA_period,0,MODE_SMMA,PRICE_MEDIAN,2);
 double Ma10 = iMA(NULL,0,MA_period,0,MODE_SMMA,PRICE_MEDIAN,4);
 double Ma15 = iMA(NULL,0,MA_period,0,MODE_SMMA,PRICE_MEDIAN,7);
 double RSI = iRSI(NULL,PERIOD_H1,RSI_period,PRICE_CLOSE,0);
 
if(OrdersTotal()<Index_orders)
 {
   if(Ma0>Ma5 && Ma5>Ma10 && Ma10>Ma15 && Open[0]<Ma0 && Close[0]>Ma0 && RSI>60)
     {
       ticket=OrderSend(Symbol(),OP_BUY,0.1,Ask,1,Bid-StopLoss*Point,Ask+TakeProfit*Point);
       OrderSelect(ticket,SELECT_BY_TICKET); 
     }
     
     if(Ma0<Ma5 && Ma5<Ma10 && Ma10<Ma15 && Open[0]>Ma0 && Close[0]<Ma0 && RSI<36)
     {
       ticket=OrderSend(Symbol(),OP_SELL,0.1,Bid,1,Ask+StopLoss*Point,Bid-TakeProfit*Point);
       OrderSelect(ticket,SELECT_BY_TICKET); 
     }
}
if(OrdersTotal()<1)
{
for(int i=0;i<OrdersTotal(); i++)
 {
 OrderSelect(i,SELECT_BY_POS);
   if(OrderType() == OP_BUY)
   {
     if(Ask+100*Point<OrderOpenPrice())
     {
       OrderClose(OrderTicket(),OrderLots()/2,Bid,3,Red);
       ticket=OrderSend(Symbol(),OP_SELL,0.1,Bid,1,Ask+StopLoss*Point,Bid-TakeProfit*Point);
       OrderSelect(ticket,SELECT_BY_TICKET);
     }
   
   }
   
     if(OrderType() == OP_SELL)
       {
         if(Bid-100*Point>OrderOpenPrice())
          {
            OrderClose(OrderTicket(),OrderLots()/2,Ask,3,Red);
            ticket=OrderSend(Symbol(),OP_BUY,0.1,Ask,1,Bid-StopLoss*Point,Ask+TakeProfit*Point);
            OrderSelect(ticket,SELECT_BY_TICKET);
          }
   
      }
 
 }
}

if(GlobalVariableGet("time")!= Time[0])
{
      for(int col=0;col<OrdersTotal(); col++)
      {
       OrderSelect(col,SELECT_BY_POS);
       {
         if(OrderType()==OP_BUY)
         {
           if(Bid-Tral*Point>OrderOpenPrice())
           {
             OrderModify(OrderTicket(),OrderOpenPrice(),Bid-Tral*Point,OrderTakeProfit(),0);
           }
         }
         
          if(OrderType()==OP_SELL)
           {
             if(Ask+Tral*Point<OrderOpenPrice())
              {
                OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Tral*Point,OrderTakeProfit(),0);
              }
           }
       
       }
      
       GlobalVariableSet("time",Time[0]);
      }
}
}
else
{
  Alert("Советник работает только на валютной паре EURUSD и таймфрейме M5! Платный советник работает на всех таймфреймах!");
}
 return;
}


