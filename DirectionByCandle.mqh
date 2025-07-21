double TrendStrength(string symbol, ENUM_TIMEFRAMES tf, int lookback = 50) {
   double now = iClose(symbol, tf, 0);
   double past = iClose(symbol, tf, lookback);
   return (now - past) / past * 100.0;
}


bool IsTrendingUp(string symbol, ENUM_TIMEFRAMES tf, int lookback = 50) {
   double price_now = iClose(symbol, tf, 0);
   double price_then = iClose(symbol, tf, lookback);
   return price_now > price_then;
}


double TrendSlope(string symbol, ENUM_TIMEFRAMES tf, int lookback = 50) {
   double sum_x = 0, sum_y = 0, sum_xy = 0, sum_x2 = 0;
   for(int i = 0; i < lookback; i++) {
      double y = iClose(symbol, tf, i);
      sum_x += i;
      sum_y += y;
      sum_xy += i * y;
      sum_x2 += i * i;
   }

   double slope = (lookback * sum_xy - sum_x * sum_y) / (lookback * sum_x2 - sum_x * sum_x);
   return slope;
}


double MovingAverageSlope(string symbol, ENUM_TIMEFRAMES tf, int ma_period = 50) {
   double ma_Values[];
   int ma_Handle  = iMA(symbol, tf, ma_period, 0, MODE_SMA, PRICE_CLOSE);
   
   if(ma_Handle == INVALID_HANDLE)  {
      Print("Error creating MA handle: ", GetLastError());
      return 0.0;
   }    
  
   ArraySetAsSeries(ma_Values, true);
   if(CopyBuffer(ma_Handle, 0, 0, 2, ma_Values) != 2) {
      Print("Error copying MA buffer: ", GetLastError());
      return 0.0;
   }
   // ma_Values[0] is the most recent, ma_Values[1] is previous
   double ma_now = ma_Values[0];
   double ma_prev = ma_Values[1];
   return ma_now - ma_prev;
}






