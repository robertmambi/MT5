

   //####################################################################
   
   #include "common.mqh";

   int Global_ma0 = 12;
   int Global_ma1 = 20;
   int Global_ma2 = 50;
   int Global_ma3 = 100;
   int Global_ma4 = 200;
   
   ENUM_TIMEFRAMES Global_tf = PERIOD_M5;
    
   ENUM_MA_METHOD GetMAMethod(int period) {
      
      switch (period) {

         case Global_ma2: return MODE_EMA; 
         case Global_ma3: return MODE_EMA;
         case Global_ma4: return MODE_EMA;
                  default: return MODE_SMA;
      }
   }

   //####################################################################

   bool CheckMAConditions(ENUM_TIMEFRAMES tf,string strUPDW = NULL) {

   int periods[] = {Global_ma0, Global_ma1, Global_ma2, Global_ma3, Global_ma4};
   double ma[5][3];  // [period index][0] for current, [1] for previous

   for (int i = 0; i < ArraySize(periods); i++)
   {
      int maHandle =-1;
      
      maHandle = iMA(_Symbol, tf, periods[i], 0, GetMAMethod(periods[i]), PRICE_CLOSE);
      
      if (maHandle == INVALID_HANDLE)
      {
         Print("Error creating MA handle for period ", periods[i], ": ", GetLastError());
         return false;
      }

      double buffer[];
      ArraySetAsSeries(buffer, true);
      if (CopyBuffer(maHandle, 0, 0, 5, buffer) != 5)
      {
         Print("Error copying MA buffer for period ", periods[i], ": ", GetLastError());
         return false;
      }

      ma[i][0] = buffer[0];  // C  = current
      ma[i][1] = buffer[1];  // P  = previous
      ma[i][2] = buffer[4];  // Px = previous 5 Candle back

      // Free the indicator handle to avoid resource leaks
      IndicatorRelease(maHandle);
   }

   // Extract current values
   double MA0C = ma[0][0];
   double MA1C = ma[1][0];
   double MA2C = ma[2][0];
   double MA3C = ma[3][0];
   double MA4C = ma[4][0];
   
   double MA0P = ma[0][1];
   double MA1P = ma[1][1];
   double MA2P = ma[2][1];
   double MA3P = ma[3][1];
   double MA4P = ma[4][1];

   double MA0Px = ma[0][2];
   double MA1Px = ma[1][2];
   double MA2Px = ma[2][2];
   double MA3Px = ma[3][2];
   double MA4Px = ma[4][2];
   
   double D0CPx = NormalizeDouble(MA0C-MA0Px,2);
   double D1CPx = NormalizeDouble(MA1C-MA1Px,2);
   double D2CPx = NormalizeDouble(MA2C-MA2Px,2);
   double D3CPx = NormalizeDouble(MA3C-MA3Px,2);
   double D4CPx = NormalizeDouble(MA4C-MA4Px,2);
   
   bool DeltaUP = false;
   bool DeltaDW = false;
   
      if(tf == PERIOD_M1) {
      DeltaUP =(D0CPx > 1.50)
            && (D1CPx > 1.25)
            && (D2CPx > 0.40)
            && (D3CPx > 0.25)
            && (D4CPx > 0.10);
            
      DeltaDW =(D0CPx < -1.50)
            && (D1CPx < -1.25)
            && (D2CPx < -0.40)
            && (D3CPx < -0.25)
            && (D4CPx < -0.10);
   } 
   else if(tf == PERIOD_M5) {
      DeltaUP =(D0CPx > 1.50)
            && (D1CPx > 1.50)
            && (D2CPx > 1.25)
            && (D3CPx > 0.40)
            && (D4CPx > 0.15);
            
      DeltaDW =(D0CPx < -1.50)
            && (D1CPx < -1.50)
            && (D2CPx < -1.25)
            && (D3CPx < -0.40)
            && (D4CPx < -0.15);
   }
   
   

   
   
      if      (
               // 5<4<3<2<1
               (MA4C < MA3C) 
            && (MA3C < MA2C) 
            && (MA2C < MA1C) 
            && (MA1C < MA0C)
            
            //10<5  9<4  8<3  7<2  6<1
            && (MA4P < MA4C) 
            && (MA3P < MA3C) 
            && (MA2P < MA2C) 
            && (MA1P < MA1C) 
            && (MA0P < MA0C) 

            //15<10  14<9  13<8  12<7  11<6
            && (MA4Px < MA4P) 
            && (MA3Px < MA3P) 
            && (MA2Px < MA2P) 
            && (MA1Px < MA1P) 
            && (MA0Px < MA0P) 
            
            && DeltaUP
             
            && (strUPDW == "UP")
         ) {
         //   Log(EnumToString(tf) + " UP-D0CPx-D4CPx= "+DoubleToString(D0CPx,2)+"  "+DoubleToString(D1CPx,2)+"  "+DoubleToString(D2CPx,2)+"  "+DoubleToString(D3CPx,2)+"  "+DoubleToString(D4CPx,2)+"  ");
            return true;
           }
     
      else if ((MA4C > MA3C) 
            && (MA3C > MA2C) 
            && (MA2C > MA1C) 
            && (MA1C > MA0C)
            
            && (MA4P > MA4C) 
            && (MA3P > MA3C) 
            && (MA2P > MA2C) 
            && (MA1P > MA1C) 
            && (MA0P > MA0C)

            && (MA4Px > MA4P) 
            && (MA3Px > MA3P) 
            && (MA2Px > MA2P) 
            && (MA1Px > MA1P) 
            && (MA0Px > MA0P) 

            && DeltaDW
            
            && (strUPDW == "DW")
        ) {
        //   Log(EnumToString(tf) + " DW-D0CPx-D4CPx= "+DoubleToString(D0CPx,2)+"  "+DoubleToString(D1CPx,2)+"  "+DoubleToString(D2CPx,2)+"  "+DoubleToString(D3CPx,2)+"  "+DoubleToString(D4CPx,2)+"  ");
           return true;
          }
   
   
   
      return false;
   }


   //####################################################################


   double GetMACurrentValue( int ma_period, ENUM_TIMEFRAMES tf, int index = 0)
   {
      int maHandle = iMA(_Symbol, tf, ma_period, 0, GetMAMethod(ma_period), PRICE_CLOSE);
      if (maHandle == INVALID_HANDLE)
      {
         Print("Error creating MA handle: ", GetLastError());
         return EMPTY_VALUE;
      }
   
      double buffer[];
      ArraySetAsSeries(buffer, true);
   
      if (CopyBuffer(maHandle, 0, 0, (index+1), buffer) != (index+1))
      {
         Print("Error copying MA buffer: ", GetLastError());
         IndicatorRelease(maHandle);
         return EMPTY_VALUE;
      }
   
      IndicatorRelease(maHandle);
      return buffer[index];
   }


   //####################################################################

   // CheckMASlope(20, PERIOD_M5, "UP",  0,  5,  1)
   bool CheckMASlope(int ma_period, ENUM_TIMEFRAMES tf = PERIOD_M5, string strUPDW = NULL, int indexC = 0, int indexP = 5, double diff = 1) {
   
      if (strUPDW == "UP" || strUPDW == "DW")  ;
      else return false;
      
      double MA_indexC = GetMACurrentValue(ma_period, tf, indexC);
      double MA_indexP = GetMACurrentValue(ma_period, tf, indexP);

      //Log(strUPDW + " MA_indexC, MA_indexP, diff =" + DoubleToString(MA_indexC,2) +" | " + DoubleToString(MA_indexP,2) + " | " + DoubleToString((MA_indexC-MA_indexP),2) );

      if(strUPDW == "UP") return ((MA_indexC-MA_indexP) > diff);
      if(strUPDW == "DW") return ((MA_indexP-MA_indexC) > diff);
      
      return false;
   }








 //(BoolToUpDown(IsTrending(_Symbol, PERIOD_M1)) == "DW")
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


double GetParabolicSAR(string symbol, ENUM_TIMEFRAMES timeframe, int shift = 1, double step = 0.015, double max = 0.005)
{
// step/max = 0.015/0.005
// step/max = 0.02/0.002

   int handle = iSAR(symbol, timeframe, step, max);

   if (handle == INVALID_HANDLE)
   {
      Print("Failed to create SAR handle: ", GetLastError());
      return EMPTY_VALUE;
   }

   double sar[];
   if (CopyBuffer(handle, 0, shift, 1, sar) <= 0)
   {
      Print("Failed to copy SAR data: ", GetLastError());
      return EMPTY_VALUE;
   }

   return sar[0];
}
