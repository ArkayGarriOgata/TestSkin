//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/15/09, 09:38:08
// ----------------------------------------------------
// Method: wms_api_Send_aMs_inventory
// Description
// print skid labels and populate the wms.cases table
//target fields:
//case_id, glue_date, qty_in_case, jobit, case_status_code, ams_location, bin_id, insert_datetime, update_datetime, update_initials
//warehouse, skid_number
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
$break:=False:C215
util_PAGE_SETUP(->[WMS_SerializedShippingLabels:96]; "SSCC_Arkay")
uConfirm("Print to PDF?"; "PDF"; "Printer")
If (ok=1)
	<>PrintToPDF:=True:C214
End if 
PDF_setUp("supercases"+".pdf"; False:C215)
//start by sending the jobits that may be required
uConfirm("Update Jobits?"; "Update"; "Ignore")
If (ok=1)
	wms_api_SendJobitsInInventory
End if 

x_find_duplicate_bins
//now select bin that are interesting
READ WRITE:C146([Finished_Goods_Locations:35])
zwStatusMsg("ORDER BY"; " will be: Row;>;Tier;>;Bin;>")
uConfirm("Which bins? (All bins uses Location='@-@'.)"; "Query"; "All Bins")
If (ok=1)
	QUERY:C277([Finished_Goods_Locations:35])
	$sort_option:=True:C214
Else 
	QUERY:C277([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="@-@")  //rack locations have a hyphen
	$sort_option:=False:C215
End if 

//set up for 3 options
//1) create, export, print (original)
//2) create, export, print later
//3) print prior exports labels
uConfirm("Export Super Cases to WMS? (otherwise subselection with a palletID assigned)"; "Export"; "Print Existing")
If (ok=1)
	If (wms_api_Send_Super_Case("init"))
		
		uConfirm("Print while exporting?"; "Print and Export"; "Export Only")
		If (ok=1)
			$print_now:=True:C214
		Else 
			$print_now:=False:C215
		End if 
		
		//making a fresh start
		APPLY TO SELECTION:C70([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43:="")
		If ($sort_option)
			uConfirm("Custom sort order?"; "Yes"; "Std R-T-B")
			If (ok=1)
				ORDER BY:C49([Finished_Goods_Locations:35])
			Else 
				ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; <; [Finished_Goods_Locations:35]Tier:39; >; [Finished_Goods_Locations:35]Bin:38; >)
			End if 
		Else 
			ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; <; [Finished_Goods_Locations:35]Tier:39; >; [Finished_Goods_Locations:35]Bin:38; >)
		End if 
		
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
			
			FIRST RECORD:C50([Finished_Goods_Locations:35])
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 First record
		
		$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
		
		//ARRAY TEXT($aJobitHash;0)  `track supercase numbers
		//ARRAY INTEGER($aJobitCounter;0)
		
		uThermoInit($numRecs; "Sending Inventory")
		For ($i; 1; $numRecs)
			If ($break)
				$i:=$i+$numRecs
			End if 
			
			$jobit:=Replace string:C233([Finished_Goods_Locations:35]Jobit:33; "."; "")  //clear out the periods
			
			wms_glued:=JMI_getGlueDate([Finished_Goods_Locations:35]Jobit:33)
			$qty_in_case:=[Finished_Goods_Locations:35]QtyOH:9
			
			$ams_location:=Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)
			Case of 
				: ($ams_location="FG")
					$case_status_code:=100
				: ($ams_location="CC")
					$case_status_code:=1
				: ($ams_location="EX")
					$case_status_code:=10
				: ($ams_location="XC")
					$case_status_code:=350
				: ($ams_location="FX")
					$case_status_code:=100
				: ($ams_location="PX")
					$case_status_code:=100
				Else 
					$case_status_code:=500
			End case 
			
			wms_bin_id:=wms_convert_bin_id("wms"; [Finished_Goods_Locations:35]Location:2)
			$insert_datetime:=[Finished_Goods_Locations:35]OrigDate:27  //TS2iso (TSTimeStamp ([Finished_Goods_Locations]OrigDate;Current time))
			$update_datetime:=[Finished_Goods_Locations:35]ModDate:21  //TS2iso (TSTimeStamp ([Finished_Goods_Locations]ModDate;Current time))
			$modWho:="aMs"  //[Finished_Goods_Locations]ModWho `there is an FKey restriction on htis column
			$warehouse:=Substring:C12([Finished_Goods_Locations:35]Warehouse:36; 1; 1)
			If (Length:C16($warehouse)=0)
				$warehouse:="H"
			End if 
			
			//passing globals: wms_glued and wms_bin_id  to Barcode_SSCC_PnG
			If ($print_now)
				$option:=1  //print, but without dialog
			Else 
				$option:=2
			End if 
			$ArkayUCCid:="0090808292"
			cbSuperCase:=0  //do it manually here
			Barcode_SSCC_PnG($option; [Finished_Goods_Locations:35]Jobit:33; [Finished_Goods_Locations:35]QtyOH:9; ""; "1"; "1"; ""; CUST_getName([Finished_Goods_Locations:35]CustID:16); FG_getLine([Finished_Goods_Locations:35]ProductCode:1); $ArkayUCCid)
			[Finished_Goods_Locations:35]skid_number:43:=[WMS_SerializedShippingLabels:96]HumanReadable:5
			$case_id:=[Finished_Goods_Locations:35]skid_number:43  //having skid# for case# triggers super_case behavior
			
			$success:=wms_api_Send_Super_Case("insert"; $case_id; wms_glued; $qty_in_case; $jobit; $case_status_code; $ams_location; wms_bin_id; $insert_datetime; $update_datetime; $modWho; $warehouse; [Finished_Goods_Locations:35]skid_number:43)
			If ($success)
				[Finished_Goods_Locations:35]wms_bin_id:44:=wms_bin_id
				[Finished_Goods_Locations:35]Cases:24:=1
				If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)="FX")
					[Finished_Goods_Locations:35]Location:2:="FG"+Substring:C12([Finished_Goods_Locations:35]Location:2; 3)
					[Finished_Goods_Locations:35]wms_bin_id:44:="FX "+[Finished_Goods_Locations:35]wms_bin_id:44
				End if 
				If (Substring:C12([Finished_Goods_Locations:35]Location:2; 1; 2)="PX")
					[Finished_Goods_Locations:35]Location:2:="FG"+Substring:C12([Finished_Goods_Locations:35]Location:2; 3)
					[Finished_Goods_Locations:35]wms_bin_id:44:="PX "+[Finished_Goods_Locations:35]wms_bin_id:44
				End if 
				SAVE RECORD:C53([Finished_Goods_Locations:35])
			End if 
			NEXT RECORD:C51([Finished_Goods_Locations:35])
			uThermoUpdate($i)
		End for 
		uThermoClose
		
		$error:=wms_api_Send_Super_Case("kill")
		
	Else 
		uConfirm("Problem connecting to WMS, nothing happened."; "OK"; "Dang")
	End if 
	
