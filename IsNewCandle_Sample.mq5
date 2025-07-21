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
//+------------------------------------------------------------------+

      
int OnInit() {
   // OnInit_OnTick_IsNewCandle();
   OnInit_IsNewCandle();
   return(INIT_SUCCEEDED);
}

int x = 0;
ulong j = 0;

//---------------------------------+
void OnTick() {
   // OnInit_OnTick_IsNewCandle();

   // OnTick_IsNewCandle();

    j++;

   if ( IsNewCandle(PERIOD_M1) ) { 
        x++;
      Log("Tick = " + IntegerToString(j) + " ; Min-Count = " + IntegerToString(x) + " ; M1 - New Candle Detected ");
 
   }

   if ( IsNewCandle(PERIOD_M5) ) { 

      Log("Tick = " + IntegerToString(j) + " ; Min-Count = " + IntegerToString(x) + " ; M5 - New Candle Detected");
 
   }



//+--------------------------------+   
 
}

