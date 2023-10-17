#include <Arrays\List.mqh>
#include "TradeManagementWindow.mqh"
#include "TradeTpDistanceHelper.mqh"

EVENT_MAP_BEGIN(TradeManagementWindow)
ON_EVENT(ON_CLICK, fullCloseButton, OnClickFullCloseButton)
ON_EVENT(ON_CLICK, tmSetNewSlButton, memoryButtonStore.OnClickSetSlButton)
ON_EVENT(ON_END_EDIT, percentageClosePartialEdit, OnEndEditPercentageClosePartialEdit)
ON_EVENT(ON_END_EDIT, tmNewSlPriceEdit, OnEndEditTmNewSlPriceEdit)
ON_EVENT(ON_CLICK, updateSLButton, OnClickUpdateSLButton)
ON_EVENT(ON_CLICK, closePartialButton, OnClickClosePartialButton)
ON_EVENT(ON_CLICK, pyramidTp0.setTpButton, memoryButtonStore.OnClickSetTp0)
ON_EVENT(ON_CLICK, pyramidTp1.setTpButton, memoryButtonStore.OnClickSetTp1)
ON_EVENT(ON_CLICK, pyramidingIncreaseRiskButton, OnClickIncreaseRiskButton)
ON_EVENT(ON_CLICK, pyramidingReduceRiskButton, OnClickReduceRiskButton)
ON_EVENT(ON_END_EDIT, pyramidingRiskTextEdit, OnEndEditPyramidingRiskTextEdit)
ON_EVENT(ON_CLICK, executePyramidingButton, OnClickExecutePyramidingButton)
EVENT_MAP_END(CAppDialog);



void TradeManagementWindow::OnClickFullCloseButton(void) {
   CPositionInfo  m_position;
   CTrade         m_trade;
   
   m_trade.SetAsyncMode(true);
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(m_position.SelectByIndex(i)) {
         if(m_position.Symbol() == Symbol()) {
            if(!m_trade.PositionClose(m_position.Ticket())) { // close a position by the specified m_symbol
               Print(__FILE__," ",__FUNCTION__,", ERROR: ",m_trade.ResultRetcode(),", PositionClose ",m_position.Ticket(),", ",m_trade.ResultRetcodeDescription());
            }
         }
      }
   }
   
   
   m_trade.SetAsyncMode(true);
   for(int i=OrdersTotal()-1; i>=0; i--) {
      ulong ticket=OrderGetTicket(i);
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL)==Symbol()) {        
         m_trade.OrderDelete(ticket);
      }
   }
}

bool TradeManagementWindow::OnEndEditPercentageClosePartialEdit(void) {
   bool isNumber = isNumberCheckForEdits(&percentageClosePartialEdit);
   bool customCheck = true;
   if(isNumberStrict(percentageClosePartialEdit.Text())){
      double currentValue = StringToDouble(percentageClosePartialEdit.Text());
      double modulo = MathMod(currentValue, positionSplit);
      if (modulo != 0 || currentValue > 100 || currentValue < 0) {
         percentageClosePartialEdit.ColorBackground(clrRed);
         customCheck = false;
      }
   }
   return (isNumber && customCheck);
}


void TradeManagementWindow::OnClickUpdateSLButton(void) {
   if(!isNumberStrict(tmNewSlPriceEdit.Text())) {
      isNumberCheckForEdits(&tmNewSlPriceEdit);
      tmNewSlPriceEdit.ColorBackground(clrRed);
      return;
   }
   
   ObjectDelete(0, "updateSlPrice");
   double newSlprice =  StringToDouble(tmNewSlPriceEdit.Text());
   
   CPositionInfo  m_position;
   CTrade         m_trade;
   
   m_trade.SetAsyncMode(true);
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(m_position.SelectByIndex(i)) {
         if(m_position.Symbol() == Symbol()) {
            if(!m_trade.PositionModify(m_position.Ticket(), newSlprice, m_position.TakeProfit())) {
               Print(__FILE__," ",__FUNCTION__,", ERROR: ",m_trade.ResultRetcode(),", PositionModify ",m_position.Ticket(),", ",m_trade.ResultRetcodeDescription());
            }
         }
      }
   }
   
   COrderInfo m_orderInfo;   
   for(int i=OrdersTotal()-1; i>=0; i--) {
      ulong ticket=OrderGetTicket(i);
      if(m_orderInfo.Select(ticket) && m_orderInfo.Symbol()==Symbol()) {
         double priceOpen = m_orderInfo.PriceOpen();
         if(!m_trade.OrderModify(ticket, priceOpen, newSlprice, m_orderInfo.TakeProfit(), m_orderInfo.TypeTime(), m_orderInfo.TimeExpiration(), priceOpen))
            Print(__FILE__," ",__FUNCTION__,", ERROR: ",m_trade.ResultRetcode(),", OrderModify ",m_position.Ticket(),", ",m_trade.ResultRetcodeDescription());
      }
   }
   
   updateOpenRisk();   
}

