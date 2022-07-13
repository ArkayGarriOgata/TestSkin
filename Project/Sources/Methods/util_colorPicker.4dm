//%attributes = {"publishedWeb":true}
//PM: util_colorPicker(current color) -> new color
//@author mlb - 3/28/02  11:10
C_TEXT:C284(xText)
xText:="Sample"
C_LONGINT:C283($1; $0; i1; i2; i3; $winRef; gridBtn)
If ($1#0)
	i1:=($1*-1)%256
	i2:=($1*-1)\256
	i3:=$1
Else 
	i1:=Black:K11:16
	i2:=White:K11:1
	i3:=-(i1+(256*i2))
End if 
$winRef:=Open form window:C675([zz_control:1]; "ColorPicker"; Sheet form window:K39:12)
//$winRef:=Open form window([CONTROL];"ColorPicker";5)
DIALOG:C40([zz_control:1]; "ColorPicker")
If (ok=1)
	$0:=i3
Else 
	$0:=$1
End if 
CLOSE WINDOW:C154($winRef)