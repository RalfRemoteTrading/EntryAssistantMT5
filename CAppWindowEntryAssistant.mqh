#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Edit.mqh>


#include "PartialRow.mqh"
#include "ExecutionArea.mqh"
#include "MemoryButton.mqh"
#include "MemoryButtonStore.mqh"

class CAppWindowEntryAssistant : public CAppDialog {
private:
   int positionSplitinPercent;
   
   CButton buttonClearFields;
   CCheckBox pendingOrderCheckBox;
   CEdit pendingPriceEdit;
   MemoryButton buttonSetPendingOrderPrice;
   CPanel section12Seperator;
   
   CEdit slPriceEdit;
   CLabel slPriceLabel;
   CLabel slPointsEdit;
   CLabel slPointsLabel;
   MemoryButton setSlButton;
   
   CLabel totalRiskTextLabel;
   CEdit totalRiskTextEdit;
   CLabel totalRiskInLotsLabel;
   CLabel totalRiskInMoneyLabel;
   CButton increaseRiskButton;
   CButton reduceRiskButton;
   
   CPanel section23Seperator; 
   
   CPanel section34Seperator;
   
   ExecutionArea *executionArea;
   

public:

   PartialRow *partialRow0;
   PartialRow *partialRow1;
   PartialRow *partialRow2;
   PartialRow *partialRow3;
   
   MemoryButtonStore *memoryButtonStore;


   CAppWindowEntryAssistant(int positionSplitinPercent);
   ~CAppWindowEntryAssistant(void);
   //--- create
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   
   void maybeSetPrice(double price);
   void updatesSLPoints(void);
   void updateRisk(void);
   
   void WindowMinimize(void) {Minimize();}
   void WindowMaximize(void) {Maximize();}

protected:
   //--- create dependent controls   
   bool CreateButtonClearFields(void);
   
   bool CreatePendingOrderCheckBox(void);
   bool CreatePendingPriceEdit(void);
   bool CreateButtonSetPendingOrderPrice(void);
   bool CreateSectionSeperators(void);
   
   bool CreateSlPriceEdit(void);
   bool CreateSlPointsEdit(void);
   bool CreateSetSlButton(void);
   bool CreatTotalRiskEditLabels(void);
   bool CreatTotalModifyRiskButtons(void);
      
   // even handling   
   void OnClickButtonClearFields(void);
   void OnChangePendingOrderCheckBox(void);
   void OnEndEditPendingPriceEdit(void);
   void OnEndEditSlPriceEdit(void);
   void OnEndEditTotalRiskTextEdit(void);
   void OnClickIncreaseRiskButton(void);
   void OnClickReduceRiskButton(void);
   
   void OnClickPlaceLong(void);
   void OnClickPlaceShort(void);
   void OnClickFullCloseButton(void);


};