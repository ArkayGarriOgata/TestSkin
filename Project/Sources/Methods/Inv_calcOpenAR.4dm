//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 04/21/06, 11:01:26
// ----------------------------------------------------
// Method: Inv_calcOpenAR
// Description
// ` find the value of the unpaid invoices for a customer
//
// Parameters custid
// ----------------------------------------------------

C_TEXT:C284($1)
C_REAL:C285($0; $ar)
C_LONGINT:C283($invoice)

$ar:=0

QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6=$1; *)
QUERY:C277([Customers_Invoices:88];  & ; [Customers_Invoices:88]Status:22#"Paid")

If (Records in selection:C76([Customers_Invoices:88])>0)
	SELECTION TO ARRAY:C260([Customers_Invoices:88]ExtendedPrice:19; $aExtendedPrice)
	
	For ($invoice; 1; Size of array:C274($aExtendedPrice))
		$ar:=$ar+$aExtendedPrice{$invoice}
	End for 
	
End if 

$0:=Round:C94($ar; 0)