#property copyright "xAI"
#property link      "https://www.xai.com"
#property version   "1.00"
#property indicator_separate_window
#property indicator_buffers 2
#property indicator_plots   2

// Plot RSI
#property indicator_label1  "RSI"
#property indicator_type1   DRAW_LINE
#property indicator_color1  clrDodgerBlue
#property indicator_style1  STYLE_SOLID
#property indicator_width1  1

// Plot RSI MA
#property indicator_label2  "RSI_MA"
#property indicator_type2   DRAW_LINE
#property indicator_color2  clrRed
#property indicator_style2  STYLE_SOLID
#property indicator_width2  1

// Input parameters
input int InpRSIPeriod = 14;    // RSI Period
input int InpMAPeriod  = 9;     // MA Period

// Indicator buffers
double RSIBuffer[];
double RSI_MA_Buffer[];

// Global variables
int rsi_handle;

//+------------------------------------------------------------------+
//| Custom indicator initialization function                         |
//+------------------------------------------------------------------+
int OnInit()
{
   // Set indicator buffers
   SetIndexBuffer(0, RSIBuffer, INDICATOR_DATA);
   SetIndexBuffer(1, RSI_MA_Buffer, INDICATOR_DATA);
   
   // Create RSI handle
   rsi_handle = iRSI(_Symbol, _Period, InpRSIPeriod, PRICE_CLOSE);
   if(rsi_handle == INVALID_HANDLE)
   {
      Print("Error creating RSI indicator");
      return(INIT_FAILED);
   }
   
   // Set indicator properties
   IndicatorSetString(INDICATOR_SHORTNAME, "RSI_MA(" + string(InpRSIPeriod) + "," + string(InpMAPeriod) + ")");
   IndicatorSetInteger(INDICATOR_LEVELS, 2);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 0, 30);
   IndicatorSetDouble(INDICATOR_LEVELVALUE, 1, 70);
   IndicatorSetDouble(INDICATOR_MINIMUM, 0);
   IndicatorSetDouble(INDICATOR_MAXIMUM, 100);
   
   return(INIT_SUCCEEDED);
}

//+------------------------------------------------------------------+
//| Custom indicator deinitialization function                       |
//+------------------------------------------------------------------+
void OnDeinit(const int reason)
{
   if(rsi_handle != INVALID_HANDLE)
      IndicatorRelease(rsi_handle);
}

//+------------------------------------------------------------------+
//| Custom indicator calculation function                            |
//+------------------------------------------------------------------+
int OnCalculate(const int rates_total,
                const int prev_calculated,
                const int begin,
                const double &price[])
{
   // Check if we have enough bars
   if(rates_total < InpRSIPeriod + InpMAPeriod) return(0);
   
   // Copy RSI values
   int to_copy = (prev_calculated == 0) ? rates_total : rates_total - prev_calculated + 1;
   if(CopyIndicatorBuffer(rsi_handle, 0, 0, to_copy, RSIBuffer) <= 0)
   {
      Print("Error copying RSI buffer");
      return(0);
   }
   
   // Calculate Moving Average of RSI
   for(int i = MathMax(InpMAPeriod-1, prev_calculated); i < rates_total; i++)
   {
      double sum = 0.0;
      for(int j = 0; j < InpMAPeriod; j++)
      {
         sum += RSIBuffer[i-j];
      }
      RSI_MA_Buffer[i] = sum / InpMAPeriod;
   }
   
   return(rates_total);
}

//+------------------------------------------------------------------+
//| Helper function to copy indicator buffer                         |
//+------------------------------------------------------------------+
int CopyIndicatorBuffer(int handle, int buffer_num, int start_pos, int count, double &buffer[])
{
   return CopyBuffer(handle, buffer_num, start_pos, count, buffer);
}