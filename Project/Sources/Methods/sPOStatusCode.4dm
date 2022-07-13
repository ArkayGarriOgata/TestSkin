//%attributes = {"publishedWeb":true}
//(p) sPoStatusCode
//code in status popup since it exists in 2 places I wanted to place it into proc
//$1 pointer to popup menu array
//•121598  Systems G3  UPR zero out qtyopen on cancel
//•042999  MLB  UPR 1995
//•081702  mlb  UPR 1977
// • mel (10/27/04, 15:12:52) refactor

C_TEXT:C284($selectedStatus)
C_LONGINT:C283($num; $i)

//check for requirements to change status
Case of 
	: (astat=0)
		//nothing selected
	: (astat{astat}="")
		//list currently contains spaces for readablility
		
	: (astat{astat}=[Purchase_Orders:11]Status:15)
		//no change requested
		
	: (Not:C34(User in group:C338(Current user:C182; "PO_Approval")) & (Current user:C182#"Designer"))
		uConfirm("Your password does not allow you change Purchase Orders' status!"; "OK"; "Help")
		
	: (PO_ChkJobLink#0)
		uConfirm("Direct purchase items need to be linked to jobforms!"; "OK"; "Help")
		
	Else   //pre requisites have been met
		$selectedStatus:=astat{astat}
		uPOfindClauses  //make sure clauses are up to date
		sChkVendorId
		
		Case of   //change the status
			: ($selectedStatus="Approved") & ([Purchase_Orders:11]PurchaseApprv:44)  //reopening
				SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Qty_Open:27; $qtyOpen; [Purchase_Orders_Items:12]Qty_Shipping:4; $qtyOrdered; [Purchase_Orders_Items:12]Qty_Received:14; $qtyReceived)
				For ($i; 1; Size of array:C274($qtyOpen))
					$qtyOpen{$i}:=$qtyOrdered{$i}-$qtyReceived{$i}
				End for 
				ARRAY TO SELECTION:C261($qtyOpen; [Purchase_Orders_Items:12]Qty_Open:27)
				ARRAY REAL:C219($qtyOpen; 0)
				ARRAY REAL:C219($qtyOrdered; 0)
				ARRAY REAL:C219($qtyReceived; 0)
				[Purchase_Orders:11]Status:15:=$selectedStatus
				
				
			: ($selectedStatus="Approved")
				CREATE EMPTY SET:C140([Purchase_Orders:11]; "problemApproving")
				PoOneApprove([Purchase_Orders:11]PONo:1)
				CLEAR SET:C117("problemApproving")
				
			: (Position:C15("Cancel"; $selectedStatus)>0)
				//•042999  MLB  UPR 1995     
				If ([Purchase_Orders:11]Ordered:47)
					uConfirm("This PO has been 'Ordered', please contact the vendor."; "OK"; "Help")
				End if 
				
				ARRAY REAL:C219($qtyRcvd; 0)
				SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Qty_Received:14; $qtyRcvd; [Purchase_Orders_Items:12]Canceled:44; $aCancelled)
				$num:=0
				For ($i; 1; Size of array:C274($qtyRcvd))
					$num:=$num+$qtyRcvd{$i}
					$aCancelled{$i}:=True:C214
				End for 
				
				If ($num=0)
					ARRAY TO SELECTION:C261($qtyRcvd; [Purchase_Orders_Items:12]Qty_Open:27; $aCancelled; [Purchase_Orders_Items:12]Canceled:44)
					[Purchase_Orders:11]Status:15:=$selectedStatus
					[Purchase_Orders:11]PurchaseApprv:44:=False:C215
				Else 
					BEEP:C151
					ALERT:C41("Can't cancel a received PO. See UPR 1995.")
				End if 
				
			: (Position:C15("Full"; $selectedStatus)>0)
				SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Qty_Received:14; $qtyOpen)
				For ($i; 1; Size of array:C274($qtyOpen))
					$qtyOpen{$i}:=0
				End for 
				ARRAY TO SELECTION:C261($qtyOpen; [Purchase_Orders_Items:12]Qty_Open:27)
				ARRAY REAL:C219($qtyOpen; 0)
				[Purchase_Orders:11]Status:15:=$selectedStatus
				
			: ($selectedStatus="Closed")
				SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]Qty_Received:14; $qtyOpen)
				For ($i; 1; Size of array:C274($qtyOpen))
					$qtyOpen{$i}:=0
				End for 
				ARRAY TO SELECTION:C261($qtyOpen; [Purchase_Orders_Items:12]Qty_Open:27)
				ARRAY REAL:C219($qtyOpen; 0)
				[Purchase_Orders:11]Status:15:=$selectedStatus
				
			Else   //why not
				[Purchase_Orders:11]Status:15:=$selectedStatus
				//[Purchase_Orders]PurchaseApprv:=False
		End case 
		
		If ([Purchase_Orders:11]Status:15#Old:C35([Purchase_Orders:11]Status:15))
			[Purchase_Orders:11]StatusBy:16:=<>zResp
			[Purchase_Orders:11]StatusDate:17:=4D_Current_date
			//• 7/14/98 cs angelo wants to be able to track every thing
			If (Old:C35([Purchase_Orders:11]Status:15)="Approved")
				[Purchase_Orders:11]StatusTrack:51:="BACK TO "+[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
			Else 
				[Purchase_Orders:11]StatusTrack:51:=[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
			End if 
			//PO_SaveRecord ("save")
		End if 
		
End case 