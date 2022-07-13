//%attributes = {"publishedWeb":true}
//(p) rMarykayOrdLine
//locate orderlines forMArykay report
//moved code to this procedure until we can get this straightened out.• 
//• 1/14/98 cs attempt to include FGs which exist against closed orders    
//$2 - is NOT customer name - is customer ID
//• 2/9/98 cs created

C_TEXT:C284($CR)

$Cr:=Char:C90(13)

If ($2#"")  //limit to one customer    
	MESSAGE:C88($CR+" Searching Orderlines, limiting to Custid:"+$2)
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$2; *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))); *)
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]SpecialBilling:37=False:C215)
Else 
	MESSAGE:C88($CR+"  Searching Orderlines, limiting to "+String:C10($3)+" months or less...")
	QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#"Cancel@"; *)  //•080195  MLB 1490
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#"Kill"; *)  //•080195  MLB 1490    
	QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]DateOpened:13<=($4-(365*($3/12))))
End if 

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	MESSAGE:C88($CR+"     Searching related Bin locations...")
	uRelateSelect(->[Finished_Goods_Locations:35]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5; 0)  //get fg locations
	MESSAGE:C88($CR+"     Searching related production records...")
	uRelateSelect(->[Job_Forms_Items:44]OrderItem:2; ->[Customers_Order_Lines:41]OrderLine:3; 0)  //*    Production related to ORDERLINES•••
	MESSAGE:C88($CR+"     Searching related F/G transactions...")
	uRelateSelect(->[Finished_Goods_Transactions:33]ProductCode:1; ->[Finished_Goods_Locations:35]ProductCode:1; 0)
	
Else 
	
	MESSAGE:C88($CR+"     Searching related Bin locations...")
	ARRAY TEXT:C222($_ProductCode; 0)
	DISTINCT VALUES:C339([Customers_Order_Lines:41]ProductCode:5; $_ProductCode)
	QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
	MESSAGE:C88($CR+"     Searching related production records...")
	RELATE MANY SELECTION:C340([Job_Forms_Items:44]OrderItem:2)
	MESSAGE:C88($CR+"     Searching related F/G transactions...")
	DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $_ProductCode)
	QUERY WITH ARRAY:C644([Finished_Goods_Transactions:33]ProductCode:1; $_ProductCode)
	
End if   // END 4D Professional Services : January 2019 query selection
