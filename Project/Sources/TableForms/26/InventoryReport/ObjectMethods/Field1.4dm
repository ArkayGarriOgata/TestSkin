//(S)[F/G].IventoryReport.ProductCode
//upr 1285 11/22/94
//added for upr 02/23/95 chip
//•080195  MLB  UPR 1490
READ ONLY:C145([Finished_Goods_Locations:35])
C_LONGINT:C283($i)

QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Finished_Goods:26]ProductCode:1; *)
QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]CustID:16=[Finished_Goods:26]CustID:2)  //•080195  MLB  UPR 1490
tStock:=0
tStock2:=0
tStock2Ex:=0  //added for upr 02/23/95
tStockEx:=0  //added for upr 02/23/95
tStockBH:=0
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	FIRST RECORD:C50([Finished_Goods_Locations:35])
	For ($i; 1; Records in selection:C76([Finished_Goods_Locations:35]))
		Case of 
			: ([Finished_Goods_Locations:35]Location:2="BH:@")  //exclude bill and holds
				tStockBH:=tStockBH+[Finished_Goods_Locations:35]QtyOH:9
			: ([Finished_Goods_Locations:35]Location:2="FG:@")
				tStock:=tStock+[Finished_Goods_Locations:35]QtyOH:9
			Else   //count all else as examining  `added for upr 02/23/95
				tStockEx:=tStockEx+[Finished_Goods_Locations:35]QtyOH:9
		End case 
		NEXT RECORD:C51([Finished_Goods_Locations:35])
	End for 
	
Else 
	
	ARRAY TEXT:C222($_Location; 0)
	ARRAY LONGINT:C221($_QtyOH; 0)
	SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Location:2; $_Location; [Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
	$nb_record:=Size of array:C274($_QtyOH)
	
	For ($i; 1; $nb_record)
		Case of 
			: ($_Location{$i}="BH:@")  //exclude bill and holds
				tStockBH:=tStockBH+$_QtyOH{$i}
			: ($_Location{$i}="FG:@")
				tStock:=tStock+$_QtyOH{$i}
			Else   //count all else as examining  `added for upr 02/23/95
				tStockEx:=tStockEx+$_QtyOH{$i}
		End case 
		
	End for 
	
End if   // END 4D Professional Services : January 2019 query selection

//tStock2:=tStock

//SEARCH([OrderLines];[OrderLines]ProductCode=[Finished_Goods]ProductCode)
USE SET:C118("OneCustOpenOrders")  //•080195  MLB  UPR 1490
// ******* Verified  - 4D PS - January  2019 ********

QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5=[Finished_Goods:26]ProductCode:1)


// ******* Verified  - 4D PS - January 2019 (end) *********
ARRAY LONGINT:C221($aOrdQty; 0)
ARRAY REAL:C219($aOverRun; 0)
ARRAY LONGINT:C221($aShipped; 0)
ARRAY LONGINT:C221($aReturned; 0)
ARRAY LONGINT:C221($aOpen; 0)
SELECTION TO ARRAY:C260([Customers_Order_Lines:41]Quantity:6; $aOrdQty; [Customers_Order_Lines:41]OverRun:25; $aOverRun; [Customers_Order_Lines:41]Qty_Shipped:10; $aShipped; [Customers_Order_Lines:41]Qty_Returned:35; $aReturned; [Customers_Order_Lines:41]Qty_Open:11; $aOpen)
//i know this is redundant, but if wouldn't work when in the include layout
tOpenOR:=0
//TRACE
For ($i; 1; Size of array:C274($aOrdQty))
	tWithOR:=$aOrdQty{$i}*(1+($aOverRun{$i}/100))
	tNetShipped:=$aShipped{$i}-$aReturned{$i}
	If (tWithOR>tNetShipped)
		If ($aOpen{$i}>0)  //upr 1285 make sure order is still open
			tOpenOR:=tOpenOR+tWithOR-tNetShipped
		End if 
	End if 
End for 
tStock2:=tStock-tOpenOR
tStock2Ex:=tStock2+tStockEx  //•080195  MLB  UPR 1490
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; >)
	FIRST RECORD:C50([Customers_Order_Lines:41])
	
	
Else 
	
	ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13; >)
	
End if   // END 4D Professional Services : January 2019 First record
