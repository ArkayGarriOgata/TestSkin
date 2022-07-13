If (Form event code:C388=On Clicked:K2:4)
	If (aRpt{Self:C308->}="√")
		aRpt{Self:C308->}:=""
		vSel:=vSel-1
	Else 
		aRpt{Self:C308->}:="√"
		vSel:=vSel+1
	End if 
End if 