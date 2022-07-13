//•081195  MLB  make sure tStock is init for each orderline
//•081795  MLB 
//•031496  MLB limit to jobit number
Case of 
	: (Form event code:C388=On Display Detail:K2:22)
		//Script: tExcessDolT in B1 area increments liCust    
		If (liCust>Size of array:C274(aCustomer))  //if element to enter is larger than array insert element in to arrays
			liValues:=liCust  //increment value indexes (customer incremented in break)    
			INSERT IN ARRAY:C227(aCustomer; liCust)  //add a customer element
			For ($i; 1; 8)  //•081795  MLB 
				INSERT IN ARRAY:C227(aTotals{$i}; liValues)  //add value elements, atotals assigned in B1, by scripts
			End for 
		End if 
		
		If (aCustomer{liCust}="")  //no customer name entered yet
			aCustomer{liCust}:=[Customers_Order_Lines:41]CustomerName:24
		End if 
		
		If (([Customers_Order_Lines:41]CustID:4+":"+[Customers_Order_Lines:41]ProductCode:5)#[Finished_Goods:26]FG_KEY:47)
			qryFinishedGood([Customers_Order_Lines:41]CustID:4; [Customers_Order_Lines:41]ProductCode:5)
		End if 
		
		//*Determine planned production & inventory for this orderline
		tStock:=0  //•081195  MLB  make sure tStock is init for each orderline
		tStockDol:=0  //•081195  MLB  make sure tStock is init for each orderline
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OrderItem:2=[Customers_Order_Lines:41]OrderLine:3)
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			//•080295  MLB  UPR 1490
			//*.   Find all the inventory which can be attributed to this orderline
			// (see also doContractExpi)
			ARRAY TEXT:C222($aforms; 0)
			//DISTINCT VALUES([JobMakesItem]JobForm;$aforms)
			ARRAY LONGINT:C221($aItem; 0)  //•031496  MLB 
			SELECTION TO ARRAY:C260([Job_Forms_Items:44]JobForm:1; $aforms; [Job_Forms_Items:44]ItemNumber:7; $aItem)  //•031496  MLB
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
				
				CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "stock")
				CREATE EMPTY SET:C140([Finished_Goods_Locations:35]; "oneForm")
				
				For ($i; 1; Size of array:C274($aforms))
					QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobForm:19=$aforms{$i}; *)
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]JobFormItem:32=$aItem{$i}; *)  //•031496  MLB
					QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")
					CREATE SET:C116([Finished_Goods_Locations:35]; "oneForm")
					UNION:C120("stock"; "oneForm"; "stock")
				End for 
				USE SET:C118("stock")
				CLEAR SET:C117("stock")
				CLEAR SET:C117("oneForm")
				
			Else 
				
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]ProductCode:1=[Customers_Order_Lines:41]ProductCode:5; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2="FG:@")
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Locations:35]JobForm:19; $aforms)
				QUERY SELECTION WITH ARRAY:C1050([Finished_Goods_Locations:35]JobFormItem:32; $aItem)
				
			End if   // END 4D Professional Services : January 2019 
			
			ARRAY LONGINT:C221($aQtyOH; 0)
			SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]QtyOH:9; $aQtyOH)
			//*.   Tally up the inventory
			tStock:=0
			For ($i; 1; Size of array:C274($aQtyOH))
				tStock:=tStock+$aQtyOH{$i}
			End for 
			tStockDol:=(tStock/1000)*[Customers_Order_Lines:41]Price_Per_M:8
			ARRAY TEXT:C222($aforms; 0)
			ARRAY LONGINT:C221($aQtyOH; 0)
		Else 
			uClearSelection(->[Finished_Goods_Locations:35])
		End if 
		
		tOR:=[Customers_Order_Lines:41]Quantity:6*(1+([Customers_Order_Lines:41]OverRun:25/100))
		tOpen:=tOR-[Customers_Order_Lines:41]Qty_Shipped:10+[Customers_Order_Lines:41]Qty_Returned:35
		If (tOpen<0)
			tOpen:=0
		End if 
		tOpenDol:=(tOpen/1000)*[Customers_Order_Lines:41]Price_Per_M:8
		
		
		If (tStock>tOpen)
			tCustStock:=tOpen
		Else 
			tCustStock:=tStock
		End if 
		tCustDol:=(tCustStock/1000)*[Customers_Order_Lines:41]Price_Per_M:8
		
		If ([Customers_Order_Lines:41]DateOpened:13#!00-00-00!)
			$yrs:=12*(Year of:C25(dDateEnd)-Year of:C25([Customers_Order_Lines:41]DateOpened:13))
			tAge:=Month of:C24(dDateEnd)-Month of:C24([Customers_Order_Lines:41]DateOpened:13)+$yrs
		Else 
			tAge:=0
		End if 
		
		tExcess:=tStock-tOpen
		If (tExcess<0)
			tExcess:=0
		End if 
		tExcessDol:=(tExcess/1000)*[Customers_Order_Lines:41]Price_Per_M:8
		//*Get open releases
		QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8=0)
		ARRAY LONGINT:C221($aQtyOH; 0)
		SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Qty:6; $aQtyOH)
		tReleases:=0
		For ($i; 1; Size of array:C274($aQtyOH))
			tReleases:=tReleases+$aQtyOH{$i}
		End for 
		
End case 
//eolp