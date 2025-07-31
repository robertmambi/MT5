//
//      Log("TrendStrength M1,M5,M15,M30 = " 
//         + DoubleToString(TrendStrength(Symbol(), PERIOD_M1), 2)
//         + "," + DoubleToString(TrendStrength(Symbol(), PERIOD_M5), 2)
//         + "," + DoubleToString(TrendStrength(Symbol(), PERIOD_M15), 2)
//         + "," + DoubleToString(TrendStrength(Symbol(), PERIOD_M30), 2)
//         );
//
//      Log("IsTrendingUp  M1,M5,M15,M30 = " 
//         + BoolToUpDown(IsTrendingUp(Symbol(), PERIOD_M1))
//         + "," + BoolToUpDown(IsTrendingUp(Symbol(), PERIOD_M5))
//         + "," + BoolToUpDown(IsTrendingUp(Symbol(), PERIOD_M15))
//         + "," + BoolToUpDown(IsTrendingUp(Symbol(), PERIOD_M30))
//         );
//
//      Log("TrendSlope    M1,M5,M15,M30 = " 
//         + DoubleToString(TrendSlope(Symbol(), PERIOD_M1), 2)
//         + "," + DoubleToString(TrendSlope(Symbol(), PERIOD_M5), 2)
//         + "," + DoubleToString(TrendSlope(Symbol(), PERIOD_M15), 2)
//         + "," + DoubleToString(TrendSlope(Symbol(), PERIOD_M30), 2)
//         );
//
//      Log("MovingAverageSlope M1,M5,M15,M30 = " 
//         + DoubleToString(MovingAverageSlope(Symbol(), PERIOD_M1), 2)
//         + "," + DoubleToString(MovingAverageSlope(Symbol(), PERIOD_M5), 2)
//         + "," + DoubleToString(MovingAverageSlope(Symbol(), PERIOD_M15), 2)
//         + "," + DoubleToString(MovingAverageSlope(Symbol(), PERIOD_M30), 2)
//         );
//
//      Log("CheckMAConditions  M1,M5,M15,M30 = " 
//         + CheckMAConditions(Symbol(), PERIOD_M1)
//         + "," + CheckMAConditions(Symbol(), PERIOD_M5)
//         + "," + CheckMAConditions(Symbol(), PERIOD_M15)
//         + "," + CheckMAConditions(Symbol(), PERIOD_M30)
//         );


#include "common.mqh";

   int Global_ma0 = 20;
   int Global_ma1 = 40;
   int Global_ma2 = 80;
   int Global_ma3 = 240;
   
   ENUM_TIMEFRAMES Global_tf = PERIOD_M5;
    
   ENUM_MA_METHOD GetMAMethod(int period) {
      if (period == Global_ma3) return MODE_LWMA;  // Use EMA for the longest period
      return MODE_EMA;  // Use LWMA for shorter periods
   }


   string CheckMAConditions(ENUM_TIMEFRAMES tf) {

   int periods[] = {Global_ma0, Global_ma1, Global_ma2, Global_ma3};
   double ma[4][2];  // [period index][0] for current, [1] for previous

   for (int i = 0; i < ArraySize(periods); i++)
   {
      int maHandle =-1;
      
      maHandle = iMA(_Symbol, tf, periods[i], 0, GetMAMethod(periods[i]), PRICE_CLOSE);
      
      if (maHandle == INVALID_HANDLE)
      {
         Print("Error creating MA handle for period ", periods[i], ": ", GetLastError());
         return "Error";
      }

      double buffer[];
      ArraySetAsSeries(buffer, true);
      if (CopyBuffer(maHandle, 0, 0, 2, buffer) != 2)
      {
         Print("Error copying MA buffer for period ", periods[i], ": ", GetLastError());
         return "Error";
      }

      ma[i][0] = buffer[0];  // current
      ma[i][1] = buffer[1];  // previous

      // Free the indicator handle to avoid resource leaks
      IndicatorRelease(maHandle);
   }

   // Extract current values
   double MA20C  = ma[0][0];
   double MA60C  = ma[1][0];
   double MA120C = ma[2][0];
   double MA240C = ma[3][0];

   double MA20P  = ma[0][1];
   double MA60P  = ma[1][1];
   double MA120P = ma[2][1];
   double MA240P = ma[3][1];

   if (  (MA240C < MA120C) && (MA120C < MA60C) && (MA60C < MA20C)
      && (MA240P < MA240C) && (MA120P < MA120C) && (MA60P < MA60C) && (MA20P < MA20C) 
    ){
    // Print (EnumToString(tf) + " : double MA240C = " + DoubleToString(MA240C, 2) + " ; MA120C = " + DoubleToString(MA120C, 2) + " ; MA60C = " + DoubleToString(MA60C, 2) + " ; MA20C = " + DoubleToString(MA20C, 2));
    // Print (EnumToString(tf) + " : double MA240P = " + DoubleToString(MA240P, 2) + " ; MA120P = " + DoubleToString(MA120P, 2) + " ; MA60P = " + DoubleToString(MA60P, 2) + " ; MA20P = " + DoubleToString(MA20P, 2));
      return "UP";
      }
   else if ( (MA240C > MA120C) && (MA120C > MA60C) && (MA60C > MA20C)
          && (MA240P > MA240C) && (MA120P > MA120C) && (MA60P > MA60C) && (MA20P > MA20C) 
        )
      return "DW";
   else
      return "XX";
   }


