//%attributes = {"publishedWeb":true}
//(P) beforeVend: before phase processing for Vendor
//1/20/95
//5/2/95 upr 1498
//5/4/95 phone conversation
//•052395  MLB  

If (Is new record:C668([Vendors:7]))  //1/20/95
	[Vendors:7]ID:1:=app_set_id_as_string(Table:C252(->[Vendors:7]))  //String(nNextID (Table(->[Vendors]));"00000")
	[Vendors:7]Std_Terms:13:="Net 60"
	[Vendors:7]Std_Discount:14:=0  //5/4/95
	[Vendors:7]Within:29:=0  //5/4/95
	[Vendors:7]NetDue:30:=45  //5/4/95
	[Vendors:7]zCount:19:=1
	If (filePtr=(->[Purchase_Orders:11]))
		[Purchase_Orders:11]VendorID:2:=[Vendors:7]ID:1
	End if 
End if 

If (iMode#2)  //not modify
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
End if 

//•091096  MLB  messaging to Dynamics
C_DATE:C307(dDate)
C_TIME:C306(tTime)
If ([Vendors:7]ModTimeStamp:31>0)
	TS2DateTime([Vendors:7]ModTimeStamp:31; ->dDate; ->tTime)
Else 
	dDate:=!00-00-00!
	tTime:=?00:00:00?
End if 

Case of 
	: (FORM Get current page:C276=1) & (filePtr=(->[Vendors:7]))
		REDUCE SELECTION:C351([Vendors_Contacts:53]; 0)
		REDUCE SELECTION:C351([Purchase_Orders:11]; 0)
		REDUCE SELECTION:C351([Purchase_Orders_Items:12]; 0)
		
	: (FORM Get current page:C276=2)
		QUERY:C277([Vendors_Contacts:53]; [Vendors_Contacts:53]VendorID:1=[Vendors:7]ID:1)
		
	: (FORM Get current page:C276=3) & (filePtr=(->[Vendors:7]))
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
			QUERY:C277([Purchase_Orders:11]; [Purchase_Orders:11]VendorID:2=[Vendors:7]ID:1)  //made this search selection
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		ORDER BY:C49([Purchase_Orders:11]; [Purchase_Orders:11]PONo:1)
		OBJECT SET ENABLED:C1123(bOpen; False:C215)
		OBJECT SET ENABLED:C1123(bAll; True:C214)
		
	: (FORM Get current page:C276=4) & (filePtr=(->[Vendors:7]))
		QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]VendorID:39=[Vendors:7]ID:1)  //5/2/95 upr 1498
		ORDER BY:C49([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]PoItemDate:40; <)
End case 