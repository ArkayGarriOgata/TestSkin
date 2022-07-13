//%attributes = {"publishedWeb":true}
//(p) qryPoToOrder 
//central place to search for PO s that are to be ordered
//return number of records found (might be useful)
//• 7/25/97 cs created

C_LONGINT:C283($0)

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Ordered:47=False:C215; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]INX_autoPO:48=False:C215; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]Status:15="Approved")

$0:=Records in selection:C76([Purchase_Orders:11])