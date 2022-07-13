//%attributes = {"publishedWeb":true}
//(p) qryPo2Approve
//central place to search for PO s 2 approve 
//return number of records found (might be useful)
//• 7/25/97 cs created

C_LONGINT:C283($0)

//QUERY([PURCHASE_ORDER];[PURCHASE_ORDER]Status="Reviewed";*)

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Req Approved"; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]INX_autoPO:48=False:C215)
//QUERY SELECTION([PURCHASE_ORDER];[PURCHASE_ORDER]ReqNo="R@")  `get only those it

$0:=Records in selection:C76([Purchase_Orders:11])