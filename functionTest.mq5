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
#include "Orders.mqh";
#include "DirectionByCandle.mqh";
#include "AccountInfo.mqh"

//+------------------------------------------------------------------+
//+------------------------------------------------------------------+

int OnInit() {
   OnInit_IsNewCandle();
   return(INIT_SUCCEEDED);
}


int x = 0;
ulong j = 0;

//---------------------------------+

// UP
double PriceUP    = 0;
datetime TimeUP;
bool TrendingUP   = false;
bool CheckMaUP    = false;
bool EntryPointUP = false;

// DW
double PriceDW    = 0;
datetime TimeDW;
bool TrendingDW   = false;
bool CheckMaDW    = false;
bool EntryPointDW = false;

// Both
int BuySell = 0;
bool OpenOrders = false;


void OnTick() {

   OpenOrders   = false;
   
   TrendingUP   = false;
   CheckMaUP    = false;
   EntryPointUP = false;

   TrendingDW   = false;
   CheckMaDW    = false;
   EntryPointDW = false;



   if (BuySell == 0) {

      //UP   
      GetCurrentPrice(PriceUP,TimeUP,true);
      EntryPointUP =     (PriceUP < GetMACurrentValue(Global_ma0, PERIOD_M1))
                    &&  (PriceUP > GetMACurrentValue(Global_ma2, PERIOD_M1));
      if(EntryPointUP) BuySell=1;
      
      //DW
      GetCurrentPrice(PriceDW,TimeDW,false);
      EntryPointDW =     (PriceDW > GetMACurrentValue(Global_ma0, PERIOD_M1))
                    &&  (PriceDW < GetMACurrentValue(Global_ma2, PERIOD_M1));
      if(EntryPointDW) BuySell=2;      
      
   }

      j++;
   
   if ( IsNewCandle(PERIOD_M1) ) {
   
      x++;   
      

      Log("Tick"+IntegerToString(j)+"M1-"+IntegerToString(x) + " ==================================================================");


      TrendingDW =    (BoolToUpDown(IsTrending(_Symbol, PERIOD_M1)) == "DW")
                   && (BoolToUpDown(IsTrending(_Symbol, PERIOD_M5)) == "DW");
      CheckMaDW  = (CheckMAConditions(PERIOD_M1) == "DW");
      
      TrendingUP =    (BoolToUpDown(IsTrending(_Symbol, PERIOD_M1)) == "UP")
                   && (BoolToUpDown(IsTrending(_Symbol, PERIOD_M5)) == "UP");
      CheckMaUP  = (CheckMAConditions(PERIOD_M1) == "UP");      OpenOrders = (CountTrades() == 0);
      
//      Log("TrendingUp=" + TrendingUp);
//      Log("CheckMaUp=" + CheckMaUp);
//      Log("OpenOrders=" + OpenOrders);
//      Log("BuySell=" + BuySell);
//      
//      Log("PriceUp=" + PriceUp);
//      Log("GetMACurrentValue-ma0=" + GetMACurrentValue(Global_ma0, PERIOD_M1));
//      Log("GetMACurrentValue-ma2=" + GetMACurrentValue(Global_ma2, PERIOD_M1));
      
      if( (BuySell == 1) && TrendingUP && CheckMaUP && OpenOrders) {
      
         double   buy_price  = 0;
         datetime buy_time = NULL;
         GetCurrentPrice(buy_price,buy_time,true);
         PlaceArrow(buy_time, buy_price, true) ;
         
         //datetime buy_time =;
         Log("---------------------------------------");      
         Log("BUY - BUY - BUY - BUY - BUY - BUY - BUY");
         Log("---------------------------------------");         
         
      }
      
      if( (BuySell == 2) && TrendingDW && CheckMaDW && OpenOrders) {
      
         double   buy_price  = 0;
         datetime buy_time = NULL;
         GetCurrentPrice(buy_price,buy_time,false);
         PlaceArrow(buy_time, buy_price, false) ;
         
         //datetime buy_time =;
         Log("---------------------------------------");      
         Log("SELL - SELL - SELL- SELL - SELL - SELL - SELL");
         Log("---------------------------------------");         
         
      }

      Log("Ticket = " + IntegerToString(j) + " M1-Loop=" + IntegerToString(x));
      Log("CountTrades = " + IntegerToString(CountTrades()));
      Log("BuySell = " + BuySell);     
      Log("CheckMAConditions M1= " + CheckMAConditions(PERIOD_M1));
      Log("IsTrending_M_1_5_15_30 = " + IsTrending_M_1_5_15_30());
      Log(
           BoolToUpDown(IsTrending(_Symbol, PERIOD_M1))  + " "
         + BoolToUpDown(IsTrending(_Symbol, PERIOD_M5))  + " "
         + BoolToUpDown(IsTrending(_Symbol, PERIOD_M15)) + " "
         + BoolToUpDown(IsTrending(_Symbol, PERIOD_M30))
         );
         
      if(BuySell == 1) BuySell = 0;
      if(BuySell == 2) BuySell = 0;        
    }
}

