#include "CAppWindowEntryAssistant.mqh"
#include "Spacings.mqh"

CAppWindowEntryAssistant::CAppWindowEntryAssistant(int positionSplitinPercent) {
   this.positionSplitinPercent = positionSplitinPercent;
   this.partialRow0 = new PartialRow("Partial 1", &this, "mw");
   this.partialRow1 = new PartialRow("Partial 2", &this, "mw");
   this.partialRow2 = new PartialRow("Partial 3", &this, "mw");
   this.partialRow3 = new PartialRow("Partial 4", &this, "mw");
   this.executionArea = new ExecutionArea(&this, "mw");
   
   this.memoryButtonStore = new MemoryButtonStore();
}

CAppWindowEntryAssistant::~CAppWindowEntryAssistant(void) {}

bool CAppWindowEntryAssistant::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2) {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return false;
   if(!CreateButtonClearFields())
      return false;   
   if(!CreatePendingOrderCheckBox())
      return false;
   if(!CreatePendingPriceEdit())
      return false;
   if(!CreateButtonSetPendingOrderPrice())
      return false;
   if(!CreateSectionSeperators())
      return false;
   if(!CreateSlPriceEdit())
      return false;
   if(!CreateSlPointsEdit())
      return false;
   if(!CreateSetSlButton())
      return false;
   if(!CreatTotalRiskEditLabels())
      return false;
   if(!CreatTotalModifyRiskButtons())
      return false;
   
   if (!partialRow0.CreateRow(50, X1_SECTION3_COL1, X1_SECTION3_COL2, X1_SECTION3_COL3, X1_SECTION3_COL4,
                              Y1_SECTION3_ROW1_LABEL, Y1_SECTION3_ROW1_MAIN, Y1_SECTION3_ROW1_SUB))                              
      return false;
   if (!partialRow1.CreateRow(20, X1_SECTION3_COL1, X1_SECTION3_COL2, X1_SECTION3_COL3, X1_SECTION3_COL4,
                              Y1_SECTION3_ROW2_LABEL, Y1_SECTION3_ROW2_MAIN, Y1_SECTION3_ROW2_SUB))
      return false;            
   if (!partialRow2.CreateRow(20, X1_SECTION3_COL1, X1_SECTION3_COL2, X1_SECTION3_COL3, X1_SECTION3_COL4,
                              Y1_SECTION3_ROW3_LABEL, Y1_SECTION3_ROW3_MAIN, Y1_SECTION3_ROW3_SUB))
      return false;                              
   if (!partialRow3.CreateRow(10, X1_SECTION3_COL1, X1_SECTION3_COL2, X1_SECTION3_COL3, X1_SECTION3_COL4,
                              Y1_SECTION3_ROW4_LABEL, Y1_SECTION3_ROW4_MAIN, Y1_SECTION3_ROW4_SUB))
      return false;
   if (!executionArea.Create(X1_SECTION4_COL1, X1_SECTION4_COL2, Y1_SECTION4_ROW1, Y1_SECTION4_ROW2, Y1_SECTION4_ROW3))
      return false;
   
   partialRow0.addPendingControlls(&pendingOrderCheckBox, &pendingPriceEdit);
   partialRow1.addPendingControlls(&pendingOrderCheckBox, &pendingPriceEdit);
   partialRow2.addPendingControlls(&pendingOrderCheckBox, &pendingPriceEdit);
   partialRow3.addPendingControlls(&pendingOrderCheckBox, &pendingPriceEdit);
   
   memoryButtonStore.add(&setSlButton);
   memoryButtonStore.add(&partialRow0.setTpButton);
   memoryButtonStore.add(&partialRow1.setTpButton);
   memoryButtonStore.add(&partialRow2.setTpButton);
   memoryButtonStore.add(&partialRow3.setTpButton);
   memoryButtonStore.add(&buttonSetPendingOrderPrice);
   updateRisk();
   
   return true;
}



bool CAppWindowEntryAssistant::CreateButtonClearFields(void) {
   if(!buttonClearFields.Create(0, "mwClearFieldsButton", 0,
                                 X1_SECTION1_COL1, Y1_SECTION1_ROW1, X1_SECTION1_COL1 + BUTTON_WIDTH*2, Y1_SECTION1_ROW1+BUTTON_HEIGHT))
      return false;
   if(!buttonClearFields.Text("Clear fields"))
      return false;
   if(!buttonClearFields.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!Add(buttonClearFields))
      return false;
   
   return true;
}

