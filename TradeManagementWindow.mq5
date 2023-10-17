#include "TradeManagementWindow.mqh"
#include "Spacings.mqh"

TradeManagementWindow::TradeManagementWindow(int positionSplit) {
   this.positionSplit = positionSplit;
   this.pyramidTp0= new PartialRow("Pyramid 1", &this, "tm");
   this.pyramidTp1 = new PartialRow("Pyramid 2", &this, "tm");
   this.memoryButtonStore = new MemoryButtonStore();
}
TradeManagementWindow::~TradeManagementWindow(void) {}

bool TradeManagementWindow::Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2) {
   if(!CAppDialog::Create(chart,name,subwin,x1,y1,x2,y2))
      return false;
   if(!CreateButtonFullClose())
      return false;   
   if(!CreateButtonPartialClose())
      return false;
   if(!CreateTmSection12Seperator())
      return false;
   if(!CreateSlArea())
      return false;
   if (!pyramidTp0.CreateRow(70, TM_X1_SECTION3_COL1, TM_X1_SECTION3_COL2, TM_X1_SECTION3_COL3, TM_X1_SECTION3_COL4,
                              TM_Y1_SECTION3_ROW1_LABEL, TM_Y1_SECTION3_ROW1_MAIN, TM_Y1_SECTION3_ROW1_SUB))
      return false;
   if (!pyramidTp1.CreateRow(30, TM_X1_SECTION3_COL1, TM_X1_SECTION3_COL2, TM_X1_SECTION3_COL3, TM_X1_SECTION3_COL4,
                              TM_Y1_SECTION3_ROW2_LABEL, TM_Y1_SECTION3_ROW2_MAIN, TM_Y1_SECTION3_ROW2_SUB))
      return false;         
   
   if(!CreatePyramidingControls())
      return false;
      
   if(!CreateTotalRiskElements())
      return false;
      
   memoryButtonStore.add(&tmSetNewSlButton);
   memoryButtonStore.add(&pyramidTp0.setTpButton);
   memoryButtonStore.add(&pyramidTp1.setTpButton);   
   return true;
}

bool TradeManagementWindow::CreateButtonFullClose(void) {
   if(!fullCloseButton.Create(0, "tmfullCloseButton", 0,
                         TM_X1_COL1, TM_Y1_ROW1, TM_X1_COL1 + BUTTON_WIDTH*1.5, TM_Y1_ROW1+BUTTON_HEIGHT*2.5))
      return false;   
   if(!fullCloseButton.Text("Full close"))
      return false;
   if(!fullCloseButton.ColorBackground(clrOrange))
      return false;   
   if(!Add(fullCloseButton))
      return false;
   return true;
}

bool TradeManagementWindow::CreateButtonPartialClose(void) {
   if(!closePartialButton.Create(0, "tmclosePartialButton", 0,
                         TM_X1_COL2, TM_Y1_ROW1, TM_X1_COL2 + BUTTON_WIDTH*1.5, TM_Y1_ROW1+BUTTON_HEIGHT*1.3))
      return false;   
   if(!closePartialButton.Text("Close partial"))
      return false;
   if(!closePartialButton.ColorBackground(clrOrange))
      return false;   
   if(!Add(closePartialButton))
      return false;
      
      
   if(!percentageClosePartialEdit.Create(0, "tmpercentageClosePartialEdit", 0,
                         TM_X1_COL2, TM_Y1_ROW2, TM_X1_COL2 + BUTTON_WIDTH/2, TM_Y1_ROW2+BUTTON_HEIGHT))
      return false;   
   if(!percentageClosePartialEdit.Text("50"))
      return false;
   if(!Add(percentageClosePartialEdit))
      return false;
      
   if(!percentLabel.Create(0, "tmpercentLabelExecution", 0,
                         TM_X1_COL2 + 3 + BUTTON_WIDTH/2, TM_Y1_ROW2, TM_X1_COL2 + BUTTON_WIDTH/2, TM_Y1_ROW2+BUTTON_HEIGHT))
      return false;   
   if(!percentLabel.Text("%"))
      return false;
   if(!Add(percentLabel))
      return false;
   
   if(!multipleNoteLabel.Create(0, "tmmultipleNoteLabel", 0,
                         TM_X1_COL2 + BUTTON_WIDTH*0.8, TM_Y1_ROW2+3, TM_X1_COL2 + BUTTON_WIDTH, TM_Y1_ROW2+3))
      return false;   
   if(!multipleNoteLabel.Text("multiple of " + IntegerToString(this.positionSplit) + "%"))
      return false;
   if(!multipleNoteLabel.FontSize(SMALL_FONT_SIZE))
      return false;
   if(!Add(multipleNoteLabel))
      return false; 
      
   return true;
}

