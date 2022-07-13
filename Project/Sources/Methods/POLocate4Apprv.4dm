//%attributes = {"publishedWeb":true}
//(p) POLocate4Apprv (locate POs for Approval
//$1 - string (optional) anything - flag this is to find requisitions NOT POs
//• 6/2/97 cs create
//• cs 9/9/97 

C_LONGINT:C283($0)

Case of 
	: (Count parameters:C259=1)  //requistions
		zwStatusMsg("APPROVAL"; "Locating Requisitions")
		QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Requisition")
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]ReqNo:5; >)
		
	: (User in group:C338(Current user:C182; "PO_Approval_Mgr"))  //this is POs ready for upper managment (Mitchell etc)
		zwStatusMsg("APPROVAL"; "Locating Purchase Orders To Approve")
		qryPO2Approve  //get aproval ready
		
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1; >)
		
	: (User in group:C338(Current user:C182; "PO_Approval"))  //this is pos ready for Purchasing approval
		
		zwStatusMsg("APPROVAL"; "Locating Purchase Orders To Approve")
		qryPO2Approve
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1; >)  //• cs 9/9/97 [PURCHASE_ORDER]Status;< - problem with sorts - try this 
		
	Else 
		uClearSelection(->[Purchase_Orders:11])
End case 

$0:=Records in selection:C76([Purchase_Orders:11])