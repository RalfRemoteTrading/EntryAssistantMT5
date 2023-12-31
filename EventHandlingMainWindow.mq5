#include <Trade\PositionInfo.mqh>
#include <Trade\Trade.mqh>

#include "CAppWindowEntryAssistant.mqh"
#include "PartialRow.mqh"
#include "Util.mq5"

#include <Controls\Defines.mqh>

EVENT_MAP_BEGIN(CAppWindowEntryAssistant)
ON_EVENT(ON_CLICK, buttonClearFields, OnClickButtonClearFields)
ON_EVENT(ON_CHANGE, pendingOrderCheckBox, OnChangePendingOrderCheckBox)
ON_EVENT(ON_END_EDIT, pendingPriceEdit, OnEndEditPendingPriceEdit)
ON_EVENT(ON_CLICK, buttonSetPendingOrderPrice, memoryButtonStore.OnClickButtonSetPendingOrderPrice)
ON_EVENT(ON_CLICK, setSlButton, memoryButtonStore.OnClickSetSlButton)
ON_EVENT(ON_END_EDIT, totalRiskTextEdit, OnEndEditTotalRiskTextEdit)
ON_EVENT(ON_END_EDIT, slPriceEdit, OnEndEditSlPriceEdit)
ON_EVENT(ON_CLICK, increaseRiskButton, OnClickIncreaseRiskButton)
ON_EVENT(ON_CLICK, reduceRiskButton, OnClickReduceRiskButton)

ON_EVENT(ON_CLICK, partialRow0.setTpButton, memoryButtonStore.OnClickSetTp0)
ON_EVENT(ON_CLICK, partialRow1.setTpButton, memoryButtonStore.OnClickSetTp1)
ON_EVENT(ON_CLICK, partialRow2.setTpButton, memoryButtonStore.OnClickSetTp2)
ON_EVENT(ON_CLICK, partialRow3.setTpButton, memoryButtonStore.OnClickSetTp3)

ON_EVENT(ON_CLICK, executionArea.placeLongButton, OnClickPlaceLong)
ON_EVENT(ON_CLICK, executionArea.placeShortButton, OnClickPlaceShort)
EVENT_MAP_END(CAppDialog);





void CAppWindowEntryAssistant::OnChangePendingOrderCheckBox(void) {
   if(!pendingOrderCheckBox.Checked()){
      pendingPriceEdit.Hide();
      buttonSetPendingOrderPrice.Hide();
      buttonSetPendingOrderPrice.Disable();      
      ObjectDelete(0, "pendingPriceEntryLine");
   }
   else {
      pendingPriceEdit.Show();
      buttonSetPendingOrderPrice.Show();
      buttonSetPendingOrderPrice.Enable();
      if(isNumberStrict(StringToDouble(pendingPriceEdit.Text()))){      
         createPriceLine("pendingPriceEntryLine", StringToDouble(pendingPriceEdit.Text()), clrOrange);
      }
   }
   updatesSLPoints();
   partialRow0.updateTpPoints();
   partialRow1.updateTpPoints();
   partialRow2.updateTpPoints();
   partialRow3.updateTpPoints();
   updateRisk();
}

void CAppWindowEntryAssistant::OnEndEditPendingPriceEdit(void) {
   isNumberCheckForEdits(&pendingPriceEdit);
   updatesSLPoints();
   partialRow0.updateTpPoints();
   partialRow1.updateTpPoints();
   partialRow2.updateTpPoints();
   partialRow3.updateTpPoints();
   updateRisk();
}

void CAppWindowEntryAssistant::OnEndEditSlPriceEdit(void) {
   isNumberCheckForEdits(&slPriceEdit);
   updatesSLPoints();
   partialRow0.updateTpPoints();
   partialRow1.updateTpPoints();
   partialRow2.updateTpPoints();
   partialRow3.updateTpPoints();
   updateRisk();
}



