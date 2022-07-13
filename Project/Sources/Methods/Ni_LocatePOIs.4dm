//%attributes = {"publishedWeb":true}
//(p) JCO_LocatePOIs (JobCloseOut)
//locate POitems and populate process arrays
//$1 - string - (optional) anyhting flag to clear arays
//• 10/30/97 cs created
//• 8/13/98 cs miss labeled an array for Company ID

C_LONGINT:C283($Count)
C_TEXT:C284($1)

If (Count parameters:C259=0)
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		uRelateSelect(->[Purchase_Orders_Items:12]POItemKey:1; ->[Job_Forms_Issue_Tickets:90]PoItemKey:1; 0)  //get alll bins based on current selection if issue ticekets
		
		
	Else 
		
		RELATE ONE SELECTION:C349([Job_Forms_Issue_Tickets:90]; [Purchase_Orders_Items:12])
		
		
	End if   // END 4D Professional Services : January 2019 query selection
	$Count:=Records in selection:C76([Purchase_Orders_Items:12])
	ARRAY TEXT:C222(aPOIPoiKey; $Count)
	ARRAY TEXT:C222(aPOICompID; $Count)
	ARRAY TEXT:C222(aPOIDept; $Count)
	ARRAY TEXT:C222(aPOIExpCode; $Count)
	ARRAY TEXT:C222(aPOIComKey; $Count)
	ARRAY REAL:C219(aPOIPrice; $Count)  //extended price
	ARRAY REAL:C219(aPOIOrdAmt; $Count)  //ordered qty
	ARRAY TEXT:C222(aPoiRmCode; $Count)  //• 3/9/98 cs added way to track RM code for exception reports
	SELECTION TO ARRAY:C260([Purchase_Orders_Items:12]POItemKey:1; aPOIPoiKey; [Purchase_Orders_Items:12]CompanyID:45; aPOICompID; [Purchase_Orders_Items:12]DepartmentID:46; aPOIDept; [Purchase_Orders_Items:12]ExpenseCode:47; aPOIExpCode; [Purchase_Orders_Items:12]ExtPrice:11; aPOIPrice; [Purchase_Orders_Items:12]Commodity_Key:26; aPOIComKey; [Purchase_Orders_Items:12]Qty_Ordered:30; aPOIOrdAmt; [Purchase_Orders_Items:12]Raw_Matl_Code:15; aPOiRMCode)
Else 
	$Count:=0
	ARRAY TEXT:C222(aPOIPoiKey; $Count)
	ARRAY TEXT:C222(aPOICompID; $Count)
	ARRAY TEXT:C222(aPOIDept; $Count)
	ARRAY TEXT:C222(aPOIExpCode; $Count)
	ARRAY TEXT:C222(aPOIComKey; $Count)
	ARRAY REAL:C219(aPOIPrice; $Count)
	ARRAY TEXT:C222(aPoiRmCode; $Count)  //• 3/9/98 cs added way to track RM code for exception reports
End if 