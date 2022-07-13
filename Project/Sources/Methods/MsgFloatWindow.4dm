//%attributes = {"publishedWeb":true}
//(p) MsgFloatWindow
//$1 - text - (optional) message text to initally display
//open a floating window for message purposes
//• 7/1/98 cs created

C_TEXT:C284($1)

NewWindow(300; 150; 0; -720)

If (Count parameters:C259=1)
	MESSAGE:C88($1)
End if 