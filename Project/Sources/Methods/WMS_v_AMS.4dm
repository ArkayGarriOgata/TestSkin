//%attributes = {}
// _______
// Method: WMS_v_AMS   ( ) ->
// By: Mel Bohince @ 11/10/20, 08:46:31
// Description
// present a dialog to user which compares WMS & AMS by jobit and location
// ----------------------------------------------------

C_LONGINT:C283($1; $pid; $hit)

If (Count parameters:C259=0)
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; 1; *)
	SHOW PROCESS:C325($pid)
	
Else   //init
	//put the work here
	SET MENU BAR:C67(<>defaultMenu)
	vAskMePID:=0
	<>AskMeFG:=""
	<>AskMeCust:=""
	
	WMS_API_LoginLookup  //make sure <>WMS variables are up to date
	
	C_BOOLEAN:C305(searchWidgetInited)
	searchWidgetInited:=False:C215
	
	
	
	If (True:C214)  //get the ams data and consolidate by jobit and location
		
		//can't figure out a good way to massage the collection of dup jobitlocations; therefore all the array bullshit that follows
		//$fg_locations_c:=ds.Finished_Goods_Locations.all().orderBy("Jobit asc, Location asc").toCollection("Jobit, Location, ProductCode, CustID, QtyOH")  //NOGO multiple tuples for jobit+location
		
		///break out next few lines to server func someday:
		READ ONLY:C145([Finished_Goods_Locations:35])
		ALL RECORDS:C47([Finished_Goods_Locations:35])
		//QUERY([Finished_Goods_Locations];[Finished_Goods_Locations]ProductCode="225110-00")//"90690470")
		zwStatusMsg("COMPARE"; "Loading arrays")
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY TEXT:C222($_Location; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_CustID; 0)
		ARRAY LONGINT:C221($_QtyOH; 0)
		SELECTION TO ARRAY:C260([Finished_Goods_Locations:35]Jobit:33; $_Jobit; \
			[Finished_Goods_Locations:35]Location:2; $_Location; \
			[Finished_Goods_Locations:35]ProductCode:1; $_ProductCode; \
			[Finished_Goods_Locations:35]CustID:16; $_CustID; \
			[Finished_Goods_Locations:35]QtyOH:9; $_QtyOH)
		REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
		
		$numLoc:=Size of array:C274($_Jobit)
		//concatenate the jobit+location so dups can be rolled up, eliminating skid distinctions
		zwStatusMsg("COMPARE"; "keying arrays")
		ARRAY TEXT:C222($_key; $numLoc)
		For ($i; 1; $numLoc)
			$_key{$i}:=$_Jobit{$i}+"@"+$_Location{$i}
		End for 
		SORT ARRAY:C229($_key; $_Jobit; $_Location; $_ProductCode; $_CustID; $_QtyOH; >)
		
		zwStatusMsg("COMPARE"; "consolidating arrays")
		//create a new set of arrays where qty is the total of all jobit+location combinations
		ARRAY TEXT:C222($jobitLocation; 0)
		ARRAY TEXT:C222($jobit; 0)
		ARRAY TEXT:C222($location; 0)
		ARRAY TEXT:C222($productCode; 0)
		ARRAY TEXT:C222($custid; 0)
		ARRAY LONGINT:C221($qty; 0)
		
		For ($i; 1; $numLoc)  //consolidate
			$hit:=Find in array:C230($jobitLocation; $_key{$i})
			If ($hit=-1)
				APPEND TO ARRAY:C911($jobitLocation; $_key{$i})
				APPEND TO ARRAY:C911($jobit; $_Jobit{$i})
				APPEND TO ARRAY:C911($location; $_Location{$i})
				APPEND TO ARRAY:C911($productCode; $_ProductCode{$i})
				APPEND TO ARRAY:C911($custid; $_CustID{$i})
				APPEND TO ARRAY:C911($qty; $_QtyOH{$i})
			Else 
				$qty{$hit}:=$qty{$hit}+$_QtyOH{$i}
			End if 
		End for 
		//done with these
		ARRAY TEXT:C222($_Jobit; 0)
		ARRAY TEXT:C222($_Location; 0)
		ARRAY TEXT:C222($_ProductCode; 0)
		ARRAY TEXT:C222($_CustID; 0)
		ARRAY LONGINT:C221($_QtyOH; 0)
		ARRAY TEXT:C222($_key; 0)
		
		zwStatusMsg("COMPARE"; "Building collection from consolidated ams locations")
		$numLoc:=Size of array:C274($jobitLocation)
		C_COLLECTION:C1488($fg_locations_c)
		$fg_locations_c:=New collection:C1472
		For ($i; 1; $numLoc)  //consolidate
			$fg_locations_c.push(New object:C1471("Jobit"; $jobit{$i}; "Location"; $location{$i}; "ProductCode"; $productCode{$i}; "CustID"; $custid{$i}; "QtyOH"; $qty{$i}; "key"; $jobitLocation{$i}; "WMSqty"; 0; "difference"; $qty{$i}))
		End for 
		
		//done with these
		ARRAY TEXT:C222($jobitLocation; 0)
		ARRAY TEXT:C222($jobit; 0)
		ARRAY TEXT:C222($location; 0)
		ARRAY TEXT:C222($productCode; 0)
		ARRAY TEXT:C222($custid; 0)
		ARRAY LONGINT:C221($qty; 0)
		
	End if   //getting ams data
	
	If (True:C214)  //get the wms data and consolidate by jobit and location
		zwStatusMsg("COMPARE"; "Loading WMS arrays")
		//now get the 
		$connectedToWMS:=WMS_API_4D_DoLogin
		
		
		//select jobit, bin_id, qty_in_case from cases where case_status_code in (1, 100, 350) // 43,000 records, leave out those in (300) shipped status
		//to bad I can't seem to "group by jobit, bin_id'
		$sql:="select jobit, bin_id, qty_in_case from cases where case_status_code in (1, 100, 350) order by jobit, bin_id"
		ARRAY TEXT:C222($_jobit; 0)
		ARRAY TEXT:C222($_bin_id; 0)
		ARRAY LONGINT:C221($_qty_in_case; 0)
		SQL EXECUTE:C820($sql; $_jobit; $_bin_id; $_qty_in_case)
		If (ok=1)
			If (Not:C34(SQL End selection:C821))
				SQL LOAD RECORD:C822(SQL all records:K49:10)
			End if 
			SQL CANCEL LOAD:C824
			
		Else 
			//sql execute failure
		End if 
		
		If ($connectedToWMS)
			WMS_API_4D_DoLogout
		End if 
		
		zwStatusMsg("COMPARE"; "keying WMS arrays")
		$numLoc:=Size of array:C274($_jobit)
		ARRAY TEXT:C222($_key; $numLoc)
		For ($i; 1; $numLoc)  //adding key
			$_key{$i}:=$_jobit{$i}+"@"+$_bin_id{$i}
		End for 
		SORT ARRAY:C229($_key; $_jobit; $_bin_id; $_qty_in_case; >)
		
		zwStatusMsg("COMPARE"; "consolidating WMS arrays")
		For ($i; 1; $numLoc)  //consolidate
			$hit:=Find in array:C230($jobitLocation; $_key{$i})
			If ($hit=-1)
				APPEND TO ARRAY:C911($jobitLocation; $_key{$i})
				APPEND TO ARRAY:C911($jobit; $_jobit{$i})
				APPEND TO ARRAY:C911($location; $_bin_id{$i})
				APPEND TO ARRAY:C911($qty; $_qty_in_case{$i})
			Else 
				$qty{$hit}:=$qty{$hit}+$_qty_in_case{$i}
			End if 
		End for 
		//done with these
		ARRAY TEXT:C222($_jobit; 0)
		ARRAY TEXT:C222($_bin_id; 0)
		ARRAY LONGINT:C221($_qty_in_case; 0)
		ARRAY TEXT:C222($_key; 0)
		
		$numLoc:=Size of array:C274($jobitLocation)
		ARRAY LONGINT:C221($_matched; $numLoc)  //this will be used to tag wms's found in ams
		
		C_TEXT:C284($lookup)
		C_OBJECT:C1216($loc)
		For each ($loc; $fg_locations_c)  //get the corrisponding qty from wms
			
			$lookup:=Replace string:C233($loc.Jobit; "."; "")+"@"+wms_convert_bin_id("wms"; $loc.Location)  //wms doesn't use the period separators
			$hit:=Find in array:C230($jobitLocation; $lookup)
			If ($hit>-1)
				$loc.WMSqty:=$loc.WMSqty+$qty{$hit}
				$_matched{$hit}:=1  //tag that it jobit@location is in both
				
			Else   //in ams, !wms
				$loc.WMSqty:=0
			End if 
			
			$loc.difference:=$loc.QtyOH-$loc.WMSqty
			
		End for each 
		
		//now find the unmatched wms records and push them onto the collection
		C_OBJECT:C1216($jobit_e)
		C_TEXT:C284($ams_jobit; $cpn; $cust)
		
		For ($i; 1; $numLoc)
			If ($_matched{$i}=0)
				$ams_jobit:=JMI_makeJobIt($jobit{$i})
				$jobit_e:=ds:C1482.Job_Forms_Items.query("Jobit=:1"; $ams_jobit).first()
				If ($jobit_e#Null:C1517)
					$cpn:=$jobit_e.ProductCode
					$cust:=$jobit_e.CustId
					$fg_locations_c.push(New object:C1471("Jobit"; $ams_jobit; "Location"; wms_convert_bin_id("ams"; $location{$i}); "ProductCode"; $cpn; "CustID"; $cust; "QtyOH"; 0; "key"; $jobitLocation{$i}; "WMSqty"; $qty{$i}; "difference"; (-1*$qty{$i})))
				End if   //not null
			End if   //not matched
		End for 
		
		//done with these
		ARRAY TEXT:C222($jobitLocation; 0)
		ARRAY TEXT:C222($jobit; 0)
		ARRAY TEXT:C222($location; 0)
		ARRAY LONGINT:C221($qty; 0)
		
		//$fg_locations_c:=$fg_locations_c.orderBy("key asc")
		
	End if   //getting wms data
	
	zwStatusMsg("COMPARE"; "Opening form")
	C_OBJECT:C1216($form_o)
	$form_o:=New object:C1471
	$form_o.windowTitle:="aMs v WMS Comparison"
	$form_o.masterTable:=Table:C252(->[Finished_Goods_Locations:35])
	$form_o.baseForm:="aMsWMS_Comparison"
	
	$form_o.defaultOrderBy:="key asc"
	$form_o.fg_locations_c:=$fg_locations_c.orderBy($form_o.defaultOrderBy)  //this is to restore after searching
	$form_o.listBoxEntities:=$form_o.fg_locations_c  //this will be queried on
	$form_o.editEntity:=ds:C1482.Finished_Goods_Locations.query("Jobit = :1 and Location = :2"; $fg_locations_c[0].Jobit; $fg_locations_c[0].Location)
	$form_o.noticeText:="ALL aMs Finished_Goods_Locations"
	$form_o.editorGroup:=""
	
	
	app_form_Open($form_o)
	
	
End if 
//Release_UI
