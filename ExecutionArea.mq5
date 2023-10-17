#include "ExecutionArea.mqh"
#include "Spacings.mqh"

ExecutionArea::ExecutionArea(CAppDialog *mainWindow, string prefix) {
   this.mainWindow = mainWindow;
   this.prefix = prefix;
   
}

bool ExecutionArea::Create(int xCol1, int xCol2, int yRow1, int yRow2, int yRow3) {
   if(!placeLongButton.Create(0, prefix+"placeLongButton", 0,
                         xCol1, yRow1, xCol1 + BUTTON_WIDTH*1.5, yRow1+BUTTON_HEIGHT*1.3))
      return false;   
   if(!placeLongButton.Text("Place long"))
      return false;
   if(!placeLongButton.ColorBackground(clrGreen))
      return false;   
   if(!mainWindow.Add(placeLongButton))
      return false;
      
   if(!placeShortButton.Create(0, prefix+"placeShortButton", 0,
                         xCol2, yRow1, xCol2 + BUTTON_WIDTH*1.5, yRow1+BUTTON_HEIGHT*1.3))
      return false;   
   if(!placeShortButton.Text("Place short"))
      return false;
   if(!placeShortButton.ColorBackground(clrRed))
      return false;   
   if(!mainWindow.Add(placeShortButton))
      return false;
   return true;         
}