
C_DATE:C307($dateEntered)
//$dateEntered:=aDate{ListBox1}`doesn't work anymore
$dateEntered:=Date:C102(Get edited text:C655)
If ($dateEntered<newHRD)
	BEEP:C151
	aDate{ListBox1}:=newHRD
Else 
	aDate{ListBox1}:=$dateEntered
End if 
aSelected{ListBox1}:="X"