Else   //printing prior export
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]skid_number:43#"")  //don't bother if no pallet id
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	If ($sort_option)
		uConfirm("Custom sort order?"; "Yes"; "Std R-T-B")
		If (ok=1)
			ORDER BY:C49([Finished_Goods_Locations:35])
		Else 
			ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; <; [Finished_Goods_Locations:35]Tier:39; >; [Finished_Goods_Locations:35]Bin:38; >)
		End if 
	Else 
		ORDER BY:C49([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Row:37; <; [Finished_Goods_Locations:35]Tier:39; >; [Finished_Goods_Locations:35]Bin:38; >)
	End if 
	
	$numRecs:=Records in selection:C76([Finished_Goods_Locations:35])
	uThermoInit($numRecs; "Printing Records")
	For ($i; 1; $numRecs)
		If ($break)
			$i:=$i+$numRecs
		End if 
		
		QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]HumanReadable:5=[Finished_Goods_Locations:35]skid_number:43)
		
		zwStatusMsg("PRINTING"; "SSCC = "+BarCode_HumanReadableSSCC([WMS_SerializedShippingLabels:96]HumanReadable:5))
		If (Position:C15("Proct"; [WMS_SerializedShippingLabels:96]Customer:24)>0)
			$labelFormat:="Spec2005"
		Else 
			$labelFormat:="SSCC_Arkay"
		End if 
		wms_bin_id:=[Finished_Goods_Locations:35]wms_bin_id:44
		Print form:C5([WMS_SerializedShippingLabels:96]; $labelFormat)  //[WMS_SerializedShippingLabels];"SSCC_Arkay"
		
		NEXT RECORD:C51([Finished_Goods_Locations:35])
		uThermoUpdate($i)
	End for 
	uThermoClose
	
End if   //exporting
If (Not:C34(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
	
	UNLOAD RECORD:C212([Finished_Goods_Locations:35])
	
	
Else 
	
	// see line 194
	
	
End if   // END 4D Professional Services : January 2019 
UNLOAD RECORD:C212([WMS_SerializedShippingLabels:96])
PDF_setUp