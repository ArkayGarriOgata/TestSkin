//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_compare_to_ams - Created v0.1.0-JJG (05/18/16) - re-written for MySQL vs 4D
// check a bin/jobit match between system in ams use the lastcyclecount field in wms use the inventory fields
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//In aMs there is a protected button on the PI tab of the DBA screen and PI palette called 'aMs v WMS'

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.

If (<>fWMS_Use4D)
	WMS_API_4D_compareToAMS
	
Else 
	wms_MySQL_compare_to_ams
	
End if 



If (False:C215)  //v0.1.0-JJG (05/18/16) - moved to wms_MySQL_compae_to_ams
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 04/14/09, 13:58:45
	//  // ----------------------------------------------------
	//  // Method: wms_compare_to_ams
	//  // Description
	//  // check a bin/jobit match between systems
	//  //in ams use the lastcyclecount fields
	//  //in wms use the inventory fields
	//  // ----------------------------------------------------
	//  // Modified by: Mel Bohince (3/22/16) always designate the warehouse as R
	
	//  //In aMs there is a protected button on the PI tab of the DBA screen and PI palette called 'aMs v WMS'
	//$msg:=""
	//$msg:=$msg+"1)In aMs, not in WMS{[Finished_Goods_Locations]LastCycleCount:=-1} also in wms.missing_inventory table"+Char(13)
	//$msg:=$msg+"2)In WMS, not in aMs{WMS.inventory_date not set to current date}"+Char(13)
	//$msg:=$msg+"3)In both, but quantity discrepancy{[Finished_Goods_Locations]LastCycleCount:=-1*$aWMS_qty}"+Char(13)
	//$msg:=$msg+"4)Both systems insync{[Finished_Goods_Locations]LastCycleCount:=$ams_qty when match ?}"+Char(13)
	
	
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	
	//If ($conn_id>0)
	//$inventory_date:=4D_Current_date
	//$mysql_date:=String(Year of($inventory_date);"0000")+"-"+String(Month of($inventory_date);"00")+"-"+String(Day of($inventory_date);"00")
	//$package_type:="summary"
	//$update_initials:=<>zResp
	//$sql:="INSERT INTO `"+"missing_inventory"+"` ( "
	//$sql:=$sql+"`"+"package_id"+"`, "
	//$sql:=$sql+"`"+"package_type"+"`, "
	//$sql:=$sql+"`"+"update_initials"+"`, "
	//$sql:=$sql+"`"+"warehouse"+"`, "
	//$sql:=$sql+"`"+"inventory_date"+"`, "
	//$sql:=$sql+"`"+"inventory_bin_id"+"`  "
	//$sql:=$sql+") VALUES ( ?, ?, ?, ?, ?, ? )"
	//insert_missing_stmt:=MySQL New SQL Statement ($conn_id;$sql)
	
	//READ WRITE([Finished_Goods_Locations])
	//  //QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location="@-@")  `search only rack locations
	//ALL RECORDS([Finished_Goods_Locations])
	//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]LastCycleCount:=0)
	//FIRST RECORD([Finished_Goods_Locations])
	//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]LastCycleDate:=$inventory_date)
	
	//C_LONGINT($i;$numRecs)
	//$numRecs:=Records in selection([Finished_Goods_Locations])
	//$i:=0
	//FIRST RECORD([Finished_Goods_Locations])
	
	//uThermoInit ($numRecs;"Updating Records")
	//While (Not(End selection([Finished_Goods_Locations])))
	
	//$warehouse:="R"  // always R  Substring([Finished_Goods_Locations]Location;4;1)
	//$jobit:=Replace string([Finished_Goods_Locations]Jobit;".";"")
	//$location:=wms_convert_bin_id ("wms";[Finished_Goods_Locations]Location)
	//$ams_qty:=[Finished_Goods_Locations]QtyOH
	
	//$query:="select bin_id, jobit, sum(qty_in_case) from cases "
	//$where_clause:="where bin_id = '"+$location+"' and jobit = '"+$jobit+"' "
	//$where_clause:=$where_clause+"and (case_status_code < 300 or  case_status_code = 350) "  // Modified by: Mel Bohince (3/24/16) dont get shipped and scrapped"
	//$query:=$query+$where_clause+"group by jobit"
	
	//$update_stmt:="update cases set inventory_date = '"+$mysql_date+"' , warehouse = '"+$warehouse+"' "+$where_clause
	//$update_match:="update cases set inventory_date = '"+$mysql_date+"' , warehouse = '"+$warehouse+"' , inventory_bin_id = '"+$location+"' "+$where_clause
	
	//$row_set:=MySQL Select ($conn_id;$query)
	//$row_count:=MySQL Get Row Count ($row_set)
	//If ($row_count=1)
	//ARRAY TEXT($abin_id;0)
	//ARRAY TEXT($ajobit;0)
	//ARRAY LONGINT($aWMS_qty;0)
	//MySQL Column To Array ($row_set;"";1;$abin_id)
	//MySQL Column To Array ($row_set;"";2;$ajobit)
	//MySQL Column To Array ($row_set;"";3;$aWMS_qty)
	
	//If ($aWMS_qty{1}=$ams_qty)
	//[Finished_Goods_Locations]LastCycleCount:=$ams_qty
	//$rows_affected:=MySQL Execute (DB_ConnectionManager ("Connection");$update_match)
	//Else 
	//[Finished_Goods_Locations]LastCycleCount:=-1*$aWMS_qty{1}
	//$rows_affected:=MySQL Execute (DB_ConnectionManager ("Connection");$update_stmt)
	//End if 
	
	//Else   //not found in wms
	//[Finished_Goods_Locations]LastCycleCount:=-1
	//  //create a record in [WMS]Missing_Inventory table
	//$package_type:=$jobit+" = "+String($ams_qty)
	//$package_id:="ams_bin_"+[Finished_Goods_Locations]Location
	//$inventory_bin_id:=$location
	
	//MySQL Set String In SQL (insert_missing_stmt;1;$package_id)
	//MySQL Set String In SQL (insert_missing_stmt;2;$package_type)  //
	//MySQL Set String In SQL (insert_missing_stmt;3;$update_initials)
	//MySQL Set String In SQL (insert_missing_stmt;4;$warehouse)  //
	//MySQL Set Date In SQL (insert_missing_stmt;5;$inventory_date)  //
	//MySQL Set String In SQL (insert_missing_stmt;6;$inventory_bin_id)  //
	
	//$rows_affected:=MySQL Execute (DB_ConnectionManager ("Connection");"";insert_missing_stmt)
	
	//End if 
	
	//SAVE RECORD([Finished_Goods_Locations])
	//NEXT RECORD([Finished_Goods_Locations])
	//uThermoUpdate ($i)
	//$i:=$i+1
	//End while 
	//uThermoClose 
	
	//MySQL Delete SQL Statement (insert_missing_stmt)
	
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//BEEP
	//util_FloatingAlert ($msg)
	
	//Else 
	//uConfirm ("Could not connect to WMS database.";"OK";"Help")
	//End if 
End if 