void CAppWindowEntryAssistant::OnClickButtonClearFields(void) {
   deleteAllCreatedChartObjects();
   pendingPriceEdit.Text("");
   slPriceEdit.Text("");
   slPointsEdit.Text("");
   partialRow0.reset();
   partialRow1.reset();
   partialRow2.reset();
   partialRow3.reset();
}

void CAppWindowEntryAssistant::OnEndEditTotalRiskTextEdit(void) {
   isNumberCheckForEdits(&totalRiskTextEdit);
   updateRisk();
}

void CAppWindowEntryAssistant::OnClickIncreaseRiskButton(void) {
   string currentRisk = totalRiskTextEdit.Text();
   if(isNumber(currentRisk)) {
      // TODO take from params
      double newRisk = StringToDouble(currentRisk) + 0.05;
      totalRiskTextEdit.Text(DoubleToString(newRisk, 2));
      updateRisk();
   }
}

void CAppWindowEntryAssistant::OnClickReduceRiskButton(void) {
   string currentRisk = totalRiskTextEdit.Text();
   if(isNumber(currentRisk)) {
      // TODO take from params
      double newRisk = StringToDouble(currentRisk) - 0.05;
      if (newRisk > 0)
         totalRiskTextEdit.Text(DoubleToString(newRisk, 2));
      updateRisk();
   }
}


