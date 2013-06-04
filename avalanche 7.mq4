//+------------------------------------------------------------------+
//|                                                  avalanche 7.mq4 |
//|                                                 George Tischenko |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "George Tischenko"

extern bool Monitor=true; //в тестере при выключенной визуализации отключать (тормозит)
extern int Distance=25,   //расстояние в пунктах от цены до первого открытия позиции
           MinProfit=5,   //минимальный профит в пунктах, если открытых ордеров более 1
           Slippage=3;
extern double Lot=0.1;

int Trade=0;
double BLot,StartPrice;              
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//----
  StartPrice=Bid;
  BLot=MarketInfo(Symbol(),15);      // MODE_LOTSIZE размер контракта в базовой валюте инструмента
//----
  if(Monitor==true)
    {
    int a,y;
    for(a=0,y=5;a<=3;a++)
      {
      string N=DoubleToStr(a,0);
  
      ObjectCreate(N,OBJ_LABEL,0,0,0,0,0);
      ObjectSet(N,OBJPROP_CORNER,3);
      ObjectSet(N,OBJPROP_XDISTANCE,5);
      ObjectSet(N,OBJPROP_YDISTANCE,y);
      y+=20;
      }  
    }
//----
  return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
  if(Monitor==true)
    {
    for(int a=0;a<=3;a++)
      {
      string N=DoubleToStr(a,0);
      ObjectDelete(N);
      } 
    }
//----
  return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
  int i;
//---- 
  if(OrdersTotal()==0)
    {
    RefreshRates();
    if((Ask-StartPrice>=Distance*Point && Trade==0) || Trade==1) 
      {
      OrderSend(Symbol(),OP_BUY,Lot,Ask,Slippage,0,0,"",1307,0,Blue);
      }
    if((StartPrice-Bid>=Distance*Point && Trade==0) || Trade==-1)  
      {
      OrderSend(Symbol(),OP_SELL,Lot,Bid,Slippage,0,0,"",1307,0,Red);
      }
    }
  else //OrdersTotal()>0
    {//узнаем размер максимального лота, тип и цену открытия последнего активного ордера
    double lots=0, Type=-1, OpenPrice=0;
    for(i=0;i<OrdersTotal();i++)
      {//самый последний ордер имеет самый большой объем
      if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
        {
        if(OrderSymbol()==Symbol())
          {
          if(lots<OrderLots())
            {
            lots=OrderLots();
            Type=OrderType();
            OpenPrice=OrderOpenPrice();
            }
          }
        }
      }
      
     //возможно, ордера надо закрыть - проверим это:
    int C=0; //флаг закрытия всех позиций
    if(OrdersTotal()==1) //ЭТО ДЛЯ ПАР ТИПА XXX/USD
      {
      if(AccountProfit()>=BLot*Lot*Point*Distance) 
        {
        switch(Type)
          {
          case 0 : Trade=1; break;
          case 1 : Trade=-1;
          }
        C=1;
        }
      }
    else //OrdersTotal()>1
      {//лишь бы без убытка...
      if(AccountProfit()>=BLot*Lot*Point*MinProfit)
        {
        switch(Type)
          {
          case 0 : Trade=1; break;
          case 1 : Trade=-1;
          }
        C=1;
        }
      }
     
    switch(C)
      {
      case 0 : //закрываться рановато...
        {
        lots*=2; //опять Мартин :-(
        RefreshRates();
        switch(Type)
          {
          case 0 :
            {
            if(OpenPrice-Bid>=Point*Distance*2) 
              {if(OrderSend(Symbol(),OP_SELL,lots,Bid,Slippage,0,0,"",1307,0,Red)>0) return(0);}
            break;
            }
          case 1 :
            {
            if(Ask-OpenPrice>=Point*Distance*2)
              {if(OrderSend(Symbol(),OP_BUY,lots,Ask,Slippage,0,0,"",1307,0,Blue)>0) return(0);}
            }
          }
        break;
        }
      case 1 : //закрываем все позиции
        {
        while(OrdersTotal()>0)
          {
          int ticket_buy=0,  //тикет ордера BUY (не может быть=0)
              ticket_sell=0; //тикет ордера SELL (не может быть=0)
          for(i=0;i<OrdersTotal();i++)
            {
            if(OrderSelect(i,SELECT_BY_POS)==true)
              {
              if(OrderSymbol()==Symbol())
                {
                switch(OrderType())
                  {
                  case 0 : ticket_buy=OrderTicket(); break;
                  case 1 : ticket_sell=OrderTicket();
                  }
                }
              }
            }
          //проверка тикетов на некорректность:  
          bool OCB=ticket_buy>0 && ticket_sell>0;
          if(OCB) OrderCloseBy(ticket_buy,ticket_sell,White); // Цикл закрытия
          else
            {//закрываем оставшиеся одиночные ордера
            for(i=0;i<OrdersTotal();i++) //если total==0, цикл просто не сработает
              {//закрываем оставшиеся ордера
              if(OrderSelect(i,SELECT_BY_POS,MODE_TRADES)==true)
                {
                if(OrderSymbol()==Symbol())
                  {
                  RefreshRates();
                  switch(OrderType())
                    {
                    case 0 : 
                      {
                      while(!OrderClose(OrderTicket(),OrderLots(),Bid,Slippage,White)) 
                        {
                        Sleep(10000);
                        RefreshRates();
                        } 
                      break;
                      }
                    case 1 : 
                      {
                      while(!OrderClose(OrderTicket(),OrderLots(),Ask,Slippage,White)) 
                        {
                        Sleep(10000);
                        RefreshRates();
                        } 
                      }
                    }
                  }
                }
              }
            }
          }//end while 
        }
      }
    } 
//==== БЛОК МОНИТОРИНГА
  if(Monitor==true)
    {
    string str="Balance: "+DoubleToStr(AccountBalance(),2)+" $";
    ObjectSetText("0",str,10,"Arial Black",White);
    
    str="Profit: "+DoubleToStr(AccountProfit(),2)+" $";
    ObjectSetText("1",str,10,"Arial Black",Silver);
    
    str="Free Margine: "+DoubleToStr(AccountFreeMargin(),2)+" $";
    ObjectSetText("2",str,10,"Arial Black",Yellow);
    
    str="OrdersTotal: "+DoubleToStr(OrdersTotal(),0);
    ObjectSetText("3",str,10,"Arial Black",Aqua);
    }
//----
  return(0);
  }
//+------------------------------------------------------------------+