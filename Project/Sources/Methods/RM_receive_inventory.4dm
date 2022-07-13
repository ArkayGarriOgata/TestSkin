//%attributes = {}
// ----------------------------------------------------
// Method: RM_receive_inventory   ( ) ->success

// By: Mel Bohince @ 03/02/16, 14:00:48
// Description
// receive normal inventory
// ----------------------------------------------------
C_BOOLEAN:C305($0)
$0:=True:C214

$po:=Substring:C12([Raw_Materials_Transactions:23]POItemKey:4; 1; 7)
If (SupplyChain_BinManager("material-at-vendor?"; $po)="YES")
	$recno:=Record number:C243([Raw_Materials_Transactions:23])  //push, new transaction will be created
	$costToApply:=Abs:C99(Num:C11(SupplyChain_BinManager("relieve-material-at-vendor"; $po)))  // /2/6/12abs the cost so that unit add-on works
	GOTO RECORD:C242([Raw_Materials_Transactions:23]; $recno)  //pop
Else 
	$costToApply:=0
End if 
$costToApplyPerUnit:=0  //base this on the count being received write now.

QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1=[Raw_Materials_Transactions:23]Raw_Matl_Code:1; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=[Raw_Materials_Transactions:23]Location:15; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]POItemKey:19=[Raw_Materials_Transactions:23]POItemKey:4)
If (Records in selection:C76([Raw_Materials_Locations:25])=0)
	RM_PostReceiptNewBin
Else 
	If (Not:C34(fLockNLoad(->[Raw_Materials_Locations:25])))  //screw it, make another
		RM_PostReceiptNewBin
	End if 
End if   //bin exists

[Raw_Materials_Locations:25]ActCost:18:=[Raw_Materials_Transactions:23]ActCost:9
If (Not:C34([Raw_Materials_Transactions:23]consignment:27))
	[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9+[Raw_Materials_Transactions:23]POQty:8
	[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyAvailable:13+[Raw_Materials_Transactions:23]POQty:8
Else 
	[Raw_Materials_Locations:25]ConsignmentQty:26:=[Raw_Materials_Locations:25]ConsignmentQty:26+[Raw_Materials_Transactions:23]POQty:8
End if 

SAVE RECORD:C53([Raw_Materials_Locations:25])


RM_PostReceiptPOupdate

If ($costToApply>0)  //add-in the cost to the bins unit cost so issues will get the bucks
	$costToApplyPerUnit:=Num:C11(SupplyChain_BinManager("unit-cost-add-on"; String:C10($costToApply); [Raw_Materials_Locations:25]POItemKey:19))
End if 

If (Substring:C12([Raw_Materials_Transactions:23]Commodity_Key:22; 1; 2)="01")  //receiving board
	RM_MillRelieveInventory([Raw_Materials_Transactions:23]POItemKey:4; [Raw_Materials_Transactions:23]POQty:8; Record number:C243([Raw_Materials_Transactions:23]))
End if 

// Modified by: Mel Bohince (2/14/17) 
If ([Raw_Materials_Groups:22]Commodity_Code:1=1) | ([Raw_Materials_Groups:22]Commodity_Code:1=20)  // Modified by: Mel Bohince (2/23/16) direct purchase of sheet initiative, (7/22/16 comm 20 added
	
	QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Raw_Materials_Transactions:23]POItemKey:4; *)
	QUERY:C277([Purchase_Orders_Job_forms:59];  & ; [Purchase_Orders_Job_forms:59]JobFormID:2#"")
	If (Records in selection:C76([Purchase_Orders_Job_forms:59])>0)
		$success:=JML_setStockReceivedSheeted([Purchase_Orders_Job_forms:59]JobFormID:2; [Purchase_Orders_Items:12]UM_Arkay_Issue:28)
		If (Not:C34($success))
			//uCancelTran
			$body:="Job Master Log record for "+[Purchase_Orders_Job_forms:59]JobFormID:2+" was locked at the time of Stock receipt. Please set the date manually so schedules show green."
			$from:=Email_WhoAmI
			distributionList:=Batch_GetDistributionList(""; "PROD")
			$subject:="Stock Received Not Set for "+[Purchase_Orders_Job_forms:59]JobFormID:2
			EMAIL_Sender($subject; ""; $body; distributionList; ""; $from; $from)
		End if 
	End if   //job assigned to po
End if   //comm=1


