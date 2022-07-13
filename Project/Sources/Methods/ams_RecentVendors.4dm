//%attributes = {"publishedWeb":true}
//PM: ams_RecentVendors() -> 
//@author mlb - 7/3/02  11:55
//find poitem that should stay, then the vendors releated to these

C_TEXT:C284($inventory_RecentSet; $receipts_RecentSet; $poi_RecentSet)
C_DATE:C307($receiptCutOffDate; $poiCutOffDate; $1)

If (Count parameters:C259=0)
	<>cutOffDate1:=Date:C102(Request:C163("What's the cutoff date?"; String:C10(Add to date:C393(Current date:C33; -1; 0; 0)); "Continue"; "Cancel"))
	If (OK=1)
		If (<>cutOffDate1<(Add to date:C393(Current date:C33; 0; -6; 0)))
			CONFIRM:C162("Delete in-actives?"; "No"; "Delete")
			If (OK=0)
				$delete:=True:C214
			Else 
				$delete:=False:C215
			End if 
			OK:=1
			
		Else 
			$delete:=False:C215
		End if 
	End if 
	
Else   //original call
	OK:=1
	$delete:=False:C215
End if 

If (OK=1)
	$receiptCutOffDate:=$1  //keep 1 plus current
	$poiCutOffDate:=$1  //keep 1 plus current
	
	MESSAGES OFF:C175
	If (<>fContinue)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			$inventory_RecentSet:=ams_RecentRMInventory("all")
			USE SET:C118($inventory_RecentSet)
			ARRAY TEXT:C222($aHasInventory; 0)
			DISTINCT VALUES:C339([Raw_Materials_Locations:25]POItemKey:19; $aHasInventory)
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			$inventory_RecentSet:=ams_RecentRMInventory  //clear set
			
		Else 
			
			ALL RECORDS:C47([Raw_Materials_Locations:25])
			ARRAY TEXT:C222($aHasInventory; 0)
			DISTINCT VALUES:C339([Raw_Materials_Locations:25]POItemKey:19; $aHasInventory)
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
	
	If (<>fContinue)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			$receipts_RecentSet:=ams_RecentRMxfers($receiptCutOffDate)
			USE SET:C118($receipts_RecentSet)
			ARRAY TEXT:C222($aHasReceipts; 0)
			DISTINCT VALUES:C339([Raw_Materials_Transactions:23]POItemKey:4; $aHasReceipts)
			REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
			$receipts_RecentSet:=ams_RecentRMxfers  //clear set
			
		Else 
			
			QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]XferDate:3>=$receiptCutOffDate; *)
			QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Receipt")
			ARRAY TEXT:C222($aHasReceipts; 0)
			DISTINCT VALUES:C339([Raw_Materials_Transactions:23]POItemKey:4; $aHasReceipts)
			REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
	
	If (<>fContinue)
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			$poi_RecentSet:=ams_RecentRMpurchases($poiCutOffDate)
			USE SET:C118($poi_RecentSet)
			ARRAY TEXT:C222($aHasPOI; 0)
			DISTINCT VALUES:C339([Purchase_Orders_Items:12]POItemKey:1; $aHasPOI)
			REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
			$poi_RecentSet:=ams_RecentRMpurchases  //clear set
			
		Else 
			
			QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40>=$poiCutOffDate)
			ARRAY TEXT:C222($aHasPOI; 0)
			DISTINCT VALUES:C339([Purchase_Orders_Items:12]POItemKey:1; $aHasPOI)
			REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End if 
	
	If (<>fContinue)
		ARRAY TEXT:C222($aPOI; (Size of array:C274($aHasInventory)+Size of array:C274($aHasReceipts)+Size of array:C274($aHasPOI)))
		$poiCursor:=0
		
		For ($i; 1; Size of array:C274($aHasInventory))
			$hit:=Find in array:C230($aPOI; $aHasInventory{$i})
			If ($hit=-1)
				$poiCursor:=$poiCursor+1
				$aPOI{$poiCursor}:=$aHasInventory{$i}
			End if 
		End for 
		
		For ($i; 1; Size of array:C274($aHasReceipts))
			$hit:=Find in array:C230($aPOI; $aHasReceipts{$i})
			If ($hit=-1)
				$poiCursor:=$poiCursor+1
				$aPOI{$poiCursor}:=$aHasReceipts{$i}
			End if 
		End for 
		
		For ($i; 1; Size of array:C274($aHasPOI))
			$hit:=Find in array:C230($aPOI; $aHasPOI{$i})
			If ($hit=-1)
				$poiCursor:=$poiCursor+1
				$aPOI{$poiCursor}:=$aHasPOI{$i}
			End if 
		End for 
		
		zwStatusMsg("RECENT VENDORS"; "Finding PO Items")
		ARRAY TEXT:C222($aPOI; $poiCursor)
		READ ONLY:C145([Purchase_Orders_Items:12])
		QUERY WITH ARRAY:C644([Purchase_Orders_Items:12]POItemKey:1; $aPOI)
		
		zwStatusMsg("RECENT VENDORS"; "Initiating Vendor Active Flag")
		READ WRITE:C146([Vendors:7])
		ALL RECORDS:C47([Vendors:7])
		APPLY TO SELECTION:C70([Vendors:7]; [Vendors:7]Active:15:=False:C215)
		
		zwStatusMsg("RECENT VENDORS"; "Setting Vendor Active Flag")
		RELATE ONE SELECTION:C349([Purchase_Orders_Items:12]; [Vendors:7])
		APPLY TO SELECTION:C70([Vendors:7]; [Vendors:7]Active:15:=True:C214)
		
		If ($delete)
			QUERY:C277([Vendors:7]; [Vendors:7]Active:15=False:C215)
			util_DeleteSelection(->[Vendors:7])  //cut off the head and the body will die
		End if 
	End if 
End if 