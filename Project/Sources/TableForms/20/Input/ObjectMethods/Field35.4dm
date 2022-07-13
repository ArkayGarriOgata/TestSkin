C_LONGINT:C283($i)  //3/15/95 upr 66  
If (<>SubformCalc)  //3/20/95 upr 66
	If ([Estimates_Machines:20]FormChangeHere:9)
		
		If ([Estimates_DifferentialsForms:47]Subforms:31=0)
			[Estimates_DifferentialsForms:47]Subforms:31:=Num:C11(Request:C163("How many subforms do you need?"; "2"))
			If (ok=0) | ([Estimates_DifferentialsForms:47]Subforms:31<2)
				[Estimates_DifferentialsForms:47]Subforms:31:=0
				SAVE RECORD:C53([Estimates_DifferentialsForms:47])
				[Estimates_Machines:20]FormChangeHere:9:=False:C215
				BEEP:C151
				BEEP:C151
			End if 
		End if 
		
		If ([Estimates_Machines:20]FormChangeHere:9)  //still true
			
			Core_ObjectSetColor(->[Estimates_Machines:20]FormChangeHere:9; -(3+(256*0)))
			//qryEstSubForm 
			FORM GOTO PAGE:C247(2)
		End if 
		
	Else 
		//qryEstSubForm 
		
		Core_ObjectSetColor(->[Estimates_Machines:20]FormChangeHere:9; -(15+(256*0)))
		[Estimates_Machines:20]Flex_field1:18:=0
		[Estimates_Machines:20]Flex_Field2:19:=0
		[Estimates_Machines:20]Flex_Field3:20:=0
		[Estimates_Machines:20]Flex_Field4:21:=0
		[Estimates_Machines:20]Flex_Field7:38:=0
	End if 
	
Else 
	If ([Estimates_Machines:20]CostCtrID:4="412") | ([Estimates_Machines:20]CostCtrID:4="416")
		If (([Estimates_Machines:20]Flex_Field2:19+[Estimates_Machines:20]Flex_Field4:21)=0)
			BEEP:C151
			ALERT:C41("You must specify the number of plate changes")
			[Estimates_Machines:20]FormChangeHere:9:=False:C215
		End if 
	End if 
End if   //subforms are active
//