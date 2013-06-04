//+------------------------------------------------------------------+
//|                                                   Poker_SHOW.mq4 |
//|                                                  Maximus_genuine |
//|                                              gladmxm@bigmir.net  |
//+------------------------------------------------------------------+
#property copyright "Maximus_genuine"
#property link      "gladmxm@bigmir.net "

//---- input parameters

//..........................................................................

extern int       Royal=8; // ----№ покерной комбинации 
extern int       SL =89; // уровень стоп-лосса в пунктах 
//..........................................................................
extern bool      In_BUY   =true;    //---вход в лонг
extern bool      In_SELL   =true;   //---вход в шорт   

 
//..........................................................................

 
 
//---- other parameters
   static int  prevtime=0;
          int    ticket=0;
          int         x=1;
          int level=16422;
          int    TP=   20;
       //-------------------------
          int Magic_BUY  =123;
          int Magic_SELL =321;
         
 
//+------------------------------------------------------------------+
//| expert initialization function                                   |
//+------------------------------------------------------------------+
int init()
  {
//--------------------------------
      if(Digits == 5) x=10;
      
      MathSrand(TimeCurrent());
//--------------------------------
    if (SL< 20) SL=20; TP=MathRound(1.618*SL);
//--------------------------------
    if (Royal==0) level=2;
    if (Royal==1) level=9;
    if (Royal==2) level=49;
    if (Royal==3) level=66;
    if (Royal==4) level=130;
    if (Royal==5) level=699;
    if (Royal==6) level=1562;
    if (Royal==7) level=13846;
 // if (Royal==8) level=16422;
//--------------------------------
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
//..........................................................................
    if (Time[0] == prevtime) return(0); 
                             prevtime = Time[0];
    if (!IsTradeAllowed()) {
     prevtime=Time[1]; Sleep(30000 + MathRand());  //--- формировка бара---
                           }
//..........................................................................
 
 
 My_Play( Magic_BUY, In_BUY, level,Ask,iMA(NULL,0,89,5,MODE_EMA,PRICE_OPEN,0));    //---торговля по лонгам
   
   
 My_Play(Magic_SELL,In_SELL,level,iMA(NULL,0,89,5,MODE_EMA,PRICE_OPEN,0),Bid);  //---торговля  по шортам
   
   
//..........................................................................
   return(0);//-----------выход из стартовой функции------------
  }
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx
void  My_Play(int mn,bool flag,int level,double a1,double a2) { 
 
         int total=OrdersTotal();
         
    for (int i = 0; i < total; i++) { OrderSelect(i, SELECT_BY_POS, MODE_TRADES);//---проход по ордерам--
    
    
                if (OrderSymbol() == Symbol() && OrderMagicNumber() == mn) { 
                
            
                
                return(0);
                                                                           } 
                                    }
 
//..........................................................................
      ticket = -1;  int Rand=MathRand();  
      
   
 
  if (  flag                          &&  // ---флаг открытия ордера
  
        a1>a2                         &&  // --- проверка фильтрующей эвристики
  
        level >   Rand                &&  //---- покер-ШОУ ---
      
      
           IsTradeAllowed()) { 
           
           if (mn<200)      {
  
 ticket= OrderSend(Symbol(), OP_BUY,lot(),Ask,5*x,Bid-x*SL*Point,Ask+x*TP*Point,DoubleToStr(mn,0),mn,0,Blue);
                         
    
                            }
                         
                         
                         else {
                         
 ticket= OrderSend(Symbol(),OP_SELL,lot(),Bid,5*x,Ask+x*SL*Point,Bid-x*TP*Point,DoubleToStr(mn,0),mn,0, Red);
                        
                              }
        
   
                 RefreshRates();   
      
              if ( ticket < 0) { Sleep(30000);   prevtime = Time[1]; } 
                                           
                                           } //-- Exit ---
 
       return(0); } 
       
 
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxXXXXXXXXXXXXXXXXXXXX
double lot() {  return(0.1);    } 
//xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx


