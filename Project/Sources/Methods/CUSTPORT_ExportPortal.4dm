//%attributes = {}
//© 2020 Footprints Inc. All Rights Reserved.
//Method: Method: CUSTPORT_ExportPortal - Created `v1.0.3-PJK (2/27/20)
// Modified by: Mel Bohince (3/3/20) replace FG_Inventory_Array dependency with 
// methods FG_Inventory_CanShip and FG_Inventory_InCert

// Populate Portal_ItemMaster based on the {Customers} belonging to Customer_Portal_Extracts 
//   which is essentially group id's for those customers.
//   So ELC which is the parent company for several ams customers would be one Customer_Portal_Extract
//   and when a user is given access to ELC, then all of ELC's customers would be visiable


C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_COLLECTION:C1488($coCustomers)
C_OBJECT:C1216($enLoginRec; $esLogins; $esItems; $esCusts)
C_TEXT:C284($ttCustID; $timestamp; $ttAccessFilter)

READ WRITE:C146([Portal_ItemMaster:160])

//$esLogins:=ds.Customer_Portal_Extracts.query("CustId = :1";"")  //this eliminates the old sql ids, 
$esLogins:=ds:C1482.Customer_Portal_Extracts.all()
For each ($enLoginRec; $esLogins)
	$ttAccessFilter:=$enLoginRec.pk_id
	$currentExtractName:=$enLoginRec.Name
	
	zwStatusMsg($currentExtractName; "Clearing prior item master...")
	// DELETE ALL RECORDS FOR THIS Company's extract
	$esItems:=ds:C1482.Portal_ItemMaster.query("AccessID = :1"; $ttAccessFilter)
	$esItems.drop()  //not testing for fails
	// END DELETE
	
	If ($enLoginRec.Active)  // If this web user is active, continue
		$coCustomers:=OB Get:C1224($enLoginRec.Customers; "List"; Is collection:K8:32)
		If ($coCustomers=Null:C1517)
			$coCustomers:=New collection:C1472
		End if 
		
		//build arrays to leverage old extract code
		ARRAY TEXT:C222($cust_ids; 0)
		ARRAY BOOLEAN:C223($cust_hide_all_excess; 0)
		ARRAY BOOLEAN:C223($cust_hide_promo_excess; 0)
		For each ($ttCustID; $coCustomers)
			$esCusts:=ds:C1482.Customers.query("ID = :1"; $ttCustID)
			If ($esCusts.length>0)  //valid cust id
				APPEND TO ARRAY:C911($cust_ids; $ttCustID)
				APPEND TO ARRAY:C911($cust_hide_all_excess; $enLoginRec.Hide_All_Excess)
				APPEND TO ARRAY:C911($cust_hide_promo_excess; $enLoginRec.Hide_Promo_Excess)
			End if 
		End for each 
		
		
		//
		If (Size of array:C274($cust_ids)>0)
			//FG_Inventory_Array   // ??????? Do we need this at all???
			$timestamp:=fYYMMDD(Current date:C33; 0; "")+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
			//**************************
			//for each customer in the the cust_id's array:
			//get open jobits, orders, and releases along with their f/g record 
			//plus and f/g records that have inventory
			
			//this union will be the f/g's included in the item master
			//**************************
			
			//**************************
			//get the inventoried f/g's 
			zwStatusMsg($currentExtractName; "Gathering F/G's Locations...")
			QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]CustID:16; $cust_ids)
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0; *)  //close search and in case there are negatives
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]KillStatus:30=0)  // Modified by: Mel Bohince (6/7/18) don't include kills
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "inventory")
			
			zwStatusMsg($currentExtractName; "Gathering F/G's Jobits...")
			QUERY WITH ARRAY:C644([Job_Forms_Items:44]CustId:15; $cust_ids)
			QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //close search and item not completed
			CREATE SET:C116([Job_Forms_Items:44]; "jobs")  //need this later
			RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_jobs")
			UNION:C120("inventory"; "fg_jobs"; "finished_goods")
			CLEAR SET:C117("fg_jobs")
			
			zwStatusMsg($currentExtractName; "Gathering F/G's Orderlines...")
			QUERY WITH ARRAY:C644([Customers_Order_Lines:41]CustID:4; $cust_ids)
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#("can@"); *)
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#("kill@"))
			CREATE SET:C116([Customers_Order_Lines:41]; "cust_orders")
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#("close@"); *)
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)  //close search and order still open
			CREATE SET:C116([Customers_Order_Lines:41]; "orders")  //need this later
			
			USE SET:C118("cust_orders")  //get historical order lines
			$cut_off:=Add to date:C393(4D_Current_date; 0; -6; 0)
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=$cut_off)
			CREATE SET:C116([Customers_Order_Lines:41]; "order_history")  //need this later
			UNION:C120("orders"; "order_history"; "orders")
			USE SET:C118("orders")
			RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_orders")
			UNION:C120("finished_goods"; "fg_orders"; "finished_goods")
			CLEAR SET:C117("fg_orders")
			
			zwStatusMsg($currentExtractName; "Gathering F/G's Releases...")
			QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]CustID:12; $cust_ids)
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"))  //not forecast and close query
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "cust_releases")  //hold for shipments
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //still has open qty mlb 10/26/10
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)  //not shipped
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "releases")  //need this later also
			RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_releases")
			UNION:C120("finished_goods"; "fg_releases"; "finished_goods")
			CLEAR SET:C117("fg_releases")
			
			//get recent shipments
			zwStatusMsg($currentExtractName; "Gathering F/G's Shipments...")
			USE SET:C118("cust_releases")
			CLEAR SET:C117("cust_releases")
			$cut_off:=4D_Current_date-14
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>$cut_off; *)  //has shipped
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8>0)
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "shipments")
			RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_shipments")
			UNION:C120("finished_goods"; "fg_shipments"; "finished_goods")
			CLEAR SET:C117("fg_shipments")
			
			
			
			
			
			USE SET:C118("finished_goods")
			CLEAR SET:C117("finished_goods")
			If (Records in selection:C76([Finished_Goods:26])>0)
				ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1)
				zwStatusMsg("CUSTPORT_ExportPortal"; "Exporting F/G: "+String:C10(Records in selection:C76([Finished_Goods:26]))+" records for "+$currentExtractName)
				
				ARRAY TEXT:C222($_CustID; 0)
				ARRAY TEXT:C222($_OutLine_Num; 0)
				ARRAY TEXT:C222($_FG_KEY; 0)
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_OrderType; 0)
				ARRAY TEXT:C222($_CartonDesc; 0)
				ARRAY TEXT:C222($_Line_Brand; 0)
				
				SELECTION TO ARRAY:C260([Finished_Goods:26]CustID:2; $_CustID; \
					[Finished_Goods:26]OutLine_Num:4; $_OutLine_Num; \
					[Finished_Goods:26]FG_KEY:47; $_FG_KEY; \
					[Finished_Goods:26]ProductCode:1; $_ProductCode; \
					[Finished_Goods:26]OrderType:59; $_OrderType; \
					[Finished_Goods:26]CartonDesc:3; $_CartonDesc; \
					[Finished_Goods:26]Line_Brand:15; $_Line_Brand)
				
				C_LONGINT:C283($Iter; $numElements)
				
				$numElements:=Size of array:C274($_CustID)
				uThermoInit($numElements; "Creating "+$currentExtractName+"'s item master")
				
				For ($Iter; 1; Size of array:C274($_CustID); 1)
					$hit:=Find in array:C230($cust_ids; $_CustID{$Iter})
					If ($hit>-1)
						$cust_access_filter:=$ttAccessFilter
						$hide_all_excess:=$cust_hide_all_excess{$hit}
						$hide_promo_excess:=$cust_hide_promo_excess{$hit}
					Else 
						$cust_access_filter:="00000"
						$hide_all_excess:=False:C215
						$hide_promo_excess:=False:C215
					End if 
					
					CREATE RECORD:C68([Portal_ItemMaster:160])
					[Portal_ItemMaster:160]pk_id:1:=Generate UUID:C1066
					[Portal_ItemMaster:160]AccessID:2:=$cust_access_filter
					[Portal_ItemMaster:160]product_line:3:=$_Line_Brand{$Iter}
					[Portal_ItemMaster:160]product_code:4:=$_ProductCode{$Iter}
					
					$cases:=PK_getCasesPerSkid($_OutLine_Num{$Iter})
					$packed_at:=PK_getCaseCount($_OutLine_Num{$Iter})
					[Portal_ItemMaster:160]packing_spec:6:=String:C10($cases)+"x"+String:C10($packed_at)+"="+String:C10($cases*$packed_at)
					[Portal_ItemMaster:160]qty_onhand:7:=FG_Inventory_CanShip($_FG_KEY{$Iter})  //FG_Inventory_Array ("lookupCanShip";$_FG_KEY{$Iter})  // Modified by: Mel Bohince (8/4/17) 
					[Portal_ItemMaster:160]qty_certification:8:=FG_Inventory_InCert($_FG_KEY{$Iter})  //FG_Inventory_Array ("lookupEX";$_FG_KEY{$Iter})
					[Portal_ItemMaster:160]qty_wip:9:=JMI_getPlannedQty($_ProductCode{$Iter})
					[Portal_ItemMaster:160]qty_open_order:10:=ORD_GetOpenDemand($_ProductCode{$Iter}; "no overrun")
					[Portal_ItemMaster:160]qty_scheduled:11:=REL_getOpenReleased($_ProductCode{$Iter})
					If ($hide_all_excess)
						If ([Portal_ItemMaster:160]qty_onhand:7>[Portal_ItemMaster:160]qty_open_order:10)
							[Portal_ItemMaster:160]qty_onhand:7:=[Portal_ItemMaster:160]qty_open_order:10  //hide excess of promo items from portal
						End if 
					End if 
					
					If ($hide_promo_excess)
						If ([Portal_ItemMaster:160]qty_onhand:7>[Portal_ItemMaster:160]qty_open_order:10) & ($_OrderType{$Iter}="Promotional")
							[Portal_ItemMaster:160]qty_onhand:7:=[Portal_ItemMaster:160]qty_open_order:10  //hide excess of promo items from portal
						End if 
					End if 
					
					[Portal_ItemMaster:160]historic_orders:12:=ORD_GetCurrentOrders($_ProductCode{$Iter}; (Add to date:C393(4D_Current_date; 0; -6; 0)))
					
					$fg_desc:=Replace string:C233($_CartonDesc{$Iter}; Char:C90(Quote:K15:44); " ")  //sql delimitor
					$fg_desc:=Replace string:C233($fg_desc; "\\"; "-")  //sql escape
					[Portal_ItemMaster:160]description:5:=$fg_desc
					[Portal_ItemMaster:160]last_update:13:=$timestamp
					
					SAVE RECORD:C53([Portal_ItemMaster:160])
					UNLOAD RECORD:C212([Portal_ItemMaster:160])
					
					uThermoUpdate($Iter)
				End for 
				uThermoClose
				
				
				
			End if 
		End if   // If (Size of array($cust_ids)>0)
		
		
		
		
		
		
		
		
	End if   // End If this web user is active
	
End for each 





zwStatusMsg("CUSTPORT_ExportPortal"; "Finished ")
BEEP:C151