// _______
// Method: [Job_Forms].GroupClose.toggle   ( ) ->
// By: TJF 040596
// ----------------------------------------------------

vSel:=0
For ($i; 1; Size of array:C274(aRpt))
	If (aRpt{$i}="")
		aRpt{$i}:="√"
		vSel:=VSel+1
	Else 
		aRpt{$i}:=""
	End if 
End for 