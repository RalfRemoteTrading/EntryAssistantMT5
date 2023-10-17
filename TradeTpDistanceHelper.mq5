#include "TradeTpDistanceHelper.mqh"



TradeTpDistanceHelper::TradeTpDistanceHelper(int ticket, float tpDistance, float volume){
   this.ticket = ticket;
   this.tpDistance = tpDistance;
   this.volume = volume;
}

TradeTpDistanceHelper::~TradeTpDistanceHelper(){}

int TradeTpDistanceHelper::getTicket() {
   return this.ticket;
}

float TradeTpDistanceHelper::getTpDistance() {
   return this.tpDistance;
}

float TradeTpDistanceHelper::getVolume() {
   return this.volume;
}

int TradeTpDistanceHelper::Compare(const CObject* node, const int mode=0) const{
   TradeTpDistanceHelper *other = (TradeTpDistanceHelper*)node;
   if(this.tpDistance < other.getTpDistance())
      return 1;
   if(this.tpDistance > other.getTpDistance())
      return -1;
   return 0;
}