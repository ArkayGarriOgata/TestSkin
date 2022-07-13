//%attributes = {}
//Method:  Ship_Dialog_Invc(tFormName)
//Description: Uses current record in [Customers_Bills_of_Lading]

If (True:C214)  //Initialize
	
	C_TEXT:C284($1; $tFormName)
	
	C_LONGINT:C283($nWindowReference)
	C_TEXT:C284($tWindowTitle)
	
	C_OBJECT:C1216($oWindow)
	C_LONGINT:C283($nWindowReference)
	
	$tFormName:=$1
	
	$oWindow:=New object:C1471()
	
	$oWindow.tFormName:=$tFormName
	$oWindow.nWindowType:=Plain form window:K39:10
	
	$nWindowReference:=0
	$tWindowTitle:="Invoice"
	
End if   //Done initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

SET WINDOW TITLE:C213($tWindowTitle; $nWindowReference)

DIALOG:C40($tFormName)

CLOSE WINDOW:C154