bool TradeManagementWindow::CreateTmSection12Seperator(void) {
   if(!tmSection12Seperator.Create(0, "tmSection12Seperator", 0,
                         TM_X1_COL1, TM_Y1_12_SEPERATOR, TM_X1_COL2 + BUTTON_WIDTH*1.7, TM_Y1_12_SEPERATOR+1))
      return false;
   if(!tmSection12Seperator.ColorBackground(0))
      return false;      
   if(!Add(tmSection12Seperator))
      return false;
      
   if(!tmSection23Seperator.Create(0, "tmSection23Seperator", 0,
                         TM_X1_COL1, TM_Y1_23_SEPERATOR, TM_X1_COL2 + BUTTON_WIDTH*1.7, TM_Y1_23_SEPERATOR+1))
      return false;
   if(!tmSection23Seperator.ColorBackground(0))
      return false;      
   if(!Add(tmSection23Seperator))
      return false;   
      
   return true;
}

bool  TradeManagementWindow::CreateTotalRiskElements(void) {
   if(!tmTotalRiskTextLabel.Create(0, "tmTotalRiskTextLabel", 0,
                                 TM_X1_SECTION3_COL1, TM_Y1_SECTION3_ROW4, TM_X1_SECTION3_COL1 + BUTTON_WIDTH*1.3, TM_Y1_SECTION3_ROW4+BUTTON_HEIGHT))
      return false;
   if(!tmTotalRiskTextLabel.Text("Total risk"))
      return false;
   if(!tmTotalRiskTextLabel.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!Add(tmTotalRiskTextLabel))
      return false;      
      
      
   
   if(!tmTotalRiskTextEdit.Create(0, "tmTotalRiskTextEdit", 0,
                                 TM_X1_SECTION3_COL2+10, TM_Y1_SECTION3_ROW4, TM_X1_SECTION3_COL2 + BUTTON_WIDTH*1.1, TM_Y1_SECTION3_ROW4+BUTTON_HEIGHT))
      return false;
   if(!tmTotalRiskTextEdit.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!Add(tmTotalRiskTextEdit))
      return false;   
      
     
      
   
   if(!tmTotalRiskInLotsLabel.Create(0, "tmTotalRiskInLotsLabel", 0,
                                 TM_X1_SECTION3_COL3-35, TM_Y1_SECTION3_ROW4, TM_X1_SECTION3_COL3-35 + BUTTON_WIDTH, TM_Y1_SECTION3_ROW4+10))
      return false;
   if(!tmTotalRiskInLotsLabel.Text("x.xx Lots"))
      return false;
   if(!tmTotalRiskInLotsLabel.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!Add(tmTotalRiskInLotsLabel))
      return false;
      
   if(!tmTotalRiskInMoneyLabel.Create(0, "tmTotalRiskInMoneyLabel", 0,
                                 TM_X1_SECTION3_COL4, TM_Y1_SECTION3_ROW4, TM_X1_SECTION3_COL4+5, TM_Y1_SECTION3_ROW4+15))
      return false;
   if(!tmTotalRiskInMoneyLabel.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!tmTotalRiskInMoneyLabel.Color(clrRed))
      return false;
   if(!Add(tmTotalRiskInMoneyLabel))
      return false;
   
   
   updateOpenRisk();
   
   return true;
}

