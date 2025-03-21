//
//
//+-----------------------------------------
// Return TRUE/FALSE when new candle appear
//+-----------------------------------------
// OnInit_OnTick_IsNewCandle(); ==> Copy to OnInit() and to OnTick 
//+-----------------------------------------



//************ SAMPLE   BELOW ***********
//+-----------------------------------------
//int OnInit() {
//   OnInit_OnTick_IsNewCandle();
//   
//   return(INIT_SUCCEEDED);
//}
////+------------------------------------------------------------------+
//
//void OnTick() {
//   OnInit_OnTick_IsNewCandle();
//
//   iLoop = iLoop + 1;
//
//   if (IsNewCandle(PERIOD_M1)) { 
//         Print("PERIOD_M1 Do something "+IntegerToString(iLoop));
//   }
//   
//   if (IsNewCandle(PERIOD_M5)) { 
//         Print("PERIOD_M5 Do something"+IntegerToString(iLoop));
//   }
//}
//+-----------------------------------------





void OnInit_OnTick_IsNewCandle() {
   IsNewCandle(PERIOD_H4 ,true);
   IsNewCandle(PERIOD_H1 ,true);
   IsNewCandle(PERIOD_M30,true);
   IsNewCandle(PERIOD_M15,true);
   IsNewCandle(PERIOD_M5 ,true);
   IsNewCandle(PERIOD_M1 ,true);
}


bool IsNewCandle(ENUM_TIMEFRAMES TimeFrame, bool first_call = false) {

   static datetime H4_NewCandleTime  = 0;
   static datetime H1_NewCandleTime  = 0;
   static datetime M30_NewCandleTime = 0;
   static datetime M15_NewCandleTime = 0;
   static datetime M5_NewCandleTime  = 0;
   static datetime M1_NewCandleTime  = 0;
   
   static bool H4_result  = false;
   static bool H1_result  = false;
   static bool M30_result = false;
   static bool M15_result = false;
   static bool M5_result  = false;
   static bool M1_result  = false;
   
   datetime CurrTime = iTime(_Symbol, TimeFrame,0);
   
   switch (TimeFrame) {
   
      case PERIOD_H4:
         if(!first_call) return H4_result;
         
         if (H4_NewCandleTime != CurrTime) {
             H4_NewCandleTime  = CurrTime;
             H4_result = true;
             return H4_result;
         } else {H4_result = false;}
      break;
      case PERIOD_H1:
         if(!first_call) return H1_result;
         
         if (H1_NewCandleTime != CurrTime) {
             H1_NewCandleTime  = CurrTime;
             H1_result = true;
             return H1_result;
         } else {H1_result = false;}
      break;
      case PERIOD_M30:
         if(!first_call) return M30_result;
         
         if (M30_NewCandleTime != CurrTime) {
             M30_NewCandleTime  = CurrTime;
             M30_result = true;
             return M30_result;
         } else {M30_result = false;}
      break;
      case PERIOD_M15:
         if(!first_call) return M15_result;
         
         if (M15_NewCandleTime != CurrTime) {
             M15_NewCandleTime  = CurrTime;
             M15_result = true;
             return M15_result;
         } else {M15_result = false;}
      break;
      case PERIOD_M5:
         if(!first_call) return M5_result;
         
         if (M5_NewCandleTime != CurrTime) {
             M5_NewCandleTime  = CurrTime;
             M5_result = true;
             return M5_result;
         } else {M5_result = false;}
      break;
      
      case PERIOD_M1:
      
         if(!first_call) return M1_result;
         
         //Print("M1_NewCandleTime=",M1_NewCandleTime,"  CurrTime=",CurrTime);
         
         if (M1_NewCandleTime != CurrTime) {
             M1_NewCandleTime  = CurrTime;
             M1_result = true;
             //Print("M1-New-Candle");
             return M1_result;
         } else {M1_result = false;}
      break;



      default: return false;break;
    }
   

   return false;
}