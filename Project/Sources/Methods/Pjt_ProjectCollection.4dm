//%attributes = {"publishedWeb":true}
//PM:  Pjt_ProjectCollection(message)  3/10/00  mlb
//facade to the Project class

C_TEXT:C284($1; $msg)
C_LONGINT:C283($cust; $i; $custRef)

$msg:=$1

Case of 
	: ($msg="loadList")
		Pjt_ProjectSelector("construct")
		
	: ($msg="addCustomer")
		C_TEXT:C284(pjtCustid)
		pjtCustid:=CUST_new
		
		//how to get that customer back into the project picker?
		
	: ($msg="addProject")
		$name:=Request:C163("Project's designated name:"; ""; "Create"; "Cancel")
		//TRACE
		While (ok=1)
			If (Length:C16($name)>0)
				CREATE RECORD:C68([Customers_Projects:9])
				[Customers_Projects:9]id:1:=app_set_id_as_string(Table:C252(->[Customers_Projects:9]))  //fGetNextID (->[Customers_Projects];5)
				[Customers_Projects:9]Name:2:=$name
				[Customers_Projects:9]DateOpened:11:=4D_Current_date
				[Customers_Projects:9]Customerid:3:=pjtCustid
				[Customers_Projects:9]CustomerName:4:=pjtCustName
				SAVE RECORD:C53([Customers_Projects:9])
				pjtId:=[Customers_Projects:9]id:1
				pjtName:=$name
				
				CREATE RECORD:C68([Users_Record_Accesses:94])
				[Users_Record_Accesses:94]UserInitials:1:=<>zResp
				[Users_Record_Accesses:94]TableName:2:=Table name:C256(->[Customers_Projects:9])  //"Project"
				[Users_Record_Accesses:94]PrimaryKey:3:=[Customers_Projects:9]id:1
				[Users_Record_Accesses:94]AccessType:4:="RWO"
				SAVE RECORD:C53([Users_Record_Accesses:94])
				
				pjtRecordNumber:=Record number:C243([Customers_Projects:9])
				Pjt_ProjectSelector("insertProject"; ->pjtRecordNumber)
				ok:=0  //break out of the loop
			Else 
				BEEP:C151
				ALERT:C41("You must designate a name for the new project.")
				$name:=Request:C163("Project's designated name:"; ""; "Create"; "Cancel")
			End if 
			
		End while 
End case 