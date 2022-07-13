//bCopy: 
If (fAutoID=False:C215)
	QUERY:C277(zDefFilePtr->; zDefField->=sCriterion2)
	If (Records in selection:C76(zDefFilePtr->)>0)
		BEEP:C151
		ALERT:C41("To ID already exists.  Please enter new ID.")
		REJECT:C38
		
	Else 
		If (sCriterion2="")
			BEEP:C151
			ALERT:C41("A value for To ID must be entered.  Please enter new ID.")
			REJECT:C38
		End if 
	End if 
End if 
//EOS