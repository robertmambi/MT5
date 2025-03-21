//+------------------------------------------------------------------+
//|                                                    BreakEven.mqh |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property strict
//+------------------------------------------------------------------+

//+---------------------------------------------+
//| Return (TRUE/FALSE)  When SMA Crossing      |
//+---------------------------------------------+

string SMA_Crossing(
      int ma_period_1 = 6,
      int ma_period_2 = 16,
      ENUM_TIMEFRAMES TimeFrame = PERIOD_M5,
      string strTrend = "null")
{

   if(StringCompare(strTrend,"buy",false) == 0) 
   {
      return(iMA(Symbol(), TimeFrame, ma_period_1, 0, MODE_SMA, PRICE_OPEN, 0) > iMA(Symbol(), TimeFrame, ma_period_2, 0, MODE_SMA, PRICE_OPEN, 0));
   } else {
      return(iMA(Symbol(), TimeFrame, ma_period_1, 0, MODE_SMA, PRICE_OPEN, 0) < iMA(Symbol(), TimeFrame, ma_period_2, 0, MODE_SMA, PRICE_OPEN, 0));
   }
}
