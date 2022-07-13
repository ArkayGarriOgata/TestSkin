//%attributes = {"publishedWeb":true}
//PM: FG_PrepServiceAutoInvoice(cpn;order#) -> 
//see also FG_PrepServiceAutoContractInv
//@author mlb - 8/9/01  14:27

C_TEXT:C284($1)
C_LONGINT:C283($2; $0)

Case of 
	: (Count parameters:C259=0)
		ARRAY LONGINT:C221(aOrderNumbers; 0)
		$0:=Size of array:C274(aOrderNumbers)
		
	: (Count parameters:C259=1)
		$0:=Find in array:C230(aOrderNumbers; Num:C11($1))
		
	: (Count parameters:C259=2)
		INSERT IN ARRAY:C227(aOrderNumbers; 1)
		aOrderNumbers{1}:=$2
		$cpn:=$1
		READ ONLY:C145([Finished_Goods_Specifications:98])
		FG_PrepServicesQueries("6"; False:C215)  //find the control numbers for this cpn which havent been invoiced
		CLEAR SET:C117("anyPressDate")  //don't need it here 11/24/04
		QUERY SELECTION:C341([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ProductCode:3=$cpn)
		SELECTION TO ARRAY:C260([Finished_Goods_Specifications:98]OrderNumber:59; $aPrepOrders)
		$numOrders:=Size of array:C274($aPrepOrders)
		$0:=Size of array:C274(aOrderNumbers)
		
		For ($i; 1; $numOrders)
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]OrderNumber:1=$aPrepOrders{$i})  //get the item
			Invoice_NonShippingItem("*")  // •and invoice the sob's• 
		End for 
		
End case 