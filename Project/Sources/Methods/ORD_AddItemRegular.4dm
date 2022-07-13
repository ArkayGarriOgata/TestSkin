//%attributes = {"publishedWeb":true}
//PM:  ORD_AddItemRegular  110899  mlb
//formerly  `doOrderAddItem     --JML   9/17/93
//called by doOpenOrder2()
//2/23/95
//upr 1447 3/6/95
//4/5/95 upr 1458
//5/3/95 upr 1489 chip
//•051595  MLB  UPR 1508
//•060195  MLB  UPR 184
//•072195  MLB  UPR 1685
//• 11/5/97 cs added assignment of classsifcation from carton spec
//  since this is now mandatory - on orderline it makes sense to do this
//• 4/14/98 cs Nan checking
//• 4/20/98 cs users want to combine multiple divisions of same customer
// Modified by: Mel Bohince (6/18/13) allow the same product code more than once with $make_another_line_item
// Modified by: Mel Bohince (2/11/21) revert to estimate's customer id rather than cspec's custid

C_BOOLEAN:C305($1; $sameItem; $make_another_line_item)
C_LONGINT:C283($2; $thisItem; $0)  //4/5/95 upr 1458
C_TEXT:C284($ordLine; $pCode)

$thisItem:=$2
$0:=$thisItem  //pass bac the same number unless incremented
$sameItem:=$1
$pCode:=[Estimates_Carton_Specs:19]ProductCode:5  //  `4/5/95 upr 1458

If ($sameItem)  //subform prolly incountered
	uConfirm("Combine like items on one line?"; "Combine"; "Separate")
	If (OK=1)
		$make_another_line_item:=False:C215  //add the qty into last orderline
	Else 
		$make_another_line_item:=True:C214  //make a new order line
	End if 
Else 
	$make_another_line_item:=True:C214  //since this isn't a dup'd item
End if 

If ($make_another_line_item)  //(Not($sameItem)) // Modified by: Mel Bohince (6/18/13) allow the same product code more than once
	CREATE RECORD:C68([Customers_Order_Lines:41])
	[Customers_Order_Lines:41]OrderNumber:1:=vord
	[Customers_Order_Lines:41]LineItem:2:=$thisItem  //4/5/95 upr 1458
	$0:=$thisItem+1  //4/5/95 upr 1458
	$ordLine:=fMakeOLkey(vord; $thisItem)
	//$ordLine:=String(vord;"00000")+"."+String($thisItem;"00")  `4/5/95 upr 1458
	[Customers_Order_Lines:41]OrderLine:3:=$ordLine
	//[Customers_Order_Lines]CustID:=[Estimates_Carton_Specs]CustID  //• 4/20/98 cs was vcust  users want to combine multiple divisions of same custome
	[Customers_Order_Lines:41]CustID:4:=vcust  // Modified by: Mel Bohince (2/11/21) revert to estimate's customer
	[Customers_Order_Lines:41]OrderType:22:=[Estimates_Carton_Specs:19]OriginalOrRepeat:9
	[Customers_Order_Lines:41]ProductCode:5:=$pCode
	[Customers_Order_Lines:41]SpecialBilling:37:=False:C215
	[Customers_Order_Lines:41]CartonSpecKey:19:=[Estimates_Carton_Specs:19]CartonSpecKey:7
	[Customers_Order_Lines:41]Classification:29:=[Estimates_Carton_Specs:19]Classification:72  //• 11/5/97 cs 
End if   //not same item
READ WRITE:C146([Finished_Goods:26])
$Denom:=nlGetFGDenom  //5/3/95 standardize $Denom search

If (Records in selection:C76([Finished_Goods:26])=0)
	uConfirm("What is the pricing unit of measure for "+vcust+":"+$pCode; "/Thousand"; "/Each")
	
	If (OK=1)
		$denom:=1000
	Else 
		$denom:=1
	End if 
End if 

