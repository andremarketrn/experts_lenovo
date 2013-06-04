//+------------------------------------------------------------------+
//|                                                   Лавина V_6.mq4 |
//|                      Copyright © 2008, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2008, MetaQuotes Software Corp."
#property link      "http://www.MQL-Advisor.ru"

extern double Lot=0.01;
extern int    Dist=25;
extern double Pribyl=5;
extern double K_Martin=2;
extern int    Tral_Step=5;

int r,ret;

//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
Lot=NormalizeDouble(AccountBalance()/100000,2);  
   return(0);
  }
//+------------------------------------------------------------------+
//| expert deinitialization function                                 |
//+------------------------------------------------------------------+
int deinit()
  {
//----
Comment("");   
//----
   return(0);
  }
//+------------------------------------------------------------------+
//| expert start function                                            |
//+------------------------------------------------------------------+
int start()
  {
int B=0,S=0,BS=0,SS=0;
double Prof=0,L_B=0,L_S=0,Lev_B,Lev_S,L_BS=0,L_SS=0;  
//-------------- Определим что имеем --------------------------------------------      
          for( r=0;r<OrdersTotal();r++) //  
      {
      if(OrderSelect(r,SELECT_BY_POS,MODE_TRADES)==false)    continue;
      if(OrderSymbol()==Symbol())
      {
      if (OrderType()==OP_BUY )        {  B++;Prof=Prof+OrderProfit()+OrderSwap();L_B=L_B+OrderLots();Lev_B=OrderOpenPrice();}
      if (OrderType()==OP_SELL )       {  S++;Prof=Prof+OrderProfit()+OrderSwap();L_S=L_S+OrderLots();Lev_S=OrderOpenPrice();}

      if (OrderType()==OP_BUYSTOP )   {   BS++;Lev_B=OrderOpenPrice();L_BS=L_BS+OrderLots();}
      if (OrderType()==OP_SELLSTOP)   {   SS++;Lev_S=OrderOpenPrice();L_SS=L_SS+OrderLots();}
      }}
//--------- Комментарии -----------------------------
Comment("Профит  ",Prof,"   Dist  ",Dist,"   Lot  ",Lot,"\n","Уровень BUY  ",Lev_B,"\n","Уровень SELL  ",Lev_S,
        "\n","B  ",L_B,"  BS  ",L_BS,"\n","S  ",L_S,"  SS  ",L_SS);      
      
//------- Если нет позиций ------------------------
if (B+S+BS+SS==0)
{
ret= OrderSend(Symbol(),OP_BUYSTOP,Lot,Ask+Dist*Point,0,0,0,"",0,0,Blue);
ret= OrderSend(Symbol(),OP_SELLSTOP,Lot,Bid-Dist*Point,0,0,0,"",0,0,Red);
return(0);     
}

//--------- Добавляем на случай разворота -------------------------
if (L_B>L_S && L_B>=L_S+L_SS) // --  Если BUY больше чем SELL
{
ret=OrderSend(Symbol(),OP_SELLSTOP,NormalizeDouble(L_B*K_Martin-(L_S+L_SS),2),Lev_S,3,0,0,"",0,0,CLR_NONE);
return(0);
}
if (L_S>L_B && L_S>=L_B+L_BS) // --  Если SELL больше чем BUY
{
ret=OrderSend(Symbol(),OP_BUYSTOP,NormalizeDouble(L_S*K_Martin-(L_B+L_BS),2),Lev_B,3,0,0,"",0,0,CLR_NONE);
return(0);
}
//--------- Имеем прибыль -----------------------------------------------------

//if (L_B+L_S==Lot && Prof>=Pribyl*Lot/0.01)
if  (L_B+L_S<=3*Lot && Prof>=Pribyl*Lot/0.01)
{       
     for( r=0;r<OrdersTotal();r++) //  
     {
        if (OrderSelect(r,SELECT_BY_POS,MODE_TRADES)==true )
        {    //--------- Самый первый раз ----------------------------------
          if (OrderStopLoss()==0 && OrderType()==OP_BUY)
          { 
          ret=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()-2*Dist*Point,0,0,CLR_NONE);
          PlaySound("tick.wav");
          //return(0);
          }  //----------- Трейлинг --------------------------
          if (Bid-(2*Dist+Tral_Step)*Point>OrderStopLoss() && OrderStopLoss()!=0  && OrderType()==OP_BUY)
          { 
          ret=OrderModify(OrderTicket(),OrderOpenPrice(),Bid-2*Dist*Point,0,0,CLR_NONE);
          PlaySound("tick.wav");
          //return(0);
          }
          if (OrderStopLoss()==0 && OrderType()==OP_SELL)
          { 
          ret=OrderModify(OrderTicket(),OrderOpenPrice(),OrderOpenPrice()+2*Dist*Point,0,0,CLR_NONE);
          PlaySound("tick.wav");
          //return(0);
          }  //----------- Трейлинг --------------------------
          if (Bid+(2*Dist+Tral_Step)*Point<OrderStopLoss() && OrderStopLoss()!=0  && OrderType()==OP_SELL)
          { 
          ret=OrderModify(OrderTicket(),OrderOpenPrice(),Bid+2*Dist*Point,0,0,CLR_NONE);
          PlaySound("tick.wav");
          //return(0);
          }          
          
          }

     }
}
if (L_B+L_BS==0 || L_S+L_SS==0) CloseALL();
if (Prof>=Pribyl*Lot/0.01 && L_S+L_B>2*Lot) CloseALL();
//------------  Кризис выходим с 0 -------------------------------------
//if (MathAbs(L_B-L_S)>=5*Lot && Prof>=0) CloseALL();
   return(0);
  }
