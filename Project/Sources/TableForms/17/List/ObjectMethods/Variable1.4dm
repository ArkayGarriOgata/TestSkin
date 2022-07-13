//(S) [FIRSTFILE]List'bExport

C_LONGINT:C283($i; $numElements)

$numElements:=Records in set:C195("UserSet")
If ($numElements=0)  //bSelect button from selectionList layout
	uConfirm("You did not select any Estimates."; "Try again"; "Help")
Else 
	uConfirm("Extract the "+String:C10($numElements)+" selected Estimates?"; "Extract"; "Cancel")
	If (ok=1)
		BEEP:C151
		//ALERT("Extracting Estimates is not up-to-date. If *may* work.";"Huh?")
		CUT NAMED SELECTION:C334([Estimates:17]; "WhileCalculating")
		$wasReadOnly:=Read only state:C362([Estimates:17])
		If ($wasReadOnly)
			READ WRITE:C146([Estimates:17])
		End if 
		USE SET:C118("UserSet")
		ARRAY TEXT:C222($aEstimate; 0)
		SELECTION TO ARRAY:C260([Estimates:17]EstimateNo:1; $aEstimate; [Estimates:17]Status:30; $aStatus)
		SORT ARRAY:C229($aEstimate; >)
		
		$numElements:=Size of array:C274($aEstimate)
		uThermoInit($numElements; "Extracting Estimates")
		For ($i; 1; $numElements)
			Exp_ExportEst($aEstimate{$i})
			$aStatus{$i}:="Extracted"
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		ARRAY TO SELECTION:C261($aStatus; [Estimates:17]Status:30)
		
		If ($wasReadOnly)
			READ ONLY:C145([Estimates:17])
		End if 
		
		USE NAMED SELECTION:C332("WhileCalculating")
		
		uConfirm("Extracts are in the ~/Documents/aMs_Documents/Exported_Estimates folder. "; "OK"; "Help")
	End if 
End if 