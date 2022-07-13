C_OBJECT:C1216($obResult)

$obResult:=Form:C1466.ent.save(dk auto merge:K85:24)

If ($obResult.success)
	zwStatusMsg("PARTS BIN"; "Changes saved")
	CANCEL:C270
Else 
	BEEP:C151
	CANCEL:C270
End if 