bool TradeManagementWindow::CreateSlArea(void) {
   if(!tmNewSlPriceEdit.Create(0, "tmNewSlPriceEdit", 0,
                         TM_X1_SECTION2_COL1, TM_Y1_SECTION2_ROW1, TM_X1_SECTION2_COL1 + BUTTON_WIDTH*1.2, TM_Y1_SECTION2_ROW1+BUTTON_HEIGHT))
      return false;
   if(!Add(tmNewSlPriceEdit))
      return false;
      
   if(!tmSetNewSlButton.Create(0, "tmSetNewSlButton", 0,
                         TM_X1_SECTION2_COL2, TM_Y1_SECTION2_ROW1, TM_X1_SECTION2_COL2 + BUTTON_WIDTH*1.2, TM_Y1_SECTION2_ROW1+BUTTON_HEIGHT))
      return false;   
   if(!tmSetNewSlButton.Text("Set new SL"))
      return false;
   if(!Add(tmSetNewSlButton))
      return false; 
      
   if(!updateSLButton.Create(0, "tmupdateSLButton", 0,
                         TM_X1_SECTION2_COL3, TM_Y1_SECTION2_ROW1, TM_X1_SECTION2_COL3 + BUTTON_WIDTH, TM_Y1_SECTION2_ROW1+BUTTON_HEIGHT))
      return false;   
   if(!updateSLButton.Text("Update SL"))
      return false;
   if(!updateSLButton.ColorBackground(clrLightCoral))
      return false;   
   if(!Add(updateSLButton))
      return false;   
      
   return true;
}

bool TradeManagementWindow::CreatePyramidingControls(void) {
   if(!pyramidingIncreaseRiskButton.Create(0, "tmpyramidingIncreaseRiskButton", 0,
                                 TM_X1_SECTION3_COL1, TM_Y1_SECTION3_ROW3, TM_X1_SECTION3_COL1 + BUTTON_WIDTH*0.8, TM_Y1_SECTION3_ROW3+BUTTON_HEIGHT/3*2))
      return false;
      
   if(!pyramidingIncreaseRiskButton.Text("+ 0.05%"))
      return false;
   if(!pyramidingIncreaseRiskButton.FontSize(SMALL_FONT_SIZE+1))
      return false;  
   if(!Add(pyramidingIncreaseRiskButton))
      return false;
      
   if(!pyramidingReduceRiskButton.Create(0, "tmpyramidingReduceRiskButton", 0,
                                 TM_X1_SECTION3_COL1, TM_Y1_SECTION3_ROW3+BUTTON_HEIGHT/3*2+4, TM_X1_SECTION3_COL1 + BUTTON_WIDTH*0.8, TM_Y1_SECTION3_ROW3+BUTTON_HEIGHT/3*2*2+4))
      return false;
      
   if(!pyramidingReduceRiskButton.Text("- 0.05%"))
      return false;
   if(!pyramidingReduceRiskButton.FontSize(SMALL_FONT_SIZE+1))
      return false;  
   if(!Add(pyramidingReduceRiskButton))
      return false;

   if(!pyramidingRiskTextEdit.Create(0, "tmpyramidingRiskTextEdit", 0,
                                 TM_X1_SECTION3_COL2, TM_Y1_SECTION3_ROW3+5, TM_X1_SECTION3_COL2 +BUTTON_WIDTH*0.7, TM_Y1_SECTION3_ROW3+BUTTON_HEIGHT+5))
      return false;
   if(!pyramidingRiskTextEdit.Text("0.25"))
      return false;
   if(!Add(pyramidingRiskTextEdit))
      return false;


   if(!pyramidingPercentLabel.Create(0, "tmpyramidingPercentLabel", 0,
                                 TM_X1_SECTION3_COL2+3+ BUTTON_WIDTH*0.7, TM_Y1_SECTION3_ROW3+5, TM_X1_SECTION3_COL2 + BUTTON_WIDTH*0.7, TM_Y1_SECTION3_ROW3+BUTTON_HEIGHT+5))
      return false;
   if(!pyramidingPercentLabel.Text("%"))
      return false;
   if(!Add(pyramidingPercentLabel))
      return false;

   if(!executePyramidingButton.Create(0, "tmexecutePyramidingButton", 0,
                         TM_X1_SECTION3_COL3-15, TM_Y1_SECTION3_ROW3+5, TM_X1_SECTION3_COL3 + BUTTON_WIDTH * 1.5, TM_Y1_SECTION3_ROW3+BUTTON_HEIGHT+5))
      return false;   
   if(!executePyramidingButton.Text("Add positions"))
      return false;
   if(!executePyramidingButton.ColorBackground(clrLightBlue))
      return false;   
   if(!Add(executePyramidingButton))
      return false;

   return true;
}



