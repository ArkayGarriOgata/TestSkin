//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/26/06, 11:13:56
// ----------------------------------------------------
// Method: Estimate_DupCartons
// ----------------------------------------------------

C_TEXT:C284($oldDiffID; $1; $newDiffID; $2; $3; $estimate; $oldDifferentialDesignation; $newDifferentialDesignation)
C_LONGINT:C283($item; $collectionSize)

$oldDiffID:=$1
$estimate:=Substring:C12($oldDiffID; 1; 9)
$oldDifferentialDesignation:=Substring:C12($oldDiffID; 10)
$newDiffID:=$2
$newDifferentialDesignation:=Substring:C12($newDiffID; 10)
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)  //get source cartons
	QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$oldDifferentialDesignation)
	$collectionSize:=Records in selection:C76([Estimates_Carton_Specs:19])
	CREATE SET:C116([Estimates_Carton_Specs:19]; "dupingSet")
	ARRAY TEXT:C222(aOldCspec; 0)
	ARRAY TEXT:C222(aNewCspec; 0)
	ARRAY TEXT:C222(aOldCspec; $collectionSize)
	ARRAY TEXT:C222(aNewCspec; $collectionSize)
	For ($item; 1; $collectionSize)
		USE SET:C118("dupingSet")
		GOTO SELECTED RECORD:C245([Estimates_Carton_Specs:19]; $item)
		DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
		[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
		aOldCspec{$item}:=[Estimates_Carton_Specs:19]CartonSpecKey:7
		[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
		aNewCspec{$item}:=[Estimates_Carton_Specs:19]CartonSpecKey:7
		[Estimates_Carton_Specs:19]diffNum:11:=$newDifferentialDesignation
		If (Count parameters:C259=3)
			[Estimates_Carton_Specs:19]ProcessSpec:3:=$3
		End if 
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
	End for 
	
	CLEAR SET:C117("dupingSet")
	
Else 
	//reduce line 27 and 28
	
	ARRAY LONGINT:C221($_record_number; 0)
	QUERY:C277([Estimates_Carton_Specs:19]; [Estimates_Carton_Specs:19]Estimate_No:2=$estimate; *)  //get source cartons
	QUERY:C277([Estimates_Carton_Specs:19];  & ; [Estimates_Carton_Specs:19]diffNum:11=$oldDifferentialDesignation)
	$collectionSize:=Records in selection:C76([Estimates_Carton_Specs:19])
	LONGINT ARRAY FROM SELECTION:C647([Estimates_Carton_Specs:19]; $_record_number)
	
	ARRAY TEXT:C222(aOldCspec; 0)
	ARRAY TEXT:C222(aNewCspec; 0)
	ARRAY TEXT:C222(aOldCspec; $collectionSize)
	ARRAY TEXT:C222(aNewCspec; $collectionSize)
	For ($item; 1; $collectionSize)
		GOTO RECORD:C242([Estimates_Carton_Specs:19]; $_record_number{$item})
		DUPLICATE RECORD:C225([Estimates_Carton_Specs:19])
		[Estimates_Carton_Specs:19]pk_id:78:=Generate UUID:C1066
		aOldCspec{$item}:=[Estimates_Carton_Specs:19]CartonSpecKey:7
		[Estimates_Carton_Specs:19]CartonSpecKey:7:=fCSpecID  //•120695  MLB  UPR 234 chg method of primary keying CartonSpec records
		aNewCspec{$item}:=[Estimates_Carton_Specs:19]CartonSpecKey:7
		[Estimates_Carton_Specs:19]diffNum:11:=$newDifferentialDesignation
		If (Count parameters:C259=3)
			[Estimates_Carton_Specs:19]ProcessSpec:3:=$3
		End if 
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Estimates_Carton_Specs]z_SYNC_ID;->[Estimates_Carton_Specs]z_SYNC_DATA)
		SAVE RECORD:C53([Estimates_Carton_Specs:19])
	End for 
End if   // END 4D Professional Services : January 2019 





