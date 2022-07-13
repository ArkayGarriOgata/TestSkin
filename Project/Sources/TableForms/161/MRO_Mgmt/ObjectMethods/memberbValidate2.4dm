C_OBJECT:C1216($obResult)

$obResult:=Form:C1466.part.save(dk auto merge:K85:24)

If ($obResult.success)
	zwStatusMsg("RAW MATERIAL"; "Changes saved")
	Form:C1466.parts:=Form:C1466.parts
	
Else 
	BEEP:C151
	
End if 

