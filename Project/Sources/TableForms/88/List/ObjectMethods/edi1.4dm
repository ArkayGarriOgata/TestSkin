// -------
// Method: [Customers_Invoices].List.edi   ( ) ->
// By: Mel Bohince @ 08/23/17, 16:04:09
// Description
// test edi messaging
// ----------------------------------------------------
// Modified by: Mel Bohince (9/20/17) 
//Hi Mel,
//The prefix change is just for testing.
//Pretty sure for EDI invoicing though, you would only be looking at N6P and G4P SAP prefixes
//EDI_Prep & G Operations,

// Modified by: Mel Bohince (10/23/18)don't save to outbox unless there were qualified invoices to send
// Modified by: Mel Bohince (12/23/19) chg indicator in BIG element 7 for credit memos
// Modified by: Mel Bohince (4/6/20) permit resending an invoice, lines 51 and 63 commented out

C_LONGINT:C283($transNumber; $numInvoices; $i; $err)
C_BOOLEAN:C305($invoices_to_send)  // Modified by: Mel Bohince (10/23/18)

$invoices_to_send:=False:C215
CUT NAMED SELECTION:C334([Customers_Invoices:88]; "before")

If (Not:C34(Read only state:C362([Customers_Invoices:88])))
	If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
		
		CREATE EMPTY SET:C140([Customers_Invoices:88]; "mark")
		COPY SET:C600("UserSet"; "UserSelected")
		UNION:C120("mark"; "UserSelected"; "mark")
		CLEAR SET:C117("UserSelected")
		
	Else 
		
		COPY SET:C600("UserSet"; "mark")
		
	End if   // END 4D Professional Services : January 2019 
	
	If (Records in set:C195("mark")>0)
		USE SET:C118("mark")
		CLEAR SET:C117("mark")
		$numInvoices:=Records in selection:C76([Customers_Invoices:88])
		If ($numInvoices>0)
			ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)
			
			
			$err:=EDI_Invoice810("new"; "PnG")
			
			uThermoInit($numInvoices; "Send P&G EDI Invoices...")
			For ($i; 1; $numInvoices)
				If ([Customers_Invoices:88]CustomerID:6="00199")
					// Modified by: Mel Bohince (9/20/17) 
					If (Position:C15("N6P"; [Customers_Invoices:88]CustomersPO:11)>0) | (Position:C15("G4P"; [Customers_Invoices:88]CustomersPO:11)>0)
						//If ([Customers_Invoices]EDI_Prep=0) | (Current user="Designer")  //not already sent
						
						//was returning $err, but need a cross ref between edi transation and invoice number so 997 can make the connection
						$transNumber:=EDI_Invoice810("add-invoice")
						If ($transNumber>0)
							$invoices_to_send:=True:C214
							[Customers_Invoices:88]EDI_Prep:33:=$transNumber  //$timeStamp  //make this negative when invoice is acknowledged
						Else 
							[Customers_Invoices:88]EDI_Prep:33:=0
						End if 
						SAVE RECORD:C53([Customers_Invoices:88])
						
						//End if   //not already sent
					End if   //SAP prefix on PO
				End if   //PnG invoice
				
				NEXT RECORD:C51([Customers_Invoices:88])
				
				uThermoUpdate($i)
			End for 
			
			uThermoClose
			
			If ($invoices_to_send)
				$err:=EDI_Invoice810("send")
			Else 
				uConfirm("No qualified invoices to send."; "OK"; "Help")
			End if 
			
		End if 
		
	Else 
		uConfirm("You must select the Invoices you wish to send via EDI."; "OK"; "Help")
	End if 
	
Else 
	uConfirm("You must be in 'Modify' mode to EDI these Invoices."; "OK"; "Help")
End if 



USE NAMED SELECTION:C332("before")
FORM SET OUTPUT:C54([Customers_Invoices:88]; "List")