

//+------------------------------------------------------------------+
//| Struct to hold per-timeframe state                               |
//+------------------------------------------------------------------+
struct TimeframeState {
   datetime lastCandleTime;
   datetime prevCandleTime;
   bool     isNewCandle;
};

// Define indices for known timeframes (expand as needed)
#define TF_COUNT  9  // Number of timeframes you want to track

int timeframes[TF_COUNT] = {
   PERIOD_M1, PERIOD_M5, PERIOD_M15, PERIOD_M30,
   PERIOD_H1, PERIOD_H4, PERIOD_D1, PERIOD_W1, PERIOD_MN1
};

TimeframeState tfData[TF_COUNT];

//+------------------------------------------------------------------+
//| Map ENUM_TIMEFRAMES to index in tfData[]                        |
//+------------------------------------------------------------------+
int GetTimeFrameIndex(ENUM_TIMEFRAMES tf) {
   for(int i = 0; i < TF_COUNT; i++) {
      if(timeframes[i] == tf)
         return i;
   }
   return -1;
}

//+------------------------------------------------------------------+
//| Returns true if a new candle has formed on this timeframe        |
//| Also updates last and previous candle timestamps                 |
//+------------------------------------------------------------------+
bool IsNewCandle(ENUM_TIMEFRAMES tf) {
   int index = GetTimeFrameIndex(tf);
   if(index == -1) return false;

   datetime currTime = iTime(_Symbol, tf, 0);

   if(tfData[index].lastCandleTime != currTime) {
      tfData[index].prevCandleTime = tfData[index].lastCandleTime;
      tfData[index].lastCandleTime = currTime;
      tfData[index].isNewCandle = true;
      return true;
   }

   tfData[index].isNewCandle = false;
   return false;
}

//+------------------------------------------------------------------+
//| Example: Call this from OnTick() or OnTimer()                    |
//+------------------------------------------------------------------+
void OnTick_IsNewCandle() {
   for(int i = 0; i < TF_COUNT; i++) {
      ENUM_TIMEFRAMES tf = (ENUM_TIMEFRAMES)timeframes[i];
      if(IsNewCandle(tf)) {
         Print("🕒 New candle on ", EnumToString(tf),
               " at ", TimeToString(tfData[i].lastCandleTime, TIME_DATE|TIME_MINUTES));
      }
   }
}

//+------------------------------------------------------------------+
//| Initialization if needed                                         |
//+------------------------------------------------------------------+
int OnInit_IsNewCandle() {
   // Preload the current candle times so false triggers are avoided
   for(int i = 0; i < TF_COUNT; i++) {
      tfData[i].lastCandleTime = iTime(_Symbol, (ENUM_TIMEFRAMES)timeframes[i], 0);
      tfData[i].prevCandleTime = tfData[i].lastCandleTime;
      tfData[i].isNewCandle = false;
   }
   return INIT_SUCCEEDED;
}


















//+-------------------OLD--Code-------------------------+
// void OnInit_OnTick_IsNewCandle() {
//    IsNewCandle(PERIOD_H4 ,true);
//    IsNewCandle(PERIOD_H1 ,true);
//    IsNewCandle(PERIOD_M30,true);
//    IsNewCandle(PERIOD_M15,true);
//    IsNewCandle(PERIOD_M5 ,true);
//    IsNewCandle(PERIOD_M1 ,true);
// }


// bool IsNewCandle(ENUM_TIMEFRAMES TimeFrame, bool first_call = false) {

//    static datetime H4_NewCandleTime  = 0;
//    static datetime H1_NewCandleTime  = 0;
//    static datetime M30_NewCandleTime = 0;
//    static datetime M15_NewCandleTime = 0;
//    static datetime M5_NewCandleTime  = 0;
//    static datetime M1_NewCandleTime  = 0;
   
//    static bool H4_result  = false;
//    static bool H1_result  = false;
//    static bool M30_result = false;
//    static bool M15_result = false;
//    static bool M5_result  = false;
//    static bool M1_result  = false;
   
//    datetime CurrTime = iTime(_Symbol, TimeFrame,0);
   
//    switch (TimeFrame) {
   
//       case PERIOD_H4:
//          if(!first_call) return H4_result;
         
//          if (H4_NewCandleTime != CurrTime) {
//              H4_NewCandleTime  = CurrTime;
//              H4_result = true;
//              return H4_result;
//          } else {H4_result = false;}
//       break;
//       case PERIOD_H1:
//          if(!first_call) return H1_result;
         
//          if (H1_NewCandleTime != CurrTime) {
//              H1_NewCandleTime  = CurrTime;
//              H1_result = true;
//              return H1_result;
//          } else {H1_result = false;}
//       break;
//       case PERIOD_M30:
//          if(!first_call) return M30_result;
         
//          if (M30_NewCandleTime != CurrTime) {
//              M30_NewCandleTime  = CurrTime;
//              M30_result = true;
//              return M30_result;
//          } else {M30_result = false;}
//       break;
//       case PERIOD_M15:
//          if(!first_call) return M15_result;
         
//          if (M15_NewCandleTime != CurrTime) {
//              M15_NewCandleTime  = CurrTime;
//              M15_result = true;
//              return M15_result;
//          } else {M15_result = false;}
//       break;
//       case PERIOD_M5:
//          if(!first_call) return M5_result;
         
//          if (M5_NewCandleTime != CurrTime) {
//              M5_NewCandleTime  = CurrTime;
//              M5_result = true;
//              return M5_result;
//          } else {M5_result = false;}
//       break;
      
//       case PERIOD_M1:
      
//          if(!first_call) return M1_result;
         
//          //Print("M1_NewCandleTime=",M1_NewCandleTime,"  CurrTime=",CurrTime);
         
//          if (M1_NewCandleTime != CurrTime) {
//              M1_NewCandleTime  = CurrTime;
//              M1_result = true;
//              //Print("M1-New-Candle");
//              return M1_result;
//          } else {M1_result = false;}
//       break;



//       default: return false;break;
//     }
   

//    return false;
// }