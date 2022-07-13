//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/26/06, 11:30:00
// ----------------------------------------------------
// Method: Estimate_DupFormCartons

// ----------------------------------------------------

C_TEXT:C284($oldDiffID; $1; $newDiffID; $2)
C_LONGINT:C283($item; $collectionSize; $hit)

$oldDiffID:=$1
$newDiffID:=$2
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$oldDiffID+"@")
	$collectionSize:=Records in selection:C76([Estimates_FormCartons:48])
	CREATE SET:C116([Estimates_FormCartons:48]; "dupingSet")
	
	For ($item; 1; $collectionSize)
		
		USE SET:C118("dupingSet")
		GOTO SELECTED RECORD:C245([Estimates_FormCartons:48]; $item)
		DUPLICATE RECORD:C225([Estimates_FormCartons:48])
		[Estimates_FormCartons:48]pk_id:18:=Generate UUID:C1066
		$hit:=Find in array:C230(aOldCspec; [Estimates_FormCartons:48]Carton:1)  //•111495  MLB  UPR ralph
		[Estimates_FormCartons:48]Carton:1:=aNewCspec{$hit}  //store key to this new reocrd-establish link.
		[Estimates_FormCartons:48]DiffFormID:2:=$newDiffID+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 12)
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_FormCartons]_SYNC_ID;->[Estimates_FormCartons]_SYNC_DATA)
		SAVE RECORD:C53([Estimates_FormCartons:48])
	End for 
	CLEAR SET:C117("dupingSet")
	
Else 
	//reduce line 22 and 23 on the loop
	
	ARRAY LONGINT:C221($_dupingSet; 0)
	
	QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=$oldDiffID+"@")
	$collectionSize:=Records in selection:C76([Estimates_FormCartons:48])
	LONGINT ARRAY FROM SELECTION:C647([Estimates_FormCartons:48]; $_dupingSet)
	For ($item; 1; $collectionSize)
		GOTO RECORD:C242([Estimates_FormCartons:48]; $_dupingSet{$item})
		DUPLICATE RECORD:C225([Estimates_FormCartons:48])
		[Estimates_FormCartons:48]pk_id:18:=Generate UUID:C1066
		$hit:=Find in array:C230(aOldCspec; [Estimates_FormCartons:48]Carton:1)  //•111495  MLB  UPR ralph
		[Estimates_FormCartons:48]Carton:1:=aNewCspec{$hit}  //store key to this new reocrd-establish link.
		[Estimates_FormCartons:48]DiffFormID:2:=$newDiffID+Substring:C12([Estimates_FormCartons:48]DiffFormID:2; 12)
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_FormCartons]_SYNC_ID;->[Estimates_FormCartons]_SYNC_DATA)
		SAVE RECORD:C53([Estimates_FormCartons:48])
	End for 
	
	
End if   // END 4D Professional Services : January 2019 


