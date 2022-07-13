//%attributes = {"publishedWeb":true}
//(P) afterPOI: after phase for PO Items
//upr 1295a 11/3/94 update cost on bin and xfer 
//4/26/95 upr 1469 chip
//Upr 0235 Cs - 12/4/96 - change in chargecode format
//• 4/11/97 cs launch RmSubgroup change if Needed into it's own process
//• 4/1/98 cs Nan checking
//• 4/30/98 cs added tracking for RM codes on change orders
//•121798  mlb correct how unit cost is caluclated
//•5/06/99  MLB  move as much aout of theis method as possible
//•051899  mlb  unload bin and xfer records before price change on server

C_LONGINT:C283($pid)

PO_setExtendedTotals("current")

If (Not:C34([Purchase_Orders_Items:12]Canceled:44))
	[Purchase_Orders_Items:12]Qty_Open:27:=[Purchase_Orders_Items:12]Qty_Shipping:4-[Purchase_Orders_Items:12]Qty_Received:14
Else 
	[Purchase_Orders_Items:12]Qty_Open:27:=0
End if 
uUpdateTrail(->[Purchase_Orders_Items:12]ModDate:19; ->[Purchase_Orders_Items:12]ModWho:20; ->[Purchase_Orders_Items:12]zCount:21)

If (Is new record:C668([Purchase_Orders_Items:12])) & ([Purchase_Orders:11]DefaultJobId:3#"")  //new po_item & default job number was entered
	$numJobs:=0  // Modified by: Mel Bohince (6/9/21) 
	SET QUERY DESTINATION:C396(Into variable:K19:4; $numJobs)
	QUERY SELECTION:C341([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders_Items:12]POItemKey:1)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	If ($numJobs=0)  //if there is no record, 
		CREATE RECORD:C68([Purchase_Orders_Job_forms:59])  //create it
		[Purchase_Orders_Job_forms:59]POItemKey:1:=[Purchase_Orders_Items:12]POItemKey:1
		[Purchase_Orders_Job_forms:59]JobFormID:2:=[Purchase_Orders:11]DefaultJobId:3
		SAVE RECORD:C53([Purchase_Orders_Job_forms:59])
	End if 
End if 

If (lPOCORec>0)  //change order, record item change
	GOTO RECORD:C242([Purchase_Orders_Chg_Orders:13]; lPOCORec)  //get it back
	QUERY:C277([Purchase_Orders_ChgOrder_Items:166]; [Purchase_Orders_ChgOrder_Items:166]id_added_by_converter:10=[Purchase_Orders_Chg_Orders:13]POCO_Items:9; *)
	QUERY:C277([Purchase_Orders_ChgOrder_Items:166];  & ; [Purchase_Orders_ChgOrder_Items:166]ItemNo:1=[Purchase_Orders_Items:12]ItemNo:3)
	If (Records in selection:C76([Purchase_Orders_ChgOrder_Items:166])=0)
		CREATE RECORD:C68([Purchase_Orders_ChgOrder_Items:166])
		[Purchase_Orders_ChgOrder_Items:166]id_added_by_converter:10:=[Purchase_Orders_Chg_Orders:13]POCO_Items:9
		[Purchase_Orders_ChgOrder_Items:166]ItemNo:1:=[Purchase_Orders_Items:12]ItemNo:3
		[Purchase_Orders_ChgOrder_Items:166]OldQty:2:=Old:C35([Purchase_Orders_Items:12]Qty_Shipping:4)
		[Purchase_Orders_ChgOrder_Items:166]OldUOM:3:=Old:C35([Purchase_Orders_Items:12]UM_Ship:5)
		[Purchase_Orders_ChgOrder_Items:166]OldPrice:4:=Old:C35([Purchase_Orders_Items:12]UnitPrice:10)
		[Purchase_Orders_ChgOrder_Items:166]OldRawMatlCode:8:=Old:C35([Purchase_Orders_Items:12]Raw_Matl_Code:15)  //• 4/30/98 cs 
		[Purchase_Orders_ChgOrder_Items:166]NewRawMatlCode:9:=[Purchase_Orders_Items:12]Raw_Matl_Code:15  //• 4/30/98 cs   
	End if 
	[Purchase_Orders_ChgOrder_Items:166]NewQty:5:=[Purchase_Orders_Items:12]Qty_Shipping:4
	If (Not:C34(Old:C35([Purchase_Orders_Items:12]Canceled:44))) & ([Purchase_Orders_Items:12]Canceled:44)
		[Purchase_Orders_ChgOrder_Items:166]NewQty:5:=0
	End if 
	[Purchase_Orders_ChgOrder_Items:166]NewUOM:6:=[Purchase_Orders_Items:12]UM_Ship:5
	[Purchase_Orders_ChgOrder_Items:166]NewPrice:7:=[Purchase_Orders_Items:12]UnitPrice:10
	SAVE RECORD:C53([Purchase_Orders_ChgOrder_Items:166])
End if 

If (Old:C35([Purchase_Orders_Items:12]UnitPrice:10)#[Purchase_Orders_Items:12]UnitPrice:10) | (Old:C35([Purchase_Orders_Items:12]FactNship2price:25)#[Purchase_Orders_Items:12]FactNship2price:25) | (Old:C35([Purchase_Orders_Items:12]FactDship2price:38)#[Purchase_Orders_Items:12]FactDship2price:38) | (Old:C35([Purchase_Orders_Items:12]FactDship2cost:37)#[Purchase_Orders_Items:12]FactDship2cost:37) | (Old:C35([Purchase_Orders_Items:12]FactNship2cost:29)#[Purchase_Orders_Items:12]FactNship2cost:29)  //• 4/7/98 cs total $ or unit price change
	C_LONGINT:C283($pid)
	//$pid:=Execute on server("POIpriceChange";64000;"POIpriceChange"
	//«;[PO_Items]POItemKey;rActPrice;[PO_Items]ExpenseCode)
	rActPrice:=([Purchase_Orders_Items:12]UnitPrice:10*([Purchase_Orders_Items:12]FactNship2price:25/[Purchase_Orders_Items:12]FactDship2price:38))*([Purchase_Orders_Items:12]FactNship2cost:29/[Purchase_Orders_Items:12]FactDship2cost:37)
	POIpriceChange([Purchase_Orders_Items:12]POItemKey:1; rActPrice; [Purchase_Orders_Items:12]ExpenseCode:47)
End if 

If (fNewRM)
	fNewRM:=False:C215
	Case of 
		: (applyFixedCost=0)
			//don't change 
		: (applyFixedCost=1)  //reverting to normal poi
			RMX_setCosts([Purchase_Orders_Items:12]POItemKey:1; [Purchase_Orders_Items:12]UnitPrice:10)
		: (applyFixedCost=2)  //doing the special fixed cost calcution 
			POI_FixedCostCorrection
	End case 
	
	RM_makeLikePOI2([Purchase_Orders_Items:12]POItemKey:1; rActPrice)
End if 
REDUCE SELECTION:C351([Raw_Materials:21]; 0)