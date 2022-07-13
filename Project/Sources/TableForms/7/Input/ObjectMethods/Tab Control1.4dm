C_LONGINT:C283($itemRef)
C_TEXT:C284($targetPage)
GET LIST ITEM:C378(iTabControl; *; $itemRef; $targetPage)
Case of 
	: (filePtr=(->[Purchase_Orders:11]))
		OBJECT SET ENABLED:C1123(bOpen; False:C215)
		OBJECT SET ENABLED:C1123(bAll; False:C215)
		
	: ($targetPage="Contacts")
		QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)
		
	: ($targetPage="Purchase Orders") & (filePtr=(->[Vendors:7]))
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
			
			qryOpenPOs  // replaced below with this line - consitancy in search algorithims
			QUERY SELECTION:C341([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=[Vendors:7]ID:1)  //made this search selection
			
			
		Else 
			<>PassThrough:=True:C214
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
			QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Partial@")
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]Status:15="Approved"; *)
			QUERY:C277([Purchase_Orders:11];  | ; [Purchase_Orders:11]Status:15="Partial@"; *)
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=[Vendors:7]ID:1)
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1)
		OBJECT SET ENABLED:C1123(bOpen; False:C215)
		OBJECT SET ENABLED:C1123(bAll; True:C214)
		
		
	: ($targetPage="Performance") & (filePtr=(->[Vendors:7]))
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]VendorID:39=[Vendors:7]ID:1)  //5/2/95 upr 1498
		ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40; <)
End case 