bool IsTrending(string symbol, ENUM_TIMEFRAMES tf, int lookback = 50) {
   double price_now = iClose(symbol, tf, 0);
   double price_then = iClose(symbol, tf, lookback);
   return price_now > price_then;
}


string IsTrending_M_1_5_15_30() {

    if ( 
            BoolToUpDown(IsTrending(_Symbol, PERIOD_M1))  == "UP" 
         && BoolToUpDown(IsTrending(_Symbol, PERIOD_M5))  == "UP" 
         && BoolToUpDown(IsTrending(_Symbol, PERIOD_M15)) == "UP" 
         && BoolToUpDown(IsTrending(_Symbol, PERIOD_M30)) == "UP" 
      ) return "UP";
     else if ( 
            BoolToUpDown(IsTrending(_Symbol, PERIOD_M1))  == "DW" 
         && BoolToUpDown(IsTrending(_Symbol, PERIOD_M5))  == "DW" 
         && BoolToUpDown(IsTrending(_Symbol, PERIOD_M15)) == "DW" 
         && BoolToUpDown(IsTrending(_Symbol, PERIOD_M30)) == "DW" 
      ) return "DW";     
    else return "XX";
}

double GetMACurrentValue( int ma_period, ENUM_TIMEFRAMES tf)
{
   int maHandle = iMA(_Symbol, tf, ma_period, 0, GetMAMethod(ma_period), PRICE_CLOSE);
   if (maHandle == INVALID_HANDLE)
   {
      Print("Error creating MA handle: ", GetLastError());
      return EMPTY_VALUE;
   }

   double buffer[];
   ArraySetAsSeries(buffer, true);

   if (CopyBuffer(maHandle, 0, 0, 1, buffer) != 1)
   {
      Print("Error copying MA buffer: ", GetLastError());
      IndicatorRelease(maHandle);
      return EMPTY_VALUE;
   }

   IndicatorRelease(maHandle);
   return buffer[0];
}


//##################################################################################








double TrendStrength(string symbol, ENUM_TIMEFRAMES tf, int lookback = 50) {
   double now = iClose(symbol, tf, 0);
   double past = iClose(symbol, tf, lookback);
   // Print("Current Price: ", DoubleToString(now, 2), " | Past Price: ", DoubleToString(past, 2));
   return ((now - past) / past * 100.0)*100.0;
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
   return slope*100.0;
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
   return (ma_now - ma_prev)*100.0;
}





double SurfaceBetweenMA(string symbol, ENUM_TIMEFRAMES tf, int period = 100)
{
   double ma20[], ma120[];
   int ma20_handle  = iMA(symbol, tf,  20, 0, MODE_EMA, PRICE_CLOSE);
   int ma120_handle = iMA(symbol, tf, 120, 0, MODE_EMA, PRICE_CLOSE);

   if (ma20_handle == INVALID_HANDLE || ma120_handle == INVALID_HANDLE)
   {
      Print("Error creating MA handles: ", GetLastError());
      return 0.0;
   }

   // Ensure latest bar is at index 0
   ArraySetAsSeries(ma20, true);
   ArraySetAsSeries(ma120, true);

   if (CopyBuffer(ma20_handle, 0, 0, period, ma20) != period ||
       CopyBuffer(ma120_handle, 0, 0, period, ma120) != period)
   {
      Print("Error copying MA buffers: ", GetLastError());
      return 0.0;
   }

   double area = 0.0;

   //Print(DoubleToString( ma20[0],2) + " " + DoubleToString( ma20[1],2) + " " + DoubleToString( ma20[2],2) + " " + DoubleToString( ma20[3],2));
   //Print(DoubleToString(ma120[0],2) + " " + DoubleToString(ma120[1],2) + " " + DoubleToString(ma120[2],2) + " " + DoubleToString(ma120[3],2));
   
   for (int i = 0; i < period; i++)
   {
      area += (ma20[i] - ma120[i]);  
   }

   return area;
}
