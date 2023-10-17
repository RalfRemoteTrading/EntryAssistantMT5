 #include <Object.mqh>

class TradeTpDistanceHelper : public CObject {
private:
   int ticket;
   float tpDistance;
   float volume;
   
public:
   TradeTpDistanceHelper(int ticket, float tpDistance, float volume);
   ~TradeTpDistanceHelper();
   int getTicket();
   float getTpDistance();
   float getVolume();   
   virtual int Compare(const CObject* node, const int mode=0) const;
};