//-JML   9/29/93
//have to allow user to choose from existing pSpec or create a brand new one.
//• 10/8/97 cs track last used date for pSpecs
MESSAGES OFF:C175
C_LONGINT:C283($numAdded; $winRef; $hit; $i; $numPspecs)
$winRef:=OpenSheetWindow(->[zz_control:1]; "Select_PSpec")
DIALOG:C40([zz_control:1]; "Select_PSpec")
CLOSE WINDOW:C154

If (OK=1)
	
	If (bNew=1)  //user wishes to create a brand new process spec record
		FORM SET INPUT:C55([Process_Specs:18]; "Input")
		ADD RECORD:C56([Process_Specs:18]; *)
		
		If (ok=1)
			CREATE RECORD:C68([Estimates_PSpecs:57])
			[Estimates_PSpecs:57]EstimateNo:1:=[Estimates:17]EstimateNo:1
			[Estimates_PSpecs:57]ProcessSpec:2:=[Process_Specs:18]ID:1
			SAVE RECORD:C53([Estimates_PSpecs:57])
		End if 
		
	Else   //user wishes to attach exisitng process specs to this estimate.
		READ WRITE:C146([Process_Specs:18])
		$numPspecs:=Size of array:C274(ListBox1)
		SELECTION TO ARRAY:C260([Estimates_PSpecs:57]ProcessSpec:2; $alreadyPicked)
		$numAdded:=0
		uThermoInit($numPspecs; "Adding Process Specs to estimate "+[Estimates:17]EstimateNo:1)
		For ($i; 1; $numPspecs)
			uThermoUpdate($i)
			If (aSelected{$i}="X")
				$hit:=Find in array:C230($alreadyPicked; asDiff{$i})
				If ($hit=-1)
					QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=asDiff{$i}; *)  //• 10/8/97 cs locate selected pspec
					QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)  //TRACE
					If (fLockNLoad(->[Process_Specs:18]))
						[Process_Specs:18]LastUsed:5:=4D_Current_date  //update last used date
						SAVE RECORD:C53([Process_Specs:18])
						
						CREATE RECORD:C68([Estimates_PSpecs:57])
						[Estimates_PSpecs:57]EstimateNo:1:=[Estimates:17]EstimateNo:1
						[Estimates_PSpecs:57]ProcessSpec:2:=asDiff{$i}
						SAVE RECORD:C53([Estimates_PSpecs:57])
						
						$numAdded:=$numAdded+1
					End if 
				End if 
			End if 
		End for 
		uThermoClose
		zwStatusMsg("Done"; "Added "+String:C10($numAdded)+" PSpecs to estimate "+[Estimates:17]EstimateNo:1)
	End if 
	
End if 

QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
ORDER BY:C49([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2; >)
uClearSelection(->[Process_Specs:18])
READ ONLY:C145([Process_Specs:18])
MESSAGES ON:C181
ARRAY TEXT:C222(asDiff; 0)
ARRAY TEXT:C222(aSelected; 0)
//