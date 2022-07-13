//%attributes = {"publishedWeb":true}
//Procedure: doRenameCust()  011796  MLB

C_TEXT:C284(<>Cust)  //1/12/95  upr 1392
C_TEXT:C284(<>Name; <>OldName)  //1/12/95  upr 1392

SAVE RECORD:C53([Customers:16])
<>Cust:=Request:C163("Enter the id of the customer to be renamed:"; "00000")  //[CUSTOMER]ID
If (OK=1) & (Length:C16(<>Cust)=5)
	READ WRITE:C146([Customers:16])
	QUERY:C277([Customers:16]; [Customers:16]ID:1=<>Cust)
	If (Records in selection:C76([Customers:16])=1)
		If (fLockNLoad(->[Customers:16]))
			<>OldName:=[Customers:16]Name:2
			<>Name:=Request:C163("Enter the new name: "; <>OldName)
			
			If (OK=1) & (Length:C16(<>Name)>0)
				[Customers:16]Name:2:=<>Name
				SAVE RECORD:C53([Customers:16])
				$ID:=New process:C317("CUST_ApplyNameChange"; <>lMinMemPart)
				If (False:C215)
					CUST_ApplyNameChange
				End if 
				
			End if   //new name given
			
		Else   //locked customer record
			BEEP:C151
			ALERT:C41("Customer "+<>Cust+" was locked.")
		End if 
		
	Else   //no cust found
		BEEP:C151
		ALERT:C41("Customer "+<>Cust+" was not found.")
	End if 
	
End if 