//%attributes = {"publishedWeb":true}
// -------
// Method: Invoice_SetInvoiceBtnState   ( ) ->
// formerly (p)gSetInvoiceButn
//for upr 1268
//definition of enabling changed by upr 1444

ARRAY BOOLEAN:C223($aSplBill; 0)
ARRAY LONGINT:C221($aInvoNum; 0)
ARRAY TEXT:C222($aPOnum; 0)
C_BOOLEAN:C305($enable)
C_LONGINT:C283($i)

SELECTION TO ARRAY:C260([Customers_Order_Lines:41]SpecialBilling:37; $aSplBill; [Customers_Order_Lines:41]InvoiceNum:38; $aInvoNum; [Customers_Order_Lines:41]PONumber:21; $aPOnum)
$enable:=False:C215
For ($i; 1; Size of array:C274($aSplBill))
	If ($aSplBill{$i}) & ($aInvoNum{$i}=0) & ($aPOnum{$i}#"")
		$enable:=True:C214
		$i:=$i+Size of array:C274($aSplBill)  //break
	End if 
End for 

If ($enable)
	OBJECT SET ENABLED:C1123(hbInvoice; True:C214)
Else 
	OBJECT SET ENABLED:C1123(hbInvoice; False:C215)  //make this button inaccessable
End if 