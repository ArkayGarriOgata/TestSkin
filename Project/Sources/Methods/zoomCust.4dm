//%attributes = {"publishedWeb":true}
//(P) zoomCust
//upr 1169 8/9/94
//1/10/97 -cs- modified case for estimate containing combined customer
//  (multiple customers on one job)
TRACE:C157
C_LONGINT:C283($temp)
C_LONGINT:C283($recNo)
C_POINTER:C301($1; $2)  //pointers to container holding cust id & address id
$temp:=iMode
If ($temp<=2)
	iMode:=2
Else 
	iMode:=3
End if 
fromZoom:=True:C214
READ WRITE:C146([Customers:16])
Case of 
	: (Count parameters:C259=2)  //via customer order
		QUERY:C277([Customers:16]; [Customers:16]ID:1=[Customers_Orders:40]CustID:2)
		MODIFY RECORD:C57([Customers:16]; *)
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_Orders:40]CustID:2; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Bill to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aBilltos)
		aBilltos{0}:=[Customers_Orders:40]CustID:2
		SORT ARRAY:C229(aBilltos; >)
		
		QUERY:C277([Customers_Addresses:31]; [Customers_Addresses:31]CustID:1=[Customers_Orders:40]CustID:2; *)
		QUERY:C277([Customers_Addresses:31];  & ; [Customers_Addresses:31]AddressType:3="Ship to")
		SELECTION TO ARRAY:C260([Customers_Addresses:31]CustAddrID:2; aShiptos)
		aShiptos{0}:=[Customers_Orders:40]CustID:2
		SORT ARRAY:C229(aShiptos; >)
		//uBuildAddrSelec ("Bill to";$1;$2)
		READ ONLY:C145([Customers:16])
		UNLOAD RECORD:C212([Customers:16])
		uBuildBrandLis2  //upr 1221 11/22/94
		
	: (Count parameters:C259=1)
		iMode:=3
		QUERY:C277([Customers:16]; [Customers:16]ID:1=$1->)
		DISPLAY SELECTION:C59([Customers:16]; *)
		Text1:=[Customers:16]Name:2
		[Estimates:17]CustomerName:47:=Text1
		READ ONLY:C145([Customers:16])  //••
		UNLOAD RECORD:C212([Customers:16])  //••
		
	: ([Estimates:17]Cust_ID:2#"") & ([Estimates:17]Cust_ID:2#<>sCombindID)  //no params, via estimate, •1/10/97 -cs - check for combined customer
		RELATE ONE:C42([Estimates:17]Cust_ID:2)
		MODIFY RECORD:C57([Customers:16]; *)
		Text1:=[Customers:16]Name:2
		[Estimates:17]CustomerName:47:=Text1
		uBuildBrandList
		uBuildAddrSelec("Bill to")
		READ ONLY:C145([Customers:16])
		UNLOAD RECORD:C212([Customers:16])  //••
		
		//•1/10/97 added to handle multiple customers on one job  
	: (Record number:C243([Estimates_Carton_Specs:19])#No current record:K29:2) & ([Estimates:17]Cust_ID:2=<>sCombindID)  //no params, via estimate, •1/10/97 -cs -  combined customer
		Case of 
			: ([Estimates_Carton_Specs:19]CustID:6="")  //nothing to search for
				$recNo:=fPickList(->[Customers:16]ID:1; ->[Customers:16]Name:2; ->[Customers:16]SalesmanID:3)
				If ($RecNo>=0)
					GOTO RECORD:C242([Customers:16]; $recno)
				Else   //clear selection
					uClearSelection(->[Customers:16])
				End if 
			: ([Estimates_Carton_Specs:19]CustID:6#"")  //search on entered custid
				qryCustomer(->[Customers:16]ID:1; [Estimates_Carton_Specs:19]CustID:6)
			Else   //clear selection
				uClearSelection(->[Customers:16])
		End case 
		
		If (Records in selection:C76([Customers:16])>0)  //if there was a customer found
			ONE RECORD SELECT:C189([Customers:16])
			Text1:=[Customers:16]Name:2
			[Estimates_Carton_Specs:19]CustID:6:=[Customers:16]ID:1
			// uBuildBrandList no brand info avail (i think)
			uBuildAddrSelec("Bill to")
			READ ONLY:C145([Customers:16])
			UNLOAD RECORD:C212([Customers:16])  //••    
		End if 
		//end 1/10/97 mods
		
	Else 
		$recNo:=fPickList(->[Customers:16]ID:1; ->[Customers:16]Name:2; ->[Customers:16]ParentCorp:19)
		If ($recNo>-1)
			GOTO RECORD:C242([Customers:16]; $recNo)
			[Estimates:17]Cust_ID:2:=[Customers:16]ID:1
			Text1:=[Customers:16]Name:2
			[Estimates:17]CustomerName:47:=Text1
			uBuildBrandList
			uBuildAddrSelec("Bill to")
		Else 
			[Estimates:17]Cust_ID:2:=""
			Text1:="Customer not specified."
			[Estimates:17]CustomerName:47:=""
			Text3:=""
			[Estimates:17]z_Bill_To_ID:5:=""
			Text2:="Bill to address not available."
			ARRAY TEXT:C222(aBrand; 0)
			//ARRAY TO LIST(aBrand;"Product Lines")
		End if 
		UNLOAD RECORD:C212([Customers:16])  //••    
		READ ONLY:C145([Customers:16])  //••
End case 
iMode:=$temp
fromZoom:=False:C215
//