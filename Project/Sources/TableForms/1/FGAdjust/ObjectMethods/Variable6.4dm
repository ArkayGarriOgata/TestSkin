If (Length:C16(tSkidNumber)>0) & (rReal1=0)  // Modified by: Mel Bohince (7/13/16) skid eradication option
	uConfirm("Make this skid like it never happened?"; "Remove"; "Keep")
	If (ok=1)
		makeSkidDisappear:=True:C214
	Else 
		makeSkidDisappear:=False:C215
	End if 
End if 