bool CAppWindowEntryAssistant::CreatePendingOrderCheckBox(void) {
   if(!pendingOrderCheckBox.Create(0, "mwPendingOrderCheckBox", 0,
                         X1_SECTION1_COL1, Y1_SECTION1_ROW2, X1_SECTION1_COL1 + BUTTON_WIDTH*2, Y1_SECTION1_ROW2+BUTTON_HEIGHT))
      return false;
   if(!pendingOrderCheckBox.Text("Pending order"))
      return false;
   pendingOrderCheckBox.Checked(false);
   if(!Add(pendingOrderCheckBox))
      return false;
   return true;
}

bool CAppWindowEntryAssistant::CreatePendingPriceEdit(void) {
   if(!pendingPriceEdit.Create(0, "mwPendingOrderPriceEdit", 0,
                         X1_SECTION1_COL2, Y1_SECTION1_ROW2, X1_SECTION1_COL2 + BUTTON_WIDTH*1.2, Y1_SECTION1_ROW2+BUTTON_HEIGHT))
      return false;
   pendingPriceEdit.Hide();
   if(!Add(pendingPriceEdit))
      return false;
   return true;
}


bool CAppWindowEntryAssistant::CreateButtonSetPendingOrderPrice(void) {
   if(!buttonSetPendingOrderPrice.Create(0, "mwPendingOrderPriceSetButton", 0,
                         X1_SECTION1_COL3, Y1_SECTION1_ROW2, X1_SECTION1_COL3 + BUTTON_WIDTH, Y1_SECTION1_ROW2+BUTTON_HEIGHT))
      return false;
   if(!buttonSetPendingOrderPrice.Text("Set Price"))
      return false;
   if(!buttonSetPendingOrderPrice.FontSize(NORMAL_FONT_SIZE))
      return false;
   buttonSetPendingOrderPrice.Hide();
   if(!Add(buttonSetPendingOrderPrice))
      return false;
   return true;
}

bool CAppWindowEntryAssistant::CreateSectionSeperators(void) {
   if(!section12Seperator.Create(0, "mwsection12Seperator", 0,
                         X1_SECTION1_COL1, Y1_SECTION12_SEPERATOR, X1_SECTION1_COL3 + BUTTON_WIDTH, Y1_SECTION12_SEPERATOR+1))
      return false;
   if(!section12Seperator.ColorBackground(0))
      return false;      
   if(!Add(section12Seperator))
      return false;
      
   if(!section23Seperator.Create(0, "mwsection23Seperator", 0,
                         X1_SECTION1_COL1, Y1_SECTION23_SEPERATOR, X1_SECTION1_COL3 + BUTTON_WIDTH, Y1_SECTION23_SEPERATOR+1))
      return false;
   if(!section23Seperator.ColorBackground(0))
      return false;      
   if(!Add(section23Seperator))
      return false;
      
   if(!section34Seperator.Create(0, "mwsection34Seperator", 0,
                         X1_SECTION1_COL1, Y1_SECTION34_SEPERATOR, X1_SECTION1_COL3 + BUTTON_WIDTH, Y1_SECTION34_SEPERATOR+1))
      return false;
   if(!section34Seperator.ColorBackground(0))
      return false;      
   if(!Add(section34Seperator))
      return false;
      
   return true;
}


bool CAppWindowEntryAssistant::CreateSlPriceEdit(void) {
   if(!slPriceEdit.Create(0, "mwslPriceEdit", 0,
                         X1_SECTION2_COL1, Y1_SECTION2_ROW1, X1_SECTION2_COL1 + BUTTON_WIDTH*1.3, Y1_SECTION2_ROW1+BUTTON_HEIGHT))
      return false;
   if(!Add(slPriceEdit))
      return false;
      
   if(!slPriceLabel.Create(0, "mwslPriceLabel", 0,
                         X1_SECTION2_COL1_SUB, Y1_SECTION2_ROW1_SUB, X1_SECTION2_COL1_SUB, Y1_SECTION2_ROW1_SUB))
      return false;      
   if(!slPriceLabel.Text("Price"))
      return false;
   if(!slPriceLabel.FontSize(SMALL_FONT_SIZE))
      return false;
   if(!Add(slPriceLabel))
      return false;
                              
   return true;
}



bool CAppWindowEntryAssistant::CreateSlPointsEdit(void) {
   if(!slPointsEdit.Create(0, "mwslPointsEdit", 0,
                         X1_SECTION2_COL2, Y1_SECTION2_ROW1, X1_SECTION2_COL2 + BUTTON_WIDTH*1.1, Y1_SECTION2_ROW1+BUTTON_HEIGHT))
      return false;
   if(!Add(slPointsEdit))
      return false;
      
   if(!slPointsLabel.Create(0, "mwslPointsLabel", 0,
                         X1_SECTION2_COL2_SUB, Y1_SECTION2_ROW1_SUB, X1_SECTION2_COL2_SUB, Y1_SECTION2_ROW1_SUB))
      return false;
      
   if(!slPointsLabel.Text("Points"))
      return false;
   if(!slPointsLabel.FontSize(SMALL_FONT_SIZE))
      return false;
   if(!Add(slPointsLabel))
      return false;
                      
   return true;
}


