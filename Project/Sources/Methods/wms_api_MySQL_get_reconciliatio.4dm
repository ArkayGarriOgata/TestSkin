//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_get_reconciliatio - Created v0.1.0-JJG (05/18/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

// moved from wms_api_get_reconciliation for MySQL vs 4D

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 10/20/08, 12:06:40
// ----------------------------------------------------
// Method: wms_api_get_reconciliation
// Description
// make ams match wms by finding all jobits that are currently in wms,
//     then loop thru each of these, for each
//      set the ams LastCycleCount to the QtyOH, then 0 out the ams QtyOH
//      find all the remaining cases (stat<300) in wms for that jobit grouped by ams location
//          then update/create the ams.location to match
//  option removed to then delete all  QtyOH=0

// NOTE: if the jobit is not in wms, then the ams side will not be changed
// ----------------------------------------------------
// Modified by: Mel Bohince (9/17/12)
// Modified by: Mel Bohince (12/17/14)  also protect FG: which is outside service locations
// Modified by: Mel Bohince (12/18/15) fg: is now FG:OS@

READ WRITE:C146([Finished_Goods_Locations:35])
READ ONLY:C145([Job_Forms_Items:44])

//CONFIRM("Merge or start fresh?";"Merge";"Fresh")
//If (ok=1)
//$start_fresh:=False
//CONFIRM("Remove zero onhands when possible?";"Remove";"Keep")
//If (ok=1)
//$clear_zeros:=True
//Else 
//$clear_zeros:=False
//End if 
//Else 
$start_fresh:=True:C214
$clear_zeros:=False:C215
//End if 
<>WMS_ERROR:=0
//$conn_id:=DB_ConnectionManager ("Open")
If ($conn_id>0)
	//get unique jobits from wms
	$sql:="select distinct jobit from cases"  //limit 100where jobit = '875880106'"
	
	//$row_set:=MySQL Select ($conn_id;$sql)
	//$number_of_jobits:=MySQL Get Row Count ($row_set)
	If ($number_of_jobits>0)
		ARRAY TEXT:C222($aCases_jobits; 0)
		//MySQL Column To Array ($row_set;"";1;$aCases_jobits)
		//MySQL Delete Row Set ($row_set)
		
		//ALL RECORDS([Finished_Goods_Locations])
		//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Location#"FG:AV@")  //9/17/12 mlb Part of the RAMA dealeo, wms would have these items as shipped
		QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2#"@AV@"; *)  //consignment
		QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2#"@OS@")  //outside service Modified by: Mel Bohince (12/18/15) fg: is now FG:OS@// Modified by: Mel Bohince (12/17/14)  also protect FG: which is outside service locations
		//
		//If ($start_fresh)
		util_DeleteSelection(->[Finished_Goods_Locations:35])
		//Else 
		//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]LastCycleCount:=[Finished_Goods_Locations]QtyOH)
		//FIRST RECORD([Finished_Goods_Locations])
		//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]QtyOH:=0)
		//FIRST RECORD([Finished_Goods_Locations])
		//APPLY TO SELECTION([Finished_Goods_Locations];[Finished_Goods_Locations]Cases:=0)
		//End if 
		
		uThermoInit($number_of_jobits; "Reconciling Inventory")
		For ($wms_jobit; 1; $number_of_jobits)
			$ams_jobit:=JMI_makeJobIt($aCases_jobits{$wms_jobit})
			
			//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]Jobit=$ams_jobit)
			
			//look up jobit in wms
			ARRAY TEXT:C222($aCases_Location; 0)
			ARRAY LONGINT:C221($aCases_Qty; 0)
			ARRAY TEXT:C222($aSkid_Number; 0)
			ARRAY LONGINT:C221($aNum_Cases; 0)
			$sql:="select bin_id, sum(qty_in_case), count(case_id), skid_number from cases "
			$sql:=$sql+"where jobit = '"+$aCases_jobits{$wms_jobit}+"' and (case_status_code < 300 or  case_status_code = 350) group by concat(bin_id,"+"jobit)"
			//$row_set:=MySQL Select ($conn_id;$sql)
			//$number_of_locations:=MySQL Get Row Count ($row_set)
			//MySQL Column To Array ($row_set;"";1;$aCases_Location)
			//MySQL Column To Array ($row_set;"";2;$aCases_Qty)
			//MySQL Column To Array ($row_set;"";3;$aNum_Cases)
			//MySQL Column To Array ($row_set;"";4;$aSkid_Number)
			//MySQL Delete Row Set ($row_set)
			
			//make corrections to match
			//look up jobit in ams
			For ($location; 1; $number_of_locations)
				$ams_location:=wms_convert_bin_id("ams"; $aCases_Location{$location})
				QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Jobit:33=$ams_jobit; *)
				QUERY:C277([Finished_Goods_Locations:35];  & ; [Finished_Goods_Locations:35]Location:2=$ams_location)
				If (Records in selection:C76([Finished_Goods_Locations:35])=0)
					$numJMI:=qryJMI($ams_jobit)
					//If ($numJMI>0)
					CREATE RECORD:C68([Finished_Goods_Locations:35])  //uMakeFGLocation
					[Finished_Goods_Locations:35]Jobit:33:=$ams_jobit  //12345.78.01
					[Finished_Goods_Locations:35]ProductCode:1:=[Job_Forms_Items:44]ProductCode:3
					[Finished_Goods_Locations:35]Location:2:=$ams_location
					[Finished_Goods_Locations:35]JobForm:19:=Substring:C12($ams_jobit; 1; 8)
					[Finished_Goods_Locations:35]JobFormItem:32:=Num:C11(Substring:C12($ams_jobit; 10; 2))
					[Finished_Goods_Locations:35]CustID:16:=[Job_Forms_Items:44]CustId:15
					[Finished_Goods_Locations:35]zCount:18:=1
					[Finished_Goods_Locations:35]OrigDate:27:=[Job_Forms_Items:44]Glued:33
					[Finished_Goods_Locations:35]ModWho:22:="wms0"
					//End if 
				Else 
					[Finished_Goods_Locations:35]ModWho:22:="wms1"
				End if 
				
				//If ([Finished_Goods_Locations]QtyOH#$aCases_Qty{$location})
				[Finished_Goods_Locations:35]QtyOH:9:=[Finished_Goods_Locations:35]QtyOH:9+$aCases_Qty{$location}  //`uChgFGqty
				[Finished_Goods_Locations:35]skid_number:43:=$aSkid_Number{$location}
				[Finished_Goods_Locations:35]wms_bin_id:44:=$aCases_Location{$location}
				[Finished_Goods_Locations:35]Cases:24:=[Finished_Goods_Locations:35]Cases:24+$aNum_Cases{$location}
				[Finished_Goods_Locations:35]ModDate:21:=4D_Current_date
				SAVE RECORD:C53([Finished_Goods_Locations:35])
				//End if 
			End for 
			
			uThermoUpdate($wms_jobit)
			
		End for 
		uThermoClose
		
		If ($clear_zeros)  //now get rid of anything not found
			QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]QtyOH:9=0)
			util_DeleteSelection(->[Finished_Goods_Locations:35])
		End if 
		
	Else 
		uConfirm("Could not get a list of jobits from the cases table. "; "OK"; "Help")
	End if 
	
	//MySQL Delete Row Set ($row_set)
	//$conn_id:=DB_ConnectionManager ("Close")
	
Else 
	uConfirm("Could not connect to WMS database."; "OK"; "Help")
End if 

UNLOAD RECORD:C212([Finished_Goods_Locations:35])