//%attributes = {}
//Method:  Tgsn_PrGb_DisplayInvalid(panInvalidInvoice;patPONumber;patReason)
//Description:  This method will display invalid invoices

If (True:C214)  //Initialize 
	
	C_POINTER:C301($1; $panInvalidInvoice)
	C_POINTER:C301($2; $patPONumber)
	C_POINTER:C301($3; $patReason)
	
	C_LONGINT:C283($nInvalidInvoice; $nNumberOfInvalidInvoices)
	
	ARRAY TEXT:C222($atHeader; 0)
	ARRAY POINTER:C280($apColumn; 0)
	ARRAY LONGINT:C221($anTrait; 0)
	
	C_TEXT:C284($tWindowTitle)
	
	$panInvalidInvoice:=$1
	$patPONumber:=$2
	$patReason:=$3
	
	APPEND TO ARRAY:C911($atHeader; "Invoice Number")
	APPEND TO ARRAY:C911($atHeader; "PO Number")
	APPEND TO ARRAY:C911($atHeader; "Reason")
	
	APPEND TO ARRAY:C911($apColumn; $panInvalidInvoice)
	APPEND TO ARRAY:C911($apColumn; $patPONumber)
	APPEND TO ARRAY:C911($apColumn; $patReason)
	
	APPEND TO ARRAY:C911($anTrait; 2+16)  //Best size and center
	APPEND TO ARRAY:C911($anTrait; 2+8)  //Best size and align right
	APPEND TO ARRAY:C911($anTrait; 2)
	
	$tWindowTitle:="Invoices with Issues"
	
End if   //Done Initialize

$nNumberOfInvalidInvoices:=Size of array:C274($panInvalidInvoice->)

If ($nNumberOfInvalidInvoices>0)
	
	Core_Dialog_ViewArray(->$apColumn; ->$atHeader; ->$anTrait; $tWindowTitle)
	
End if 
