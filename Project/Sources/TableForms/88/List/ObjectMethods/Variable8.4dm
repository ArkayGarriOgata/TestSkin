//Script: bApprove()  

If (Macintosh option down:C545)  //•2/29/00  mlb to recover from lost postings
	$pendingStatusOnly:=False:C215
Else 
	$pendingStatusOnly:=True:C214
End if 

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
		
		CUT NAMED SELECTION:C334([Customers_Invoices:88]; "before")
		
		USE SET:C118("mark")
		CLEAR SET:C117("mark")
		
		If ($pendingStatusOnly)
			QUERY SELECTION:C341([Customers_Invoices:88]; [Customers_Invoices:88]Status:22="Pending")
		End if 
		
		$numInvoices:=Records in selection:C76([Customers_Invoices:88])
		If ($numInvoices>0)
			ARRAY TEXT:C222($aNewStatus; $numInvoices)
			For ($i; 1; $numInvoices)
				$aNewStatus{$i}:="Approved"
			End for 
			ARRAY TO SELECTION:C261($aNewStatus; [Customers_Invoices:88]Status:22)
			zwStatusMsg("INVOICE"; String:C10($numInvoices)+" Pending invoices have been set to Approved")
		Else 
			uConfirm("Current status must be 'Pending' to change to 'Approved'."; "OK"; "Help")
		End if 
		
		USE NAMED SELECTION:C332("before")
		
	Else 
		uConfirm("You must select the Invoices you wish to Approve."; "OK"; "Help")
	End if 
	
Else 
	uConfirm("You must be in 'Modify' mode to Approve these Invoices."; "OK"; "Help")
End if 