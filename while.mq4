//--------------------------------------------------------------------
// simpleopen.mq4 
// ???????????? ??? ????????????? ? ???????? ??????? ? ???????? MQL4.
//--------------------------------------------------------------------
int start()                                  // ????. ??????? start()
  {                                          // ???????? BUY
   int Ticket = 0;
      Ticket = OrderSend(Symbol(),OP_BUY,0.1,Ask,3,Bid-15*Point,Bid+15*Point);
   if (Ticket > 0)
      {
      Comment("the position was successfully opened");
      }
   else
      {
      Comment("something went croocked. the error number is ",GetLastError());
      } 
   return;                                   // ????? ?? start()
  }
//--------------------------------------------------------------------
//what did I do wrong in this one?//