//%attributes = {}
//obsolete, superceded by CUSTPORT_ExportPortal
//obsolete, superceded by CUSTPORT_ExportPortal
//obsolete, superceded by CUSTPORT_ExportPortal
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/18/10, 10:38:57
//mlb 10/26/10 exclude releases with qty <=0 to remove ancient releases
// ----------------------------------------------------
// Method: CUSTPORT_ExportODBC, see CUSTPORT_Export for orig
// Description:
// Export interesting data to mysql on external server
// ----------------------------------------------------
// Modified by: Mel Bohince (5/9/17) change from MySQL Connect to native 4D SQL with odbc driver
// biggest change is only one statement at a time can be sent per execute
// Modified by: Mel Bohince (8/4/17) don't include qty in a SHIPPED staging area
// Modified by: Mel Bohince (6/7/18) don't include kills
READ ONLY:C145([Finished_Goods:26])
READ ONLY:C145([Finished_Goods_Locations:35])
READ ONLY:C145([Finished_Goods_PackingSpecs:91])
READ WRITE:C146([Customer_Portal_Extracts:158])

C_LONGINT:C283(conn_id)
//C_BLOB($sql_blob)
//C_TEXT($1;$2;$3)
C_LONGINT:C283($i; $affected_rows)
C_TEXT:C284($t; $r; $t2)
//SET BLOB SIZE($sql_blob;0)

$t:="', '"
$t2:=", "
$t3:=", '"
$r:="),"+Char:C90(13)

//*** Use ODBC Manager to set up $ODBCdataSource
// it will save the username, but password hardcoded below
// be sure to call the connection cust-port
// server has a whitelist, so you must register your ip first
// user's have specified IP ranges
$ODBCdataSource:="cust-port"
$database:="customer_portal"
$hostname:="mysql.arkayportal.com"
$port:="3306"
If (Application type:C494=4D Local mode:K5:1)
	$username:="mel_at_work"
	$password:="Y-had-I-8-so-much"
Else 
	$username:="mysharona"
	$password:="wene-rta-quuh"
End if 
//$theText:=Replace string($theText;Char(Quote );" ")
//**** find which customers are participating
//**** need their custid and portal access code
//**** the portal access code can be the same as custid or different to group several ams custs into one access group
ARRAY TEXT:C222($cust_ids; 0)
ARRAY TEXT:C222($access_filter; 0)
QUERY:C277([Customer_Portal_Extracts:158]; [Customer_Portal_Extracts:158]Active:5=True:C214)
SELECTION TO ARRAY:C260([Customer_Portal_Extracts:158]CustId:1; $cust_ids; [Customer_Portal_Extracts:158]Access_Filter:2; $cust_access_filters; [Customer_Portal_Extracts:158]Hide_All_Excess:3; $cust_hide_all_excess; [Customer_Portal_Extracts:158]Hide_Promo_Excess:4; $cust_hide_promo_excess)
REDUCE SELECTION:C351([Customer_Portal_Extracts:158]; 0)

