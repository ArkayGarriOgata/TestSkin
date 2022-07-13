//%attributes = {}
//Method:  Tgsn_PrGb_ValidInvoiceB (panInvoiceNumber;panInvalidInvoice;patInvalidPO;patInvalidReason)=>bValidInvoice
//Description:  This method will determine if the invoice is ready to send to PrGb

If (True:C214)  //Initialize 
	
	C_BOOLEAN:C305($0; $bValidInvoice)
	C_POINTER:C301($1; $panInvoiceNumber; $2; $panInvalidInvoice)
	C_POINTER:C301($3; $patInvalidPO; $4; $patInvalidReason)
	
	C_LONGINT:C283($nInvoiceNumber; $nNumberOfInvoiceNumbers)
	C_TEXT:C284($tReason)
	
	C_OBJECT:C1216($oAsk)
	
	ARRAY LONGINT:C221($anInvoiceNumber; 0)
	ARRAY TEXT:C222($atCustomersPO; 0)
	
	$panInvoiceNumber:=$1
	$panInvalidInvoice:=$2
	$patInvalidPO:=$3
	$patInvalidReason:=$4
	$bValidInvoice:=False:C215
	
	$oAsk:=New object:C1471()
	
End if   //Done Initialize

USE SET:C118("UserSet")

Case of   //Valid invoice
		
	: (Read only state:C362([Customers_Invoices:88]))
		
		$oAsk.tMessage:="You must be in 'Modify' mode to send these via Tungsten"
		Core_Dialog_Alert($oAsk)
		
	: (Records in set:C195("UserSet")<1)
		
		$oAsk.tMessage:="You must select the Invoices you wish to send via Tungsten"
		Core_Dialog_Alert($oAsk)
		
	Else   //invoice
		
		SELECTION TO ARRAY:C260([Customers_Invoices:88]InvoiceNumber:1; $anInvoiceNumber; [Customers_Invoices:88]CustomersPO:11; $atCustomersPO)
		$nNumberOfInvoiceNumbers:=Size of array:C274($anInvoiceNumber)
		
		For ($nInvoiceNumber; 1; $nNumberOfInvoiceNumbers)  //Loop through InvoiceNumber
			
			$tReason:=CorektBlank
			
			If (Tgsn_PrGb_VerifyB($anInvoiceNumber{$nInvoiceNumber}; ->$tReason))  //Valid invoice information
				
				APPEND TO ARRAY:C911($panInvoiceNumber->; $anInvoiceNumber{$nInvoiceNumber})
				
			Else   //Invalid invoice
				
				APPEND TO ARRAY:C911($panInvalidInvoice->; $anInvoiceNumber{$nInvoiceNumber})
				APPEND TO ARRAY:C911($patInvalidPO->; $atCustomersPO{$nInvoiceNumber})
				APPEND TO ARRAY:C911($patInvalidReason->; $tReason)
				
			End if   //Done valid invoice information
			
		End for   //Done looping through InvoiceNumber
		
		$bValidInvoice:=(Size of array:C274($panInvoiceNumber->)>0)
		
End case   //Done valid invoice

$0:=$bValidInvoice
