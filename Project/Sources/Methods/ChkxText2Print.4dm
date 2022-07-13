//%attributes = {"publishedWeb":true}
//$1 - Text to Add to xText for Printing
//• 5/28/97 cs created

If (Length:C16(xText)+Length:C16($1)>30000)
	If (Count parameters:C259=2)
		rPrintText($2)
	Else 
		rPrintText
	End if 
	xText:=$1
	$0:=True:C214
Else 
	xText:=xText+$1
	$0:=False:C215
End if 