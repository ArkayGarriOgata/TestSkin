// ----------------------------------------------------
// Object Method: [Job_Forms].DieBoard.Button1
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If ([Job_DieBoards:152]DateBinOut:5=!00-00-00!)
	[Job_DieBoards:152]DateBinOut:5:=4D_Current_date
Else 
	[Job_DieBoards:152]Bin:4:=Request:C163("Which Bin?"; [Job_DieBoards:152]Bin:4; "Put Away"; "Cancel")
	If (ok=1)
		[Job_DieBoards:152]DateBinOut:5:=!00-00-00!
	Else 
		BEEP:C151
		uConfirm("You must enter a Bin to 'Put Away'"; "Try Again"; "Help")
	End if 
End if 

If ([Job_DieBoards:152]DateBinOut:5=!00-00-00!)
	SetObjectProperties(""; ->bPut; True:C214; "Take Out")
Else 
	SetObjectProperties(""; ->bPut; True:C214; "Put Away")
End if 