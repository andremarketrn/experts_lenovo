//+------------------------------------------------------------------+
//| My_First_EA.mq4 |
//| Coders Guru |
//| http://www.forex-tsd.com |
//+------------------------------------------------------------------+
#property copyright "Coders Guru"
#property link "http://www.forex-tsd.com"
//---- input parameters
extern double TakeProfit=250.0;
extern double Lots=0.1;
extern double TrailingStop=35.0;
//+------------------------------------------------------------------+
//| expert initialization function |
//+------------------------------------------------------------------+
int init()
{
//----
//----
return(0);
}
//+------------------------------------------------------------------+
//| expert deinitialization function |
//+------------------------------------------------------------------+
int deinit()
{
//----
//----
return(0);
}
int Crossed (double line1 , double line2)
{
static int last_direction = 0;
static int current_dirction = 0;
if(line1>line2)current_dirction = 1; //up
if(line1<line2)current_dirction = 2; //down
if(current_dirction != last_direction) //changed
{
last_direction = current_dirction;
return (last_direction);
}
else
{
return (0);
}
}
//+------------------------------------------------------------------+
//| expert start function |
//+------------------------------------------------------------------+
int start()
{
//----
int cnt, ticket, total;
double shortEma, longEma;
if(Bars<100)
{
Print("bars less than 100");
return(0);
}
if(TakeProfit<10)
{
Print("TakeProfit less than 10");
return(0); // check TakeProfit
}
shortEma = iMA(NULL,0,8,0,MODE_EMA,PRICE_CLOSE,0);
longEma = iMA(NULL,0,13,0,MODE_EMA,PRICE_CLOSE,0);
int isCrossed = Crossed (shortEma,longEma);
total = OrdersTotal();
if(total < 1)
{
if(isCrossed == 1)
{
ticket=OrderSend(Symbol(),OP_BUY,Lots,Ask,3,0,Ask+TakeProfit*Point,
"My EA",12345,0,Green);
if(ticket>0)
{
if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
Print("BUY order opened : ",OrderOpenPrice());
}
else Print("Error opening BUY order : ",GetLastError());
return(0);
}
if(isCrossed == 2)
{
ticket=OrderSend(Symbol(),OP_SELL,Lots,Bid,3,0,
Bid-TakeProfit*Point,"My EA",12345,0,Red);
if(ticket>0)
{
if(OrderSelect(ticket,SELECT_BY_TICKET,MODE_TRADES))
Print("SELL order opened : ",OrderOpenPrice());
}
else Print("Error opening SELL order : ",GetLastError());
return(0);
}
return(0);
}
for(cnt=0;cnt<total;cnt++)
{
OrderSelect(cnt, SELECT_BY_POS, MODE_TRADES);
if(OrderType()<=OP_SELL && OrderSymbol()==Symbol())
{
if(OrderType()==OP_BUY) // long position is opened
{
// should it be closed?
if(isCrossed == 2)
{
OrderClose(OrderTicket(),OrderLots(),Bid,3,Violet);
// close position
return(0); // exit
}
// check for trailing stop
if(TrailingStop>0)
{
if(Bid-OrderOpenPrice()>Point*TrailingStop)
{
if(OrderStopLoss()<Bid-Point*TrailingStop)
{
OrderModify(OrderTicket(),OrderOpenPrice(),Bid-
Point*TrailingStop,OrderTakeProfit(),0,Green);
return(0);
}
}
}
}
else // go to short position
{
// should it be closed?
if(isCrossed == 1)
{
OrderClose(OrderTicket(),OrderLots(),Ask,3,Violet);
// close position
return(0); // exit
}
// check for trailing stop
if(TrailingStop>0)
{
if((OrderOpenPrice()-Ask)>(Point*TrailingStop))
{
if((OrderStopLoss()>(Ask+Point*TrailingStop)) ||
(OrderStopLoss()==0))
{
OrderModify(OrderTicket(),OrderOpenPrice(),Ask+Point*TrailingStop,
OrderTakeProfit(),0,Red);
return(0);
}
}
}
}
}
}
return(0);
}
//+------------------------------------------------------------------+