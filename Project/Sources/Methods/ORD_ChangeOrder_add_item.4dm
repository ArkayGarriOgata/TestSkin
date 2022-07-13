//%attributes = {"publishedWeb":true}
//(P) ORD_ChangeOrder_add_item was doCOAdd2     --BAK   6/24/94
//upr 1411 1/25/95 
//option:  searching item no by loop counter(as originally done) or c-spec item no
//and attempt to add missing product classifications
//UPR 1188 02/13/95 chip
//upr 1437 2/20/95 combine qty of same item# c-specs
//upr 1447 3/6/95
//•051595  MLB  UPR 1508
//• 4/9/98 cs nan checking/removal
//mlb 111899 turn off speciall billing flag
// Modified by: Mel Bohince (6/18/13) remove the byPosition option, as it is always on

C_BOOLEAN:C305($make_another_line_item)
C_LONGINT:C283($1; $lastItem; $0)  //4/5/95 upr 1458

$lastItem:=$1

USE SET:C118("addedChangeOrderItems")  // these are the freshly made cco items that match the order
//QUERY SELECTION([Customers_Order_Changed_Items];[Customers_Order_Changed_Items]ItemNo=$thisItem)  
// ******* Verified  - 4D PS - January  2019 ********
QUERY SELECTION:C341([Customers_Order_Changed_Items:176]; [Customers_Order_Changed_Items:176]OldProductCode:9=[Estimates_Carton_Specs:19]ProductCode:5)

// ******* Verified  - 4D PS - January 2019 (end) *********

Case of 
	: (Records in selection:C76([Customers_Order_Changed_Items:176])=0)  // must be adding an item
		$make_another_line_item:=True:C214
		
	: (Records in selection:C76([Customers_Order_Changed_Items:176])>0)  //found one already there, subform situation?
		uConfirm("Combine "+[Estimates_Carton_Specs:19]ProductCode:5+" on one line "+String:C10([Customers_Order_Changed_Items:176]ItemNo:1)+"?"; "Combine"; "Separate")
		If (OK=1)
			$make_another_line_item:=False:C215  //add the qty into last orderline
		Else 
			$make_another_line_item:=True:C214  //make a new order line
		End if 
End case 

If ($make_another_line_item)
	CREATE RECORD:C68([Customers_Order_Changed_Items:176])
	[Customers_Order_Changed_Items:176]id_added_by_converter:41:=[Customers_Order_Change_Orders:34]OrderChg_Items:6
	$lastItem:=$lastItem+1
	[Customers_Order_Changed_Items:176]ItemNo:1:=$lastItem  //$item_num  //••••
Else 
	
End if 
[Customers_Order_Changed_Items:176]NewProductCode:10:=[Estimates_Carton_Specs:19]ProductCode:5
[Customers_Order_Changed_Items:176]NewOverRun:31:=[Estimates_Carton_Specs:19]OverRun:47
[Customers_Order_Changed_Items:176]NewUnderRun:33:=[Estimates_Carton_Specs:19]UnderRun:48
[Customers_Order_Changed_Items:176]CartonSpecKey:6:=[Estimates_Carton_Specs:19]CartonSpecKey:7  //added UPR 1188 02/13/95 chip
[Customers_Order_Changed_Items:176]NewOrdType:15:=[Estimates_Carton_Specs:19]OriginalOrRepeat:9  //BAK 9/13/94 was using incorrect field
If (Length:C16([Customers_Order_Changed_Items:176]NewOrdType:15)=0)
	[Customers_Order_Changed_Items:176]NewOrdType:15:=[Customers_Order_Changed_Items:176]OrderType:8
End if 
[Customers_Order_Changed_Items:176]SpecialBilling:38:=False:C215  //mlb 111899

If ([Customers_Order_Changed_Items:176]NewClassificati:35="")  //1/25/95
	If ([Finished_Goods:26]FG_KEY:47#([Estimates_Carton_Specs:19]CustID:6+":"+[Estimates_Carton_Specs:19]ProductCode:5))
		READ ONLY:C145([Finished_Goods:26])
		qryFinishedGood([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5)  //•051595  MLB  UPR 1508
	End if 
	[Customers_Order_Changed_Items:176]NewClassificati:35:=[Finished_Goods:26]ClassOrType:28
End if 

Case of 
	: (rb1=1)
		[Customers_Order_Changed_Items:176]NewQty:4:=[Customers_Order_Changed_Items:176]NewQty:4+[Estimates_Carton_Specs:19]Quantity_Want:27  //2/20/95
		If ([Estimates_Carton_Specs:19]CostWant_Per_M:25#0)  //upr 1447 3/6/95      
			[Customers_Order_Changed_Items:176]NewCost:14:=[Estimates_Carton_Specs:19]CostWant_Per_M:25
			[Customers_Order_Changed_Items:176]NewLaborCost:19:=[Estimates_Carton_Specs:19]CostLabor_Per_M:64
			[Customers_Order_Changed_Items:176]NewOHCost:21:=[Estimates_Carton_Specs:19]CostOH_Per_M:65
			[Customers_Order_Changed_Items:176]NewMatlCost:17:=[Estimates_Carton_Specs:19]CostMatl_Per_M:66
			[Customers_Order_Changed_Items:176]NewSECost:23:=[Estimates_Carton_Specs:19]CostScrap_Per_M:67
		Else 
			[Customers_Order_Changed_Items:176]NewExcessQty:40:=[Customers_Order_Changed_Items:176]NewExcessQty:40+[Estimates_Carton_Specs:19]Quantity_Want:27
		End if 
		
		[Customers_Order_Changed_Items:176]NewPrice:5:=[Estimates_Carton_Specs:19]PriceWant_Per_M:28
	: (rb2=1)
		[Customers_Order_Changed_Items:176]NewQty:4:=[Customers_Order_Changed_Items:176]NewQty:4+[Estimates_Carton_Specs:19]Quantity_Yield:29  //2/20/95
		If ([Estimates_Carton_Specs:19]CostWant_Per_M:25#0)  //upr 1447 3/6/95
			[Customers_Order_Changed_Items:176]NewCost:14:=[Estimates_Carton_Specs:19]CostYield_Per_M:26
			[Customers_Order_Changed_Items:176]NewLaborCost:19:=[Estimates_Carton_Specs:19]CostYldLabor:68
			[Customers_Order_Changed_Items:176]NewOHCost:21:=[Estimates_Carton_Specs:19]CostYldOH:69
			[Customers_Order_Changed_Items:176]NewMatlCost:17:=[Estimates_Carton_Specs:19]CostYldMatl:70
			[Customers_Order_Changed_Items:176]NewSECost:23:=[Estimates_Carton_Specs:19]CostYldSE:71
		Else 
			[Customers_Order_Changed_Items:176]NewExcessQty:40:=[Customers_Order_Changed_Items:176]NewExcessQty:40+[Estimates_Carton_Specs:19]Quantity_Want:27
		End if 
		[Customers_Order_Changed_Items:176]NewPrice:5:=[Estimates_Carton_Specs:19]PriceYield_PerM:30
	Else 
		BEEP:C151
		ALERT:C41("Please contact Impact Solutions, error in doCOAdd2")
End case 

SAVE RECORD:C53([Customers_Order_Changed_Items:176])
$0:=$lastItem  //pass bac the same number unless incremented