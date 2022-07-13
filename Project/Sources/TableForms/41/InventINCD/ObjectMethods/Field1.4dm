//(S)[orderlines].InventINCD.Orderline
//upr 1285 11/22/94
//2/22/95
//3/14/95 show currents moths as CURR
//•080295  MLB  UPR 1490
//*If not aborted then
If (<>fContinue)  //2/22/95
	C_LONGINT:C283($yrs)
	
	//*Determine the age of the orderline
	If ([Customers_Order_Lines:41]DateOpened:13#!00-00-00!)  //1/11/95 upr 1329
		$yrs:=12*(Year of:C25(dDateEnd)-Year of:C25([Customers_Order_Lines:41]DateOpened:13))
		tAge:=Month of:C24(dDateEnd)-Month of:C24([Customers_Order_Lines:41]DateOpened:13)+$yrs
		t10:=String:C10(tAge; "#,###;-#,###;CURR")  //3/14/95
	Else 
		tAge:=0
		t10:="DATE?"  //3/14/95
	End if 
	//*Determine the overrun qty allowed
	tWithOR:=[Customers_Order_Lines:41]Quantity:6*(1+([Customers_Order_Lines:41]OverRun:25/100))
	//*Determine the net shippments
	tNetShipped:=[Customers_Order_Lines:41]Qty_Shipped:10-[Customers_Order_Lines:41]Qty_Returned:35
	//*Determine the open qty with overrun
	If ([Customers_Order_Lines:41]Qty_Open:11>0)  //upr 1285
		tOpenOR:=tWithOR-tNetShipped
	Else 
		tOpenOR:=0
	End if 
	
	tOpenRel:=0
	tWIP:=0  //
	tOrdStk:=0
	tOrdStkDol:=0
	tExcess:=0
	C_LONGINT:C283($i)
	C_TEXT:C284($cpn)
	$cpn:=[Customers_Order_Lines:41]ProductCode:5
	C_REAL:C285($price)
	$price:=[Customers_Order_Lines:41]Price_Per_M:8
	//*Determine planned production & inventory for this orderline
	QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
	If (Records in selection:C76([Job_Forms_Items:44])>0)
		//•080295  MLB  UPR 1490
		//*.   Find all the inventory which can be attributed to this orderline
		ARRAY TEXT:C222($aforms; 0)
		DISTINCT VALUES:C339([Job_Forms_Items:44]JobForm:1; $aforms)
		If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
			
			CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "stock")
			CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "oneForm")
			For ($i; 1; Size of array:C274($aforms))
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$cpn; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobForm:19=$aforms{$i}; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")
				CREATE SET:C116([Finished_Goods_Locations:35]; "oneForm")
				UNION:C120("stock"; "oneForm"; "stock")
			End for 
			USE SET:C118("stock")
			ARRAY LONGINT:C221($aQtyOH; 0)
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
			CLEAR SET:C117("stock")
			CLEAR SET:C117("oneForm")
			
		Else 
			
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=$cpn; *)
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")
			QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Locations:35]JobForm:19; $aforms)
			
			ARRAY LONGINT:C221($aQtyOH; 0)
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
			
		End if   // END 4D Professional Services : January 2019 
		
		ARRAY TEXT:C222($aforms; 0)
		//*.   Find any planned production still open
		ARRAY LONGINT:C221($aYield; 0)
		ARRAY LONGINT:C221($aActual; 0)
		SELECTION TO ARRAY:C260([Job_Forms_Items:44]Qty_Yield:9; $aYield; [Job_Forms_Items:44]Qty_Actual:11; $aActual)
		For ($i; 1; Size of array:C274($aYield))
			If (($aYield{$i}-$aActual{$i})>0)
				tWIP:=tWIP+($aYield{$i}-$aActual{$i})
			End if 
		End for 
		//*.   Tally up the inventory
		For ($i; 1; Size of array:C274($aQtyOH))
			tOrdStk:=tOrdStk+$aQtyOH{$i}
		End for 
		tOrdStkDol:=(tOrdStk/1000)*$price
		ARRAY LONGINT:C221($aQtyOH; 0)
	Else 
		uClearSelection(->[Finished_Goods_Locations:35])  //080995     
	End if   //jmi not zero
	//*Determine open qty on order  
	//tOpenOR should be equal to total qty+overrun, but not to exeed qty on hand
	If (tOpenOR>0)  //if there is open qty on the order
		If (tOrdStk>=[Customers_Order_Lines:41]Qty_Open:11)  //upr 1285 close out with available stock
			If (tOrdStk<tOpenOR)  //•080295  MLB  UPR 1490
				tOpenOR:=tOrdStk
			End if 
			tExcess:=tOrdStk-tOpenOR
		End if 
		
	Else   //order has been filled
		tExcess:=tOrdStk
	End if 
	
	
	//*Get release information, one line per shipto
	C_TEXT:C284(txReleases; $dest)
	C_TEXT:C284($lastDest)
	C_LONGINT:C283($yrs; $open; $shipped)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3)
	ARRAY TEXT:C222($aShipTo; 0)
	ARRAY LONGINT:C221($SchQty; 0)
	ARRAY LONGINT:C221($ActQty; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Shipto:10; $aShipTo; [Customers_ReleaseSchedules:46]Sched_Qty:6; $SchQty; [Customers_ReleaseSchedules:46]Actual_Qty:8; $ActQty)
	SORT ARRAY:C229($aShipTo; $SchQty; $ActQty; >)
	txReleases:=""  //build a text block to print varible frrame on the report
	$lastDest:=""
	$open:=0
	$shipped:=0
	For ($i; 1; Size of array:C274($aShipTo))
		If ($lastDest#$aShipTo{$i})  //setup next destination
			If ($i#1)  //finish last
				$sdest:=Char:C90(32)*35
				$sdest:=Change string:C234($sdest; $dest; 8)
				$sOpen:=String:C10($open; "^^^^^^^^^")
				$sship:=String:C10($shipped; "^^^^^^^^^")
				If (($open+$shipped)#0)  // (($sdest+$sOpen+$sship)#(Char(32)*45))
					txReleases:=txReleases+$sdest+$sOpen+"     "+$sship+Char:C90(13)
				End if 
			End if   //not first iteration
			
			$lastDest:=$aShipTo{$i}
			QUERY:C277([Addresses:30]; [Addresses:30]ID:1=$lastDest)
			If (Records in selection:C76([Addresses:30])=1)
				$dest:=[Addresses:30]City:6+", "+[Addresses:30]State:7
			Else 
				$dest:=""
			End if 
			$open:=0
			$shipped:=0
		End if   //not same dest
		
		If ($ActQty{$i}=0)
			$open:=$open+$SchQty{$i}
			tOpenRel:=tOpenRel+$SchQty{$i}  //this goes in the report subheader as Open Rel Qty
		Else 
			$shipped:=$shipped+$ActQty{$i}
		End if 
	End for 
	//print the last one
	$sdest:=Char:C90(32)*35
	$sdest:=Change string:C234($sdest; $dest; 8)
	$sOpen:=String:C10($open; "^^^^^^^^^")
	$sship:=String:C10($shipped; "^^^^^^^^^")
	If (($open+$shipped)#0)  // (($sdest+$sOpen+$sship)#(Char(32)*45))
		txReleases:=txReleases+$sdest+$sOpen+"     "+$sship+Char:C90(13)
	End if 
	
End if   //continue
//