//Duplicate Process spec record
If (Records in set:C195("clickedPSpec")=1)
	USE SET:C118("clickedPSpec")
	QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_PSpecs:57]ProcessSpec:2; *)  //• 10/8/97 cs locate selected pspec
	QUERY:C277([Process_Specs:18];  & ; [Process_Specs:18]Cust_ID:4=[Estimates:17]Cust_ID:2)
	If (Records in selection:C76([Process_Specs:18])=1)
		$newId:=Substring:C12([Estimates_PSpecs:57]ProcessSpec:2; 1; 17)+"dup"
		$newId:=Substring:C12(Request:C163("Enter a name for the new Process Spec: "; $newId; "Duplicate"; "Cancel"); 1; 20)
		If (ok=1) & (Length:C16($newId)>0)
			$recNo:=PSPEC_Duplicate([Estimates:17]Cust_ID:2; $newId)
			If ($recNo>=0)
				CREATE RECORD:C68([Estimates_PSpecs:57])
				[Estimates_PSpecs:57]EstimateNo:1:=[Estimates:17]EstimateNo:1
				[Estimates_PSpecs:57]ProcessSpec:2:=$newId
				SAVE RECORD:C53([Estimates_PSpecs:57])
				
			Else 
				BEEP:C151
				ALERT:C41("That Pspec already exists for this customer, no duplication occurred.")
			End if 
		Else 
			BEEP:C151
			zwStatusMsg("DUP PSPEC"; "Canceled.")
		End if 
	Else 
		BEEP:C151
		zwStatusMsg("DUP PSPEC"; "Process Spec not found.")
	End if 
	
	QUERY:C277([Estimates_PSpecs:57]; [Estimates_PSpecs:57]EstimateNo:1=[Estimates:17]EstimateNo:1)
	ORDER BY:C49([Estimates_PSpecs:57]; [Estimates_PSpecs:57]ProcessSpec:2; >)
	
Else 
	BEEP:C151
	zwStatusMsg("DUP PSPEC"; "Click on a PSpec.")
End if 