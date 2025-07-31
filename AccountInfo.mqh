#property copyright "Copyright 2023, MetaQuotes Ltd."
#property link      "https://www.mql5.com"
#property version   "1.00"


double CalculateLotSize(double stopLossPoints, double riskPercent = 1.0)
{
   // 1. Get account balance
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);

   // 2. Calculate money to risk (e.g. 1% of balance)
   double riskMoney = balance * riskPercent / 100.0;

   // 3. Get symbol properties
   double tickSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE);
   double tickValue = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE);
   double contractSize = SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE);

   // 4. Calculate value per point per lot
   double pointValuePerLot = (tickValue / tickSize);

   // 5. Total risk in points
   double totalLossPerLot = stopLossPoints * pointValuePerLot;

   if (totalLossPerLot <= 0)
   {
      Print("Invalid loss calculation. Check tickSize and tickValue.");
      return 0;
   }

   // 6. Calculate and return lot size
   double lots = riskMoney / totalLossPerLot;

   // Round to nearest minimal lot step
   double minLot = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN);
   double lotStep = SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP);
   lots = MathFloor(lots / lotStep) * lotStep;
   lots = MathMax(lots, minLot);

   return NormalizeDouble(lots, _Digits);  // 2 digits precision for lot size
}





void Info() 
  { 
//--- Show all the information available from the function AccountInfoDouble() 
   printf("ACCOUNT_BALANCE =  %G",AccountInfoDouble(ACCOUNT_BALANCE)); 
   printf("ACCOUNT_CREDIT =  %G",AccountInfoDouble(ACCOUNT_CREDIT)); 
   printf("ACCOUNT_PROFIT =  %G",AccountInfoDouble(ACCOUNT_PROFIT)); 
   printf("ACCOUNT_EQUITY =  %G",AccountInfoDouble(ACCOUNT_EQUITY)); 
   printf("ACCOUNT_MARGIN =  %G",AccountInfoDouble(ACCOUNT_MARGIN)); 
   printf("ACCOUNT_MARGIN_FREE =  %G",AccountInfoDouble(ACCOUNT_MARGIN_FREE)); 
   printf("ACCOUNT_MARGIN_LEVEL =  %G",AccountInfoDouble(ACCOUNT_MARGIN_LEVEL)); 
   printf("ACCOUNT_MARGIN_SO_CALL = %G",AccountInfoDouble(ACCOUNT_MARGIN_SO_CALL)); 
   printf("ACCOUNT_MARGIN_SO_SO = %G",AccountInfoDouble(ACCOUNT_MARGIN_SO_SO));
   
   
   Print("TickSize     = ",SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_SIZE));
   Print("TickValue    = ",SymbolInfoDouble(_Symbol, SYMBOL_TRADE_TICK_VALUE));
   Print("ContractSize = ",SymbolInfoDouble(_Symbol, SYMBOL_TRADE_CONTRACT_SIZE));
   Print("MinLot       = ",SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_MIN));
   Print("LotStep      = ",SymbolInfoDouble(_Symbol, SYMBOL_VOLUME_STEP));
   
  }
  