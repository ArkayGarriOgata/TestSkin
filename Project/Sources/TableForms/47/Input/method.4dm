// ----------------------------------------------------
// Form Method: [Estimates_DifferentialsForms].Input
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Load:K2:1)
		SetObjectProperties("restricted_access"; -><>NULL; testRestrictions)  // Modified by: Mark Zinke (5/10/13)
		Case of 
			: (Is new record:C668([Estimates_DifferentialsForms:47]))
				CANCEL:C270
			Else 
				wWindowTitle("push"; "Differential Form "+[Estimates_DifferentialsForms:47]DiffFormId:3)
				Mat_viaForm:=False:C215  //set on page 2,tells material delete how to recover correct selection of records
				
				If (iMode>2)
					READ ONLY:C145([Estimates_FormCartons:48])
					READ ONLY:C145([Estimates_Machines:20])
					READ ONLY:C145([Estimates_Materials:29])
					
				Else 
					If (<>SubformCalc)  //3/20/95 upr 66
						SetObjectProperties(""; ->[Estimates_DifferentialsForms:47]Subforms:31; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/10/13)
					End if 
					
					If ([Estimates_DifferentialsForms:47]ProcessSpec:23="")
						[Estimates_DifferentialsForms:47]ProcessSpec:23:=[Estimates_Differentials:38]ProcessSpec:5
					End if 
					
					If ([Estimates_DifferentialsForms:47]DateCustomerWant:7=!00-00-00!)
						[Estimates_DifferentialsForms:47]DateCustomerWant:7:=[Estimates:17]DateCustomerWant:23
					End if 
					
					If ([Estimates_DifferentialsForms:47]JobType:9="")
						[Estimates_DifferentialsForms:47]JobType:9:="3 Prod"
					End if 
				End if 
				
				If ([Process_Specs:18]ID:1#[Estimates_DifferentialsForms:47]ProcessSpec:23)
					QUERY:C277([Process_Specs:18]; [Process_Specs:18]ID:1=[Estimates_DifferentialsForms:47]ProcessSpec:23)
				End if 
				
				QUERY:C277([Estimates_FormCartons:48]; [Estimates_FormCartons:48]DiffFormID:2=[Estimates_DifferentialsForms:47]DiffFormId:3)
				r1:=Sum:C1([Estimates_FormCartons:48]FormWantQty:9)  //3/15/95 upr 66
				r2:=Sum:C1([Estimates_FormCartons:48]MakesQty:5)
				//ORDER BY([Estimates_FormCartons];[Estimates_FormCartons]ItemNumber;>)
				ORDER BY:C49([Estimates_FormCartons:48]; [Estimates_FormCartons:48]SubFormNumber:10; >; [Estimates_FormCartons:48]ItemNumber:3; >)
				
				If (FORM Get current page:C276=2)
					If (testRestrictions)
						SetObjectProperties("estOnly@"; -><>NULL; False:C215)  // Modified by: Mark Zinke (5/10/13)
					Else 
						SetObjectProperties("estOnly@"; -><>NULL; True:C214)  // Modified by: Mark Zinke (5/10/13)
						Mat_viaForm:=True:C214  //tells material delete procedure how to restore correct selection of material rec
						QUERY:C277([Estimates_Machines:20]; [Estimates_Machines:20]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
						ORDER BY:C49([Estimates_Machines:20]; [Estimates_Machines:20]Sequence:5; >)
						QUERY:C277([Estimates_Materials:29]; [Estimates_Materials:29]DiffFormID:1=[Estimates_DifferentialsForms:47]DiffFormId:3)
						ORDER BY:C49([Estimates_Materials:29]; [Estimates_Materials:29]Sequence:12; >)
					End if 
				End if 
				COPY NAMED SELECTION:C331([Estimates_Materials:29]; "materialsOnForm")
				
				If (imode>2)
					OBJECT SET ENABLED:C1123(bValidate; False:C215)
					OBJECT SET ENABLED:C1123(bDelCPN2For; False:C215)
					OBJECT SET ENABLED:C1123(bAddCPN2For; False:C215)
				End if 
				
				<>jobform:=String:C10([Estimates:17]JobNo:50)+"."+String:C10([Estimates_DifferentialsForms:47]FormNumber:2; "00")
				
		End case 
		
	: (Form event code:C388=On Validate:K2:3)
		ON ERR CALL:C155("eAbortedSaveRecord")
		If ([Estimates_DifferentialsForms:47]Width:5=0) | ([Estimates_DifferentialsForms:47]Lenth:6=0)
			uConfirm("Form dimensions are missing, you will not be able to Calculate."; "Fix Later"; "Go Back")
			If (OK=0)
				ABORT:C156
			End if 
		End if 
		If ([Estimates_DifferentialsForms:47]NumberSheets:4=0)
			uConfirm("Net Sheets not specified, you will not be able to Calculate."; "Fix Later"; "Go Back")
			If (OK=0)
				ABORT:C156
			End if 
		End if 
		
		If ([Estimates_DifferentialsForms:47]NumberUpOverrid:30>0)  //• 5/23/97 cs upr 1870  
			uConfirm("Number Up (over ride) has been set to "+String:C10([Estimates_DifferentialsForms:47]NumberUpOverrid:30)+" on this Form-Spec."+Char:C90(13)+"Is this Correct?"; "Yes"; "Go Back")
			If (OK=0)
				ABORT:C156
			End if 
		End if 
		ON ERR CALL:C155("")
		
		Est_NumberOfSheetsAssertion
		
		[Estimates_DifferentialsForms:47]NumItems:8:=Records in selection:C76([Estimates_FormCartons:48])
		
		Estimate_ReCalcNeeded
		
		$numSF:=0
		SELECTION TO ARRAY:C260([Estimates_FormCartons:48]SubFormNumber:10; $aSF)
		For ($i; 1; [Estimates_DifferentialsForms:47]NumItems:8)
			If ($aSF{$i}>$numSF)
				$numSF:=$aSF{$i}
			End if 
		End for 
		
		If ($numSF>1) & ([Estimates_DifferentialsForms:47]NumberUpOverrid:30=0)
			BEEP:C151
			ALERT:C41("You have subforms, verify the NumberUp override at the form level."; "FIX")
			REJECT:C38
		End if 
		
	: (Form event code:C388=On Unload:K2:2)
		wWindowTitle("pop")
		CLEAR NAMED SELECTION:C333("materialsOnForm")
		
		//USE NAMED SELECTION("cartonsInDifferential")
		Mat_viaForm:=False:C215  //tells material delete procedure how to restore correct selection of material rec
End case 