//+------------------------------------------------------------------+
//|                                                PriceImpuls_01.mq4 |
//|                                                            runik |
//|                                                  ngb2008@mail.ru |
//+------------------------------------------------------------------+
#property copyright "runik"
#property link      "ngb2008@mail.ru"

//---- input parameters
extern int       step=15; // расстояние которое должна пробежать цена с определенной скоростью 
// (при step=15 и w=1 за 15 тиков цена должна пробежать 15 пунктов, тогда открываемся )
extern double    w=1.0; // скорость изм цены. пунктов за тик 
extern int       tp=5;
extern int       sl=30;
extern int       MagicNumber=943;
extern double    lot=0.1;
extern int       slipage=2;
extern double    pause=100; // после закрытия последней сделки можно сделать паузу, секунд
datetime lt=0; 
double p[2]; 
int t,to;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
t=step/w; 
int e=ArrayResize(p, t);
ArrayInitialize(p,Bid);
lt=TimeCurrent();  
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
//----
if(DayOfWeek()==0 || DayOfWeek()==6)  return(0);// не работает в выходные дни.
// поиск максимума и минимума за последнее время
double max,min;
int r=FillP();
to=CountTrades();
if (to>0)
 {
 lt=TimeCurrent();
 }
if (to==0)
  {
  if ((TimeCurrent()-lt)<pause) return(0);
  
  if (Bid>(p[ArrayMinimum(p)]+step*Point))
   {
   Print(" ArrayMinimum(p)  ", p[ArrayMinimum(p)]);
   int ticket=OrderSend(Symbol(),OP_BUY,lot,Ask,slipage,Ask-sl*Point,Ask+tp*Point,"",MagicNumber,0,Green) ; 
   }
  }
  
if (to==0)
  {
  if (Bid<(p[ArrayMaximum(p)]-step*Point))
   {
   Print(" ArrayMinimum(p)  ", p[ArrayMaximum(p)]);
   ticket=OrderSend(Symbol(),OP_SELL,lot,Bid,slipage,Bid+sl*Point,Bid-tp*Point,"",MagicNumber,0,Red); 
   }
  }  
  



   
//----
   return(0);
  }
//+------------------------------------------------------------------+

int FillP()
{
for(int cnt=t;cnt>=1;cnt--)
      {
      p[cnt]=p[cnt-1];
      }
p[0]=Bid;            
}

int CountTrades() {
   int count = 0;
   for (int trade = OrdersTotal() - 1; trade >= 0; trade--) {
      OrderSelect(trade, SELECT_BY_POS, MODE_TRADES);
      if (OrderSymbol() != Symbol() || OrderMagicNumber() != MagicNumber) continue;
      if (OrderSymbol() == Symbol() && OrderMagicNumber() == MagicNumber)
         if (OrderType() == OP_SELL || OrderType() == OP_BUY) count++;
   }
   return (count);
}

