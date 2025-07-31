#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"





//##################################################################





void Log(string message = NULL) {
   Print(TimeToString(TimeCurrent(), TIME_DATE|TIME_MINUTES|TIME_SECONDS),": ",message);
}

string BoolToString(bool value) {
   return value ? "true" : "false";
}

string BoolToUpDown(bool value) {
   return value ? "UP" : "DW";
}

void PlaceArrow(datetime time, double price, bool isBullish) {

   string objName = "Arrow_" + TimeToString(time, TIME_MINUTES|TIME_SECONDS);
   
   if(!ObjectCreate(0, objName, OBJ_ARROW, 0, time, price))
   {
      Print("Failed to create arrow: ", GetLastError());
      return;
   }

   if(isBullish) {
      ObjectSetInteger(0, objName, OBJPROP_ARROWCODE, 233); // Up arrow
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clrMintCream);
      ObjectSetDouble (0, objName, OBJPROP_PRICE, price + 10 * Point());
   } else {
      ObjectSetInteger(0, objName, OBJPROP_ARROWCODE, 234); // Down arrow
      ObjectSetInteger(0, objName, OBJPROP_COLOR, clrPink);
      ObjectSetDouble(0, objName, OBJPROP_PRICE, price - 10 * Point());
   }

   ObjectSetInteger(0, objName, OBJPROP_WIDTH, 2);
   ObjectSetInteger(0, objName, OBJPROP_ANCHOR, ANCHOR_CENTER);
}


