//(s) [estimate].input_bEditpspec    mod 2.22.94
//like app_OpenSelectedIncludeRecords, but open related records

If (Records in set:C195("clickedPSpec")>0)
	CUT NAMED SELECTION:C334([Estimates_PSpecs:57]; "hold")
	USE SET:C118("clickedPSpec")
	SELECTION TO ARRAY:C260([Estimates_PSpecs:57]ProcessSpec:2; $aPSpecs)
	$numCollection:=Size of array:C274($aPSpecs)
	ARRAY TEXT:C222($aPSpecKey; $numCollection)
	For ($i; 1; $numCollection)
		$aPSpecKey{$i}:=[Estimates:17]Cust_ID:2+":"+$aPSpecs{$i}
	End for 
	READ ONLY:C145([Process_Specs:18])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY WITH ARRAY:C644([Process_Specs:18]PSpecKey:106; $aPSpecKey)
		
		CREATE SET:C116([Process_Specs:18]; "◊PassThroughSet")
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
		QUERY WITH ARRAY:C644([Process_Specs:18]PSpecKey:106; $aPSpecKey)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	<>PassThrough:=True:C214
	If (iMode=1)
		$mode:=2
	Else 
		$mode:=iMode
	End if 
	ViewSetter($mode; ->[Process_Specs:18])
	
	USE NAMED SELECTION:C332("hold")
	HIGHLIGHT RECORDS:C656([Estimates_PSpecs:57]; "clickedPSpec")
	
Else 
	BEEP:C151
End if 

