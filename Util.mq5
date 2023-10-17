bool isNumberStrict(string s){
   if (StringLen(s) == 0)
      return false;
   return isNumber(s);
}

bool isNumber(string s){
  for(int iPos = StringLen(s) - 1; iPos >= 0; iPos--){
     int c = StringGetCharacter(s, iPos);
     if( (c < '0' || c > '9') && c != '.' && c != '-') return false;
  }
  return true;
}

bool isNumberCheckForEdits(CEdit *edit) {
   string currentRisk = edit.Text();
   if(isNumber(currentRisk)) {
      edit.ColorBackground(CONTROLS_EDIT_COLOR_BG);
      return true;
   }
   else {
      edit.ColorBackground(clrRed);
      return false;
   }
}



void createPriceLine(string name, double price, int lineColor) {
   ObjectCreate(0, name, OBJ_HLINE, 0, 0,price);
   ObjectSetInteger(0, name, OBJPROP_COLOR, lineColor);
   ObjectSetInteger(0, name, OBJPROP_STYLE, STYLE_DASH);
   ObjectSetInteger(0, name, OBJPROP_BACK, true);
}


void deleteAllCreatedChartObjects() {
   ObjectDelete(0, "pendingPriceEntryLine");
   ObjectDelete(0, "slPrice");
   ObjectDelete(0, "tpPrice0");
   ObjectDelete(0, "tpPrice1");
   ObjectDelete(0, "tpPrice2");
   ObjectDelete(0, "tpPrice3");
   
   ObjectDelete(0, "updateSlPrice");
   ObjectDelete(0, "pyramidTp0");
   ObjectDelete(0, "pyramidTp1");   
}

void placeOrder(ENUM_TRADE_REQUEST_ACTIONS orderOperation, ENUM_ORDER_TYPE orderType, double price, double volume, double slPrice, double tpPrice) {
   MqlTradeRequest request={};
   MqlTradeResult result={};
   request.action = orderOperation;
   request.symbol = Symbol();
   request.volume = volume;
   request.type = orderType;
   request.price = price;
   request.sl = slPrice;
   request.tp = tpPrice;
   request.deviation = 10;
   request.type_filling = ORDER_FILLING_FOK;   

   if(!OrderSendAsync(request,result))
      PrintFormat("OrderSend ERROR %d",GetLastError());     // if unable to send the request, output the error code
   // information about the operation
   PrintFormat("OrderSend OK retcode=%u  deal=%I64u  order=%I64u", result.retcode, result.deal, result.order);
}

double getRiskInMoney(double volume, double slPoints){
   double pointValue=(((SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE))*Point())/(SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE)));
   double moneyAtRisk = volume * slPoints * pointValue;
   return moneyAtRisk;
}

double getRiskInMoney(double totalRiskInPercent){
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   double totalRiskDouble = totalRiskInPercent/100;
   double moneyAtRisk = balance * totalRiskDouble;
   return moneyAtRisk;
}

double getLots(double totalRiskInPercent, double slPoints) {
   double moneyAtRisk = getRiskInMoney(totalRiskInPercent);

   double pointValue=(((SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_VALUE))*Point())/(SymbolInfoDouble(Symbol(),SYMBOL_TRADE_TICK_SIZE)));

   double totalLots=moneyAtRisk/(pointValue*slPoints);
         
   totalLots=floor(totalLots*100)/100;
   return totalLots;
}