bool CAppWindowEntryAssistant::CreateSetSlButton(void) {
   if(!setSlButton.Create(0, "mwsetSlButton", 0,
                                 X1_SECTION2_COL3, Y1_SECTION2_ROW1, X1_SECTION2_COL3 + BUTTON_WIDTH, Y1_SECTION2_ROW1+BUTTON_HEIGHT))
      return false;
   if(!setSlButton.Text("Set SL"))
      return false;
   if(!setSlButton.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!Add(setSlButton))
      return false;

   return true;
}

bool CAppWindowEntryAssistant::CreatTotalRiskEditLabels(void) {
   if(!totalRiskTextLabel.Create(0, "mwtotalRiskTextLabel", 0,
                                 X1_SECTION2_COL1, Y1_SECTION2_ROW2, X1_SECTION2_COL1 + BUTTON_WIDTH*1.3, Y1_SECTION2_ROW2+BUTTON_HEIGHT))
      return false;
   if(!totalRiskTextLabel.Text("Total risk in %"))
      return false;
   if(!totalRiskTextLabel.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!Add(totalRiskTextLabel))
      return false;
      
   if(!totalRiskInMoneyLabel.Create(0, "mwtotalRiskInMoneyLabel", 0,
                                 X1_SECTION2_COL1, Y1_SECTION2_ROW2_SUB, X1_SECTION2_COL1+5, Y1_SECTION2_ROW2_SUB+15))
      return false;
   if(!totalRiskInMoneyLabel.FontSize(SMALL_FONT_SIZE+1))
      return false;
   if(!totalRiskInMoneyLabel.Color(clrRed))
      return false;
   if(!Add(totalRiskInMoneyLabel))
      return false;
         
   
      
   if(!totalRiskTextEdit.Create(0, "mwtotalRiskTextEdit", 0,
                                 X1_SECTION2_COL2_SUB, Y1_SECTION2_ROW2, X1_SECTION2_COL2_SUB + BUTTON_WIDTH*1.1, Y1_SECTION2_ROW2+BUTTON_HEIGHT))
      return false;
   if(!totalRiskTextEdit.Text("0.5"))
      return false;
   if(!Add(totalRiskTextEdit))
      return false;
   
   if(!totalRiskInLotsLabel.Create(0, "mwtotalRiskInLotsLabel", 0,
                                 X1_SECTION2_COL2_SUB, Y1_SECTION2_ROW2_SUB, X1_SECTION2_COL2_SUB + BUTTON_WIDTH, Y1_SECTION2_ROW2_SUB+10))
      return false;
   if(!totalRiskInLotsLabel.Text("x.xx Lots"))
      return false;
   if(!totalRiskInLotsLabel.FontSize(SMALL_FONT_SIZE))
      return false;
   if(!Add(totalRiskInLotsLabel))
      return false;
   
   return true;
}

bool CAppWindowEntryAssistant::CreatTotalModifyRiskButtons(void) {
   if(!increaseRiskButton.Create(0, "mwincreaseRiskButton", 0,
                                 X1_SECTION2_COL3, Y1_SECTION2_ROW2, X1_SECTION2_COL3 + BUTTON_WIDTH, Y1_SECTION2_ROW2+BUTTON_HEIGHT/3*2))
      return false;
      
   if(!increaseRiskButton.Text("+ 0.05%"))
      return false;
   if(!increaseRiskButton.FontSize(SMALL_FONT_SIZE+1))
      return false;  
   if(!Add(increaseRiskButton))
      return false;
      
   if(!reduceRiskButton.Create(0, "mwreduceRiskButton", 0,
                                 X1_SECTION2_COL3, Y1_SECTION2_ROW2+BUTTON_HEIGHT/3*2+4, X1_SECTION2_COL3 + BUTTON_WIDTH, Y1_SECTION2_ROW2+BUTTON_HEIGHT/3*2*2+4))
      return false;
      
   if(!reduceRiskButton.Text("- 0.05%"))
      return false;
   if(!reduceRiskButton.FontSize(SMALL_FONT_SIZE+1))
      return false;  
   if(!Add(reduceRiskButton))
      return false;
      
      
      
   return true;
}