Case of   //from dialog
	: (rb1=1)  //want
		[Customers_Order_Lines:41]Quantity:6:=[Customers_Order_Lines:41]Quantity:6+[Estimates_Carton_Specs:19]Quantity_Want:27
		[Customers_Order_Lines:41]Price_Per_M:8:=uNANCheck([Estimates_Carton_Specs:19]PriceWant_Per_M:28)
		vestP:=vestP+uNANCheck((([Estimates_Carton_Specs:19]Quantity_Want:27/$denom)*[Estimates_Carton_Specs:19]PriceWant_Per_M:28))
		
		If ([Estimates_Carton_Specs:19]CostWant_Per_M:25#0)  //upr 1447 3/6/95
			[Customers_Order_Lines:41]Cost_Per_M:7:=[Estimates_Carton_Specs:19]CostWant_Per_M:25
			[Customers_Order_Lines:41]CostLabor_Per_M:30:=[Estimates_Carton_Specs:19]CostLabor_Per_M:64
			[Customers_Order_Lines:41]CostOH_Per_M:31:=[Estimates_Carton_Specs:19]CostOH_Per_M:65
			[Customers_Order_Lines:41]CostMatl_Per_M:32:=[Estimates_Carton_Specs:19]CostMatl_Per_M:66
			[Customers_Order_Lines:41]CostScrap_Per_M:33:=[Estimates_Carton_Specs:19]CostScrap_Per_M:67
			vestC:=vestC+(([Estimates_Carton_Specs:19]Quantity_Want:27/$denom)*[Estimates_Carton_Specs:19]CostWant_Per_M:25)
		Else 
			[Customers_Order_Lines:41]ExcessQtySold:40:=[Customers_Order_Lines:41]ExcessQtySold:40+[Estimates_Carton_Specs:19]Quantity_Want:27
		End if 
		
	: (rb2=1)  //yield
		[Customers_Order_Lines:41]Quantity:6:=[Customers_Order_Lines:41]Quantity:6+[Estimates_Carton_Specs:19]Quantity_Yield:29
		[Customers_Order_Lines:41]Price_Per_M:8:=uNANCheck([Estimates_Carton_Specs:19]PriceYield_PerM:30)
		vestP:=vestP+uNANCheck((([Estimates_Carton_Specs:19]Quantity_Yield:29/$denom)*[Estimates_Carton_Specs:19]PriceYield_PerM:30))
		
		If ([Estimates_Carton_Specs:19]CostYield_Per_M:26#0)  //upr 1447 3/6/95
			[Customers_Order_Lines:41]Cost_Per_M:7:=[Estimates_Carton_Specs:19]CostYield_Per_M:26
			[Customers_Order_Lines:41]CostLabor_Per_M:30:=[Estimates_Carton_Specs:19]CostYldLabor:68
			[Customers_Order_Lines:41]CostOH_Per_M:31:=[Estimates_Carton_Specs:19]CostYldOH:69
			[Customers_Order_Lines:41]CostMatl_Per_M:32:=[Estimates_Carton_Specs:19]CostYldMatl:70
			[Customers_Order_Lines:41]CostScrap_Per_M:33:=[Estimates_Carton_Specs:19]CostYldSE:71
			vestC:=vestC+(([Estimates_Carton_Specs:19]Quantity_Yield:29/$denom)*[Estimates_Carton_Specs:19]CostYield_Per_M:26)
		Else 
			[Customers_Order_Lines:41]ExcessQtySold:40:=[Customers_Order_Lines:41]ExcessQtySold:40+[Estimates_Carton_Specs:19]Quantity_Want:27
		End if 
	Else 
		BEEP:C151
		ALERT:C41("Error in DoOrderAddItem")
End case 

uLinesLikeOrder  //•051595  MLB  UPR 1508

If ([Estimates_Carton_Specs:19]PONumber:73#"")  //•072195  MLB  UPR 1685
	[Customers_Order_Lines:41]PONumber:21:=[Estimates_Carton_Specs:19]PONumber:73
End if 

[Customers_Order_Lines:41]NeedDate:14:=[Estimates:17]z_DateEstimateNeeded:21
If ([Customers_Orders:40]Status:10="CONTRACT")  //•060195  MLB  UPR 184
	[Customers_Order_Lines:41]Status:9:="CONTRACT"
	//•050396  MLB  UPR 184
	//*Get the contract price and cost
	[Customers_Order_Lines:41]Price_Per_M:8:=uNANCheck(SetContractCost([Estimates_Carton_Specs:19]CustID:6; [Estimates_Carton_Specs:19]ProductCode:5; ->[Customers_Order_Lines:41]Cost_Per_M:7; ->[Customers_Order_Lines:41]CostMatl_Per_M:32; ->[Customers_Order_Lines:41]CostLabor_Per_M:30; ->[Customers_Order_Lines:41]CostOH_Per_M:31; ->[Customers_Order_Lines:41]CostScrap_Per_M:33))
Else 
	[Customers_Order_Lines:41]Status:9:="New"
End if 
[Customers_Order_Lines:41]DateOpened:13:=4D_Current_date
[Customers_Order_Lines:41]Qty_Shipped:10:=0
[Customers_Order_Lines:41]Qty_Open:11:=[Customers_Order_Lines:41]Quantity:6
[Customers_Order_Lines:41]OverRun:25:=[Estimates_Carton_Specs:19]OverRun:47
[Customers_Order_Lines:41]UnderRun:26:=[Estimates_Carton_Specs:19]UnderRun:48
[Customers_Order_Lines:41]Classification:29:=[Estimates_Carton_Specs:19]Classification:72
gOrdFGLastValue  //5/3/95 upr 1489

If ([Finished_Goods:26]ClassOrType:28#"")  //5/3/95 upr 1489
	[Customers_Order_Lines:41]Classification:29:=[Finished_Goods:26]ClassOrType:28  //????
End if 

SAVE RECORD:C53([Customers_Order_Lines:41])
UNLOAD RECORD:C212([Finished_Goods:26])