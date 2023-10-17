#include "MemoryButton.mqh"
#include <Controls\Defines.mqh>


MemoryButton::MemoryButton(void) {
   isPushed = false;
}
MemoryButton::~MemoryButton(void) {}

bool MemoryButton::getIsPushed(void) {
   return isPushed;
}

void MemoryButton::click(void) {
   if (isPushed)
      this.changeButtonColorDeactivate();
   else
      this.changeButtonColorActivate();
      
}


void MemoryButton::changeButtonColorActivate(void) {   
   this.ColorBackground(clrDarkGray);
   this.Color(clrWhiteSmoke);
   this.ColorBorder(clrBlack);
   this.isPushed = true;
}


void MemoryButton::changeButtonColorDeactivate(void) {
   this.ColorBackground(CONTROLS_BUTTON_COLOR_BG);
   this.Color(CONTROLS_BUTTON_COLOR);
   this.ColorBorder(CONTROLS_BUTTON_COLOR_BORDER);
   this.isPushed = false;
}