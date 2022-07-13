
Case of 
	: (Form event code:C388=On Load:K2:1)
		//C_OBJECT(rep)
		//rep:=New object
		Form:C1466.reps:=ds:C1482.Salesmen.query("( Active = :1 "; True:C214).orderBy("FirstName asc")
		repSelection:="ACTIVE"
		
	: (Form event code:C388=On Selection Change:K2:29)
		Form:C1466.rep:=Form:C1466.clickedRep
		Form:C1466.customers:=ds:C1482.Customers.query("( SalesmanID = :1 "; Form:C1466.rep.ID).orderBy("Name asc")
		CustomerSelection:="REP "+Form:C1466.rep.ID
		
	: (Form event code:C388=On Drop:K2:12)
		C_LONGINT:C283($rowNum)
		$rowNum:=Drop position:C608-1
		
		C_OBJECT:C1216($rep_o; $customer_o; $status_o)
		If ($rowNum>=0)
			$rep_o:=Form:C1466.reps[$rowNum]
			
			
			$customer_o:=Form:C1466.clickedCustomer
			$customer_o.SalesmanID:=$rep_o.ID
			$status_o:=$customer_o.save(dk auto merge:K85:24)
			
			Case of 
				: ($status_o.success)
					zwStatusMsg("ASSIGNED REP"; $customer_o.Name+" now belongs to "+$rep_o.FirstName)
				Else 
					zwStatusMsg("ERROR"; $status_o.statusText)
					BEEP:C151
					ALERT:C41($status_o.statusText)
			End case 
			
			Form:C1466.reps:=Form:C1466.reps  // this line is required to refresh listbox display
			Form:C1466.customers:=Form:C1466.customers
		End if 
		
End case 
