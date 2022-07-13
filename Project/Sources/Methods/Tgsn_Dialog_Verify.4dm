//%attributes = {}
//  Method:  Tgsn_Dialog_Verify(panInvoiceNumber)
//  Description:  Displays a list that allows a user to
//.  pick which invoices get sent to Tungsten

If (True:C214)  //Initialize
	
	C_POINTER:C301($1; $panInvoiceNumber)
	C_LONGINT:C283($nWindowReference)
	C_OBJECT:C1216($oWindow)
	
	$panInvoiceNumber:=$1
	
	$oWindow:=New object:C1471()
	$oWindow.tFormName:="Tgsn_Verify"
	
End if   //Done Initialize

$nWindowReference:=Core_Window_OpenRelativeToN($oWindow)

Tgsn_Verify_Initialize(CorektPhasePreDialog; $panInvoiceNumber)

DIALOG:C40("Tgsn_Verify")