void TradeManagementWindow::maybeSetPrice(double price) {
   int buttonIdx = memoryButtonStore.getPushedButtonIdx();
   
   if (buttonIdx == -1)
      return;
      
   int decimalPrecision = SymbolInfoInteger(Symbol(), SYMBOL_DIGITS);
   switch (buttonIdx) {
      case setSlButton_idx:
         tmNewSlPriceEdit.Text(DoubleToString(price, decimalPrecision));
         isNumberCheckForEdits(&tmNewSlPriceEdit);
         tmSetNewSlButton.changeButtonColorDeactivate();
         createPriceLine("updateSlPrice", price, clrRed);
         break;
      case setTpButton0_idx:         
         pyramidTp0.setPriceText(DoubleToString(price, decimalPrecision));
         createPriceLine("pyramidTp0", price, clrDarkGreen);
         break;
      case setTpButton1_idx:         
         pyramidTp1.setPriceText(DoubleToString(price, decimalPrecision));         
         createPriceLine("pyramidTp1", price, clrSeaGreen);
         break;
      default:      
         break;
   };
   
   
   memoryButtonStore.resetMemoryButtons(NULL);
}


void TradeManagementWindow::MoveOutOfFrame(void){
   this.Move(-1000, -1000);
}

void TradeManagementWindow::maybeMoveIntoFrame(void) {
   if (this.m_rect.top < 0 || this.m_rect.left < 0) {
      this.Move(10, 80);
   }
   // else do nothing because its already in the frame and where the user wants it to be
}

void TradeManagementWindow::updateOpenRisk(void) {
   CPositionInfo  m_position;
   CTrade         m_trade;
   
   double totalMoneyAtRisk = 0;
   float totalVolume = 0;
   
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(m_position.SelectByIndex(i)) {
         if(m_position.Symbol() == Symbol()) {
            float slPrice = m_position.StopLoss();
            float openPrice = m_position.PriceOpen();
            float point = Point();
            float slPoints = MathAbs(slPrice-openPrice)/Point();
            float volume = m_position.Volume();
            totalVolume += volume;
            double positionMoneyRisk = getRiskInMoney(volume, slPoints);
            totalMoneyAtRisk += positionMoneyRisk;
         }
      }
   }
   
   double balance = AccountInfoDouble(ACCOUNT_BALANCE);
   float openRiskPercent = (float) (totalMoneyAtRisk / balance) * 100;
   
   tmTotalRiskTextEdit.Text(DoubleToString(openRiskPercent, 2) + "%");
   tmTotalRiskInLotsLabel.Text(DoubleToString(totalVolume, 2) + " Lots");
   tmTotalRiskInMoneyLabel.Text(DoubleToString(totalMoneyAtRisk, 2) + " " + AccountInfoString(ACCOUNT_CURRENCY));   
}