//%attributes = {"publishedWeb":true}
//(p) PoOneApprove `
//approves ONE Po
//• 6/4/97 cs created
//$1 [Purchase order]PoNo
//$2 string (optional) anything - Flag this is a requistion approval or odd reques
//  '*' - requistion aproval,  'V' - override on managerial approval
//  this will stop problem of purchasing people approving a requisiton
//• 7/2/97 cs stopped auto check of $ value for Manger Approval
//• 7/14/98 cs added update of new mod tracker
//mlb 021606 add [PURCHASE_ORDER]DateApproved

C_TEXT:C284($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($0)  //not used, here for backward compatibility  `$OverRun:=False

$0:=False:C215  //$OverRun  `return - was there an overrun/error

If ([Purchase_Orders:11]PONo:1#$1)  //make sure the correct record is in hand
	QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1=$1)
End if 

SET QUERY DESTINATION:C396(Into variable:K19:4; $missingExpCode)  // • mel (10/27/04, 14:12:41) don't change the selection
QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=$1; *)
QUERY:C277([Purchase_Orders_Items:12];  & ; [Purchase_Orders_Items:12]ExpenseCode:47="")
SET QUERY DESTINATION:C396(Into current selection:K19:1)

RELATE MANY:C262([Purchase_Orders:11]PONo:1)

Case of 
	: (Records in selection:C76([Purchase_Orders_Items:12])=0)
		BEEP:C151
		[Purchase_Orders:11]StatusTrack:51:="PO "+[Purchase_Orders:11]PONo:1+" has no line items."+Char:C90(13)+"Po was NOT moved to Approved status."+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
		[Purchase_Orders:11]Status:15:=Old:C35([Purchase_Orders:11]Status:15)
		ADD TO SET:C119([Purchase_Orders:11]; "problemApproving")
		
	: ($missingExpCode#0)
		[Purchase_Orders:11]StatusTrack:51:="PO "+[Purchase_Orders:11]PONo:1+" has "+String:C10(Records in selection:C76([Purchase_Orders_Items:12]))+" Items which have No expense code."+Char:C90(13)+"Po was NOT moved to Approved status."+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
		[Purchase_Orders:11]Status:15:=Old:C35([Purchase_Orders:11]Status:15)
		ADD TO SET:C119([Purchase_Orders:11]; "problemApproving")
		
		//: ([Purchase_Orders]PurchaseApprv)
		//already aprvd, don't change initials
		//ADD TO SET([Purchase_Orders];"problemApproving")
		
	: (Count parameters:C259=2)  //requistion approval
		Case of 
			: ($2="V")
				[Purchase_Orders:11]Status:15:="Approved"
				[Purchase_Orders:11]PurchaseApprv:44:=True:C214
				[Purchase_Orders:11]ApprovedBy:26:=<>zResp
				[Purchase_Orders:11]DateApproved:56:=4D_Current_date
			Else 
				//$OverRun:=BudgetAddPO ([PURCHASE_ORDER]PONo;"*")
				If (User in group:C338(Current user:C182; "Req_Approval"))
					[Purchase_Orders:11]Status:15:="Req Approved"
				Else 
					If (User in group:C338(Current user:C182; "Req_PreApproval"))
						[Purchase_Orders:11]Status:15:="Requisition"  //was "Requisition" mlb 072303
					End if 
				End if 
		End case 
		
	: (User in group:C338(Current user:C182; "PO_Approval_Mgr"))  //Management approval
		[Purchase_Orders:11]Status:15:="Approved"
		[Purchase_Orders:11]PurchaseApprv:44:=True:C214
		[Purchase_Orders:11]ApprovedBy:26:=<>zResp
		[Purchase_Orders:11]DateApproved:56:=4D_Current_date
		
	: (User in group:C338(Current user:C182; "PO_Approval"))  //purchasing approval
		[Purchase_Orders:11]Status:15:="Approved"
		[Purchase_Orders:11]ApprovedBy:26:=<>zResp
		[Purchase_Orders:11]PurchaseApprv:44:=True:C214
		[Purchase_Orders:11]DateApproved:56:=4D_Current_date
End case 

If ([Purchase_Orders:11]Status:15#Old:C35([Purchase_Orders:11]Status:15))
	[Purchase_Orders:11]StatusBy:16:=<>zResp
	[Purchase_Orders:11]StatusDate:17:=4D_Current_date
	//• 7/14/98 cs angelo wants to be able to track every thing
	[Purchase_Orders:11]StatusTrack:51:=[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
	gUpdRMLastPurch
	
Else 
	[Purchase_Orders:11]StatusTrack:51:="Status Not Changed: "+[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
	BEEP:C151
End if 

If (fSavePO)
	PO_SaveRecord("save")
End if 