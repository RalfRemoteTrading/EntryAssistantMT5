#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Edit.mqh>
#include "Spacings.mqh"
#include "Util.mq5"
#include "PartialRow.mqh"

class TradeManagementWindow : public CAppDialog {
private:
   int positionSplit;
   
   CLabel percentLabel;
   CLabel multipleNoteLabel;
   
   CEdit tmNewSlPriceEdit;   
   MemoryButton tmSetNewSlButton;
   CButton updateSLButton;
   
   
   
   CButton pyramidingIncreaseRiskButton;
   CButton pyramidingReduceRiskButton;
   CEdit pyramidingRiskTextEdit;
   CLabel pyramidingPercentLabel;
   CButton executePyramidingButton;
   
   

public:
   MemoryButtonStore *memoryButtonStore;
   
   CButton fullCloseButton;
   CButton closePartialButton;
   CEdit percentageClosePartialEdit;
   
   CPanel tmSection12Seperator;
   CPanel tmSection23Seperator;
   PartialRow *pyramidTp0;
   PartialRow *pyramidTp1;
   
   CLabel tmTotalRiskTextLabel;
   CLabel tmTotalRiskTextEdit;
   CLabel tmTotalRiskInLotsLabel;
   CLabel tmTotalRiskInMoneyLabel;
   
   
   TradeManagementWindow(int positionSplit);
   ~TradeManagementWindow(void);
   virtual bool      Create(const long chart,const string name,const int subwin,const int x1,const int y1,const int x2,const int y2);
   virtual bool      OnEvent(const int id,const long &lparam,const double &dparam,const string &sparam);
   void MoveOutOfFrame(void);
   void maybeMoveIntoFrame(void);
   void maybeSetPrice(double price);  
   void updateOpenRisk(void);

protected:
   bool CreateButtonFullClose(void);
   bool CreateButtonPartialClose(void);
   bool CreateTmSection12Seperator(void);
   bool CreateSlArea(void);
   bool CreatePyramidingControls(void);
   bool CreateTotalRiskElements();
   
   
   void OnClickFullCloseButton(void);
   void OnClickClosePartialButton(void);
   void OnClickSetNewSlButton(void);
   bool OnEndEditPercentageClosePartialEdit(void);
   void OnClickUpdateSLButton(void);
   void OnEndEditTmNewSlPriceEdit(void);
   bool OnEndEditPyramidingRiskTextEdit();
   void OnClickReduceRiskButton();
   void OnClickIncreaseRiskButton();
   void OnClickExecutePyramidingButton();
   
   
};