//%attributes = {}
C_TIME:C306($0)
If (Not:C34(<>modification4D_10_05_19))  //| (<>disable_4DPS_mod)
	
	$0:=Current time:C178(*)
	
Else 
	If (<>4d_Time.compare)
		$0:=Current time:C178-<>4d_Time.Difference
	Else 
		$0:=Current time:C178+<>4d_Time.Difference
	End if 
	
End if 