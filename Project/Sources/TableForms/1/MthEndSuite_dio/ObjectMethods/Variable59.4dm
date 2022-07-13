//(s) bToggle
//•2/11/97 cs insur that if the ven sum report is off that it stays off
//•3/12/97 cs vend sum is printing when not wanted make it so that 
//vend sum prints ONLY when manually turned on
//• 2/3/98 cs re-enable normal processing of vensum
C_LONGINT:C283($i)
For ($i; 1; Size of array:C274(aSelected))
	
	If (aSelected{$i}="X")
		aSelected{$i}:=""
	Else 
		aSelected{$i}:="X"
	End if 
	//End if 
End for 
//