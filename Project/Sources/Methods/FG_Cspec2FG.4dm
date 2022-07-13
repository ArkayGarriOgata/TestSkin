//%attributes = {"publishedWeb":true}
//PM:  FG_Cspec2FG  110999  mlb
//see also FG_CspecLikeFG
//formerly  `uCspec2FG(ordernumber)
//see also uCspecLikeFG
//$1 longint, ordernumber if = 0 skip assignment
//upr 96 8/16/94
//11/9/94 eliminate proc uCOCspec2FG
//upr 1268 chip 02/17/95
//3/6/95 add classification
//mod 4/18/95 chip special billing prob
//5/3/95 upr 1489 chip
//•060295  MLB  UPR 184 try to add brand
//•011696  MLB  pass Notes containing gluer and speed.
//• 4/14/98 cs Nan checking
//• 4/16/98 cs insure an income code is assigned
//• mlb - 4/3/03  12:51 don't change outline numbers this way
// Modified by: Mel Bohince (3/8/16) protect when estimate is for a combined customer (merge job)

C_LONGINT:C283($i; $j; $1)

If ([Finished_Goods:26]Status:14#"Final") & (Position:C15("obsolete"; [Finished_Goods:26]Status:14)=0)
	If (Count parameters:C259=2)  //call by gChgOApproval
		util_ReplaceIfNotBlank(->[Finished_Goods:26]ProductCode:1; ->[Customers_Order_Lines:41]ProductCode:5)
		util_ReplaceIfNotBlank(->[Finished_Goods:26]CustID:2; ->[Customers_Order_Lines:41]CustID:4)
		util_ReplaceIfNotBlank(->[Finished_Goods:26]Line_Brand:15; ->[Customers_Order_Lines:41]CustomerLine:42)  //•060295  MLB  UPR 184
		util_ReplaceIfNotBlank(->[Finished_Goods:26]ProjectNumber:82; ->[Customers_Order_Lines:41]ProjectNumber:50)
		
	Else 
		util_ReplaceIfNotBlank(->[Finished_Goods:26]ProductCode:1; ->[Estimates_Carton_Specs:19]ProductCode:5)
		util_ReplaceIfNotBlank(->[Finished_Goods:26]CustID:2; ->[Estimates_Carton_Specs:19]CustID:6)
		If ([Estimates:17]Cust_ID:2#<>sCombindID)  // Modified by: Mel Bohince (3/8/16) protect when estimate is for a combined customer (merge job)
			util_ReplaceIfNotBlank(->[Finished_Goods:26]Line_Brand:15; ->[Estimates:17]Brand:3)  //•060295  MLB  UPR 184
			util_ReplaceIfNotBlank(->[Finished_Goods:26]ProjectNumber:82; ->[Estimates:17]ProjectNumber:63)
		End if 
	End if 
	
	util_ReplaceIfNotBlank(->[Finished_Goods:26]ClassOrType:28; ->[Estimates_Carton_Specs:19]Classification:72)
	
	If ([Customers_Order_Lines:41]SpecialBilling:37)  //upr 1268 chip 02/17/95
		[Finished_Goods:26]Acctg_UOM:29:="E"
		[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]ProductCode:1
		[Finished_Goods:26]SpecialBilling:23:=True:C214
		[Finished_Goods:26]CustID:2:=""
	Else 
		[Finished_Goods:26]FG_KEY:47:=[Finished_Goods:26]CustID:2+":"+[Finished_Goods:26]ProductCode:1
	End if 
	
	util_ReplaceIfNotBlank(->[Finished_Goods:26]CartonDesc:3; ->[Estimates_Carton_Specs:19]Description:14)
	
	//• mlb - 4/3/03  12:51
	util_ReplaceIfNotBlank(->[Finished_Goods:26]OutLine_Num:4; ->[Estimates_Carton_Specs:19]OutLineNumber:15; "no-overlay")
	util_ReplaceIfNotBlank(->[Finished_Goods:26]PackingSpecification:103; ->[Estimates_Carton_Specs:19]OutLineNumber:15; "no-overlay")
	
	util_ReplaceIfNotBlank(->[Finished_Goods:26]SquareInch:6; ->[Estimates_Carton_Specs:19]SquareInches:16)
	util_ReplaceIfNotBlank(->[Finished_Goods:26]ProcessSpec:33; ->[Estimates_Carton_Specs:19]ProcessSpec:3)
	//[Finished_Goods]Status:="Ordered"
	
	If ($1#0)  //5/3/95 upr 1489 chip, stop order assign if $1 =0
		[Finished_Goods:26]LastOrderNo:18:=$1
	End if 
	
	[Estimates_Carton_Specs:19]PriceWant_Per_M:28:=uNANCheck([Estimates_Carton_Specs:19]PriceWant_Per_M:28)
	[Estimates_Carton_Specs:19]CostYield_Per_M:26:=uNANCheck([Estimates_Carton_Specs:19]CostYield_Per_M:26)
	util_ReplaceIfNotBlank(->[Finished_Goods:26]LastPrice:27; ->[Estimates_Carton_Specs:19]PriceWant_Per_M:28)
	util_ReplaceIfNotBlank(->[Finished_Goods:26]LastCost:26; ->[Estimates_Carton_Specs:19]CostYield_Per_M:26)
	
	[Finished_Goods:26]Width:7:=[Estimates_Carton_Specs:19]Width:17
	[Finished_Goods:26]Depth:8:=[Estimates_Carton_Specs:19]Depth:18
	[Finished_Goods:26]Height:9:=[Estimates_Carton_Specs:19]Height:19
	[Finished_Goods:26]Width_Dec:10:=[Estimates_Carton_Specs:19]Width_Dec:20
	[Finished_Goods:26]Depth_Dec:11:=[Estimates_Carton_Specs:19]Depth_Dec:21
	[Finished_Goods:26]Height_Dec:12:=[Estimates_Carton_Specs:19]Height_Dec:22
	[Finished_Goods:26]Style:32:=[Estimates_Carton_Specs:19]Style:4
	[Finished_Goods:26]StripHoles:38:=[Estimates_Carton_Specs:19]StripHoles:46
	[Finished_Goods:26]WindowMatl:39:=[Estimates_Carton_Specs:19]WindowMatl:35
	[Finished_Goods:26]WindowGauge:40:=[Estimates_Carton_Specs:19]WindowGauge:36
	[Finished_Goods:26]WindowWth:41:=[Estimates_Carton_Specs:19]WindowWth:37
	[Finished_Goods:26]WindowHth:42:=[Estimates_Carton_Specs:19]WindowHth:38
	util_ReplaceIfNotBlank(->[Finished_Goods:26]GlueType:34; ->[Estimates_Carton_Specs:19]GlueType:41)
	[Finished_Goods:26]GlueInspect:35:=[Estimates_Carton_Specs:19]GlueInspect:42
	[Finished_Goods:26]SecurityLabels:36:=[Estimates_Carton_Specs:19]SecurityLabels:43
	//util_ReplaceIfNotBlank (->[Finished_Goods]UPC;->[Estimates_Carton_Specs]UPC)
	util_ReplaceIfNotBlank(->[Finished_Goods:26]DieCutOptions:44; ->[Estimates_Carton_Specs:19]DieCutOptions:49)
	util_ReplaceIfNotBlank(->[Finished_Goods:26]PackingQty:45; ->[Estimates_Carton_Specs:19]PackingQty:61)
	
	//• 4/16/98 cs insure an income code is assigned
	QUERY:C277([Finished_Goods_Classifications:45]; [Finished_Goods_Classifications:45]Class:1=[Estimates_Carton_Specs:19]Classification:72)
	[Finished_Goods:26]GL_Income_Code:22:=[Finished_Goods_Classifications:45]GL_income_code:3
	
	[Finished_Goods:26]ModWho:25:=<>zResp
	[Finished_Goods:26]ModDate:24:=4D_Current_date
	If ([Finished_Goods:26]Acctg_UOM:29="")  //upr 1268 chip 02/17/95
		[Finished_Goods:26]Acctg_UOM:29:="M"
	End if 
	util_ReplaceIfNotBlank(->[Finished_Goods:26]Notes:20; ->[Estimates_Carton_Specs:19]CartonComment:12; "no_overlay")  //•011696  MLB  to hold glue speed
	
	[Finished_Goods:26]Leaf_Information:107:=[Estimates_Carton_Specs:19]Leaf_Information:77
	
Else 
	BEEP:C151
	zwStatusMsg("F/G: "; [Finished_Goods:26]ProductCode:1+" has status of 'Final' or 'Obsolete', record not overwritten.")
End if 