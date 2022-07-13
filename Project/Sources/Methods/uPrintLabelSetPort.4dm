//%attributes = {"publishedWeb":true}
//PM: uPrintLabelSetPort() -> 
//@author mlb - 1/31/02  11:25

C_LONGINT:C283($0; bAccept; bNo; bCancel)
bAccept:=0
bNo:=0
bCancel:=0
If (Count parameters:C259=0)
	$prn:="Label"
Else 
	$prn:=$1
End if 
uYesNoCancel("Which port is the "+$prn+" printer connected to?"; "Modem"; "Printer"; "None")

Case of 
	: (bAccept=1)
		$0:=21
	: (bNo=1)
		$0:=20
	Else 
		$0:=0
End case 