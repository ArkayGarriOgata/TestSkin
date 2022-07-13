//%attributes = {}
//Method:  FGLc_Adjust_LocationChangeB(ptChanged)=>bChangeOccurred
//Description:  This method will tell when a change occurred

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $ptChanged)
	C_BOOLEAN:C305($0; $bChangeOccurred)
	
	C_LONGINT:C283($nLocation; $nNumberOfLocations)
	
	C_LONGINT:C283($nNumberToDelete)
	C_LONGINT:C283($nNumberOfQuantities)
	
	C_TEXT:C284($tChangeDelete)
	C_TEXT:C284($tChangeQuantity)
	
	$ptChanged:=$1
	$bChangeOccurred:=False:C215
	
	$nNumberOfLocations:=Size of array:C274(FGLc_abLoc_Delete)
	
	$nNumberToDelete:=0
	$nNumberOfQuantities:=0
	
	$tChangeDelete:=CorektBlank
	$tChangeQuantity:=CorektBlank
	
End if   //Done Initialize

For ($nLocation; 1; $nNumberOfLocations)  //Loop thru locations
	
	Case of   //Change
			
		: (FGLc_abLoc_Delete{$nLocation})  //Delete
			
			$bChangeOccurred:=True:C214
			$nNumberToDelete:=$nNumberToDelete+1
			
			If ($nNumberToDelete=1)
				$tChangeDelete:="Deleting "+String:C10($nNumberToDelete)+" location."
			Else 
				$tChangeDelete:="Deleting "+String:C10($nNumberToDelete)+" locations."
			End if 
			
		: (FGLc_anLoc_Qty{$nLocation}#FGLc_anLoc_OriginalQty{$nLocation})  //Qty Changed
			
			$bChangeOccurred:=True:C214
			$nNumberOfQuantities:=$nNumberOfQuantities+1
			
			If ($nNumberOfQuantities=1)
				$tChangeQuantity:="Quantity from "+String:C10(FGLc_anLoc_OriginalQty{$nLocation})+" to "+String:C10(fGLc_anLoc_Qty{$nLocation})+"."
			Else 
				$tChangeQuantity:="Changing "+String:C10($nNumberOfQuantities)+" quantities."
			End if 
			
	End case   //Done change
	
End for   //Done looping thru locations

$ptChanged->:=Choose:C955(($tChangeDelete#CorektBlank); \
$tChangeDelete+CorektCR; \
CorektBlank)

$ptChanged->:=$ptChanged->+\
Choose:C955(($tChangeQuantity#CorektBlank); \
$tChangeQuantity; \
CorektBlank)

$0:=$bChangeOccurred
