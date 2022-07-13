//(lp) [control]ReAssignCust
Case of 
	: (Form event code:C388=On Load:K2:1)
		READ ONLY:C145([Job_Forms_Master_Schedule:67])
		//READ ONLY([old_Bookings])
		READ ONLY:C145([Customers_Orders:40])
		READ ONLY:C145([Customers_Order_Lines:41])
		READ ONLY:C145([Customers:16])
		READ ONLY:C145([Customers_Contacts:52])
		READ ONLY:C145([Contacts:51])
		C_TEXT:C284(vOldRep; vNewRep)
		C_TEXT:C284(t1; t2; t3; t2b)
		t3:=""
		t2:=""
		t2b:=""
		t1:="INSTRUCTIONS:"+Char:C90(13)
		t1:=t1+"1) Enter the Salesman's Initials"+Char:C90(13)
		t1:=t1+"2) Click on each new customer to give to this Rep"+Char:C90(13)
		t1:=t1+"3) Click the Reassign button"
		t1:=t1+"4) Click the Done button"
		vNewRep:=""
		vOldRep:=""
		NewWindow(350; 50; 0; -720)
		MESSAGE:C88("Building Customer Arrays...")
		ALL RECORDS:C47([Customers:16])
		$Count:=Records in table:C83([Customers:16])
		ARRAY TEXT:C222(aCustId; $Count)
		ARRAY TEXT:C222(aCustName; $Count)
		ARRAY TEXT:C222(aBullet; $Count)
		SELECTION TO ARRAY:C260([Customers:16]ID:1; aCustId)  //;[Customers]Name;aCustName)
		
		For ($i; 1; $Count)
			aBullet{$i}:=""
			aCustName{$i}:=CUST_getName(aCustId{$i}; "elc")
		End for 
		SORT ARRAY:C229(aCustName; aCustid; aBullet; >)
		CLOSE WINDOW:C154
End case 
//