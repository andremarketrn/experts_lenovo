//+------------------------------------------------------------------+
//|                                                Task1_Denamix.mq4 |
//|                      Copyright © 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright © 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
Alert(" --------this is a separator from the previous execution --------- ");  
Alert("My account ballance as of now is ", AccountBalance());
Print("My account ballance as of now is ", AccountBalance());
Alert("My Broker name is ", AccountCompany());
Alert("The equity of my accunt is ", AccountEquity());
Alert("The free margin of my account is ", AccountFreeMargin());
Alert("If I opened a BUY position of 0.5 lots right now my free margin would be ", AccountFreeMarginCheck(Symbol(),0,0.5));
if (AccountFreeMarginMode()==1) Alert ("Both of Your profit and loss are not used to determine your margin"); 
Alert("Your account leverage at the moment is ", AccountLeverage());
Alert("Your account margin at the moment is ", AccountMargin());
Alert("Your account is called  ", AccountName());
Alert("Your account number at the moment is ", AccountNumber());
Alert("And you have made so far ", AccountProfit(), " dollars, woohoo!");
Alert("You are now connected to the server called ", AccountServer());
Alert("They will cut you off when your account gets to ", AccountStopoutLevel(), " dollars, bastards!");
Alert("You are now connected to the server called ", AccountServer());
if (AccountStopoutMode()==0) Alert("They will get your margin-equity ratio to determine when to cut you off");
   else Alert("They will compare free marging to absolute value to determine when to cut you off");
   return(0);
  }
  
  // Question: How to clear the Alert window?
  

