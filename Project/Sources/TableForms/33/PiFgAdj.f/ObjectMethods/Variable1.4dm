//(s) rReal2
C_TEXT:C284($xText)
$xText:=(Char:C90(9)*3)+xText+Char:C90(9)+String:C10(rReal4a)+Char:C90(9)+Char:C90(9)+String:C10(rReal5a; "$###,###,##0.00")+Char:C90(13)
If (vDoc#?00:00:00?)
	SEND PACKET:C103(vDoc; $xText)
End if 