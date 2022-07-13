//%attributes = {}
// ----------------------------------------------------
// Method: RM_PostReceipts   ( ) ->
// By: Mel Bohince @ 03/02/16, 13:52:19
// Description
// rewrite sPostReceipts so transaction cancel isn't all or nothing for the separate transactions
// by saving the transaction immediately, then have a stored procedure, RM_PostReceipt_SP, finishing 
// the post, repeating until record locks are resolved
// ----------------------------------------------------

C_LONGINT:C283($i; $winRef; $numToPost; $numRM; $poItem; $numRMG)
C_BOOLEAN:C305($success)


$winRef:=NewWindow(300; 400; 6; Pop up window:K34:14; "Posting Receipts")

$numToPost:=Size of array:C274(aRMCode)  //upr1427 2/9/95
uThermoInit($numToPost; "Sending RM Transactions for Posting")
For ($i; 1; $numToPost)
	
	
	CREATE RECORD:C68([Raw_Materials_Transactions:23])
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=aRMCode{$i}
	[Raw_Materials_Transactions:23]Xfer_Type:2:="Receipt"
	[Raw_Materials_Transactions:23]Xfer_State:33:="Pending"
	[Raw_Materials_Transactions:23]XferDate:3:=dDate
	[Raw_Materials_Transactions:23]POItemKey:4:=aRMPONum{$i}+aRMPOItem{$i}
	[Raw_Materials_Transactions:23]Qty:6:=uNANCheck(aRMSTKQty{$i})
	[Raw_Materials_Transactions:23]UnitPrice:7:=aRMPOPrice{$i}
	[Raw_Materials_Transactions:23]POQty:8:=aRMPOQty{$i}
	[Raw_Materials_Transactions:23]ActCost:9:=uNANCheck(aRMStdPrice{$i})
	[Raw_Materials_Transactions:23]ActExtCost:10:=uNANCheck(Round:C94(aRMSTKQty{$i}*aRMStdPrice{$i}; 2))
	[Raw_Materials_Transactions:23]Location:15:=aRMBinNo{$i}
	[Raw_Materials_Transactions:23]viaLocation:11:="VENDOR"
	[Raw_Materials_Transactions:23]ReceivingNum:23:=aRMRecNo{$i}
	[Raw_Materials_Transactions:23]zCount:16:=1
	[Raw_Materials_Transactions:23]ModDate:17:=4D_Current_date
	[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
	SAVE RECORD:C53([Raw_Materials_Transactions:23])
	
	$recnum:=Record number:C243([Raw_Materials_Transactions:23])
	If ($recnum>=0)
		MESSAGE:C88(aRMCode{$i}+" POI: "+aRMPONum{$i}+"."+aRMPOItem{$i}+" posted\r")
	End if 
	UNLOAD RECORD:C212([Raw_Materials_Transactions:23])
	
	uThermoUpdate($i)
End for 
uThermoClose

CLOSE WINDOW:C154($winRef)

