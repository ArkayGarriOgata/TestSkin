//%attributes = {}
//Method:  Tgsn_PrGb_SendPipedInvoice
//Description:  This method is called to send P&G piped invoices to Tungsten

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oAsk; $oSuccess)
	C_TEXT:C284($tTungstenExpanDrive)
	
	ARRAY LONGINT:C221($anInvoiceNumber; 0)
	ARRAY LONGINT:C221($anInvalidInvoice; 0)
	ARRAY TEXT:C222($atInvalidPO; 0)
	ARRAY TEXT:C222($atInvalidReason; 0)
	
	$oAsk:=New object:C1471()
	$oSuccess:=New object:C1471()
	
	$tTungstenExpanDrive:="ft.tungsten-network.com"
	
End if   //Done Initialize

CUT NAMED SELECTION:C334([Customers_Invoices:88]; "Before")

Case of   //Send
		
	: (Not:C34(Tgsn_ExDr_ConnectB($tTungstenExpanDrive)))  //Make sure can connect to drive
		
		$oAsk.tMessage:="Please make sure the Tungsten volume is mounted. Contact IT if you need help. Thanks."
		Core_Dialog_Alert($oAsk)
		
	: (Not:C34(Tgsn_PrGb_ValidInvoiceB(->$anInvoiceNumber; ->$anInvalidInvoice; ->$atInvalidPO; ->$atInvalidReason)))  //Make sure we have at least one valid N6P
		
		$oAsk.tMessage:="Please make sure you select valid P&G N6P PO's."
		Core_Dialog_Alert($oAsk)
		
	Else   //Valid to send
		
		$nNumberOfInvoices:=Size of array:C274($anInvoiceNumber)
		
		If ($nNumberOfInvoices>0)  //Valid invoice
			
			Tgsn_PrGb_Send(->$anInvoiceNumber)
			
			$oSuccess.tMessage:="You succcessfully uploaded "+String:C10($nNumberOfInvoices)+CorektSpace+util_plural("invoice"; $nNumberOfInvoices)+" to Tungsten. Please verify in the Tungsten portal."
			Core_Dialog_Alert($oSuccess)
			
		End if   //Done valid invoice
		
		Tgsn_PrGb_DisplayInvalid(->$anInvalidInvoice; ->$atInvalidPO; ->$atInvalidReason)
		
End case   //Done send

USE NAMED SELECTION:C332("Before")
FORM SET OUTPUT:C54([Customers_Invoices:88]; "List")
