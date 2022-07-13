//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_get_reconciliation - Created v0.1.0-JJG (05/18/16) - re-written for MySQL vs 4D
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//  // Description
//  // make ams match wms by finding all jobits that are currently in wms,
//  //     then loop thru each of these, for each
//  //      set the ams LastCycleCount to the QtyOH, then 0 out the ams QtyOH
//  //      find all the remaining cases (stat<300) in wms for that jobit grouped by ams location
//  //          then update/create the ams.location to match
//  //  option removed to then delete all  QtyOH=0

//  // NOTE: if the jobit is not in wms, then the ams side will not be changed

WMS_API_LoginLookup  //make sure <>WMS variables are up to date.

If (<>fWMS_Use4D)
	WMS_API_4D_getRecon
Else 
	wms_api_MySQL_get_reconciliatio
End if 




If (False:C215)  //v0.1.0-JJG (05/18/16) - moved to wms_api_MySql_get_reconciliatio
	//  // ----------------------------------------------------
	//  // User name (OS): mel
	//  // Date and time: 10/20/08, 12:06:40
	//  // ----------------------------------------------------
	//  // Method: wms_api_get_reconciliation
	//  // Description
	//  // make ams match wms by finding all jobits that are currently in wms,
	//  //     then loop thru each of these, for each
	//  //      set the ams LastCycleCount to the QtyOH, then 0 out the ams QtyOH
	//  //      find all the remaining cases (stat<300) in wms for that jobit grouped by ams location
	//  //          then update/create the ams.location to match
	//  //  option removed to then delete all  QtyOH=0
	
	//  // NOTE: if the jobit is not in wms, then the ams side will not be changed
	//  // ----------------------------------------------------
	//  // Modified by: Mel Bohince (9/17/12)
	//  // Modified by: Mel Bohince (12/17/14)  also protect FG: which is outside service locations
	//  // Modified by: Mel Bohince (12/18/15) fg: is now FG:OS@
	
	//READ WRITE([Finished_Goods_Locations])
	//READ ONLY([Job_Forms_Items])
	
	//  //CONFIRM("Merge or start fresh?";"Merge";"Fresh")
	//  //If (ok=1)
	//  //$start_fresh:=False
	//  //CONFIRM("Remove zero onhands when possible?";"Remove";"Keep")
	//  //If (ok=1)
	//  //$clear_zeros:=True
	//  //Else 
	//  //$clear_zeros:=False
	//  //End if 
	//  //Else 
	//$start_fresh:=True
	//$clear_zeros:=False
	//  //End if 
	//<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	//If ($conn_id>0)
	//  //get unique jobits from wms
	//$sql:="select distinct jobit from cases"  //limit 100where jobit = '875880106'"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$number_of_jobits:=MySQL Get Row Count ($row_set)
	//If ($number_of_jobits>0)
	//ARRAY TEXT($aCases_jobits;0)
	//MySQL Column To Array ($row_set;"";1;$aCases_jobits)
	//MySQL Delete Row Set ($row_set)
	
	//  //ALL RECORDS([Finished_Goods_Locations])
	//  //QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location#"FG:AV@")  //9/17/12 mlb Part of the RAMA dealeo, wms would have these items as shipped
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location#"@AV@";*)  //consignment
	//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location#"@OS@")  //outside service Modified by: Mel Bohince (12/18/15) fg: is now FG:OS@// Modified by: Mel Bohince (12/17/14)  also protect FG: which is outside service locations
	//  //
	//  //If ($start_fresh)
	//util_DeleteSelection (->[Finished_Goods_Locations])
	//  //Else 
	//  //APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]LastCycleCount:=[Finished_Goods_Locations]QtyOH)
	//  //FIRST RECORD([Finished_Goods_Locations])
	//  //APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]QtyOH:=0)
	//  //FIRST RECORD([Finished_Goods_Locations])
	//  //APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]Cases:=0)
	//  //End if 
	
	//uThermoInit ($number_of_jobits;"Reconciling Inventory")
	//For ($wms_jobit;1;$number_of_jobits)
	//$ams_jobit:=JMI_makeJobIt ($aCases_jobits{$wms_jobit})
	
	//  //QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Jobit=$ams_jobit)
	
	//  //look up jobit in wms
	//ARRAY TEXT($aCases_Location;0)
	//ARRAY LONGINT($aCases_Qty;0)
	//ARRAY TEXT($aSkid_Number;0)
	//ARRAY LONGINT($aNum_Cases;0)
	//$sql:="select bin_id, sum(qty_in_case), count(case_id), skid_number from cases "
	//$sql:=$sql+"where jobit = '"+$aCases_jobits{$wms_jobit}+"' and (case_status_code < 300 or  case_status_code = 350) group by concat(bin_id,"+"jobit)"
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$number_of_locations:=MySQL Get Row Count ($row_set)
	//MySQL Column To Array ($row_set;"";1;$aCases_Location)
	//MySQL Column To Array ($row_set;"";2;$aCases_Qty)
	//MySQL Column To Array ($row_set;"";3;$aNum_Cases)
	//MySQL Column To Array ($row_set;"";4;$aSkid_Number)
	//MySQL Delete Row Set ($row_set)
	
	//  //make corrections to match
	//  //look up jobit in ams
	//For ($location;1;$number_of_locations)
	//$ams_location:=wms_convert_bin_id ("ams";$aCases_Location{$location})
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Jobit=$ams_jobit;*)
	//QUERY([Finished_Goods_Locations]; & ;[Finished_Goods_Locations]Location=$ams_location)
	//If (Records in selection([Finished_Goods_Locations])=0)
	//$numJMI:=qryJMI ($ams_jobit)
	//  //If ($numJMI>0)
	//CREATE RECORD([Finished_Goods_Locations])  //uMakeFGLocation
	//[Finished_Goods_Locations]Jobit:=$ams_jobit  //12345.78.01
	//[Finished_Goods_Locations]ProductCode:=[Job_Forms_Items]ProductCode
	//[Finished_Goods_Locations]Location:=$ams_location
	//[Finished_Goods_Locations]JobForm:=Substring($ams_jobit;1;8)
	//[Finished_Goods_Locations]JobFormItem:=Num(Substring($ams_jobit;10;2))
	//[Finished_Goods_Locations]CustID:=[Job_Forms_Items]CustId
	//[Finished_Goods_Locations]Count:=1
	//[Finished_Goods_Locations]OrigDate:=[Job_Forms_Items]Glued
	//[Finished_Goods_Locations]ModWho:="wms0"
	//  //End if 
	//Else 
	//[Finished_Goods_Locations]ModWho:="wms1"
	//End if 
	
	//  //If ([Finished_Goods_Locations]QtyOH#$aCases_Qty{$location})
	//[Finished_Goods_Locations]QtyOH:=[Finished_Goods_Locations]QtyOH+$aCases_Qty{$location}  //`uChgFGqty
	//[Finished_Goods_Locations]pallet_id:=$aSkid_Number{$location}
	//[Finished_Goods_Locations]wms_bin_id:=$aCases_Location{$location}
	//[Finished_Goods_Locations]Cases:=[Finished_Goods_Locations]Cases+$aNum_Cases{$location}
	//[Finished_Goods_Locations]ModDate:=4D_Current_date
	//SAVE RECORD([Finished_Goods_Locations])
	//  //End if 
	//End for 
	
	//uThermoUpdate ($wms_jobit)
	
	//End for 
	//uThermoClose 
	
	//If ($clear_zeros)  //now get rid of anything not found
	//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]QtyOH=0)
	//util_DeleteSelection (->[Finished_Goods_Locations])
	//End if 
	
	//Else 
	//uConfirm ("Could not get a list of jobits from the cases table. ";"OK";"Help")
	//End if 
	
	//  //MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
	//Else 
	//uConfirm ("Could not connect to WMS database.";"OK";"Help")
	//End if 
	
	//UNLOAD RECORD([Finished_Goods_Locations])
End if   //v0.1.0-JJG (05/18/16) - end of commented block