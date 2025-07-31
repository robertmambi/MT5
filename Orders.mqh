#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"



int CountTrades (int type = -1, string symbol = NULL, ulong magicNumber = 0)
{
   int count = 0;
   int total = PositionsTotal();

   for (int i = 0; i < total; i++)
   {
      if (PositionGetTicket(i))
      {
         string pos_symbol = PositionGetString(POSITION_SYMBOL);
         int pos_type      = (int)PositionGetInteger(POSITION_TYPE);
         ulong pos_magic   = (ulong)PositionGetInteger(POSITION_MAGIC);

         bool symbol_match = (symbol == NULL || symbol == pos_symbol);
         bool type_match   = (type == -1 || type == pos_type);
         bool magic_match  = (magicNumber == 0 || magicNumber == pos_magic);

         if (symbol_match && type_match && magic_match)
            count++;
      }
   }
   return count;
}


void GetCurrentPrice(double &price, datetime &tickTime, bool getAsk = false)
{
   MqlTick tick;
   if (!SymbolInfoTick(_Symbol, tick))
   {
      Print("Error getting tick data for symbol ", _Symbol, ": ", GetLastError());
      price = EMPTY_VALUE;
      tickTime = 0;
      return;
   }

   price = getAsk ? tick.ask : tick.bid;
   tickTime = tick.time;
}

