#include "PartialRow.mqh"
#include "Spacings.mqh"


PartialRow::PartialRow(string id, CAppDialog *mainWindow, string prefix) {
   this.id = id;
   this.mainWindow = mainWindow;
   this.prefix = prefix;
}

PartialRow::~PartialRow(void){}


bool PartialRow::CreateRow( int partialSize, int xCol1, int xCol2, int xCol3, int xCol4, int yLabel, int yMainRow, int ySubRow) {
   if(!partialXLabel.Create(0, prefix+"partialXLabel"+id, 0,
                         xCol1, yLabel, xCol1+5, yLabel+5))
      return false;      
   if(!partialXLabel.Text(id))
      return false;
   if(!partialXLabel.FontSize(SMALL_FONT_SIZE+1))
      return false;
   if(!this.mainWindow.Add(partialXLabel))
      return false;
   
   
   if(!percentOfPartialEdit.Create(0, prefix+"percentOfPartialEdit"+id, 0,
                         xCol1, yMainRow, xCol1+BUTTON_WIDTH/2, yMainRow+BUTTON_HEIGHT))
      return false;      
   SetPartialSize(partialSize);
   if(!this.mainWindow.Add(percentOfPartialEdit))
      return false;
      
   if(!percentLabel.Create(0, prefix+"percentLabel"+id, 0,
                         xCol1+5+BUTTON_WIDTH/2, yMainRow, xCol1, yMainRow+BUTTON_HEIGHT))
      return false;
   if(!percentLabel.Text("%"))
      return false;
   if(!this.mainWindow.Add(percentLabel))
      return false;
    
    
    if(!exitPriceEdit.Create(0, prefix+"exitPriceEdit"+id, 0,
                         xCol2, yMainRow, xCol2+BUTTON_WIDTH*1.2, yMainRow+BUTTON_HEIGHT))
      return false;      
   if(!this.mainWindow.Add(exitPriceEdit))
      return false;
      
   if(!exitPriceLabel.Create(0, prefix+"exitPriceLabel"+id, 0,
                         xCol2, ySubRow, xCol2, ySubRow))
      return false;
   if(!exitPriceLabel.Text("Price"))
      return false;
   if(!exitPriceLabel.FontSize(SMALL_FONT_SIZE))
      return false;
   if(!this.mainWindow.Add(exitPriceLabel))
      return false;
      
   if(!exitPointsEdit.Create(0, prefix+"exitPointsEdit"+id, 0,
                         xCol3, yMainRow, xCol3+BUTTON_WIDTH*1.1, yMainRow+BUTTON_HEIGHT))
      return false;      
   if(!exitPointsEdit.Text("n.a."))
      return false;
   if(!this.mainWindow.Add(exitPointsEdit))
      return false;
      
   if(!exitPointsLabel.Create(0, prefix+"exitexitPointsLabelPriceLabel"+id, 0,
                         xCol3, ySubRow, xCol3, ySubRow))
      return false;
   if(!exitPointsLabel.Text("Points"))
      return false;
   if(!exitPointsLabel.FontSize(SMALL_FONT_SIZE))
      return false;
   if(!this.mainWindow.Add(exitPointsLabel))
      return false;
   
   if(!setTpButton.Create(0, prefix+"setTpButton"+id, 0,
                         xCol4, yMainRow, xCol4+BUTTON_WIDTH, yMainRow+BUTTON_HEIGHT))
   if(!setTpButton.FontSize(NORMAL_FONT_SIZE))
      return false;
   if(!this.mainWindow.Add(setTpButton))
      return false;                        
   if(!setTpButton.Text("Set TP"))
      return false;
   if(!setTpButton.FontSize(NORMAL_FONT_SIZE))
      return false;
    
      
   return true;
}

void PartialRow::addPendingControlls(CCheckBox *pendingOrderCheckBox, CEdit *pendingPriceEdit){
   this.pendingOrderCheckBox = pendingOrderCheckBox;
   this.pendingPriceEdit = pendingPriceEdit;
}

void PartialRow::SetPartialSize(int sizeInPercent) {
   this.percentOfPartialEdit.Text(""+sizeInPercent);
}

void PartialRow::reset(void) {
   exitPriceEdit.Text(NULL);
   exitPointsEdit.Text("");   
}

void PartialRow::setPriceText(string text) {
   exitPriceEdit.Text(text);
   isNumberCheckForEdits(&exitPriceEdit);
   updateTpPoints();
}


void PartialRow::updateTpPoints(void) {
   bool pendingOrderActivated = false;
   if(pendingOrderCheckBox != NULL) {
      pendingOrderActivated = pendingOrderCheckBox.Checked();
   }
   if (pendingOrderActivated) {
      if (isNumberStrict(exitPriceEdit.Text()) && isNumberStrict(pendingPriceEdit.Text())){
         double selectedTpPrice = StringToDouble(exitPriceEdit.Text());
         double selectedPendingPrice = StringToDouble(pendingPriceEdit.Text());
         double diff = selectedTpPrice-selectedPendingPrice;
         double points = diff * MathPow(10, SymbolInfoInteger(Symbol(), SYMBOL_DIGITS));
         exitPointsEdit.Text(DoubleToString(points, 0));
      }
      else {
         exitPointsEdit.Text("n.a.");
      }
   }
   else {
      if (isNumberStrict(exitPriceEdit.Text())) {
         double selectedTpPrice = StringToDouble(exitPriceEdit.Text());
         double marketPrice = (SymbolInfoDouble(Symbol(), SYMBOL_BID) + SymbolInfoDouble(Symbol(), SYMBOL_ASK)) / 2;
         double diff = selectedTpPrice -marketPrice;
         double points = diff * MathPow(10, SymbolInfoInteger(Symbol(), SYMBOL_DIGITS));
         exitPointsEdit.Text(DoubleToString(points, 0));
      }
      else {
         exitPointsEdit.Text("n.a.");
      }
   }
}