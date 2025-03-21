#property copyright "Cloud & Apps Solutions"
#property link      "https://www.cloud-apps.ooo"
#property version   "1.00"

#include <trade/trade.mqh>

input double Lots = 1;
input int TpPoints = 450;
input int SlPoints = 100;
input int TslTriggerPoints = 10;
input int TslPoints = 10;
input int Magic = 2;
input ENUM_TIMEFRAMES Timeframe = PERIOD_M15;
input int AtrPeriods = 1;
input int RsiPeriod = 5;
input int TemaPeriods = 5;
input double TriggerFactor = 1;

int handleAtr;
int handleRsi;
int handleTema;
int barsTotal;
int maHandler;
int priceMa;
int priceRsi;
CTrade trade;

//----
int OnInit(){
     
   
    // Define the coordinates for the text label
   double x = 5;
   double y = 80;
   
   // Define the text to be displayed
   string infoText = "Eddy test information on chart!";
   
   // Create a text label on the chart
   ObjectCreate(0, "InfoLabel", OBJ_LABEL, 0, 0, 0);
   ObjectSetInteger(0, "InfoLabel", OBJPROP_XDISTANCE, x);
   ObjectSetInteger(0, "InfoLabel", OBJPROP_YDISTANCE, y);
   ObjectSetString(0, "InfoLabel", OBJPROP_TEXT, infoText);
   
   trade.SetExpertMagicNumber(Magic);
   handleTema = iTEMA(NULL,Timeframe,TemaPeriods,maHandler,priceMa);
   handleRsi = iRSI(NULL,Timeframe,RsiPeriod,priceRsi);
   handleAtr = iATR(NULL,Timeframe,AtrPeriods);
   barsTotal = iBars(NULL,Timeframe);
   
  
   // Text properties
    string text = "YOUR PROFIT TODAY: ";
    int font_size = 20;
    string font_name = "Arial";
    int x_coord = 200; // X-coordinate of the text
    int y_coord = 20; // Y-coordinate of the text
    color text_color = C'255,255,255'; // Color of the text

    // Draw text on the chart
    int text_label = ObjectCreate(0, "ColorText", OBJ_LABEL, 0, 0, 0);
    ObjectSetString(0, "ColorText", OBJPROP_TEXT, text);
    ObjectSetInteger(0, "ColorText", OBJPROP_COLOR, text_color);
    ObjectSetInteger(0, "ColorText", OBJPROP_XDISTANCE, x_coord);
    ObjectSetInteger(0, "ColorText", OBJPROP_YDISTANCE, y_coord);
    ObjectSetString(0, "ColorText", OBJPROP_FONT, font_name);
   
   
   return(INIT_SUCCEEDED);
  }

void OnDeinit(const int reason)
  {


  }

//-----
void OnTick(){
      
      
      for(int i = 0; i < PositionsTotal(); i + 1){
      ulong posTicket = PositionGetTicket(i);
      
      if(PositionGetSymbol(POSITION_SYMBOL) != _Symbol) continue;
      if(PositionGetInteger(POSITION_MAGIC) != Magic) continue;
      
      double bid = SymbolInfoDouble(_Symbol,SYMBOL_BID);
      double ask = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
      
      double posPriceOpen = PositionGetDouble(POSITION_PRICE_OPEN);
      double posSl = PositionGetDouble(POSITION_SL);
      double posTp = PositionGetDouble(POSITION_TP);
      
      if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_BUY){
         if(bid > posPriceOpen + TslTriggerPoints * _Point){
            double sl = bid - TslPoints * _Point;
            sl = NormalizeDouble(sl,_Digits);
            
            if (sl > posSl){
               //posTp = posTp + bid;
               trade.PositionModify(posTicket,sl,posTp);
            }
         }
      }else if(PositionGetInteger(POSITION_TYPE) == POSITION_TYPE_SELL){
         if(ask < posPriceOpen - TslTriggerPoints * _Point){
            double sl = ask + TslPoints * _Point;
            
            
            
            if(sl < posSl || posSl == 0){
               //posTp = posTp - bid;
               trade.PositionModify(posTicket,sl,posTp);
            }
         }
      }
   }

      
      double tema[];
      CopyBuffer(handleTema,0,1,5,tema);
      
      double rsi[];
      CopyBuffer(handleRsi,0,0,4,rsi);
      
      double atr[];
      CopyBuffer(handleAtr,0,1,1,atr);
      
      double open = iOpen(NULL,Timeframe,1);
      double close = iClose(NULL,Timeframe,1);
      
      if(rsi[3] > rsi[2] && rsi[2] > rsi[1]){
      
         double entry = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         entry = NormalizeDouble(entry,_Digits);
         double tp = entry + TpPoints * _Point;
         tp = NormalizeDouble(tp,_Digits);
         double sl = entry - SlPoints * _Point;
         sl = NormalizeDouble(sl,_Digits);
         trade.Buy(Lots,NULL,entry,sl,tp);
         
         
      }else if(rsi[3] < rsi[2] && rsi[2] < rsi[1]){

         double entry = SymbolInfoDouble(_Symbol,SYMBOL_ASK);
         entry = NormalizeDouble(entry,_Digits);
         double tp = entry - TpPoints * _Point;
         tp = NormalizeDouble(tp,_Digits);
         double sl = entry + SlPoints * _Point;
         sl = NormalizeDouble(sl,_Digits);
         trade.Sell(Lots,NULL,entry,sl,tp); 
         
      }
   }

//  || (open > close && open - close > atr[0]*TriggerFactor))
//  || (open < close && close - open > atr[0]*TriggerFactor))

// tema[0] > tema[1] && tema[1] > tema[2] && tema[2] > tema[3] && 
// tema[0] < tema[1] && tema[1] < tema[2] && tema[2] < tema[3] && 
//  && atr[3] > 0.23

// }else if(rsi[3] < rsi[2] && rsi[2] < rsi[1]){
// if(rsi[3] > rsi[2] && rsi[2] > rsi[1]){