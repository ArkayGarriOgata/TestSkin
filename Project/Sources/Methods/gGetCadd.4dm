//%attributes = {"publishedWeb":true}
//(P) gGetCadd

C_LONGINT:C283($i)


If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
	ORDER BY:C49([Customers_Addresses:31]; [Customers_Addresses:31]AddressType:3; >; [Customers_Addresses:31]CustAddrID:2; >)
	
	iCaddCust:=0
	iCaddShip:=0
	iCaddBill:=0
	iCaddTot:=0
	iCaddcon:=0
	iCaddOther:=0
	FIRST RECORD:C50([Customers_Addresses:31])
	For ($i; 1; Records in selection:C76([Customers_Addresses:31]))
		Case of 
			: ([Customers_Addresses:31]AddressType:3="  H.Q.")
				iCaddCust:=iCaddCust+1
			: ([Customers_Addresses:31]AddressType:3="Ship to")
				iCaddShip:=iCaddShip+1
			: ([Customers_Addresses:31]AddressType:3="Bill to")
				iCaddBill:=iCaddBill+1
			Else 
				iCaddOther:=iCaddOther+1
		End case 
		NEXT RECORD:C51([Customers_Addresses:31])
	End for 
	FIRST RECORD:C50([Customers_Addresses:31])
	iCaddTot:=iCaddCust+iCaddShip+iCaddBill+iCaddcon+iCaddOther
	
Else 
	QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers:16]ID:1)
	
	ARRAY TEXT:C222($_AddressType; 0)
	ARRAY TEXT:C222($_CustAddrID; 0)
	
	SELECTION TO ARRAY:C260([Customers_Addresses:31]AddressType:3; $_AddressType; [Customers_Addresses:31]CustAddrID:2; $_CustAddrID)
	
	SORT ARRAY:C229($_AddressType; $_CustAddrID; >)
	
	iCaddCust:=0
	iCaddShip:=0
	iCaddBill:=0
	iCaddTot:=0
	iCaddcon:=0
	iCaddOther:=0
	
	For ($i; 1; Size of array:C274($_AddressType); 1)
		Case of 
			: ($_AddressType{$i}="  H.Q.")
				iCaddCust:=iCaddCust+1
			: ($_AddressType{$i}="Ship to")
				iCaddShip:=iCaddShip+1
			: ($_AddressType{$i}="Bill to")
				iCaddBill:=iCaddBill+1
			Else 
				iCaddOther:=iCaddOther+1
		End case 
		
	End for 
	FIRST RECORD:C50([Customers_Addresses:31])
	iCaddTot:=iCaddCust+iCaddShip+iCaddBill+iCaddcon+iCaddOther
	
	
	
End if   // END 4D Professional Services : January 2019 First record