void TradeManagementWindow::OnEndEditTmNewSlPriceEdit(void) {
   isNumberCheckForEdits(&tmNewSlPriceEdit);
}



void TradeManagementWindow::OnClickClosePartialButton(void){
   if(!this.OnEndEditPercentageClosePartialEdit())
      return;
   
   CList list;         
   CPositionInfo  m_position;
   CTrade         m_trade;
   m_trade.SetAsyncMode(true);
   float totalVolumeOpen = 0;
   
   int totalNPos =    PositionsTotal();
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(m_position.SelectByIndex(i)) {
         if(m_position.Symbol() == Symbol()) {            
            float distance = MathAbs(m_position.TakeProfit()-m_position.PriceOpen());
            float volume = m_position.Volume();
            totalVolumeOpen = totalVolumeOpen + volume;
            TradeTpDistanceHelper *newTpDistanceHelper = new TradeTpDistanceHelper(m_position.Ticket(), distance, volume);
            list.Add(newTpDistanceHelper);
         }
      }
   }
   list.Sort(0);
   double percentToClose = StringToDouble(percentageClosePartialEdit.Text())/100;
   double remainingVolumeToClose = percentToClose * totalVolumeOpen;
   

   // first we want to see if there are positions on that have a higher volume then the others
   // this one should be closed first
   
   // --- this will not be implemented for now   

   // only after that the "normal" sized positions should be closed
   // these will be closed starting with the ones who have their TP closest
   for(int i=list.Total()-1; i>=0; i--){
      if(remainingVolumeToClose <=0){
         break;
      }
      
      TradeTpDistanceHelper *currentTpDistanceHelper = list.GetNodeAtIndex(i);
      if(!m_trade.PositionClose(currentTpDistanceHelper.getTicket())) {
         Print(__FILE__," ",__FUNCTION__,", ERROR: ",m_trade.ResultRetcode(),", PositionClose ", currentTpDistanceHelper.getTicket(),", ",m_trade.ResultRetcodeDescription());
      }
      else {
         remainingVolumeToClose = remainingVolumeToClose - currentTpDistanceHelper.getVolume();
      }
           
   } 
}

bool TradeManagementWindow::OnEndEditPyramidingRiskTextEdit(){   
   return isNumberCheckForEdits(&pyramidingRiskTextEdit);
}


void TradeManagementWindow::OnClickIncreaseRiskButton(void) {
   if(!OnEndEditPyramidingRiskTextEdit())
      return;
   string currentRisk = pyramidingRiskTextEdit.Text();
   if(isNumberStrict(currentRisk)) {
      // TODO take from params
      double newRisk = StringToDouble(currentRisk) + 0.05;
      pyramidingRiskTextEdit.Text(DoubleToString(newRisk, 3));
   }
}

void TradeManagementWindow::OnClickReduceRiskButton(void) {
   if(!OnEndEditPyramidingRiskTextEdit())
      return;
   string currentRisk = pyramidingRiskTextEdit.Text();
   if(isNumberStrict(currentRisk)) {
      // TODO take from params
      double newRisk = StringToDouble(currentRisk) - 0.05;
      if (newRisk > 0)
         pyramidingRiskTextEdit.Text(DoubleToString(newRisk, 3));
   }
}



