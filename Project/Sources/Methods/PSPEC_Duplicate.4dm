//%attributes = {"publishedWeb":true}
//PM: PSPEC_Duplicate(custid;pspec id) -> record number
//@author mlb - 8/1/01  10:51
//dup a pspec object if doesn't already exist, leave the current record selected
//return the record number of the new duplicate

C_TEXT:C284($newId; $oldID; $2)  //(S) [PROCESS_SPEC]Input'bDUplicate
C_TEXT:C284($oldCustid; $newCustId; $1)
C_BOOLEAN:C305($continue)
C_LONGINT:C283($0)  //record number of the new pspec, negative if failure

$oldID:=[Process_Specs:18]ID:1
$oldCustid:=[Process_Specs:18]Cust_ID:4
$continue:=False:C215
$0:=-3

If (Count parameters:C259=0)  //btn clicked
	BEEP:C151
	$newCustId:=Request:C163("Enter a CUSTOMER Id for the new Process Spec: "; $oldCustid; "Continue"; "Cancel")
	If (ok=1)
		$newId:=Request:C163("Enter a name for the new Process Spec: "; $oldID; "Continue"; "Cancel")
		If (ok=1)
			$continue:=True:C214
		End if 
	End if 
	
Else   //called 
	$continue:=True:C214
	$newCustId:=$1
	$newId:=$2
End if 

If ($continue)
	SET QUERY DESTINATION:C396(Into variable:K19:4; $exists)
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=$newCustId+":"+$newId)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($exists=0)
		$continue:=True:C214
		zwStatusMsg("DUP PSPEC"; $newCustId+":"+$newId+" will be created")
	Else 
		$continue:=False:C215
		zwStatusMsg("DUP PSPEC"; $newCustId+":"+$newId+" already exists")
	End if 
	
	If ($continue)
		PSpecEstimateLd("Machines"; "Materials")  // get the related records
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CREATE SET:C116([Process_Specs_Machines:28]; "machineSet")
			CREATE SET:C116([Process_Specs_Materials:56]; "materialSet")
			
		Else 
			
			ARRAY LONGINT:C221($_machineSet; 0)
			ARRAY LONGINT:C221($_materialSet; 0)
			
			LONGINT ARRAY FROM SELECTION:C647([Process_Specs_Machines:28]; $_machineSet)
			LONGINT ARRAY FROM SELECTION:C647([Process_Specs_Materials:56]; $_materialSet)
			
		End if   // END 4D Professional Services : January 2019 
		
		DUPLICATE RECORD:C225([Process_Specs:18])
		[Process_Specs:18]pk_id:109:=Generate UUID:C1066
		[Process_Specs:18]ID:1:=$newId
		[Process_Specs:18]Status:2:="New"
		[Process_Specs:18]Cust_ID:4:=$newCustId
		[Process_Specs:18]PSpecKey:106:=$newCustId+":"+$newId
		[Process_Specs:18]LastUsed:5:=4D_Current_date
		// deleted 5/15/20: gns_ams_clear_sync_fields(->[Process_Specs]z_SYNC_ID;->[Process_Specs]z_SYNC_DATA)
		SAVE RECORD:C53([Process_Specs:18])
		$0:=Record number:C243([Process_Specs:18])
		
		For ($i; 1; Records in selection:C76([Process_Specs_Machines:28]))
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				USE SET:C118("machineSet")
				GOTO SELECTED RECORD:C245([Process_Specs_Machines:28]; $i)
				
				
			Else 
				
				GOTO RECORD:C242([Process_Specs_Machines:28]; $_machineSet{$i})
				
				
			End if   // END 4D Professional Services : January 2019 
			DUPLICATE RECORD:C225([Process_Specs_Machines:28])
			[Process_Specs_Machines:28]pk_id:26:=Generate UUID:C1066
			[Process_Specs_Machines:28]ProcessSpec:1:=$newId
			[Process_Specs_Machines:28]CustID:2:=$newCustId
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Process_Specs_Machines]z_SYNC_ID;->[Process_Specs_Machines]z_SYNC_DATA)
			SAVE RECORD:C53([Process_Specs_Machines:28])
		End for 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CLEAR SET:C117("machineSet")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 
		
		
		For ($i; 1; Records in selection:C76([Process_Specs_Materials:56]))
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				USE SET:C118("materialSet")
				GOTO SELECTED RECORD:C245([Process_Specs_Materials:56]; $i)
				
				
			Else 
				
				GOTO RECORD:C242([Process_Specs_Materials:56]; $_materialSet{$i})
				
				
			End if   // END 4D Professional Services : January 2019 
			DUPLICATE RECORD:C225([Process_Specs_Materials:56])
			[Process_Specs_Materials:56]pk_id:22:=Generate UUID:C1066
			[Process_Specs_Materials:56]ProcessSpec:1:=$newId
			[Process_Specs_Materials:56]CustID:2:=$newCustId
			// deleted 5/15/20: gns_ams_clear_sync_fields(->[Process_Specs_Materials]z_SYNC_ID;->[Process_Specs_Materials]z_SYNC_DATA)
			SAVE RECORD:C53([Process_Specs_Materials:56])
		End for 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			CLEAR SET:C117("materialSet")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 
		
	Else 
		$0:=-1
	End if 
End if 