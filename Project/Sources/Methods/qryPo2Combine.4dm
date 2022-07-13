//%attributes = {"publishedWeb":true}
//(p)  qryPo2Combine
//returns number of records found (might need this)

C_LONGINT:C283($0)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Req Approved"; *)  //ONLY req in approved status or processed status, can be combined
	QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="ReViewed")  //other statuses are wither to far or not far enough in the process
	QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5="R@")
	
Else 
	
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Req Approved"; *)
	QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="ReViewed"; *)
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5="R@")
	
End if   // END 4D Professional Services : January 2019 query selection

$0:=Records in selection:C76([Purchase_Orders:11])