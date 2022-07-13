//(s) [process_spec].Input_bFixForms (Update related forms button)
//mod 2.22.94 fix loss of selection bug
//2/1/95 upr 1410

C_BOOLEAN:C305($proceed)
C_LONGINT:C283($caseForms)
//BEEP
READ WRITE:C146([Estimates_DifferentialsForms:47])
READ WRITE:C146([Estimates_Differentials:38])
READ WRITE:C146([Estimates_Machines:20])
READ WRITE:C146([Estimates_Materials:29])

//BEEP
If ([Process_Specs:18]Status:2#"Final")
	BEEP:C151
	If (sFile="Estimate")
		uYesNoCancel("Update Forms for THIS Estimate."+<>sCr+"Update Forms for ALL Estimates."; "One"; "All")  //added for UPR 1410
	Else 
		uYesNoCancel("Update Forms for One Estimate."+<>sCr+"Update Forms for ALL Estimates."; "One"; "All")  //added for UPR 1410
	End if 
	Case of 
		: (bNo=1)  //All case forms    
			QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23=[Process_Specs:18]ID:1)
		: (OK=1) & (sFile#"Estimate")  //called directly from pSpec, request Estimate number
			Repeat 
				$Est:=Request:C163("Please Enter an Estimate Nº")
				If (OK=1)
					QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$Est)
					If (Records in selection:C76([Estimates:17])#1)
						ALERT:C41("You Need to Enter a UNIQUE Estimate Nº.")
						uClearSelection(->[Estimates:17])
					End if 
				Else 
					uClearSelection(->[Estimates:17])
				End if 
			Until (OK=0) | (Records in selection:C76([Estimates:17])=1)
			If (Records in selection:C76([Estimates:17])=1)
				QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23=[Process_Specs:18]ID:1; *)
				QUERY:C277([Estimates_DifferentialsForms:47];  & ; [Estimates_DifferentialsForms:47]DiffFormId:3=[Estimates:17]EstimateNo:1+"@")
			Else 
				uClearSelection(->[Estimates_DifferentialsForms:47])
			End if 
		: (OK=1)  //ONE (this one)
			QUERY:C277([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23=[Process_Specs:18]ID:1; *)
			QUERY:C277([Estimates_DifferentialsForms:47];  & ; [Estimates_DifferentialsForms:47]DiffFormId:3=[Estimates:17]EstimateNo:1+"@")
		Else 
			uClearSelection(->[Estimates_DifferentialsForms:47])
	End case 
	//end upr 1410
	$caseForms:=Records in selection:C76([Estimates_DifferentialsForms:47])
	If ($caseForms>0)
		$proceed:=False:C215
		CONFIRM:C162(String:C10($caseForms)+" use this P-Spec. Update them to match?")
		If (ok=1)
			
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProcessSpec:46=[Process_Specs:18]ID:1)
			If (Records in selection:C76([Job_Forms:42])>0)
				BEEP:C151
				CONFIRM:C162("WARNING: Budgets have been created from this P-Spec, Continue?")
				If (ok=1)
					$proceed:=True:C214
				Else 
					$proceed:=False:C215
				End if 
			Else 
				$proceed:=True:C214
			End if 
			
			If ($proceed)
				QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]ProcessSpec:33=[Process_Specs:18]ID:1)
				If (Records in selection:C76([Finished_Goods:26])>0)
					CONFIRM:C162("WARNING: Finished Goods have been created from this P-Spec, Continue?")
					If (ok=1)
						$proceed:=True:C214
					Else 
						$proceed:=False:C215
					End if 
					
				End if   //proceed
				
			End if 
			
		End if   //1 st confirm    
		
		If ($proceed)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				FIRST RECORD:C50([Estimates_DifferentialsForms:47])
				CREATE SET:C116([Estimates_DifferentialsForms:47]; "Changers")
				For ($i; 1; $caseForms)
					USE SET:C118("Changers")
					GOTO SELECTED RECORD:C245([Estimates_DifferentialsForms:47]; $i)
					RELATE ONE:C42([Estimates_DifferentialsForms:47]DiffId:1)
					sUpDatePspecLin
				End for 
				CLEAR SET:C117("Changers")
				
				
			Else 
				
				ARRAY LONGINT:C221($_Estimates_Dif_Forms; 0)
				SELECTION TO ARRAY:C260([Estimates_DifferentialsForms:47]; $_Estimates_Dif_Forms)
				
				For ($i; 1; $caseForms; 1)
					GOTO RECORD:C242([Estimates_DifferentialsForms:47]; $_Estimates_Dif_Forms{$i})
					RELATE ONE:C42([Estimates_DifferentialsForms:47]DiffId:1)
					sUpDatePspecLin
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			PSpecEstimateLd("Machines"; "Materials")
			ORDER BY:C49([Process_Specs_Machines:28]; [Process_Specs_Machines:28]Seq_Num:3; >)
			ORDER BY:C49([Process_Specs_Materials:56]; [Process_Specs_Materials:56]Sequence:4; >)
		Else 
			BEEP:C151
			CONFIRM:C162("Change "+String:C10($caseForms)+" P-Spec references to "+<>zResp+" chgd on "+String:C10(4D_Current_date; 1)+"?")
			If (ok=1)
				APPLY TO SELECTION:C70([Estimates_DifferentialsForms:47]; [Estimates_DifferentialsForms:47]ProcessSpec:23:=<>zResp+" chgd on "+String:C10(4D_Current_date; 1))
			Else 
				BEEP:C151
				ALERT:C41("You may have invalidated the estimate forms that reference this P-spec.")
			End if 
		End if 
		
	Else 
		If (sFile="Estimate")
			BEEP:C151
			ALERT:C41("This P-Spec is not used by any current estimates.")
		End if 
	End if   //used somewhere
Else 
	BEEP:C151
	ALERT:C41("This P-Spec is 'Final',"+"  You MAY NOT Modify Case forms Based on this P-Spec.")
End if 

UNLOAD RECORD:C212([Estimates_DifferentialsForms:47])
UNLOAD RECORD:C212([Estimates_Differentials:38])
//