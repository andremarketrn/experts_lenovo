//+------------------------------------------------------------------+
//|                                                  avalanche 7.mq4 |
//|                                                 George Tischenko |
//|                                                                  |
//+------------------------------------------------------------------+
#property copyright "George Tischenko"

extern bool Monitor=true; //� ������� ��� ����������� ������������ ��������� (��������)
extern int Distance=25,   //���������� � ������� �� ���� �� ������� �������� �������
           MinProfit=5,   //����������� ������ � �������, ���� �������� ������� ����� 1
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
  BLot=MarketInfo(Symbol(),15);      // MODE_LOTSIZE ������ ��������� � ������� ������ �����������
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
    {//������ ������ ������������� ����, ��� � ���� �������� ���������� ��������� ������
    double lots=0, Type=-1, OpenPrice=0;
    for(i=0;i<OrdersTotal();i++)
      {//����� ��������� ����� ����� ����� ������� �����
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
      
     //��������, ������ ���� ������� - �������� ���:
    int C=0; //���� �������� ���� �������
    if(OrdersTotal()==1) //��� ��� ��� ���� XXX/USD
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
      {//���� �� ��� ������...
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
      case 0 : //����������� ��������...
        {
        lots*=2; //����� ������ :-(
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
      case 1 : //��������� ��� �������
        {
        while(OrdersTotal()>0)
          {
          int ticket_buy=0,  //����� ������ BUY (�� ����� ����=0)
              ticket_sell=0; //����� ������ SELL (�� ����� ����=0)
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
          //�������� ������� �� ��������������:  
          bool OCB=ticket_buy>0 && ticket_sell>0;
          if(OCB) OrderCloseBy(ticket_buy,ticket_sell,White); // ���� ��������
          else
            {//��������� ���������� ��������� ������
            for(i=0;i<OrdersTotal();i++) //���� total==0, ���� ������ �� ���������
              {//��������� ���������� ������
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
//==== ���� �����������
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