#include "MemoryButtonStore.mqh"


void MemoryButtonStore::MemoryButtonStore(void){};

void MemoryButtonStore::add(MemoryButton *button) {
   int currentSize= ArraySize(array);
   ArrayResize(array,ArraySize(array)+1);
   array[currentSize] = button;
}

int MemoryButtonStore::getPushedButtonIdx(void) {
   int hit = -1;
   for(int i=0; i<ArraySize(array); i++){
      MemoryButton candidate = array[i];
      if (candidate.getIsPushed()) {
         hit = i;
         break;
      }
   }
   return hit;
}

void MemoryButtonStore::resetMemoryButtons(MemoryButton *exception){
   for(int i=0; i<ArraySize(array); i++){
      MemoryButton *it = &(array[i]);
      if (it != exception)
         it.changeButtonColorDeactivate();
   }
   
   if (exception != NULL)
      exception.click();
}



void MemoryButtonStore::OnClickSetSlButton(void) {
   resetMemoryButtons(&array[setSlButton_idx]);
}

void MemoryButtonStore::OnClickSetTp0() {
   resetMemoryButtons(&array[setTpButton0_idx]);
}

void MemoryButtonStore::OnClickSetTp1() {
   resetMemoryButtons(&array[setTpButton1_idx]);
}

void MemoryButtonStore::OnClickSetTp2() {
   resetMemoryButtons(&array[setTpButton2_idx]);
}

void MemoryButtonStore::OnClickSetTp3() {
   resetMemoryButtons(&array[setTpButton3_idx]);
}
void MemoryButtonStore::OnClickButtonSetPendingOrderPrice(void) {
   resetMemoryButtons(&array[buttonSetPendingOrderPrice_idx]);
}