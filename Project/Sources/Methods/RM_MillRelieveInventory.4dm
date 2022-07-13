//%attributes = {"publishedWeb":true}
//PM: RM_MillRelieveInventory(poitem;qtyReceived) -> 
//@author mlb - 7/9/02  16:30

C_TEXT:C284($poitem; $1)
C_LONGINT:C283($qty; $2; $xferRecord; $3)

$poitem:=$1
$qty:=$2
$xferRecord:=$3

//*handle releases if they exist
READ WRITE:C146([Purchase_Orders_Releases:79])
QUERY:C277([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]POitemKey:1=$poitem; *)
QUERY:C277([Purchase_Orders_Releases:79];  & ; [Purchase_Orders_Releases:79]Actual_Qty:6=0)
If (Records in selection:C76([Purchase_Orders_Releases:79])>0)
	ORDER BY:C49([Purchase_Orders_Releases:79]; [Purchase_Orders_Releases:79]RelNumber:4; >)
	[Purchase_Orders_Releases:79]Actual_Date:5:=4D_Current_date
	[Purchase_Orders_Releases:79]Actual_Qty:6:=$qty
	SAVE RECORD:C53([Purchase_Orders_Releases:79])
End if 
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Purchase_Orders_Releases:79])
	REDUCE SELECTION:C351([Purchase_Orders_Releases:79]; 0)
	
Else 
	
	REDUCE SELECTION:C351([Purchase_Orders_Releases:79]; 0)
	
End if   // END 4D Professional Services : January 2019 

//*handle any mill inventory if it exists
$bin:=Vend_getPrefixInitials($poitem)
UNLOAD RECORD:C212([Vendors:7])

READ WRITE:C146([Raw_Materials_Locations:25])
QUERY:C277([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]POItemKey:19=$poitem; *)
QUERY:C277([Raw_Materials_Locations:25];  & ; [Raw_Materials_Locations:25]Location:2=$bin)
If (Records in selection:C76([Raw_Materials_Locations:25])=1)
	[Raw_Materials_Locations:25]ModDate:21:=4D_Current_date
	[Raw_Materials_Locations:25]ModWho:22:=<>zResp
	[Raw_Materials_Locations:25]QtyOH:9:=[Raw_Materials_Locations:25]QtyOH:9-$qty
	[Raw_Materials_Locations:25]QtyAvailable:13:=[Raw_Materials_Locations:25]QtyOH:9
	SAVE RECORD:C53([Raw_Materials_Locations:25])
	
	If ([Raw_Materials_Locations:25]QtyOH:9<=0) & (Not:C34([Raw_Materials_Locations:25]PiDoNotDelete:24))
		DELETE RECORD:C58([Raw_Materials_Locations:25])
	End if 
	
	GOTO RECORD:C242([Raw_Materials_Transactions:23]; $xferRecord)
	[Raw_Materials_Transactions:23]viaLocation:11:=$bin
	SAVE RECORD:C53([Raw_Materials_Transactions:23])
	
End if 
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
	
	UNLOAD RECORD:C212([Raw_Materials_Locations:25])
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
Else 
	
	REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
	
End if   // END 4D Professional Services : January 2019 