void CAppWindowEntryAssistant::maybeSetPrice(double price) {
   int buttonIdx = memoryButtonStore.getPushedButtonIdx();
   
   if (buttonIdx == -1)
      return;
      
   int decimalPrecision = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
   string priceAsString = DoubleToString(price, decimalPrecision);
   switch (buttonIdx) {
      case setSlButton_idx:
         slPriceEdit.Text(DoubleToString(price, decimalPrecision));
         isNumberCheckForEdits(&slPriceEdit);
         updatesSLPoints();
         updateRisk();
         createPriceLine("slPrice", price, clrRed);
         break;
      case setTpButton0_idx:         
         partialRow0.setPriceText(priceAsString);
         if(partialRow1.exitPriceEdit.Text() == "")
            partialRow1.setPriceText(priceAsString);
         if(partialRow2.exitPriceEdit.Text() == "")
            partialRow2.setPriceText(priceAsString);
         if(partialRow3.exitPriceEdit.Text() == "")
            partialRow3.setPriceText(priceAsString);            
         createPriceLine("tpPrice0", price, clrDarkGreen);
         break;
      case setTpButton1_idx:         
         partialRow1.setPriceText(priceAsString);
         if(partialRow2.exitPriceEdit.Text() == "" || partialRow2.exitPriceEdit.Text() == partialRow0.exitPriceEdit.Text())
            partialRow2.setPriceText(priceAsString);
         if(partialRow3.exitPriceEdit.Text() == "" || partialRow3.exitPriceEdit.Text() == partialRow0.exitPriceEdit.Text())
            partialRow3.setPriceText(priceAsString);            
         createPriceLine("tpPrice1", price, clrSeaGreen);
         break;
      case setTpButton2_idx:         
         partialRow2.setPriceText(priceAsString);         
         createPriceLine("tpPrice2", price, clrMediumSeaGreen);
         if(partialRow3.exitPriceEdit.Text() == "" || partialRow3.exitPriceEdit.Text() == partialRow1.exitPriceEdit.Text())
            partialRow3.setPriceText(priceAsString);   
         break;
      case setTpButton3_idx:         
         partialRow3.setPriceText(priceAsString);
         createPriceLine("tpPrice3", price, clrLimeGreen);
         break;
            case buttonSetPendingOrderPrice_idx:         
         pendingPriceEdit.Text(priceAsString);
         isNumberCheckForEdits(&pendingPriceEdit);
         updatesSLPoints();            
         partialRow0.updateTpPoints();
         partialRow1.updateTpPoints();
         partialRow2.updateTpPoints();
         partialRow3.updateTpPoints();
         updateRisk();
         createPriceLine("pendingPriceEntryLine", price, clrOrange);
         break;
      default:      
         break;
   };
   
   
   memoryButtonStore.resetMemoryButtons(NULL);
}


void CAppWindowEntryAssistant::updatesSLPoints(void){
   if (pendingOrderCheckBox.Checked()) {
      if (isNumberStrict(slPriceEdit.Text()) && isNumberStrict(pendingPriceEdit.Text())){
         double selectedSLPrice = StringToDouble(slPriceEdit.Text());         
         double selectedPendingPrice = StringToDouble(pendingPriceEdit.Text());
         double diff = selectedSLPrice-selectedPendingPrice;
         double points = diff * MathPow(10, SymbolInfoInteger(Symbol(), SYMBOL_DIGITS));
         slPointsEdit.Text(DoubleToString(points, 0));
      }
      else {
         slPointsEdit.Text("n.a.");
      }
   } else {
      if (isNumberStrict(slPriceEdit.Text())) {
         double selectedSLPrice = StringToDouble(slPriceEdit.Text());
         double marketPrice = (SymbolInfoDouble(Symbol(), SYMBOL_BID) + SymbolInfoDouble(Symbol(), SYMBOL_ASK)) / 2;
         double diff = selectedSLPrice-marketPrice;
         double points = diff * MathPow(10, SymbolInfoInteger(Symbol(), SYMBOL_DIGITS));
         slPointsEdit.Text(DoubleToString(points, 0));
      }
      else {
         slPointsEdit.Text("n.a.");
      }
   }
}


void CAppWindowEntryAssistant::updateRisk(void){
   string totalRiskText = totalRiskTextEdit.Text();
   if (isNumberStrict(totalRiskText)) {
      double moneyAtRisk = getRiskInMoney(StringToDouble(totalRiskText));
      
      string currency=AccountInfoString(ACCOUNT_CURRENCY);
      totalRiskInMoneyLabel.Text(DoubleToString(moneyAtRisk, 2) + " " + currency);
      
      string slPointsText = slPointsEdit.Text();
      if (isNumberStrict(slPointsText)) {
         double totalLots = getLots(StringToDouble(totalRiskText), MathAbs(StringToDouble(slPointsText)));
         totalRiskInLotsLabel.Text(DoubleToString(totalLots, 2) );
      }
      else {
         totalRiskInLotsLabel.Text("n.a.");
      }
   }   
}


