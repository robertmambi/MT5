//+------------------------------------------------------------------+
//|                                                 FunctionTest.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"



#include "common.mqh";

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+



//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

string maCrossing(int fastPeriod, int slowPeriod) {

   double ma_SlowValues[];
   double ma_FastValues[];
   
   int ma_SlowHandle = iMA(_Symbol, _Period, slowPeriod, 0, MODE_SMA , PRICE_CLOSE);
   int ma_FastHandle = iMA(_Symbol, _Period, fastPeriod, 0, MODE_SMA , PRICE_CLOSE);

   if( (ma_SlowHandle == INVALID_HANDLE) || (ma_FastHandle == INVALID_HANDLE) )  {
      Print("Error creating MA handle: ", GetLastError());
      return(IntegerToString(GetLastError()));
   }    

   ArraySetAsSeries(ma_SlowValues, true);
   ArraySetAsSeries(ma_FastValues, true);

   if( (CopyBuffer(ma_SlowHandle, 0, 0, 10, ma_SlowValues) <= 0) || (CopyBuffer(ma_FastHandle, 0, 0, 10, ma_FastValues) <= 0) )  {
      Print("Error copying MA buffer: ", GetLastError());
      return(IntegerToString(GetLastError()));
   } else {
   
      // 3 - 2 - 1
      bool CrossingDW = ((ma_FastValues[2] > ma_SlowValues[2]) && (ma_FastValues[1] < ma_SlowValues[1]));
      bool CrossingUP = ((ma_FastValues[2] < ma_SlowValues[2]) && (ma_FastValues[1] > ma_SlowValues[1]));

//         Print("ma_SlowValues[1]",ma_SlowValues[1]  );
//         Print("ma_SlowValues[2]",ma_SlowValues[2]  );
//         Print("ma_SlowValues[3]",ma_SlowValues[3]  );
//         
//         Print("ma_FastValues[1]",ma_FastValues[1]  );
//         Print("ma_FastValues[2]",ma_FastValues[2]  );
//         Print("ma_FastValues[3]",ma_FastValues[3]  ); 
 
      if(CrossingUP || CrossingDW) {   
      
         Print("ma_SlowValues[1]",ma_SlowValues[1]  );
         Print("ma_SlowValues[2]",ma_SlowValues[2]  );
         Print("ma_SlowValues[3]",ma_SlowValues[3]  );
         
         Print("ma_FastValues[1]",ma_FastValues[1]  );
         Print("ma_FastValues[2]",ma_FastValues[2]  );
         Print("ma_FastValues[3]",ma_FastValues[3]  );
         
         Print("CrossingUP = ", CrossingUP );
         Print("CrossingDW = ", CrossingDW );
         
         datetime time = iTime(_Symbol, PERIOD_M1, 1);
         double price = iClose(_Symbol, PERIOD_M1, 1);
         
               if (CrossingUP == CrossingDW) return "NULL";
         else  if (CrossingUP) {
            PlaceArrow(time, price, true);
            return "UP";
           }
         else  if (CrossingDW) {
            PlaceArrow(time, price, false);
            return "DOWN";
           }
         else return "NULL";      
      }
    }

   if(ma_SlowHandle != INVALID_HANDLE) IndicatorRelease(ma_SlowHandle);
   if(ma_FastHandle != INVALID_HANDLE) IndicatorRelease(ma_FastHandle);
   
return "NULL";
}

