#include <Controls\Button.mqh>

class MemoryButton : public CButton {
private:
   bool isPushed;
public:
   MemoryButton(void);   
   ~MemoryButton(void);
   bool getIsPushed(void);
   void click(void);
   void changeButtonColorActivate(void);
   void changeButtonColorDeactivate(void);

};


