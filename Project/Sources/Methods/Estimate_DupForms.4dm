//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/26/06, 10:57:35
// ----------------------------------------------------
// Method: Estimate_DupForms
// ----------------------------------------------------

C_TEXT:C284($oldDiffID; $1; $newDiffID; $2; $3)
C_LONGINT:C283($item; $collectionSize)

$oldDiffID:=$1
$newDiffID:=$2

QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]DiffId:1=$oldDiffID)
$collectionSize:=Records in selection:C76([Estimates_DifferentialsForms:47])
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	CREATE SET:C116([Estimates_DifferentialsForms:47]; "dupingSet")
	
	
	For ($item; 1; $collectionSize)
		USE SET:C118("dupingSet")
		GOTO SELECTED RECORD:C245([Estimates_DifferentialsForms:47]; $item)
		DUPLICATE RECORD:C225([Estimates_DifferentialsForms:47])
		[Estimates_DifferentialsForms:47]pk_id:37:=Generate UUID:C1066
		[Estimates_DifferentialsForms:47]DiffFormId:3:=$newDiffID+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
		[Estimates_DifferentialsForms:47]DiffId:1:=$newDiffID
		If (Count parameters:C259=3)
			[Estimates_DifferentialsForms:47]ProcessSpec:23:=$3
		End if 
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_DifferentialsForms]z_SYNC_ID;->[Estimates_DifferentialsForms]z_SYNC_DATA)
		SAVE RECORD:C53([Estimates_DifferentialsForms:47])
	End for 
	
	CLEAR SET:C117("dupingSet")
Else 
	//reduce line 22 23 18 35
	ARRAY LONGINT:C221($_dupingSet; 0)
	LONGINT ARRAY FROM SELECTION:C647([Estimates_DifferentialsForms:47]; $_dupingSet)
	For ($item; 1; $collectionSize)
		GOTO RECORD:C242([Estimates_DifferentialsForms:47]; $_dupingSet{$item})
		DUPLICATE RECORD:C225([Estimates_DifferentialsForms:47])
		[Estimates_DifferentialsForms:47]pk_id:37:=Generate UUID:C1066
		[Estimates_DifferentialsForms:47]DiffFormId:3:=$newDiffID+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
		[Estimates_DifferentialsForms:47]DiffId:1:=$newDiffID
		If (Count parameters:C259=3)
			[Estimates_DifferentialsForms:47]ProcessSpec:23:=$3
		End if 
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_DifferentialsForms]z_SYNC_ID;->[Estimates_DifferentialsForms]z_SYNC_DATA)
		SAVE RECORD:C53([Estimates_DifferentialsForms:47])
	End for 
	
End if   // END 4D Professional Services : January 2019 


