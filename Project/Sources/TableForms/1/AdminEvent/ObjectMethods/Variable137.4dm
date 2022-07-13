//uSpawnProcess ("FG_ChkInventoryBal";0;"Inventory Check";True;True)
//If (False)
//FG_ChkInventoryBal 
//End if 
//eos
uConfirm("All inventory or date range?"; "All"; "Range")
If (ok=1)
	$pid:=New process:C317("FG_ChkInventoryBal"; <>lMinMemPart; "FG_ChkInventoryBal")
	
Else 
	C_DATE:C307(dDateBegin; dDateEnd)
	$ok:=fGetDateRange(->dDateBegin; ->dDateEnd)
	$pid:=New process:C317("FG_ChkInventoryBal"; <>lMinMemPart; "FG_ChkInventoryBal"; "date range"; dDateBegin; dDateEnd)
End if 
