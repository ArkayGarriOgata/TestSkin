//%attributes = {"publishedWeb":true,"executedOnServer":true}
//PM:  Batch_PO_Completeness  092499  mlb
//set the percent receive against total ordered
//disregard those that are already at least 100%
//072809 mlb set no lines, no ord qty to onhold, remove 80% rule for full receipt

C_LONGINT:C283($i; $numPO; $j; $complete)
C_REAL:C285($ordered; $received)

MESSAGES OFF:C175
READ WRITE:C146([Purchase_Orders:11])
READ ONLY:C145([Purchase_Orders_Items:12])
READ ONLY:C145([Raw_Materials_Transactions:23])

QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15#"Closed"; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]Status:15#"Can@"; *)
QUERY:C277([Purchase_Orders:11];  & ; [Purchase_Orders:11]Status:15#"Full@")
$numPO:=Records in selection:C76([Purchase_Orders:11])
uThermoInit($numPO; "Checking PO Completeness")
utl_Trace

For ($i; 1; $numPO)
	$ordered:=0
	$received:=0
	$xfers:=0
	$complete:=0
	$qty_still_open:=0
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PONo:2=[Purchase_Orders:11]PONo:1)  //$aPOid{$i})
	If (Records in selection:C76([Purchase_Orders_Items:12])>0)
		SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Qty_Received:14; aPOQty; [Purchase_Orders_Items:12]FactNship2cost:29; arNum1; [Purchase_Orders_Items:12]FactDship2cost:37; arDenom1; [Purchase_Orders_Items:12]Canceled:44; $aCancelled; [Purchase_Orders_Items:12]Qty_Ordered:30; $aOrdered; [Purchase_Orders_Items:12]Qty_Open:27; $aOpen)
		For ($j; 1; Size of array:C274(aPOQty))
			If (Not:C34($aCancelled{$j}))
				$ordered:=$ordered+$aOrdered{$j}
				If (arNum1{$j}#0)
					$received:=$received+(aPOQty{$j}*arDenom1{$j}/arNum1{$j})
				End if 
				$qty_still_open:=$qty_still_open+$aOpen{$j}
			End if 
		End for 
		ARRAY REAL:C219(aPOQty; 0)
		ARRAY REAL:C219(arNum1; 0)
		ARRAY REAL:C219(arDenom1; 0)
		ARRAY REAL:C219($aOrdered; 0)
		ARRAY BOOLEAN:C223($aCancelled; 0)
		ARRAY REAL:C219($aOpen; 0)
		
		QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]POItemKey:4=([Purchase_Orders:11]PONo:1+"@"); *)
		QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
		If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
			$xfers:=Sum:C1([Raw_Materials_Transactions:23]Qty:6)
			If ($xfers>$received)
				$received:=$xfers
			End if 
		End if 
		
		If ($ordered#0)  //!div/0
			$complete:=Round:C94(($received/$ordered*100); 0)
			Case of 
				: ($qty_still_open<=0)
					$status:="Full Receipt"
				: ($complete>95)
					$status:="PARTIAL Receipt"
				: ($complete>0)
					$status:="Partial Receipt"
				Else 
					$status:=""
			End case 
			
		Else 
			$complete:=0
			$status:="On Hold"
		End if   //!div/0
		
	Else   //no items
		$ordered:=0
		$status:="On Hold"
	End if   //items
	
	If ($status#"")
		If ([Purchase_Orders:11]Status:15#"Closed") & ([Purchase_Orders:11]Status:15#"Cancel@") & ([Purchase_Orders:11]Status:15#"Full@")
			[Purchase_Orders:11]Status:15:=$status
		End if 
	End if 
	
	If ([Purchase_Orders:11]PercentComplete:52#$complete)
		[Purchase_Orders:11]PercentComplete:52:=$complete
	End if 
	
	If ([Purchase_Orders:11]Status:15#Old:C35([Purchase_Orders:11]Status:15)) | ([Purchase_Orders:11]PercentComplete:52#Old:C35([Purchase_Orders:11]PercentComplete:52))
		SAVE RECORD:C53([Purchase_Orders:11])
	End if 
	
	uThermoUpdate($i)
	NEXT RECORD:C51([Purchase_Orders:11])
End for   //each po
//
utl_Trace
uThermoClose
REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)