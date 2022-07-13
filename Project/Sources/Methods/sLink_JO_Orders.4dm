//%attributes = {"publishedWeb":true}
//sLink_JO_Orders()        ---JML-9/15/93
//array prcoedure script in ORder arrays of the 
//layout [control];Link_Js_to_Os"
C_BOOLEAN:C305($Continue)
$Continue:=False:C215  // tells us to move on to next selected item.


If (vViaWho="FromOrders")  //that means this is known array
	If (vOldOrdItem#asOProdCode)  //line has changed    
		If (vLinkDirty)
			CONFIRM:C162("Links have been defined but not saved."+"  Do you wish to discard these links?")
			If (OK#1)
				$Continue:=False:C215
				asOProdCode:=vOldOrdItem
			Else   //user wants to ignore all those changes
				$Continue:=True:C214
				vLinkDirty:=False:C215
			End if 
		Else   //no links were specified
			$Continue:=True:C214
		End if 
	Else   //line has not changed 
		$Continue:=False:C215
	End if 
	If (vLinkDirty & $Continue)  //update data  records
		vLinkDirty:=False:C215
		//need to update all the jobmakesitems records
		$numrec:=Records in selection:C76([Job_Forms_Items:44])
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
			
			FIRST RECORD:C50([Job_Forms_Items:44])
			For ($X; 1; $numrec)
				If (asJOrderID{asJOrderID}#[Job_Forms_Items:44]OrderItem:2)  //then we need to save this change
					[Job_Forms_Items:44]OrderItem:2:=asJOrderID{asJOrderID}
					SAVE RECORD:C53([Job_Forms_Items:44])
				End if 
				NEXT RECORD:C51([Job_Forms_Items:44])
			End for 
			
		Else 
			
			// laghzaoui replace first and next and modifier by apply and selection
			ARRAY LONGINT:C221($_record_final; 0)
			ARRAY LONGINT:C221($_Job_Forms_Items; 0)
			ARRAY TEXT:C222($_OrderItem; 0)
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]; $_Job_Forms_Items; \
				[Job_Forms_Items:44]OrderItem:2; $_OrderItem)
			
			For ($X; 1; $numrec)
				If (asJOrderID{asJOrderID}#$_OrderItem{$X})  //then we need to save this change
					
					APPEND TO ARRAY:C911($_record_final; $_Job_Forms_Items{$X})
					
				End if 
			End for 
			
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_record_final)
			APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2:=asJOrderID{asJOrderID})
			CREATE SELECTION FROM ARRAY:C640([Job_Forms_Items:44]; $_Job_Forms_Items)
			
		End if   // END 4D Professional Services : January 2019 
		
	End if 
	If ($Continue)  //move  to next array element    
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=asOProdCode{asOProdCode}; *)
		QUERY:C277([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]OrderItem:2=asOOrderID{asOOrderID})
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]OrderItem:2; asJOrderID; [Job_Forms_Items:44]ProductCode:3; asJProdCode; [Job_Forms_Items:44]Qty_Yield:9; asJQty)
		vOldJobItem:=0
		
	End if 
	
Else   //This is unknown array, so we want to toggle ORderline value.
	asJOrderID{asJOrderID}:=asOOrderID{asOORderID}
End if 

vOldOrdItem:=asOProdCode
asOOrderID:=vOldOrdItem
asOQtyOpen:=vOldOrdItem
