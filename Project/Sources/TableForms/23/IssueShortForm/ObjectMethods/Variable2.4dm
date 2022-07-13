//•2/02/00  mlb  UPR 2075 remove restriction
Case of 
	: (sCriterion2="33-SubComponentFG")  //only need item and qty
		If (Length:C16(sCriterion1)=0)
			BEEP:C151
			ALERT:C41("Invalid Subcomponent.")
			REJECT:C38
		End if 
		If (rReal1<=0)
			BEEP:C151
			ALERT:C41("Invalid Quantity.")
			REJECT:C38
		End if 
		
	: (rReal1=0)
		BEEP:C151
		ALERT:C41("Invalid Quantity.")
		REJECT:C38
	: (rReal2=0)
		BEEP:C151
		ALERT:C41("Invalid Extended Cost.")
		REJECT:C38
	: (sRefNo="")
		BEEP:C151
		ALERT:C41("Invalid Reference Number.")
		REJECT:C38
	: (sComp="") | (Num:C11(sComp)>3)
		BEEP:C151
		ALERT:C41("Invalid Division identifier.")
		REJECT:C38
		sComp:=""
	: (DeptCode="")
		BEEP:C151
		ALERT:C41("Invalid Department Code.")
		REJECT:C38
	: (sExpCode="")
		BEEP:C151
		ALERT:C41("Invalid Expense Code.")
		REJECT:C38
	: ((rReal1<0) & (rReal2>0)) | ((rReal1>0) & (rReal2<0))
		ALERT:C41("The Quantity & Dollar amounts are not in 'sync', one is positive, and the other"+" is negative."+Char:C90(13)+"You are not allowed to do this.")
		REJECT:C38
		GOTO OBJECT:C206(rReal1)
	: (rReal1<0)
		uConfirm("Quantity Entered is negative."+Char:C90(13)+"This means that the 'issue' will REMOVE costs from this job."+Char:C90(13)+"Is this what you meant?"; "No"; "Yes")
		
		If (OK=1)
			rReal1:=0
			REJECT:C38
		End if 
	: (rReal2<0)
		uConfirm("Dollar amount Entered is negative."+Char:C90(13)+"This means that the 'issue' will REMOVE costs from this job."+Char:C90(13)+"Is this what you meant?"; "No"; "Yes")
		
		If (OK=1)
			rReal2:=0
			REJECT:C38
		End if 
		
End case 
//EOS