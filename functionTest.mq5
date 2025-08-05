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
   Log("############################################################################");
   Log("Version 2.0.6");
   Log("############################################################################");
   OnInit_IsNewCandle();
   return(INIT_SUCCEEDED);
}


int x = 0;
ulong j = 0;

//---------------------------------+

// UP
bool AllUP = false;
double PriceUP    = 0;
datetime TimeUP;
//bool TrendingUP   = false;
bool CheckMaUP    = false;
bool CheckMASlUP  = false;
static bool EntryPointUP = false;

// DW
bool AllDW = false;
double PriceDW    = 0;
datetime TimeDW;
//bool TrendingDW   = false;
bool CheckMaDW    = false;
bool CheckMASlDW  = false;
static bool EntryPointDW = false;

// Both
int BuySell = 0;
bool OpenOrders = false;


void OnTick() {

   OpenOrders   = false;
   
//   TrendingUP   = false;
//   CheckMaUP    = false;
//
//   TrendingDW   = false;
//   CheckMaDW    = false;

   double OCHLopen  = 0;
   double OCHLclose = 0;
   double OCHLhigh  = 0;
   double OCHLlow   = 0;

   GetCandleOCHL(PERIOD_M1,OCHLopen,OCHLclose,OCHLhigh,OCHLlow);
   
   //UP    
   if (!EntryPointUP) {
      EntryPointUP =  ((OCHLlow-1) < GetMACurrentValue(Global_ma0, PERIOD_M5)) && (OCHLopen > OCHLclose);
      
      if(EntryPointUP) {
         //BuySell=1;
         Log("BuySell=1:Open/Close=" + DoubleToString(OCHLopen,2) + "/" + DoubleToString(OCHLclose,2));
      }
     }
     
   //DW
   if (!EntryPointDW) {      
      EntryPointDW =    ((OCHLhigh+1) > GetMACurrentValue(Global_ma0, PERIOD_M5))
                    &&  (OCHLopen < OCHLclose);
      if(EntryPointDW) {
         //BuySell=2; 
         Log("BuySell=2:Open/Close=" + DoubleToString(OCHLopen,2) + "/" + DoubleToString(OCHLclose,2));
        }
   }
   
    
  

      j++;
   
   if ( IsNewCandle(PERIOD_M1) ) {
   
      x++;   
      
      CheckMASlUP = CheckMASlope(20, PERIOD_M5, "UP",  0, 5, 1);
      CheckMASlDW = CheckMASlope(20, PERIOD_M5, "DW",  0, 5, 1);
      CheckMaDW  =  CheckMAConditions(PERIOD_M5, "DW");
      CheckMaUP  =  CheckMAConditions(PERIOD_M5, "UP");
      OpenOrders = (CountTrades() == 0);


      //AllUP = EntryPointUP && TrendingUP && CheckMaUP && OpenOrders;
      //AllDW = EntryPointDW && TrendingDW && CheckMaDW && OpenOrders;
      
//      Log("TrendingUp=" + TrendingUp);
//      Log("CheckMaUp=" + CheckMaUp);
//      Log("OpenOrders=" + OpenOrders);
//      Log("BuySell=" + BuySell);
//      
//      Log("PriceUp=" + PriceUp);
//      Log("GetMACurrentValue-ma0=" + GetMACurrentValue(Global_ma0, PERIOD_M1));
//      Log("GetMACurrentValue-ma2=" + GetMACurrentValue(Global_ma2, PERIOD_M1));





      //AllUP =  CheckMaUP && OpenOrders && EntryPointUP && CheckMASlUP;
      //AllDW =  CheckMaDW && OpenOrders && EntryPointDW && CheckMASlD 
      
      AllUP =  CheckMaUP && OpenOrders && EntryPointUP && CheckMASlUP;
      AllDW =  CheckMaDW && OpenOrders && EntryPointDW && CheckMASlDW;
            
      if(AllUP) {
      
         double   buy_price   = 0;
         double   sell_price  = 0;
         datetime buy_time = NULL;
         GetCurrentPrice(buy_price,sell_price,buy_time);
         PlaceArrow(buy_time, buy_price, true) ;
         
         //datetime buy_time =;
         Log("---------------------------------------");      
         Log("BUY - BUY - BUY - BUY - BUY - BUY - BUY");
         Log("---------------------------------------");         
         OpenOrder(ORDER_TYPE_BUY);
      }
      
      if(AllDW) {
      
         double   buy_price   = 0;
         double   sell_price  = 0;         
         datetime buy_time = NULL;
         GetCurrentPrice(buy_price,sell_price,buy_time);
         PlaceArrow(buy_time, buy_price, false) ;
         
         //datetime buy_time =;
         Log("---------------------------------------");      
         Log("SELL - SELL - SELL- SELL - SELL - SELL - SELL");
         Log("---------------------------------------");         
         OpenOrder(ORDER_TYPE_SELL);
      }

      //Log("Ticket = " + IntegerToString(j) + " M1-Loop=" + IntegerToString(x));
      //Log("CountTrades = " + IntegerToString(CountTrades()));
      //Log("BuySell = " + IntegerToString(BuySell));     
      //Log("CheckMAConditions M1= " + CheckMAConditions(PERIOD_M1));
      //Log("IsTrending_M_1_5_15_30 = " + IsTrending_M_1_5_15_30());
      //Log(
      //     BoolToUpDown(IsTrending(_Symbol, PERIOD_M1))  + " "
      //   + BoolToUpDown(IsTrending(_Symbol, PERIOD_M5))  + " "
      //   + BoolToUpDown(IsTrending(_Symbol, PERIOD_M15)) + " "
      //   + BoolToUpDown(IsTrending(_Symbol, PERIOD_M30))
      //   );
         
      BuySell = 0; 
      EntryPointDW = false;
      EntryPointUP = false;      
    }

   //if ( IsNewCandle(PERIOD_M15) ) {
   //   Log("############-----------M5----------############");
   //   MoveStopLossToParabolicSAR();
   //   Log("-----------M5----------");
   //}

   if ( IsNewCandle(PERIOD_M15) ) {
      Log("M15 -- MoveStopLossToBreakEven ---------------------############");
      MoveStopLossToBreakEven();
      Log("-----------M15----------");
   }
}

