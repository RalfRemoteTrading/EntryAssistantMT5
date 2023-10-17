#include <Controls\Dialog.mqh>
#include <Controls\Button.mqh>
#include <Controls\Panel.mqh>
#include <Controls\Label.mqh>
#include <Controls\CheckBox.mqh>
#include <Controls\Edit.mqh>

class ExecutionArea {
private:   
   CAppDialog *mainWindow;
   string prefix;
   
   CLabel percentLabel;
   CLabel multipleNoteLabel;

public:
   CButton placeLongButton;
   CButton placeShortButton;

   
   ExecutionArea(CAppDialog *mainWindow, string prefix);
  ~ExecutionArea(void);
  bool Create(int xCol1, int xCol2, int yRow1, int yRow2, int yRow3);

protected:


};