void TradeManagementWindow::OnClickExecutePyramidingButton(){
   ENUM_ORDER_TYPE orderType;
   double slPrice;
   
   CPositionInfo  m_position;
   CTrade         m_trade;
   
   int totalNPos = PositionsTotal();   
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(m_position.SelectByIndex(i)) {
         if(m_position.Symbol() == Symbol()) {            
            slPrice = m_position.StopLoss();
            ENUM_POSITION_TYPE positionType = m_position.PositionType();
            if (positionType == POSITION_TYPE_BUY)
               orderType = ORDER_TYPE_BUY;
            else
               orderType = ORDER_TYPE_SELL;
            break;
         }
      }
   }

   bool foundIssue = false;

   
   
   isNumberCheckForEdits(&pyramidTp0.exitPriceEdit);
   if(orderType == ORDER_TYPE_SELL) {
      if(StringToDouble(pyramidTp0.exitPointsEdit.Text()) >= 0) {
         pyramidTp0.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   else {
      if(StringToDouble(pyramidTp0.exitPointsEdit.Text()) <= 0) {
         pyramidTp0.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   isNumberCheckForEdits(&pyramidTp0.percentOfPartialEdit);
   double partial0Size = StringToInteger(pyramidTp0.percentOfPartialEdit.Text());
   double remainderPartial0 = MathMod(partial0Size, positionSplitinPercent);
   if (remainderPartial0 != 0){
      pyramidTp0.percentOfPartialEdit.ColorBackground(clrRed);
      foundIssue = true;
   }
   
   
   isNumberCheckForEdits(&pyramidTp1.exitPriceEdit);
   if(orderType == ORDER_TYPE_SELL) {
      if(StringToDouble(pyramidTp1.exitPointsEdit.Text()) >= 0) {
         pyramidTp1.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   else {
      if(StringToDouble(pyramidTp1.exitPointsEdit.Text()) <= 0) {
         pyramidTp1.exitPriceEdit.ColorBackground(clrRed);
         foundIssue = true;
      }
   }
   isNumberCheckForEdits(&pyramidTp1.percentOfPartialEdit);
   double partial1Size = StringToInteger(pyramidTp1.percentOfPartialEdit.Text());
   double remainderPartial1 = MathMod(partial1Size, positionSplitinPercent);
   if (remainderPartial1 != 0){
      pyramidTp1.percentOfPartialEdit.ColorBackground(clrRed);
      foundIssue = true;
   }
   
   
   double partialPercentSum = partial0Size + partial1Size;
   if (partialPercentSum != 100)
      foundIssue = true;

   
   
   ENUM_TRADE_REQUEST_ACTIONS orderOperation = TRADE_ACTION_DEAL;
   double price = SymbolInfoDouble(Symbol(), SYMBOL_ASK);
   if (ORDER_TYPE_SELL)
      price = SymbolInfoDouble(Symbol(), SYMBOL_BID);
   
   double slPoints = MathAbs(slPrice - price) * MathPow(10, SymbolInfoInteger(Symbol(), SYMBOL_DIGITS));;
   
   isNumberCheckForEdits(&tmNewSlPriceEdit);
   if(slPrice == 0) {   
      tmNewSlPriceEdit.ColorBackground(clrRed);
      foundIssue = true;      
   }
      
   if (foundIssue)
      return;
   
   ObjectDelete(0, "pyramidTp0");
   ObjectDelete(0, "pyramidTp1");
   
   
   
   double totalLots = getLots(StringToDouble(pyramidingRiskTextEdit.Text()), slPoints);
   double splitLots = StringToDouble(DoubleToString(totalLots*((double) positionSplitinPercent/100), 2));
   
   int partial0NPositions = (int) partial0Size / positionSplitinPercent;
   int partial1NPositions = (int) partial1Size / positionSplitinPercent;
   
   for(int i=0; i<partial0NPositions; i++)
      placeOrder(orderOperation, orderType, price, splitLots, slPrice, StringToDouble(pyramidTp0.exitPriceEdit.Text()));
   for(int i=0; i<partial1NPositions; i++)
      placeOrder(orderOperation, orderType, price, splitLots, slPrice, StringToDouble(pyramidTp1.exitPriceEdit.Text()));
}