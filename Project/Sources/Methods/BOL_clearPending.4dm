//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 02/04/13, 13:48:01
// ----------------------------------------------------
// Method: BOL_clearPending
// Description
// sometimes network interuption loses BOL before saving but after it has been
//    marked as pending on the release and bin; therefore, need user interface to
//    clear this condition
// ----------------------------------------------------

C_BOOLEAN:C305($preRel; $preBin)
ARRAY LONGINT:C221($rel_bols; 0)
ARRAY LONGINT:C221($fgl_bols; 0)
ARRAY LONGINT:C221($missing; 0)

$preRel:=Read only state:C362([Customers_ReleaseSchedules:46])
$preBin:=Read only state:C362([Finished_Goods_Locations:35])

READ WRITE:C146([Customers_ReleaseSchedules:46])
READ WRITE:C146([Finished_Goods_Locations:35])

uConfirm("Look for pending BOL's in Releases and Inventory that have been orphaned?"; "OK"; "Cancel")
If (OK=1)
	//look for candidates in releases
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]B_O_L_pending:45#0)
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]B_O_L_pending:45; $rel_bols)
	End if 
	
	//look for candidates in bins
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BOL_Pending:31#0)
	If (Records in selection:C76([Finished_Goods_Locations:35])>0)
		DISTINCT VALUES:C339([Finished_Goods_Locations:35]BOL_Pending:31; $fgl_bols)
	End if 
	
	//combine
	For ($i; 1; Size of array:C274($fgl_bols))
		$hit:=Find in array:C230($rel_bols; $fgl_bols{$i})
		If ($hit<0)
			APPEND TO ARRAY:C911($rel_bols; $fgl_bols{$i})
		End if 
	End for 
	
	//check to see if the BOL is missing
	For ($i; 1; Size of array:C274($rel_bols))
		QUERY:C277([Customers_Bills_of_Lading:49]; [Customers_Bills_of_Lading:49]ShippersNo:1=$rel_bols{$i})
		If (Records in selection:C76([Customers_Bills_of_Lading:49])=0)
			APPEND TO ARRAY:C911($missing; $rel_bols{$i})
		End if 
	End for 
	
	//clear out the orphans
	If (Size of array:C274($missing)>0)
		
		For ($i; 1; Size of array:C274($missing))
			uConfirm("Clear out missing BOL# "+String:C10($missing{$i}); "Clear"; "Skip")
			If (OK=1)
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]B_O_L_pending:45=$missing{$i})
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]B_O_L_pending:45:=0)
				End if 
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BOL_Pending:31=$missing{$i})
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]BOL_Pending:31:=0)
				End if 
			End if 
			
		End for 
		
	Else 
		uConfirm("Doesn't appear to be a missing BOL referenced in bins or releases."; "OK"; "Help")
	End if 
	
End if 

If ($preRel)
	READ WRITE:C146([Customers_ReleaseSchedules:46])
End if 
If ($preBin)
	READ WRITE:C146([Finished_Goods_Locations:35])
End if 