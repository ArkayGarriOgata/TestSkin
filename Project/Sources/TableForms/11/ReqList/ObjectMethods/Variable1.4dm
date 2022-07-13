
// Modified by: Mel Bohince (5/31/13) include Req On Hold in refresh

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="PlantMgr"; *)
QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Req On Hold"; *)
QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Requisition")
ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]VendorName:42; >; [Purchase_Orders:11]ReqNo:5; >)