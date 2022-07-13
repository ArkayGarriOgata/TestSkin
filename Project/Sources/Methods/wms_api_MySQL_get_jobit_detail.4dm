//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_MySQL_get_jobit_detail - Created v0.1.0-JJG (05/13/16)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//copied from wms_api_get_jobit_detail for MySQL vs 4D

// ----------------------------------------------------
// User name (OS): mel
// Date and time: 09/30/08, 07:46:54
// ----------------------------------------------------
// Method: wms_api_get_jobit_detail
// ----------------------------------------------------

$selectionSetName:="Job_Forms_Items"
If (Records in set:C195($selectionSetName)>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "holdNamedSelectionBefore")
	USE SET:C118($selectionSetName)
	
	<>WMS_ERROR:=0
	//$conn_id:=DB_ConnectionManager ("Open")
	If ($conn_id>0)
		utl_LogIt("init")
		$jobit:=[Job_Forms_Items:44]Jobit:4
		$jobit_actual_qty:=[Job_Forms_Items:44]Qty_Actual:11
		
		//the summary:
		$sql:="select skid_number, bin_id, count(case_id), sum(qty_in_case) from cases "
		$sql:=$sql+"where  jobit = '"+Replace string:C233($jobit; "."; "")+"' "
		$sql:=$sql+"group by skid_number, bin_id order by bin_id"
		
		//$row_set:=MySQL Select ($conn_id;$sql)
		//$row_count:=MySQL Get Row Count ($row_set)
		$0:=$row_count
		
		If ($row_count>0)
			//Case Id                 Skid Id               Bin Id  Case Qty
			utl_LogIt("SUMMARY:")
			utl_LogIt("Skid Id               Bin Id              Cases   Quantity")
			ARRAY TEXT:C222($aSkid_id; 0)
			ARRAY TEXT:C222($abin_id; 0)
			ARRAY LONGINT:C221($aNum_Cases; 0)
			ARRAY LONGINT:C221($aQuantity; 0)
			ARRAY LONGINT:C221($acase_state; 0)
			
			//MySQL Column To Array ($row_set;"";1;$aSkid_id)
			//MySQL Column To Array ($row_set;"";2;$aBin_id)
			//MySQL Column To Array ($row_set;"";3;$aNum_Cases)
			//MySQL Column To Array ($row_set;"";4;$aQuantity)
			$qty:=0
			$skid_cases:=0
			For ($i; 1; $row_count)
				utl_LogIt($aSkid_id{$i}+"  "+txt_Pad($aBin_id{$i}; " "; 1; 20)+"  "+String:C10($aNum_Cases{$i}; "^^^")+"  "+String:C10($aQuantity{$i}; "^,^^^,^^0"))
				$qty:=$qty+$aNum_Cases{$i}
				$skid_cases:=$skid_cases+$aQuantity{$i}
			End for 
			utl_LogIt(" === ")
			utl_LogIt("   "+String:C10($qty)+" cases on "+String:C10($row_count)+" skids totaling "+String:C10($skid_cases)+" cartons")
			utl_LogIt(" ### ")
			utl_LogIt(" ### ")
			utl_LogIt("DETAIL ")
		End if 
		
		$sql:="SELECT case_id, qty_in_case, skid_number, bin_id, case_status_code "
		$sql:=$sql+" FROM cases WHERE "
		$sql:=$sql+"jobit = '"+Replace string:C233($jobit; "."; "")+"'"
		
		//$row_set:=MySQL Select ($conn_id;$sql)
		//$row_count:=MySQL Get Row Count ($row_set)
		$0:=$row_count
		
		If ($row_count>0)
			//Case Id                 Skid Id               Bin Id  Case Qty
			
			ARRAY TEXT:C222($acase_id; 0)
			ARRAY LONGINT:C221($aqty_in_case; 0)
			ARRAY TEXT:C222($askid_number; 0)
			ARRAY TEXT:C222($abin_id; 0)
			ARRAY LONGINT:C221($acase_state; 0)
			
			//MySQL Column To Array ($row_set;"";1;$acase_id)
			//MySQL Column To Array ($row_set;"";2;$aqty_in_case)
			//MySQL Column To Array ($row_set;"";3;$askid_number)
			//MySQL Column To Array ($row_set;"";4;$abin_id)
			//MySQL Column To Array ($row_set;"";5;$acase_state)
			
			MULTI SORT ARRAY:C718($askid_number; >; $acase_id; >; $abin_id; >; $aqty_in_case; $acase_state)
			
			utl_LogIt("Case Id                 Bin Id     Case Qty    State")
			$currentskid:=""
			$qty:=0
			$skid_cases:=0
			$skid_qty:=0
			For ($i; 1; $row_count)
				If ($askid_number{$i}#$currentskid)
					If ($i#1)
						utl_LogIt(String:C10($skid_cases)+" cases on skid "+$currentskid+"  "+String:C10($skid_qty)+" qty on skid")
						utl_LogIt(" --- ")
					End if 
					$currentskid:=$askid_number{$i}
					$skid_cases:=0
					$skid_qty:=0
				End if 
				Case of 
					: ($acase_state{$i}=1)
						$state:=" CERTIFICATION "
						
					: ($acase_state{$i}=10)
						$state:=" EXAMINING "
						
					: ($acase_state{$i}=110)
						$state:=" BOL PENDING "
						
					: ($acase_state{$i}=130)
						$state:=" RE-CERT "
						
					: ($acase_state{$i}=200)
						$state:=" B&H "
						
					: ($acase_state{$i}=250)
						$state:=" EXCESS "
						
					: ($acase_state{$i}=300)
						$state:=" SHIPPED "
						
					: ($acase_state{$i}=400)
						$state:=" SCRAPPED "
						
					Else 
						$state:=" FG "
				End case 
				utl_LogIt($acase_id{$i}+"  "+$abin_id{$i}+"  "+String:C10($aqty_in_case{$i})+$state)
				$qty:=$qty+$aqty_in_case{$i}
				$skid_cases:=$skid_cases+1
				$skid_qty:=$skid_qty+$aqty_in_case{$i}
			End for 
			utl_LogIt(String:C10($skid_cases)+"  cases on skid "+$currentskid+"  "+String:C10($skid_qty)+" qty on skid")
			utl_LogIt(" --- ")
			
			utl_LogIt(String:C10($row_count)+"  total cases    "+String:C10($qty)+" total qty")
			
			utl_LogIt("show")
			utl_LogIt("init")
			
			If ($jobit_actual_qty#$qty) & ($qty>0) & (False:C215)
				uConfirm("Set aMs Qty_Actual to match WMS qty of "+String:C10($qty)+"?"; "Change"; "Ignore")
				If (ok=1)
					UNLOAD RECORD:C212([Job_Forms_Items:44])
					READ WRITE:C146([Job_Forms_Items:44])
					LOAD RECORD:C52([Job_Forms_Items:44])
					[Job_Forms_Items:44]Qty_Actual:11:=$qty
					SAVE RECORD:C53([Job_Forms_Items:44])
				End if 
			End if 
			
		Else 
			uConfirm("No case were found for "+[Job_Forms_Items:44]Jobit:4+". "; "OK"; "Help")
		End if 
		If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			
			UNLOAD RECORD:C212([Job_Forms_Items:44])
			USE NAMED SELECTION:C332("holdNamedSelectionBefore")
			
			
		Else 
			
			USE NAMED SELECTION:C332("holdNamedSelectionBefore")
			
			
		End if   // END 4D Professional Services : January 2019 
		//MySQL Delete Row Set ($row_set)
		//$conn_id:=DB_ConnectionManager ("Close")
		
	Else 
		uConfirm("Could not connect to WMS database."; "OK"; "Help")
	End if 
	
Else 
	uConfirm("Please select a Job_Forms_Item record to show bins."; "OK"; "Help")
End if 