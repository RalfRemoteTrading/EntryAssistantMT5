//+------------------------------------------------------------------+
//|                                               EntryAssistant.mq5 |
//|                                                     Ralf Hermann |
//|                                             https://www.mql5.com |
//+------------------------------------------------------------------+
#include "CAppWindowEntryAssistant.mqh"
#include "TradeManagementWindow.mqh"
#include "Util.mq5"

CAppWindowEntryAssistant *mainWindow;
TradeManagementWindow *tradeManagementWindow;

//--- Eingabeparameter
input int            positionSplitinPercent=10;


int OnInit() {
   mainWindow = new CAppWindowEntryAssistant(positionSplitinPercent);
   tradeManagementWindow = new TradeManagementWindow(positionSplitinPercent);
   
   if(!mainWindow.Create(0,"Entry Assistant",0,10, 5, 380, 565))
      return(INIT_FAILED);
   if(!tradeManagementWindow.Create(0, "Trade Management", 0, 400, 50, 400+300, 50+415))
      return(INIT_FAILED);
   mainWindow.Run();
   tradeManagementWindow.Run();
   OnTrade();
   return(INIT_SUCCEEDED);
}
  
void OnDeinit(const int reason) {
   Comment("");
   mainWindow.Destroy(reason);   
   tradeManagementWindow.Destroy(reason);
   deleteAllCreatedChartObjects();
}


void OnTrade() {
   if (isSymbolTradeOpen() || isSymbolPositionOpen()){
      tradeManagementWindow.maybeMoveIntoFrame();
   }
   else {     
      tradeManagementWindow.MoveOutOfFrame();
   }
      
   if (isSymbolPositionOpen())
      mainWindow.WindowMinimize();
   else
      mainWindow.WindowMaximize();
   
   tradeManagementWindow.updateOpenRisk();
}

void OnTradeTransaction(const MqlTradeTransaction &trans,
                        const MqlTradeRequest &request,
                        const MqlTradeResult &result) {
   // Titel nach dem Namen der Handelsereignisse-Handler-Funktion
   Print("=> ",__FUNCTION__," at ",TimeToString(TimeCurrent(),TIME_SECONDS));
   // Typ der Transaktion in Form von Enumerationswerte erhalten
   ENUM_TRADE_TRANSACTION_TYPE type=trans.type;
   // wenn die Transaktion ist ein Ergebnis der Verarbeitung einer Anfrage
   if(type==TRADE_TRANSACTION_REQUEST) {
      // den Name der Transaktion ausgeben
      PrintFormat("OrderSend retcode %d",result.retcode); 
   }
}

void OnTick() {
   mainWindow.updatesSLPoints();
   mainWindow.partialRow0.updateTpPoints();
   mainWindow.partialRow1.updateTpPoints();
   mainWindow.partialRow2.updateTpPoints();
   mainWindow.partialRow3.updateTpPoints();
}



void OnChartEvent(const int id,
                  const long& lparam,
                  const double& dparam,
                  const string& sparam) {
   
   
   if(id==CHARTEVENT_CLICK) {
      datetime time;
      double price;
      int subwindow;
      ChartXYToTimePrice(0,lparam,dparam,subwindow,time,price);
      tradeManagementWindow.maybeSetPrice(price);
      mainWindow.maybeSetPrice(price);     
   }
   
   if(StringFind(sparam, "tm") == 0)
      tradeManagementWindow.ChartEvent(id,lparam,dparam,sparam);
   else if(StringFind(sparam, "mw") == 0)
      mainWindow.ChartEvent(id,lparam,dparam,sparam);
   else{
      mainWindow.ChartEvent(id,lparam,dparam,sparam);
      tradeManagementWindow.ChartEvent(id,lparam,dparam,sparam);
   }
   
   
}

bool isSymbolTradeOpen() {
   CTrade         m_trade;
   CPositionInfo  m_position;
   
   for(int i=OrdersTotal()-1; i>=0; i--) {
      ulong ticket=OrderGetTicket(i);
      if(OrderSelect(ticket) && OrderGetString(ORDER_SYMBOL)==Symbol()) {
         return true;
      }
   }
   
   return false;
}

bool isSymbolPositionOpen() {
   CTrade         m_trade;
   CPositionInfo  m_position;
   
   m_trade.SetAsyncMode(true);
   for(int i=PositionsTotal()-1; i>=0; i--) {
      if(m_position.SelectByIndex(i)) {
         if(m_position.Symbol() == Symbol()) {
            return true;
         }
      }
   }
   
   
   return false;
}