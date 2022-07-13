//OM:  bPrint  052699  mlb
//drill down for commodity table

$poi:=Request:C163("PO Item Number to set Qty Open = 0?"; "000000000")
If (ok=1) & (Length:C16($poi)>7)
	$id:=New process:C317("POI_zeroQtyOpen"; <>lMinMemPart; "zero POI qty open"; $poi)
	If (False:C215)
		POI_zeroQtyOpen
	End if 
	
Else 
	BEEP:C151
End if 
