#include "MemoryButton.mqh"

#define buttonSetPendingOrderPrice_idx 5
#define setSlButton_idx 0
#define setTpButton0_idx 1
#define setTpButton1_idx 2
#define setTpButton2_idx 3
#define setTpButton3_idx 4


class MemoryButtonStore {

public:
   MemoryButton array[];
   
   MemoryButtonStore();   
   ~MemoryButtonStore(void);
   void add(MemoryButton *button);
   int getPushedButtonIdx(void);
   void resetMemoryButtons(MemoryButton *exception);
   
   void OnClickButtonSetPendingOrderPrice(void);
   void OnClickSetSlButton(void);
   void OnClickSetTp0(void);
   void OnClickSetTp1(void);
   void OnClickSetTp2(void);
   void OnClickSetTp3(void);
};