void CAppWindowEntryAssistant::OnClickPlaceLong(void) {
   bool foundIssue = false;

   if(pendingOrderCheckBox.Checked()){
      isNumberCheckForEdits(&pendingPriceEdit);
      if(!isNumberStrict(StringToDouble(pendingPriceEdit.Text()))) {
         pendingPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }

   isNumberCheckForEdits(&slPriceEdit);
   if(StringToInteger(slPointsEdit.Text()) >= 0) {
      slPriceEdit.ColorBackground(clrRed);
      foundIssue = true;
   }
   
   double partial0Size = 0;
   isNumberCheckForEdits(&partialRow0.exitPriceEdit);
   string partial0PointsText = partialRow0.exitPointsEdit.Text();
   if(StringCompare(partial0PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow0.exitPointsEdit.Text()) <= 0) {
         partialRow0.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }   
      isNumberCheckForEdits(&partialRow0.percentOfPartialEdit);      
      partial0Size = StringToInteger(partialRow0.percentOfPartialEdit.Text());
      double remainderPartial0 = MathMod(partial0Size, positionSplitinPercent);
      if (remainderPartial0 != 0) {
         partialRow0.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
         
   
   double partial1Size = 0;
   isNumberCheckForEdits(&partialRow1.exitPriceEdit);
   string partial1PointsText = partialRow1.exitPointsEdit.Text();
   if(StringCompare(partial1PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow1.exitPointsEdit.Text()) <= 0) {
         partialRow1.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
      isNumberCheckForEdits(&partialRow1.percentOfPartialEdit);
      partial1Size = StringToInteger(partialRow1.percentOfPartialEdit.Text());
      double remainderPartial1 = MathMod(partial1Size, positionSplitinPercent);
      if (remainderPartial1 != 0){
         partialRow1.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   
   double partial2Size = 0;
   isNumberCheckForEdits(&partialRow2.exitPriceEdit);
   string partial2PointsText = partialRow2.exitPointsEdit.Text();
   if(StringCompare(partial2PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow2.exitPointsEdit.Text()) <= 0) {
         partialRow2.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
      isNumberCheckForEdits(&partialRow2.percentOfPartialEdit);
      partial2Size = StringToInteger(partialRow2.percentOfPartialEdit.Text());
      double remainderPartial2 = MathMod(partial2Size, positionSplitinPercent);
      if (remainderPartial2 != 0){
         partialRow2.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   
   double partial3Size = 0;
   isNumberCheckForEdits(&partialRow3.exitPriceEdit);
   string partial3PointsText = partialRow3.exitPointsEdit.Text();
   if(StringCompare(partial3PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow3.exitPointsEdit.Text()) <= 0) {
         partialRow3.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
      isNumberCheckForEdits(&partialRow3.percentOfPartialEdit);
      partial3Size = StringToInteger(partialRow3.percentOfPartialEdit.Text());
      double remainderPartial3 = MathMod(partial3Size, positionSplitinPercent);
      if (remainderPartial3 != 0){
         partialRow3.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }

   if (foundIssue)
      return;
   
   deleteAllCreatedChartObjects();
   ENUM_TRADE_REQUEST_ACTIONS orderOperation = TRADE_ACTION_DEAL;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_BUY;
   double price = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   
   if (pendingOrderCheckBox.Checked()) {
      orderOperation = TRADE_ACTION_PENDING;
      price = StringToDouble(pendingPriceEdit.Text());
      
      if (SymbolInfoDouble(Symbol(), SYMBOL_ASK) < price)
         orderType = ORDER_TYPE_BUY_STOP;
      else
         orderType = ORDER_TYPE_BUY_LIMIT;
   }
   
   
   double totalLots = StringToDouble(totalRiskInLotsLabel.Text());
   double splitLots = StringToDouble(DoubleToString(totalLots/positionSplitinPercent, 2));
   
   double partialPercentSum = partial0Size + partial1Size + partial2Size + partial3Size;
      
   if(partialPercentSum > 0) {
      int partial0NPositions = (int) MathRound((partial0Size / partialPercentSum)*100 / positionSplitinPercent);
      int partial1NPositions = (int) MathRound((partial1Size  / partialPercentSum)*100 / positionSplitinPercent);
      int partial2NPositions = (int) MathRound((partial2Size  / partialPercentSum)*100 / positionSplitinPercent);
      int partial3NPositions = (int) MathRound((partial3Size  / partialPercentSum)*100 / positionSplitinPercent);
      
      for(int i=0; i<partial0NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow0.exitPriceEdit.Text()));
      for(int i=0; i<partial1NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow1.exitPriceEdit.Text()));
      for(int i=0; i<partial2NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow2.exitPriceEdit.Text()));
      for(int i=0; i<partial3NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow3.exitPriceEdit.Text()));
   }
   else {
      int nPositionsNoTp = 100/positionSplitinPercent;
      for(int i=0; i<nPositionsNoTp; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow0.exitPriceEdit.Text()));
   }
   
}

void CAppWindowEntryAssistant::OnClickPlaceShort(void) {
   bool foundIssue = false;

   if(pendingOrderCheckBox.Checked()){
      isNumberCheckForEdits(&pendingPriceEdit);
      if(!isNumberStrict(StringToDouble(pendingPriceEdit.Text()))) {
         pendingPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }

   isNumberCheckForEdits(&slPriceEdit);
   if(StringToInteger(slPointsEdit.Text()) <= 0) {
      slPriceEdit.ColorBackground(clrRed);
      foundIssue = true;
   }
   
   double partial0Size = 0;
   isNumberCheckForEdits(&partialRow0.exitPriceEdit);
   string partial0PointsText = partialRow0.exitPointsEdit.Text();
   if(StringCompare(partial0PointsText, "n.a.") != 0) {
      if(StringToDouble(partial0PointsText) >= 0) {
         partialRow0.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }   
      isNumberCheckForEdits(&partialRow0.percentOfPartialEdit);      
      partial0Size = StringToInteger(partialRow0.percentOfPartialEdit.Text());
      double remainderPartial0 = MathMod(partial0Size, positionSplitinPercent);
      if (remainderPartial0 != 0) {
         partialRow0.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
      
   
   double partial1Size = 0;
   isNumberCheckForEdits(&partialRow1.exitPriceEdit);
   string partial1PointsText = partialRow1.exitPointsEdit.Text();
   if(StringCompare(partial1PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow1.exitPointsEdit.Text()) >= 0) {
         partialRow1.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
      isNumberCheckForEdits(&partialRow1.percentOfPartialEdit);
      partial1Size = StringToInteger(partialRow1.percentOfPartialEdit.Text());
      double remainderPartial1 = MathMod(partial1Size, positionSplitinPercent);
      if (remainderPartial1 != 0){
         partialRow1.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   
   
   double partial2Size = 0;
   isNumberCheckForEdits(&partialRow2.exitPriceEdit);
   string partial2PointsText = partialRow2.exitPointsEdit.Text();
   if(StringCompare(partial2PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow2.exitPointsEdit.Text()) >= 0) {
         partialRow2.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
      isNumberCheckForEdits(&partialRow2.percentOfPartialEdit);
      partial2Size = StringToInteger(partialRow2.percentOfPartialEdit.Text());
      double remainderPartial2 = MathMod(partial2Size, positionSplitinPercent);
      if (remainderPartial2 != 0){
         partialRow2.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   
   
   double partial3Size = 0;
   isNumberCheckForEdits(&partialRow3.exitPriceEdit);
   string partial3PointsText = partialRow3.exitPointsEdit.Text();
   if(StringCompare(partial3PointsText, "n.a.") != 0) {
      if(StringToDouble(partialRow3.exitPointsEdit.Text()) >= 0) {
         partialRow3.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
      isNumberCheckForEdits(&partialRow3.percentOfPartialEdit);
      partial3Size = StringToInteger(partialRow3.percentOfPartialEdit.Text());
      double remainderPartial3 = MathMod(partial3Size, positionSplitinPercent);
      if (remainderPartial3 != 0){
         partialRow3.percentOfPartialEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }

   
   
   if (foundIssue)
      return;
   
   deleteAllCreatedChartObjects();
   
   ENUM_TRADE_REQUEST_ACTIONS orderOperation = TRADE_ACTION_DEAL;
   ENUM_ORDER_TYPE orderType = ORDER_TYPE_SELL;
   double price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   
   if (pendingOrderCheckBox.Checked()) {
      orderOperation = TRADE_ACTION_PENDING;
      price = StringToDouble(pendingPriceEdit.Text());
      
      if (SymbolInfoDouble(Symbol(), SYMBOL_BID) < price)
         orderType = ORDER_TYPE_SELL_LIMIT;
      else
         orderType = ORDER_TYPE_SELL_STOP;
   }
   
   
   double totalLots = StringToDouble(totalRiskInLotsLabel.Text());
   double splitLots = StringToDouble(DoubleToString(totalLots*(((double) positionSplitinPercent/100)), 2));
   
   double partialPercentSum = partial0Size + partial1Size + partial2Size + partial3Size;
   
   if(partialPercentSum > 0) {   
      int partial0NPositions = (int) MathRound((partial0Size / partialPercentSum)*100 / positionSplitinPercent);
      int partial1NPositions = (int) MathRound((partial1Size  / partialPercentSum)*100 / positionSplitinPercent);
      int partial2NPositions = (int) MathRound((partial2Size  / partialPercentSum)*100 / positionSplitinPercent);
      int partial3NPositions = (int) MathRound((partial3Size  / partialPercentSum)*100 / positionSplitinPercent);
              
      for(int i=0; i<partial0NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow0.exitPriceEdit.Text()));
      for(int i=0; i<partial1NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow1.exitPriceEdit.Text()));
      for(int i=0; i<partial2NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow2.exitPriceEdit.Text()));
      for(int i=0; i<partial3NPositions; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow3.exitPriceEdit.Text()));
   }
   else {
      int nPositionsNoTp = 100/positionSplitinPercent;
      for(int i=0; i<nPositionsNoTp; i++)
         placeOrder(orderOperation, orderType, price, splitLots, StringToDouble(slPriceEdit.Text()), StringToDouble(partialRow0.exitPriceEdit.Text()));
   }
}