//+------------------------------------------------------------------+
//----------------  Функция -----------------------------------------
int Ord_Tot_Sym()
{
int O_T=0;
      for(int rr=0;rr<OrdersTotal();rr++) //  
      {
      if(OrderSelect(rr,SELECT_BY_POS,MODE_TRADES)==false)    continue;
      if(OrderSymbol()==Symbol())
      {
   O_T++;    
      }}
      if (O_T>0) return(1);
      else return(0);
}
//----------- CloseByALL ---------------------------
int CloseByALL()
{
int ib,is;
double lb=0,ls=0;
int   tb=0,ts=0,lbb=0;
 if  (Ord_Tot_Sym()>0) 
 {
 RefreshRates();
                  for(ib=OrdersTotal()-1;ib>=0;ib--)
                   {
                  if(OrderSelect(ib,SELECT_BY_POS,MODE_TRADES)==false) continue;
                  if (OrderSymbol()==Symbol())
                  {
                     if (OrderType()==OP_BUY)
                     { 
                     lb=OrderLots();
                     tb=OrderTicket();
                  
                     //-- начнём поиск позиции SELL   
                        for(is=OrdersTotal()-1;is>=0;is--)
                        {
                        if(OrderSelect(is,SELECT_BY_POS,MODE_TRADES)==false) continue;
                        if (OrderSymbol()==Symbol())
                        {
                        if (OrderType()==OP_SELL)
                        {
                        ls=OrderLots();
                        ts=OrderTicket();
                        
                        if (lb<=ls)  
                          {
                          RefreshRates();
                          OrderCloseBy(tb,ts,White);
                          break;
                          }
                        }
                        }}}
                     if (OrderType()==OP_SELL) 
                     {  
                     ls=OrderLots();
                     ts=OrderTicket();
                     
                     //-- начнём поиск позиции BUY   
                        for(lbb=OrdersTotal()-1;lbb>=0;lbb--)
                        {
                        if(OrderSelect(lbb,SELECT_BY_POS,MODE_TRADES)==false) continue;
                        if (OrderSymbol()==Symbol())
                        {
                        if (OrderType()==OP_BUY)
                        {
                        lb=OrderLots();
                        tb=OrderTicket();
                        
                        if (ls<=lb) 
                            {
                            RefreshRates();
                            OrderCloseBy(ts,tb,White);
                            break;
                            }
                        }}}                     
                     
                        }}}}
                  
                  
                      
}
//-------------- CloseAll --------------------------   
int CloseALL()
{
int ic;
CloseByALL();
 while (Ord_Tot_Sym()>0) 
 {
 RefreshRates();
                  for(ic=OrdersTotal()-1;ic>=0;ic--)
                   {
                  if(OrderSelect(ic,SELECT_BY_POS,MODE_TRADES)==false) continue;
                  if (OrderSymbol()==Symbol())
                  {
                  if (OrderType()==OP_BUY)
                  {
                  //RefreshRates();
                  ret=OrderClose(OrderTicket(),OrderLots(),Bid,0,CLR_NONE);
                  if (IsTradeAllowed()) continue;
                  else Sleep(1000);
                  }
                                    
                  if (OrderType()==OP_SELL)
                  {
                  //RefreshRates();
                  ret=OrderClose(OrderTicket(),OrderLots(),Ask,0,CLR_NONE);
                  if (IsTradeAllowed()) continue;
                  else Sleep(1000);
                  }}}
//--------- Закрыли все позиции теперь закроем все ордера ------------------------                    
                  for(ic=OrdersTotal()-1;ic>=0;ic--)
                   {
                  if(OrderSelect(ic,SELECT_BY_POS,MODE_TRADES)==false) continue;
                  if (OrderSymbol()==Symbol())
                  {
                  if (OrderType()==OP_BUYSTOP || OrderType()==OP_SELLSTOP ||
                     OrderType()==OP_BUYLIMIT || OrderType()==OP_SELLLIMIT)
                  ret=OrderDelete(OrderTicket());
                  }}
      PlaySound("MsgBell.wav" );
      }
   return(0);
  }