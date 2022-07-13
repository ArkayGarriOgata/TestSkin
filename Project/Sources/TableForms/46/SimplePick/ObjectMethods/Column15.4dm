If (aQtyOnHand{InvListBox}=0)
	aPicked{InvListBox}:=0
	BEEP:C151
	
Else 
	If (Substring:C12(aPallet{InvListBox}; 1; 3)="000")  //cant ship from gaylord
		aPicked{InvListBox}:=0
		BEEP:C151
	End if 
End if 
