//+------------------------------------------------------------------+
//|                                                 FunctionTest.mq5 |
//|                                  Copyright 2023, MetaQuotes Ltd. |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"


#include "IsNewCandle.mqh";
#include "common.mqh";
#include "maCrossing.mqh";

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+


      
int OnInit() {
   OnInit_OnTick_IsNewCandle();
   return(INIT_SUCCEEDED);
}

int x = 0;

//---------------------------------+
void OnTick() {
   OnInit_OnTick_IsNewCandle();


   if ( IsNewCandle(PERIOD_M5) ) { 

      string crossover = maCrossing(20,50);
      
      if(crossover == "UP" || crossover == "DOWN") Log("MA Crossover detected");
 
   }





//+--------------------------------+   
 
}












////+----------------------------------------------+
//// check Target bars from a trackedBatTime;
////+----------------------------------------------+

//
//input int BarToTrack = 1;
//
//datetime trackedBarTime;
//
//void OnInit()
//{
//   OnInit_OnTick_IsNewCandle();
//   
//      trackedBarTime = iTime(_Symbol, PERIOD_CURRENT, BarToTrack);
//      Print("Tracking bar with open time: ", TimeToString(trackedBarTime));
//}


//

//void OnTick()
//{
//
//   OnInit_OnTick_IsNewCandle();
//   
//  if (IsNewCandle(PERIOD_M1)) {
//  
//   Sleep(3);
//   
//      datetime timeArray[];
//      //int totalBars = Bars(_Symbol, PERIOD_CURRENT);
//      int BarsCount = Bars(_Symbol, PERIOD_CURRENT,trackedBarTime,TimeCurrent());
//      int IndexHighest = iHighest(_Symbol,PERIOD_CURRENT,MODE_CLOSE,BarsCount,1);
//      double IndexHighestPrice = iHigh(_Symbol,PERIOD_CURRENT,IndexHighest);
//
//       Log("trackedBarTime=" + TimeToString(iTime(_Symbol, PERIOD_CURRENT, IndexHighest)) + " BarsCount=" + IntegerToString(BarsCount));
//       Log("IndexHighest=" + IntegerToString(IndexHighest) + " IndexHighestPrice=" + DoubleToString(IndexHighestPrice,2));
//     
//      //int copied = CopyTime(_Symbol, PERIOD_CURRENT, 0, totalBars, timeArray);
//      
//      //if(copied > 0)
//      //{
//      //   int barIndex = ArrayBsearch(timeArray, trackedBarTime);
//      //   if(barIndex >= 0 && barIndex < copied && timeArray[barIndex] == trackedBarTime)
//      //   {
//      //      double closePrice = iClose(_Symbol, PERIOD_CURRENT, barIndex);
//      //      Log("Tracked bar (time: "+ TimeToString(trackedBarTime) + " ) is now at index " + IntegerToString(barIndex) + ", Close price: " + DoubleToString(closePrice, 5));
//      //   }
//      //   else
//      //   {
//      //      Log("Tracked bar not found in current history.");
//      //   }
//      //}
//   }
//}