If (Size of array:C274($cust_ids)>0)
	FG_Inventory_Array
	C_TEXT:C284(xTitle; xText; docName)
	$timestamp:=fYYMMDD(Current date:C33; 0; "")+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")
	C_TIME:C306($docRef)
	docName:="CUSTPORT_Inventory"+$timestamp+".sql"
	$docRef:=util_putFileName(->docName)
	If ($docRef#?00:00:00?)
		//**************************
		//for each customer in the the cust_id's array:
		//get open jobits, orders, and releases along with their f/g record 
		//plus and f/g records that have inventory
		//**************************
		
		//**************************
		//get the inventoried f/g's 
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]CustID:16=$cust_ids{1}; *)
			For ($i; 2; Size of array:C274($cust_ids))
				QUERY:C277([Finished_Goods_Locations:35];  | ; [Finished_Goods_Locations:35]CustID:16=$cust_ids{$i}; *)
			End for 
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]QtyOH:9>0; *)  //close search and in case there are negatives
			QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]KillStatus:30=0)  // Modified by: Mel Bohince (6/7/18) don't include kills
			
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "inventory")
			
			//**************************
			//get open jobits
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]CustId:15=$cust_ids{1}; *)
			For ($i; 2; Size of array:C274($cust_ids))
				QUERY:C277([Job_Forms_Items:44];  | ; [Job_Forms_Items:44]CustId:15=$cust_ids{$i}; *)
			End for 
			QUERY:C277([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //close search and item not completed
			CREATE SET:C116([Job_Forms_Items:44]; "jobs")  //need this later
			//merge jobit's fg with the inventory, 
			RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_jobs")
			UNION:C120("inventory"; "fg_jobs"; "finished_goods")
			CLEAR SET:C117("fg_jobs")
			
			//**************************
			//get order lines
			QUERY:C277([Customers_Order_Lines:41]; [Customers_Order_Lines:41]CustID:4=$cust_ids{1}; *)
			For ($i; 2; Size of array:C274($cust_ids))
				QUERY:C277([Customers_Order_Lines:41];  | ; [Customers_Order_Lines:41]CustID:4=$cust_ids{$i}; *)
			End for 
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#("can@"); *)
			QUERY:C277([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Status:9#("kill@"))
			CREATE SET:C116([Customers_Order_Lines:41]; "cust_orders")
			
			USE SET:C118("cust_orders")  //get open order lines
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9#("close@"); *)
			QUERY SELECTION:C341([Customers_Order_Lines:41];  & ; [Customers_Order_Lines:41]Qty_Open:11>0)  //close search and order still open
			CREATE SET:C116([Customers_Order_Lines:41]; "orders")  //need this later
			
			USE SET:C118("cust_orders")  //get historical order lines
			$cut_off:=Add to date:C393(4D_Current_date; 0; -6; 0)
			QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]DateOpened:13>=$cut_off)
			//QUERY SELECTION([Customers_Order_Lines]; & ;[Customers_Order_Lines]Qty_Open<=0)  `close search and order still open
			CREATE SET:C116([Customers_Order_Lines:41]; "order_history")  //need this later
			
			UNION:C120("orders"; "order_history"; "orders")
			USE SET:C118("orders")
			//merge orderline fg with inventory and jobits
			RELATE ONE SELECTION:C349([Customers_Order_Lines:41]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_orders")
			UNION:C120("finished_goods"; "fg_orders"; "finished_goods")
			CLEAR SET:C117("fg_orders")
			
			//**************************
			//get open releases
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]CustID:12=$cust_ids{1}; *)
			For ($i; 2; Size of array:C274($cust_ids))
				QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]CustID:12=$cust_ids{$i}; *)
			End for 
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"))  //not forecast and close query
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "cust_releases")  //hold for shipments
			
			//get scheduled
			USE SET:C118("cust_releases")
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //still has open qty mlb 10/26/10
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!)  //not shipped
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "releases")  //need this later also
			//merge release fg with inventory and jobits and orderlines
			RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_releases")
			UNION:C120("finished_goods"; "fg_releases"; "finished_goods")
			CLEAR SET:C117("fg_releases")
			
			//**************************
			//get recent shipments
			USE SET:C118("cust_releases")
			CLEAR SET:C117("cust_releases")
			$cut_off:=4D_Current_date-14
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Actual_Date:7>$cut_off; *)  //has shipped
			QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Qty:8>0)
			CREATE SET:C116([Customers_ReleaseSchedules:46]; "shipments")
			//merge shipment fg with inventory and jobits and orderlines and releases
			RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_shipments")
			UNION:C120("finished_goods"; "fg_shipments"; "finished_goods")
			CLEAR SET:C117("fg_shipments")
			
			
		Else 
			
			QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]CustID:16; $cust_ids)
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9>0; *)  //close search and in case there are negatives
			QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]KillStatus:30=0)  // Modified by: Mel Bohince (6/7/18) don't include kills
			RELATE ONE SELECTION:C349([Finished_Goods_Locations:35]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "inventory")
			
			QUERY WITH ARRAY:C644([Job_Forms_Items:44]CustId:15; $cust_ids)
			QUERY SELECTION:C341([Job_Forms_Items:44];  & ; [Job_Forms_Items:44]Completed:39=!00-00-00!)  //close search and item not completed
			CREATE SET:C116([Job_Forms_Items:44]; "jobs")  //need this later
			RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Finished_Goods:26])
			CREATE SET:C116([Finished_Goods:26]; "fg_jobs")
			UNION:C120("inventory"; "fg_jobs"; "finished_goods")
			CLEAR SET:C117("fg_jobs")
			
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
			
			
		End if   // END 4D Professional Services : January 2019 
		//**************************
		//start the sql delete query
		//**************************
		
		//prep for overlay
		USE SET:C118("finished_goods")
		If (Records in selection:C76([Finished_Goods:26])>0)
			xText:="DELETE FROM `item_masters` WHERE 1;"  //+Char(13)
			xText:=xText+"DELETE FROM `jobs` WHERE 1;"  //+Char(13)
			xText:=xText+"DELETE FROM `orders` WHERE 1;"  //+Char(13)
			xText:=xText+"DELETE FROM `releases` WHERE 1;"  //+Char(13)
			//SEND PACKET($docRef;xText)
			//xText:=""
			SQL LOGIN:C817($ODBCdataSource; $username; $password)
			If (OK=1)
				SQL EXECUTE:C820("DELETE FROM `item_masters` WHERE 1;")
				SQL CANCEL LOAD:C824
				SQL EXECUTE:C820("DELETE FROM `jobs` WHERE 1;")
				SQL CANCEL LOAD:C824
				SQL EXECUTE:C820("DELETE FROM `orders` WHERE 1;")
				SQL CANCEL LOAD:C824
				SQL EXECUTE:C820("DELETE FROM `releases` WHERE 1;")
				SQL CANCEL LOAD:C824
				
				SQL LOGOUT:C872
				
			Else 
				EMAIL_Sender("CUSTPORT_Export"; ""; "connection to dreamhost failed at 0"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
		End if 
		
		
		//**************************
		//start the sql insert query
		//**************************
		
		//send the fg's
		xText:="INSERT INTO `item_masters` (`access_filter`, `product_line`, `product_code`, "
		xText:=xText+"`description`, `packing_spec`, `qty_onhand`, `qty_certification`, `qty_wip`, "
		xText:=xText+"`qty_open_order`, `qty_scheduled`, `historic_orders`) VALUES "+Char:C90(13)
		
		USE SET:C118("finished_goods")
		CLEAR SET:C117("finished_goods")
		If (Records in selection:C76([Finished_Goods:26])>0)
			ORDER BY:C49([Finished_Goods:26]; [Finished_Goods:26]ProductCode:1)
			zwStatusMsg("CUST_PORTAL"; "Exporting F/G: "+String:C10(Records in selection:C76([Finished_Goods:26]))+" records")
			If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) Next record
				
				While (Not:C34(End selection:C36([Finished_Goods:26])))
					
					$hit:=Find in array:C230($cust_ids; [Finished_Goods:26]CustID:2)
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
						$hide_all_excess:=$cust_hide_all_excess{$hit}
						$hide_promo_excess:=$cust_hide_promo_excess{$hit}
					Else 
						$cust_access_filter:="00000"
						$hide_all_excess:=False:C215
						$hide_promo_excess:=False:C215
					End if 
					//If (position("ZHLH-Y5-0111";[Finished_Goods]ProductCode)>0)
					//
					//end if
					$cases:=PK_getCasesPerSkid([Finished_Goods:26]OutLine_Num:4)
					$packed_at:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
					packing_spec:=String:C10($cases)+"x"+String:C10($packed_at)+"="+String:C10($cases*$packed_at)
					qty_onhand:=FG_Inventory_Array("lookupCanShip"; [Finished_Goods:26]FG_KEY:47)  // Modified by: Mel Bohince (8/4/17) 
					qty_certification:=FG_Inventory_Array("lookupEX"; [Finished_Goods:26]FG_KEY:47)
					qty_wip:=JMI_getPlannedQty([Finished_Goods:26]ProductCode:1)
					qty_open_order:=ORD_GetOpenDemand([Finished_Goods:26]ProductCode:1; "no overrun")
					qty_scheduled:=REL_getOpenReleased([Finished_Goods:26]ProductCode:1)
					If ($hide_all_excess)
						If (qty_onhand>qty_open_order)
							qty_onhand:=qty_open_order  //hide excess of promo items from portal
						End if 
					End if 
					
					If ($hide_promo_excess)
						If (qty_onhand>qty_open_order) & ([Finished_Goods:26]OrderType:59="Promotional")
							qty_onhand:=qty_open_order  //hide excess of promo items from portal
						End if 
					End if 
					
					$number_of_historic_orders:=ORD_GetCurrentOrders([Finished_Goods:26]ProductCode:1; (Add to date:C393(4D_Current_date; 0; -6; 0)))
					$fg_desc:=Replace string:C233([Finished_Goods:26]CartonDesc:3; Char:C90(Quote:K15:44); " ")  //sql delimitor
					$fg_desc:=Replace string:C233($fg_desc; "\\"; "-")  //sql escape
					xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233([Finished_Goods:26]Line_Brand:15; Char:C90(Quote:K15:44); " ")+$t+[Finished_Goods:26]ProductCode:1+$t+$fg_desc+$t+packing_spec+"'"+$t2+String:C10(qty_onhand)+$t2+String:C10(qty_certification)+$t2+String:C10(qty_wip)+$t2+String:C10(qty_open_order)+$t2+String:C10(qty_scheduled)+$t2+String:C10($number_of_historic_orders)+$r
					
					NEXT RECORD:C51([Finished_Goods:26])
				End while 
				
				
			Else 
				
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
				
				For ($Iter; 1; Size of array:C274($_CustID); 1)
					$hit:=Find in array:C230($cust_ids; $_CustID{$Iter})
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
						$hide_all_excess:=$cust_hide_all_excess{$hit}
						$hide_promo_excess:=$cust_hide_promo_excess{$hit}
					Else 
						$cust_access_filter:="00000"
						$hide_all_excess:=False:C215
						$hide_promo_excess:=False:C215
					End if 
					$cases:=PK_getCasesPerSkid($_OutLine_Num{$Iter})
					$packed_at:=PK_getCaseCount($_OutLine_Num{$Iter})
					packing_spec:=String:C10($cases)+"x"+String:C10($packed_at)+"="+String:C10($cases*$packed_at)
					qty_onhand:=FG_Inventory_Array("lookupCanShip"; $_FG_KEY{$Iter})  // Modified by: Mel Bohince (8/4/17) 
					qty_certification:=FG_Inventory_Array("lookupEX"; $_FG_KEY{$Iter})
					qty_wip:=JMI_getPlannedQty($_ProductCode{$Iter})
					qty_open_order:=ORD_GetOpenDemand($_ProductCode{$Iter}; "no overrun")
					qty_scheduled:=REL_getOpenReleased($_ProductCode{$Iter})
					If ($hide_all_excess)
						If (qty_onhand>qty_open_order)
							qty_onhand:=qty_open_order  //hide excess of promo items from portal
						End if 
					End if 
					
					If ($hide_promo_excess)
						If (qty_onhand>qty_open_order) & ($_OrderType{$Iter}="Promotional")
							qty_onhand:=qty_open_order  //hide excess of promo items from portal
						End if 
					End if 
					
					$number_of_historic_orders:=ORD_GetCurrentOrders($_ProductCode{$Iter}; (Add to date:C393(4D_Current_date; 0; -6; 0)))
					$fg_desc:=Replace string:C233($_CartonDesc{$Iter}; Char:C90(Quote:K15:44); " ")  //sql delimitor
					$fg_desc:=Replace string:C233($fg_desc; "\\"; "-")  //sql escape
					xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233($_Line_Brand{$Iter}; Char:C90(Quote:K15:44); " ")+$t+$_ProductCode{$Iter}+$t+$fg_desc+$t+packing_spec+"'"+$t2+String:C10(qty_onhand)+$t2+String:C10(qty_certification)+$t2+String:C10(qty_wip)+$t2+String:C10(qty_open_order)+$t2+String:C10(qty_scheduled)+$t2+String:C10($number_of_historic_orders)+$r
					
				End for 
				
				
			End if   // END 4D Professional Services : January 2019 
			$last_delimiter:=Length:C16(xText)-1
			xText[[$last_delimiter]]:=";"
			SEND PACKET:C103($docRef; xText)
			SQL LOGIN:C817($ODBCdataSource; $username; $password)
			If (OK=1)
				SQL EXECUTE:C820(xText)
				SQL CANCEL LOAD:C824
				SQL LOGOUT:C872
				
			Else 
				EMAIL_Sender($ODBCdataSource; ""; "connection to dreamhost failed at 1"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
		End if 
		
		//**************************
		//send the jobits
		xText:="INSERT INTO `jobs` (`access_filter`,  `product_code`,  `date_planned`, `qty_want`, `qty_actual`, `ams_ref`) VALUES "+Char:C90(13)
		
		USE SET:C118("jobs")
		CLEAR SET:C117("jobs")
		If (Records in selection:C76([Job_Forms_Items:44])>0)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				ORDER BY:C49([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3)
				zwStatusMsg("CUST_PORTAL"; "Exporting Jobits: "+String:C10(Records in selection:C76([Job_Forms_Items:44]))+" records")
				While (Not:C34(End selection:C36([Job_Forms_Items:44])))
					
					$hit:=Find in array:C230($cust_ids; [Job_Forms_Items:44]CustId:15)
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
					Else 
						$cust_access_filter:="00000"
					End if 
					xText:=xText+"('"+$cust_access_filter+$t+[Job_Forms_Items:44]ProductCode:3+$t+fYYMMDD([Job_Forms_Items:44]MAD:37; 10; "-")+"'"+$t2+String:C10([Job_Forms_Items:44]Qty_Want:24)+$t2+String:C10([Job_Forms_Items:44]Qty_Actual:11)+$t3+[Job_Forms_Items:44]Jobit:4+"'"+$r
					
					NEXT RECORD:C51([Job_Forms_Items:44])
				End while 
				
			Else 
				
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_CustId; 0)
				ARRAY DATE:C224($_MAD; 0)
				ARRAY LONGINT:C221($_Qty_Want; 0)
				ARRAY LONGINT:C221($_Qty_Actual; 0)
				ARRAY TEXT:C222($_Jobit; 0)
				
				SELECTION TO ARRAY:C260([Job_Forms_Items:44]ProductCode:3; $_ProductCode; [Job_Forms_Items:44]CustId:15; $_CustId; [Job_Forms_Items:44]MAD:37; $_MAD; [Job_Forms_Items:44]Qty_Want:24; $_Qty_Want; [Job_Forms_Items:44]Qty_Actual:11; $_Qty_Actual; [Job_Forms_Items:44]Jobit:4; $_Jobit)
				
				SORT ARRAY:C229($_ProductCode; $_CustId; $_MAD; $_Qty_Want; $_Qty_Actual; $_Jobit)
				
				zwStatusMsg("CUST_PORTAL"; "Exporting Jobits: "+String:C10(Records in selection:C76([Job_Forms_Items:44]))+" records")
				For ($Iter; 1; Size of array:C274($_ProductCode); 1)
					
					$hit:=Find in array:C230($cust_ids; $_CustId{$Iter})
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
					Else 
						$cust_access_filter:="00000"
					End if 
					xText:=xText+"('"+$cust_access_filter+$t+$_ProductCode{$Iter}+$t+fYYMMDD($_MAD{$Iter}; 10; "-")+"'"+$t2+String:C10($_Qty_Want{$Iter})+$t2+String:C10($_Qty_Actual{$Iter})+$t3+$_Jobit{$Iter}+"'"+$r
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			$last_delimiter:=Length:C16(xText)-1
			xText[[$last_delimiter]]:=";"
			SEND PACKET:C103($docRef; xText)
			SQL LOGIN:C817($ODBCdataSource; $username; $password)
			If (OK=1)
				SQL EXECUTE:C820(xText)
				SQL CANCEL LOAD:C824
				SQL LOGOUT:C872
				
			Else 
				EMAIL_Sender($ODBCdataSource; ""; "connection to dreamhost failed at 2"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
		End if 
		
		//**************************
		//send the orders
		xText:="INSERT INTO `orders` (`access_filter`, `product_line`, `product_code`, "
		xText:=xText+"`po_number`, `billto`, `qty_ordered`, `qty_open` , `date_opened`, `ams_ref`) VALU"+"E"+"S "+Char:C90(13)
		
		USE SET:C118("orders")
		CLEAR SET:C117("orders")
		If (Records in selection:C76([Customers_Order_Lines:41])>0)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				ORDER BY:C49([Customers_Order_Lines:41]; [Customers_Order_Lines:41]ProductCode:5)
				zwStatusMsg("CUST_PORTAL"; "Exporting Orders: "+String:C10(Records in selection:C76([Customers_Order_Lines:41]))+" records")
				While (Not:C34(End selection:C36([Customers_Order_Lines:41])))
					
					$hit:=Find in array:C230($cust_ids; [Customers_Order_Lines:41]CustID:4)
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
					Else 
						$cust_access_filter:="00000"
					End if 
					
					If ([Customers_Order_Lines:41]Qty_Open:11>=0)
						$open_order_qty:=[Customers_Order_Lines:41]Qty_Open:11
					Else 
						$open_order_qty:=0
					End if 
					xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233([Customers_Order_Lines:41]CustomerLine:42; Char:C90(Quote:K15:44); " ")+$t+[Customers_Order_Lines:41]ProductCode:5+$t+Replace string:C233([Customers_Order_Lines:41]PONumber:21; Char:C90(Quote:K15:44); " ")+$t+ADDR_getCity([Customers_Order_Lines:41]defaultBillto:23)+"'"+$t2+String:C10([Customers_Order_Lines:41]Quantity:6)+$t2+String:C10($open_order_qty)+$t3+fYYMMDD([Customers_Order_Lines:41]DateOpened:13; 10; "-")+$t+[Customers_Order_Lines:41]OrderLine:3+"'"+$r
					
					NEXT RECORD:C51([Customers_Order_Lines:41])
				End while 
				
			Else 
				
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_CustID; 0)
				ARRAY LONGINT:C221($_Qty_Open; 0)
				ARRAY TEXT:C222($_CustomerLine; 0)
				ARRAY TEXT:C222($_PONumber; 0)
				ARRAY TEXT:C222($_defaultBillto; 0)
				ARRAY LONGINT:C221($_Quantity; 0)
				ARRAY DATE:C224($_DateOpened; 0)
				ARRAY TEXT:C222($_OrderLine; 0)
				
				SELECTION TO ARRAY:C260([Customers_Order_Lines:41]ProductCode:5; $_ProductCode; [Customers_Order_Lines:41]CustID:4; $_CustID; [Customers_Order_Lines:41]Qty_Open:11; $_Qty_Open; [Customers_Order_Lines:41]CustomerLine:42; $_CustomerLine; [Customers_Order_Lines:41]PONumber:21; $_PONumber; [Customers_Order_Lines:41]defaultBillto:23; $_defaultBillto; [Customers_Order_Lines:41]Quantity:6; $_Quantity; [Customers_Order_Lines:41]DateOpened:13; $_DateOpened; [Customers_Order_Lines:41]OrderLine:3; $_OrderLine)
				
				SORT ARRAY:C229($_ProductCode; $_CustID; $_Qty_Open; $_CustomerLine; $_PONumber; $_defaultBillto; $_Quantity; $_DateOpened; $_OrderLine)
				
				zwStatusMsg("CUST_PORTAL"; "Exporting Orders: "+String:C10(Records in selection:C76([Customers_Order_Lines:41]))+" records")
				For ($Iter; 1; Size of array:C274($_ProductCode); 1)
					
					$hit:=Find in array:C230($cust_ids; $_CustID{$Iter})
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
					Else 
						$cust_access_filter:="00000"
					End if 
					
					If ($_Qty_Open{$Iter}>=0)
						$open_order_qty:=$_Qty_Open{$Iter}
					Else 
						$open_order_qty:=0
					End if 
					xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233($_CustomerLine{$Iter}; Char:C90(Quote:K15:44); " ")+$t+$_ProductCode{$Iter}+$t+Replace string:C233($_PONumber{$Iter}; Char:C90(Quote:K15:44); " ")+$t+ADDR_getCity($_defaultBillto{$Iter})+"'"+$t2+String:C10($_Quantity{$Iter})+$t2+String:C10($open_order_qty)+$t3+fYYMMDD($_DateOpened{$Iter}; 10; "-")+$t+$_OrderLine{$Iter}+"'"+$r
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			$last_delimiter:=Length:C16(xText)-1
			xText[[$last_delimiter]]:=";"
			SEND PACKET:C103($docRef; xText)
			SQL LOGIN:C817($ODBCdataSource; $username; $password)
			If (OK=1)
				SQL EXECUTE:C820(xText)
				SQL CANCEL LOAD:C824
				SQL LOGOUT:C872
				
			Else 
				EMAIL_Sender($ODBCdataSource; ""; "connection to dreamhost failed at 3"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
		End if 
		
		//**************************
		//send the releases
		xText:="INSERT INTO `releases` "
		xText:=xText+"(`access_filter`, `product_line`, `product_code`, `reference`, "
		xText:=xText+"`shipto`, `qty_sched`, `date_sched`, `date_dock`, `ams_ref`) VALUES "+Char:C90(13)
		
		USE SET:C118("releases")
		CLEAR SET:C117("releases")
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11)
				zwStatusMsg("CUST_PORTAL"; "Exporting Releases: "+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" records")
				While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
					
					//weed out open releases with closed or canceled orderlines
					RELATE ONE:C42([Customers_ReleaseSchedules:46]OrderLine:4)
					If (Position:C15([Customers_Order_Lines:41]Status:9; " Closed Cancel Kill ")=0)
						
						$hit:=Find in array:C230($cust_ids; [Customers_ReleaseSchedules:46]CustID:12)
						If ($hit>-1)
							$cust_access_filter:=$cust_access_filters{$hit}
						Else 
							$cust_access_filter:="00000"
						End if 
						xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233([Customers_ReleaseSchedules:46]CustomerLine:28; Char:C90(Quote:K15:44); " ")+$t+[Customers_ReleaseSchedules:46]ProductCode:11+$t+Replace string:C233([Customers_ReleaseSchedules:46]CustomerRefer:3; Char:C90(Quote:K15:44); " ")+$t+ADDR_getCity([Customers_ReleaseSchedules:46]Shipto:10)+"'"+$t2+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+$t2+"'"+fYYMMDD([Customers_ReleaseSchedules:46]Sched_Date:5; 10; "-")+$t+fYYMMDD([Customers_ReleaseSchedules:46]Promise_Date:32; 10; "-")+"'"+$t2+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+$r
					End if   //close or cancel
					
					NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				End while 
				
			Else 
				
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_CustID; 0)
				ARRAY TEXT:C222($_CustomerLine; 0)
				ARRAY TEXT:C222($_CustomerRefer; 0)
				ARRAY TEXT:C222($_Shipto; 0)
				ARRAY LONGINT:C221($_Sched_Qty; 0)
				ARRAY DATE:C224($_Sched_Date; 0)
				ARRAY DATE:C224($_Promise_Date; 0)
				ARRAY LONGINT:C221($_ReleaseNumber; 0)
				ARRAY TEXT:C222($_OrderLine; 0)
				ARRAY TEXT:C222($_Status; 0)
				
				GET FIELD RELATION:C920([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
				SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; Automatic:K51:4; Do not modify:K51:1)
				
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; [Customers_ReleaseSchedules:46]CustID:12; $_CustID; [Customers_ReleaseSchedules:46]CustomerLine:28; $_CustomerLine; [Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; [Customers_ReleaseSchedules:46]Shipto:10; $_Shipto; [Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; [Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; [Customers_ReleaseSchedules:46]Promise_Date:32; $_Promise_Date; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; [Customers_ReleaseSchedules:46]OrderLine:4; $_OrderLine; [Customers_Order_Lines:41]Status:9; $_Status)
				
				SET FIELD RELATION:C919([Customers_ReleaseSchedules:46]OrderLine:4; $lienAller; $lienRetour)
				
				SORT ARRAY:C229($_ProductCode; $_CustID; $_CustomerLine; $_CustomerRefer; $_Shipto; $_Sched_Qty; $_Sched_Date; $_Promise_Date; $_ReleaseNumber; $_OrderLine; $_Status)
				
				zwStatusMsg("CUST_PORTAL"; "Exporting Releases: "+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" records")
				
				For ($Iter; 1; Size of array:C274($_ProductCode); 1)
					
					If (Position:C15($_Status{$Iter}; " Closed Cancel Kill ")=0)
						
						$hit:=Find in array:C230($cust_ids; $_CustID{$Iter})
						If ($hit>-1)
							$cust_access_filter:=$cust_access_filters{$hit}
						Else 
							$cust_access_filter:="00000"
						End if 
						xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233($_CustomerLine{$Iter}; Char:C90(Quote:K15:44); " ")+$t+$_ProductCode{$Iter}+$t+Replace string:C233($_CustomerRefer{$Iter}; Char:C90(Quote:K15:44); " ")+$t+ADDR_getCity($_Shipto{$Iter})+"'"+$t2+String:C10($_Sched_Qty{$Iter})+$t2+"'"+fYYMMDD($_Sched_Date{$Iter}; 10; "-")+$t+fYYMMDD($_Promise_Date{$Iter}; 10; "-")+"'"+$t2+String:C10($_ReleaseNumber{$Iter})+$r
						
					End if   //close or cancel
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			$last_delimiter:=Length:C16(xText)-1
			xText[[$last_delimiter]]:=";"
			SEND PACKET:C103($docRef; xText)
			SQL LOGIN:C817($ODBCdataSource; $username; $password)
			If (OK=1)
				SQL EXECUTE:C820(xText)
				SQL CANCEL LOAD:C824
				SQL LOGOUT:C872
				
			Else 
				EMAIL_Sender($ODBCdataSource; ""; "connection to dreamhost failed"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
		End if 
		
		
		//**************************
		//send the shipments
		xText:="INSERT INTO `releases` "
		xText:=xText+"(`access_filter`, `product_line`, `product_code`, `reference`, "
		xText:=xText+"`shipto`, `qty_sched`, `date_sched`, `date_dock`, `ams_ref`, `qty_actual`, `date_"+"shipped`) VALUES "+Char:C90(13)
		
		USE SET:C118("shipments")
		CLEAR SET:C117("shipments")
		If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
				
				ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ProductCode:11)
				zwStatusMsg("CUST_PORTAL"; "Exporting Releases: "+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" records")
				While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
					$hit:=Find in array:C230($cust_ids; [Customers_ReleaseSchedules:46]CustID:12)
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
					Else 
						$cust_access_filter:="00000"
					End if 
					xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233([Customers_ReleaseSchedules:46]CustomerLine:28; Char:C90(Quote:K15:44); " ")+$t+[Customers_ReleaseSchedules:46]ProductCode:11+$t+Replace string:C233([Customers_ReleaseSchedules:46]CustomerRefer:3; Char:C90(Quote:K15:44); " ")+$t+ADDR_getCity([Customers_ReleaseSchedules:46]Shipto:10)+"'"+$t2+String:C10([Customers_ReleaseSchedules:46]Sched_Qty:6)+$t2+"'"+fYYMMDD([Customers_ReleaseSchedules:46]Sched_Date:5; 10; "-")+$t+fYYMMDD([Customers_ReleaseSchedules:46]Promise_Date:32; 10; "-")+"'"+$t2+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+$t2+String:C10([Customers_ReleaseSchedules:46]Actual_Qty:8)+$t2+"'"+fYYMMDD([Customers_ReleaseSchedules:46]Actual_Date:7; 10; "-")+"'"+$r
					
					NEXT RECORD:C51([Customers_ReleaseSchedules:46])
				End while 
				
			Else 
				
				ARRAY TEXT:C222($_ProductCode; 0)
				ARRAY TEXT:C222($_CustID; 0)
				ARRAY TEXT:C222($_CustomerLine; 0)
				ARRAY TEXT:C222($_CustomerRefer; 0)
				ARRAY TEXT:C222($_Shipto; 0)
				ARRAY LONGINT:C221($_Sched_Qty; 0)
				ARRAY DATE:C224($_Sched_Date; 0)
				ARRAY DATE:C224($_Promise_Date; 0)
				ARRAY LONGINT:C221($_ReleaseNumber; 0)
				ARRAY LONGINT:C221($_Actual_Qty; 0)
				ARRAY DATE:C224($_Actual_Date; 0)
				
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; [Customers_ReleaseSchedules:46]CustID:12; $_CustID; [Customers_ReleaseSchedules:46]CustomerLine:28; $_CustomerLine; [Customers_ReleaseSchedules:46]CustomerRefer:3; $_CustomerRefer; [Customers_ReleaseSchedules:46]Shipto:10; $_Shipto; [Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; [Customers_ReleaseSchedules:46]Sched_Date:5; $_Sched_Date; [Customers_ReleaseSchedules:46]Promise_Date:32; $_Promise_Date; [Customers_ReleaseSchedules:46]ReleaseNumber:1; $_ReleaseNumber; [Customers_ReleaseSchedules:46]Actual_Qty:8; $_Actual_Qty; [Customers_ReleaseSchedules:46]Actual_Date:7; $_Actual_Date)
				
				SORT ARRAY:C229($_ProductCode; $_CustID; $_CustomerLine; $_CustomerRefer; $_Shipto; $_Sched_Qty; $_Sched_Date; $_Promise_Date; $_ReleaseNumber; $_Actual_Qty; $_Actual_Date)
				
				zwStatusMsg("CUST_PORTAL"; "Exporting Releases: "+String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" records")
				For ($Iter; 1; Size of array:C274($_ProductCode); 1)
					$hit:=Find in array:C230($cust_ids; $_CustID{$Iter})
					If ($hit>-1)
						$cust_access_filter:=$cust_access_filters{$hit}
					Else 
						$cust_access_filter:="00000"
					End if 
					xText:=xText+"('"+$cust_access_filter+$t+Replace string:C233($_CustomerLine{$Iter}; Char:C90(Quote:K15:44); " ")+$t+$_ProductCode{$Iter}+$t+Replace string:C233($_CustomerRefer{$Iter}; Char:C90(Quote:K15:44); " ")+$t+ADDR_getCity($_Shipto{$Iter})+"'"+$t2+String:C10($_Sched_Qty{$Iter})+$t2+"'"+fYYMMDD($_Sched_Date{$Iter}; 10; "-")+$t+fYYMMDD($_Promise_Date{$Iter}; 10; "-")+"'"+$t2+String:C10($_ReleaseNumber{$Iter})+$t2+String:C10($_Actual_Qty{$Iter})+$t2+"'"+fYYMMDD($_Actual_Date{$Iter}; 10; "-")+"'"+$r
					
				End for 
				
			End if   // END 4D Professional Services : January 2019 First record
			
			$last_delimiter:=Length:C16(xText)-1
			xText[[$last_delimiter]]:=";"
			SEND PACKET:C103($docRef; xText)
			SQL LOGIN:C817($ODBCdataSource; $username; $password)
			If (OK=1)
				SQL EXECUTE:C820(xText)
				SQL CANCEL LOAD:C824
				SQL LOGOUT:C872
				
			Else 
				EMAIL_Sender($ODBCdataSource; ""; "connection to dreamhost failed at 5"; ""; ""; ""; "mel.bohince@arkay.com")
			End if 
		End if 
		
		CLOSE DOCUMENT:C267($docRef)
		
		util_deleteDocument(docName)
		
	End if 
End if   //customers to search found

zwStatusMsg("CUST_PORTAL"; "Finished ")
BEEP:C151