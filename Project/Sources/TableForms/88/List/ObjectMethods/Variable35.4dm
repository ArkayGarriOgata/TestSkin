//Script: bInclude()  052096  MLB
//mark the selected contact records with user specified initials
//•6/07/99  MLB  UPR 236 option to print a blank form with Option key down
// Modified by: Mel Bohince (3/6/18) remove preprinted option
CUT NAMED SELECTION:C334([Customers_Invoices:88]; "before")

If (Not:C34(Macintosh option down:C545))
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
				uConfirm("Print invoices on preprinted forms or blank paper?"; "Preprinted"; "Blank")
				If (ok=1)
					FORM SET OUTPUT:C54([Customers_Invoices:88]; "InvoiceForPreprintedForm")
					zwStatusMsg("INVOICE"; String:C10($numInvoices)+" Invoices are printing on preprinted forms.")
				Else 
					FORM SET OUTPUT:C54([Customers_Invoices:88]; "InvoiceForBlankPaper")
					zwStatusMsg("INVOICE"; String:C10($numInvoices)+" Invoices are printing on Plain paper.")
				End if 
				PRINT SELECTION:C60([Customers_Invoices:88])  //•061599  mlb  show print dialogs
				
			Else 
				uConfirm("Current status must be 'Pending' to change to 'Approved'."; "OK"; "Help")
			End if 
			
		Else 
			uConfirm("You must select the Invoices you wish to Approve."; "OK"; "Help")
		End if 
		
	Else 
		uConfirm("You must be in 'Modify' mode to Approve these Invoices."; "OK"; "Help")
	End if 
	
Else 
	USE SET:C118("UserSet")
	FORM SET OUTPUT:C54([Customers_Invoices:88]; "PreprintForm")
	PRINT SELECTION:C60([Customers_Invoices:88])
End if 

USE NAMED SELECTION:C332("before")
FORM SET OUTPUT:C54([Customers_Invoices:88]; "List")