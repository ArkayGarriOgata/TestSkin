C_OBJECT:C1216($obResult)

$obResult:=Form:C1466.bin.save(dk auto merge:K85:24)

If ($obResult.success)
	zwStatusMsg("PARTS BIN"; "Changes saved")
	Form:C1466.bins:=Form:C1466.bins
	
Else 
	BEEP:C151
End if 

