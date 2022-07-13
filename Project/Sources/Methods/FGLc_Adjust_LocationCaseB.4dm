//%attributes = {}
//Method:  FGLc_Adjust_LocationCaseB=>bSkidWithCaseSelected
//Description:  This method returns true if another skid with CASE was changed 

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bSkidWithCaseSelected)
	
	C_LONGINT:C283($nSkid; $nNumberOfSkids)
	
	$bSkidWithCaseSelected:=False:C215
	
	$nNumberOfSkids:=Size of array:C274(FGLc_atLoc_Skid)
	
End if   //Done Initialize

For ($nSkid; 1; $nNumberOfSkids)  //Loop through FGLc_atLoc_Skid
	
	Case of   //Skid with case selected
			
		: (FGLc_atLoc_Skid{$nSkid}#"CASE")
			
		: (FGLc_abLoc_Delete{$nSkid})
			
			$bSkidWithCaseSelected:=True:C214
			$nSkid:=$nNumberOfSkids+1  //Terminate loop
			
		: (FGLc_anLoc_OriginalQty{$nSkid}#FGLc_anLoc_Qty{$nSkid})
			
			$bSkidWithCaseSelected:=True:C214
			$nSkid:=$nNumberOfSkids+1  //Terminate loop
			
		Else   //Continue looping
			
	End case   //Done skid with case selected
	
End for   //Done looping through FGLc_atLoc_Skid

$0:=$bSkidWithCaseSelected
