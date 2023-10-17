#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Edit.mqh>

#include "MemoryButton.mqh"

class PartialRow {
private:
   string id;
   CAppDialog *mainWindow;
   string prefix;
   
   CCheckBox *pendingOrderCheckBox;
   CEdit *pendingPriceEdit;
   

   CLabel partialXLabel;
   
   CLabel percentLabel;
   
   CLabel exitPriceLabel;
   
   CLabel exitPointsLabel;
   

public:  
   CEdit percentOfPartialEdit;
   MemoryButton setTpButton;
   CEdit exitPriceEdit;
   CLabel exitPointsEdit;
  
   PartialRow(string id, CAppDialog *mainWindow, string prefix);
  ~PartialRow(void);
  bool CreateRow( int partialSize, int xCol1, int xCol2, int xCol3, int xCol4, int yLabel, int yMainRow, int ySubRow);
  void addPendingControlls(CCheckBox *pendingOrderCheckBox, CEdit *pendingPriceEdit);
  void SetPartialSize(int sizeInPercent);
  void setPriceText(string text);
  void updateTpPoints(void);
  void reset(void);

protected:


};