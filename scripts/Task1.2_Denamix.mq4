//+------------------------------------------------------------------+
//|                                              Task1.2_Denamix.mq4 |
//|                      Copyright � 2012, MetaQuotes Software Corp. |
//|                                        http://www.metaquotes.net |
//+------------------------------------------------------------------+
#property copyright "Copyright � 2012, MetaQuotes Software Corp."
#property link      "http://www.metaquotes.net"

//+------------------------------------------------------------------+
//| script program start function                                    |
//+------------------------------------------------------------------+
int start()
  {
int a, b, c=2;
double x=1.67, y, z, ab;
bool yes, no;
datetime now, after;
string one="lets " , two="finally make ", three="some money! yay!", sum;
color deepPurple;
Alert(" --------this is a separator from the previous execution --------- ");
Alert("This is my homework on data types"); // ��� �������� ������������ Alert ������ ��� ������ ����������� � �� ���� �������� � ����
   a=2147483647;
   b= a+1;
   Alert("this is what happens when you exeed the rage a was ", a, " and now a=", b);
   now = TimeCurrent() - TimeLocal();
   Alert("time difference is ", TimeToStr(now,TIME_MINUTES|TIME_SECONDS));
   Alert("Local time is ", TimeToStr(TimeLocal(),TIME_DATE|TIME_MINUTES|TIME_SECONDS));
   b++;
   Alert("The b variable is now ", b);
   b = b*(-1);
    Alert("and now the b variable is now ", b);
   ab = x+c;
   Alert("Variable ab is now ", ab); 
   sum = one+two+three;
   Alert("the sum of three string variables is: ", sum);
   sum = two + one + three;
   Alert("and this is what happens if we change order: ", sum);
   deepPurple = DeepPink + Purple;
   Alert("I have no idea what this is going to be DeepPurple: ", deepPurple); 
   DrawAllColor2();
   return(0);
  }
// ������: � �������� ������� ��������� ������� ����� ��������� ���� �������? ��� ��� ��� �������?  
  void DrawAllColor2()
{
   ObjectsDeleteAll();           // ������� ��� ������� � ����
   datetime dt;
   int it=0;
   color clr; 
   // ��������� ������� ����
   for(clr=1802700; clr < 18027903; clr++)// wanted to see which collor this is
   {
      dt = iTime(Symbol(), PERIOD_M1, it);
      it++;
      ObjectCreate("l"+it, OBJ_VLINE, 0, dt, 0);  // ���������� ������������ �����
      ObjectSet( "l"+it, OBJPROP_COLOR, clr);     // ���������� ���� �����
   }
}
//+------------------------------------------------------------------+