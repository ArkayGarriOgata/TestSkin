//%attributes = {"publishedWeb":true}
//Method: Invoice_SendAR()  042099  MLB
//send approved invoices to GreatPains Dynamics
//•060399  mlb  UPR 236 changes
//•6/07/99  MLB  abs the commission
//•6/08/99  MLB  add double entry to detail export, no hyphens in GLcode
//•061599  mlb  UPR 2048 change client id method
//•6/18/99  MLB  allow edit of prefixes
// add .txt Modified by: Mel Bohince (5/31/13)
// Modified by: Mel Bohince (7/13/17) adapt to OpenAccounts
// Modified by: Mel Bohince (7/15/21)r/o [addreeses] afterward

C_LONGINT:C283($i; $numInvoices; $numAddresses; $transNumber)
C_TIME:C306($docHDR; $docDTL)
C_TEXT:C284($header; $detail)

$numAddresses:=0
$numInvoices:=0

If (User in group:C338(Current user:C182; "AccountsReceivable"))
	Invoice_SendSetup  //get docnames and directories
	If (Invoice_SendReady=0)  //has priors been integrated? The old accounting s/w used the same file name in a hot folder
		//*Look for updated BillTos
		READ WRITE:C146([Addresses:30])
		QUERY:C277([Addresses:30]; [Addresses:30]UpdateDynamics:35#0)
		If (Records in selection:C76([Addresses:30])>0)
			//ORDER BY([Addresses];[Addresses]UpdateDynamics;>)  `save on searches 
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				CREATE SET:C116([Addresses:30]; "hold")  //•6/18/99  MLB 
				
			Else 
				
				
			End if   // END 4D Professional Services : January 2019 
			
			SELECTION TO ARRAY:C260([Addresses:30]; aRecNum; [Addresses:30]Name:2; aName; [Addresses:30]FlexwarePrefix:37; aPrefix)
			SORT ARRAY:C229(aPrefix; aName; aRecNum; >)
			NewWindow(330; 450; 0; 5; "Prefix Review")
			sCriterion1:=""
			DIALOG:C40([Addresses:30]; "DynamicsPrefix")  // Modified by: Mel Bohince (7/13/17) made listbox
			CLOSE WINDOW:C154
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				USE SET:C118("hold")
				CLEAR SET:C117("hold")
				
			Else 
				
				QUERY:C277([Addresses:30]; [Addresses:30]UpdateDynamics:35#0)
				
			End if   // END 4D Professional Services : January 2019 
			
			//If (ok=1)
			$docCust:=?00:00:00?
			
			Case of 
					//: (<>FlexwareActive)
					//$docCust:=Create document(<>DynamicsPath+<>DynamicsCustFilename)
					//Invoice_sendCustToFlexWare ($docCust)
					
					//: (<>AcctVantageActive)
					//$docCust:=Create document(<>DynamicsPath+<>DynamicsCustFilename+".av.txt")
					//Invoice_sendCustToAcctVantage ($docCust)
					
				: (<>OpenAccountsActive)
					Invoice_sendCustToOpenAccounts
					$docCust:=?11:11:11?
					
				Else 
					//$docCust:=Create document(<>DynamicsPath+<>DynamicsCustFilename)
					//Invoice_sendCustToDynamics ($docCust)
			End case 
			
			If ($docCust=?00:00:00?)
				BEEP:C151
				ALERT:C41("Customer update document could not be created.")
			End if   //document created
		End if   //addresses to send
		
		//*Gather the Approved invoices
		READ WRITE:C146([Customers_Invoices:88])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Status:22="Approved")
			CREATE SET:C116([Customers_Invoices:88]; "approvedSet")
			
		Else 
			
			QUERY:C277([Customers_Invoices:88]; [Customers_Invoices:88]Status:22="Approved")
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		$numInvoices:=Records in selection:C76([Customers_Invoices:88])
		If ($numInvoices>0)
			SET QUERY LIMIT:C395(1)  //for looking up customers
			//*-  
			Case of 
				: (<>OpenAccountsActive)  // Modified by: Mel Bohince (7/13/17) 
					$path:=Invoice_sendInvToOpenAccounts
					
					//: (<>AcctVantageActive)
					//$suffix:=fYYMMDD (4D_Current_date ;4)+"."+Replace string(String(4d_Current_time ;HH MM SS);":";"")
					//$docDTL:=Create document(<>DynamicsPath+<>DynamicsInvoiceHdrFilename+$suffix+".txt")  // add .txt Modified by: Mel Bohince (5/31/13)
					//If (OK=1)
					//Invoice_sendInvToAcctVantage ($docDTL)
					//CLOSE DOCUMENT($docDTL)
					//Else 
					//BEEP
					//ALERT("AccountAdvantage document could not be created.")
					//CLOSE DOCUMENT($docHDR)
					//End if 
					
					//: (<>FlexwareActive)
					//$docDTL:=Create document(<>DynamicsPath+<>DynamicsInvoiceDtlFilename)
					//If (OK=1)
					//Invoice_sendInvToFlexWare ($docDTL)
					//CLOSE DOCUMENT($docDTL)
					//Else 
					//BEEP
					//ALERT("Flexware document could not be created.")
					//CLOSE DOCUMENT($docHDR)
					//End if 
					
				Else 
					//If (Not(◊AcctVantageActive)) & (Not(◊FlexwareActive))
					//Invoice_sendInvToDynamics ($docHDR;$docDTL)
					//CLOSE DOCUMENT($docHDR)
					//CLOSE DOCUMENT($docDTL)
					//End if 
			End case 
			
			
			If (OK=1)
				BEEP:C151
				ALERT:C41("Integration files have been saved in directory: "+Char:C90(13)+$path)  //<>DynamicsPath)
				
			End if 
			
			SET QUERY LIMIT:C395(0)
			
			If (False:C215)  // Modified by: Mel Bohince (8/10/17) P&G EDI
				USE SET:C118("approvedSet")
				QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]CustomerID:6="00199"; *)
				QUERY SELECTION:C341([Customers_Invoices:88];  & ; [Customers_Invoices:88]Quantity:15#1)  //try to ignore spl billings
				
				C_LONGINT:C283($i; $numRecs)
				$numRecs:=Records in selection:C76([Customers_Invoices:88])
				If ($numRecs>0)  //send invoices to the edi_outbox
					ORDER BY:C49([Customers_Invoices:88]; [Customers_Invoices:88]InvoiceNumber:1; >)
					C_LONGINT:C283($timeStamp)
					$timeStamp:=TSTimeStamp
					
					$err:=EDI_Invoice810("new"; "PnG")
					
					uThermoInit($numRecs; "Send EDI Invoices...")
					For ($i; 1; $numInvoices)
						If ([Customers_Invoices:88]CustomerID:6="00199")
							If ([Customers_Invoices:88]EDI_Prep:33=0)  //not already sent
								
								//was returning $err, but need a cross ref between edi transation and invoice number so 997 can make the connection
								$transNumber:=EDI_Invoice810("add-invoice")
								If ($transNumber>0)
									[Customers_Invoices:88]EDI_Prep:33:=$transNumber  //$timeStamp  //make this negative when invoice is acknowledged
								Else 
									[Customers_Invoices:88]EDI_Prep:33:=0
								End if 
								//SAVE RECORD([Customers_Invoices])
								
							End if   //not already sent
						End if   //PnG invoice
						NEXT RECORD:C51([Customers_Invoices:88])
						
						uThermoUpdate($i)
					End for 
					
					uThermoClose
					
					
					$err:=EDI_Invoice810("send")
					
				End if 
			End if   //false
			REDUCE SELECTION:C351([Customers_Invoices:88]; 0)
			
		Else 
			BEEP:C151
			ALERT:C41("There are no Approved Invoices to send.")
		End if 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			CLEAR SET:C117("approvedSet")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
		zwStatusMsg("INVOICES"; String:C10($numAddresses)+" BillTo's and "+String:C10($numInvoices)+" invoices have been posted.")
		
	End if   //ready to send
	
	READ ONLY:C145([Addresses:30])  // Modified by: Mel Bohince (7/15/21) 
	UNLOAD RECORD:C212([Addresses:30])  // Modified by: Mel Bohince (7/15/21) 
	
Else 
	BEEP:C151
	ALERT:C41("Access restricted to 'AccountsReceivable' group.")
End if 