//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 01/24/09, 14:49:12
// ----------------------------------------------------
// Method: wms_print_location_catalog
// Description
// Modified by: Mel Bohince (10/24/12) wasn't printing pdf of first page in bottom else block
// Modified by: Mel Bohince (1/12/16) format for 10up rack labels
// ----------------------------------------------------
// Modified by: Mel Bohince (4/9/19) protect array range error
util_PAGE_SETUP(->[WMS_AllowedLocations:73]; "WarehouseRackLabels")
PRINT SETTINGS:C106
If (ok=1)
	uConfirm("Print catalog?"; "Multi-up"; "Single")
	If (ok=1)
		$rows:=Num:C11(Request:C163("How many rows?"; "9"))  //use 5 if avery 10-up form for rack labels
		uConfirm("Trim Prefix?"; "Trim"; "ALL")  //trimming "bnv" is useful when making rack labels
		If (ok=1)
			$trim:=True:C214
		Else 
			$trim:=False:C215
		End if 
		
		uConfirm("Search?"; "Search"; "Catalog")
		If (ok=0)
			//ARRAY TEXT($area;9)
			//$area{1}:="BNRCC"
			//$area{2}:="BNRFG"
			//$area{3}:="BNRXC"
			//$area{4}:="BNRXC_Proof_Staging"
			//$area{5}:="BNRFG_HOLD"
			//$area{6}:="BNRFG_TRANSIT"
			//$area{7}:="BNRFG_SAMPLES"
			//$area{8}:="BNRFG_SHIPPED"
			//$area{9}:="BNVFG_SHIPPED"
			
			//ARRAY TEXT($area2;9)
			//$area2{1}:="BNRXC_TestMaterial"
			//$area2{2}:="BNRSC_QA"
			//$area2{3}:="BNRSC_REJECT"
			//$area2{4}:="BNRSC_KILL"
			//$area2{5}:="BNRSC_Bill_n_Destroy"
			//$area2{6}:="BNRFG_KILL"
			//$area2{7}:="BNVFG"
			//$area2{8}:="BNRFG_OUTSIDE_SERVICE"
			//$area2{9}:="BNVFG_OUTSIDE_SERVICE"
			
			ARRAY TEXT:C222($area; 9)
			$area{1}:="BNRFG"
			$area{2}:="BNRFG_A"
			$area{3}:="BNRFG_B"
			$area{4}:="BNRXC"
			$area{5}:="BNRXC_Proof_Staging"
			$area{6}:="BNRFG_HOLD"
			$area{7}:="BNRFG_TRANSIT"
			$area{8}:="BNRFG_SHIPPED"
			$area{9}:="BNRFG_OUTSIDE_SERVICE"
			
			ARRAY TEXT:C222($area2; 9)
			$area2{1}:="BNVFG"
			$area2{2}:="BNVFG_A"
			$area2{3}:="BNVFG_HOLD"
			$area2{4}:="BNVSC_QA"
			$area2{5}:="BNVSC_OBSOLETE"
			$area2{6}:="BNVFG_SHIPPED_1"
			$area2{7}:="BNVFG_SHIPPED_2"
			$area2{8}:="BNVFG_SHIPPED_3"
			$area2{9}:="BNVFG_OUTSIDE_SERVICE"
			
			Print form:C5([zz_control:1]; "BlankPix8")
			Print form:C5([zz_control:1]; "BlankPix8")
			For ($i; 1; $rows)
				//SSCC_HumanReadable:="BNR-"+String($i;"00")+"-001-01"
				SSCC_HumanReadable1:=$area{$i}
				SSCC_Barcode1:=WMS_SkidId(SSCC_HumanReadable1; "barcode")
				
				SSCC_HumanReadable2:=$area2{$i}
				SSCC_Barcode2:=WMS_SkidId(SSCC_HumanReadable2; "barcode")  //BNRFG
				
				Print form:C5([WMS_AllowedLocations:73]; "WarehouseCatalog")
				
			End for 
			PAGE BREAK:C6
			
		Else 
			ARRAY TEXT:C222($area; $rows)
			ARRAY TEXT:C222($area2; $rows)
			$page_counter:=0
			
			QUERY:C277([WMS_AllowedLocations:73])
			If (Records in selection:C76([WMS_AllowedLocations:73])>0)
				ORDER BY:C49([WMS_AllowedLocations:73])  //;[WMS_AllowedLocations]ValidLocation;>)
				If (Not:C34(<>modification4D_13_02_19)) | (<>disable_4DPS_mod)  // BEGIN 4D Professional Services : UNLOAD RECORD|(<>disable_4DPS_mod)
					
					While (Not:C34(End selection:C36([WMS_AllowedLocations:73])))
						$page_counter:=$page_counter+1
						PDF_setUp("barcodes-"+String:C10($page_counter)+".pdf")
						
						C_BOOLEAN:C305(<>fDebug)
						If (<>fDebug)
							DODEBUG(Current method name:C684)
						End if 
						
						For ($label; 1; $rows)
							$area{$label}:=""
							$area2{$label}:=""
						End for 
						
						For ($label; 1; $rows)
							$area{$label}:=[WMS_AllowedLocations:73]BarcodedID:2
							NEXT RECORD:C51([WMS_AllowedLocations:73])
							If (End selection:C36([WMS_AllowedLocations:73]))
								$label:=$rows+1  //break
							End if 
						End for 
						
						If (Not:C34(End selection:C36([WMS_AllowedLocations:73])))
							For ($label; 1; $rows)
								$area2{$label}:=[WMS_AllowedLocations:73]BarcodedID:2
								NEXT RECORD:C51([WMS_AllowedLocations:73])
								If (End selection:C36([WMS_AllowedLocations:73]))
									$label:=$rows+1  //break
								End if 
							End for 
						End if 
						
						// 16px gives the 1/2" margin needed, and 144px detail should work
						//but it will put the last row off the page. So, 14px margin below,
						// or could use 16px with a 143px detail, funny, it worked rite once.
						//Print form([zz_control];"BlankPix8")
						//Print form([zz_control];"BlankPix4")
						//Print form([zz_control];"BlankPix2")
						////Print form([zz_control];"BlankPix1")
						////Print form([zz_control];"BlankPix1")
						//CONFIRM("Default heading spacer?";"16pixels";"Tweak")// Modified by: Mel Bohince (10/31/19) 
						//If (ok=1)
						For ($i; 1; 16)
							Print form:C5([zz_control:1]; "BlankPix1")
						End for 
						
						//Else 
						//$pixels:=Num(Request("How many pixels?";"14";"Ok";"Cancel"))
						//For ($i;1;$pixels)
						//Print form([zz_control];"BlankPix1")
						//end for
						//end if
						
						For ($i; 1; $rows)
							//SSCC_HumanReadable:="BNR-"+String($i;"00")+"-001-01"
							If ($trim)
								SSCC_HumanReadable1:=Substring:C12($area{$i}; 5)
							Else 
								SSCC_HumanReadable1:=$area{$i}
							End if 
							SSCC_Barcode1:=WMS_SkidId($area{$i}; "barcode")
							
							If ($trim)
								SSCC_HumanReadable2:=Substring:C12($area2{$i}; 5)
							Else 
								SSCC_HumanReadable2:=$area2{$i}
							End if 
							SSCC_Barcode2:=WMS_SkidId($area2{$i}; "barcode")  //BNRFG
							
							If ($rows=9)
								Print form:C5([WMS_AllowedLocations:73]; "WarehouseCatalog")
							Else 
								Print form:C5([WMS_AllowedLocations:73]; "WarehouseRackLabels")
							End if 
						End for 
						//$page_counter:=$page_counter+1
						//PDF_setUp ("barcodes-"+String($page_counter)+".pdf")
						PAGE BREAK:C6
					End while 
					
				Else 
					//correct bug last release 03-28-2019
					// Modified by: Mel Bohince (8/7/19) still doesn't work
					
					//C_LONGINT($LastPosition)  //;1)// Modified by: Mel Bohince (4/9/19) 
					//C_LONGINT($Lastrecord)
					
					//SELECTION TO ARRAY([WMS_AllowedLocations]BarcodedID;$_BarcodedID;\
						[WMS_AllowedLocations];$_WMS)
					
					//$Firstposition:=0
					//While (Not(End selection([WMS_AllowedLocations])))
					//$page_counter:=$page_counter+1
					//PDF_setUp ("barcodes-"+String($page_counter)+".pdf")
					
					//C_BOOLEAN(<>fDebug)
					//If (<>fDebug)
					//DODEBUG (Current method name)
					//End if 
					
					//For ($label;1;$rows)
					//$area{$label}:=""
					//$area2{$label}:=""
					//End for 
					
					//For ($label;1;$rows)
					//If (($label+$Firstposition)<=(Size of array($_BarcodedID)))  // Modified by: Mel Bohince (4/9/19) 
					//$area{$label}:=$_BarcodedID{$label+$Firstposition}
					//Else 
					
					//$label:=$rows+1  //break
					
					//End if 
					//End for 
					//$Firstposition:=$Firstposition+$rows
					//$LastPosition:=$rows
					
					//If ($label<Size of array($_BarcodedID))
					//For ($label;1;$rows)
					//If (($label+$Firstposition)<=(Size of array($_BarcodedID)))  // Modified by: Mel Bohince (4/9/19) 
					//$area2{$label}:=$_BarcodedID{$label+$Firstposition}
					//Else 
					
					//$label:=$rows+1
					
					//End if 
					//End for 
					//End if 
					
					//If (($label+$rows)<Size of array($_WMS))
					//$Firstposition:=$Firstposition+$rows
					//If ($Firstposition<=Size of array($_WMS))
					//GOTO SELECTED RECORD([WMS_AllowedLocations];$_WMS{$Firstposition})
					//Else 
					//REDUCE SELECTION([WMS_AllowedLocations];0)  // Modified by: Mel Bohince (4/9/19) 
					//End if 
					
					//Else 
					
					//GOTO SELECTED RECORD([WMS_AllowedLocations];0)
					
					//End if 
					
					
					//Print form([zz_control];"BlankPix8")
					//Print form([zz_control];"BlankPix4")
					//Print form([zz_control];"BlankPix2")
					//For ($i;1;$rows)
					//If ($trim)
					//SSCC_HumanReadable1:=Substring($area{$i};5)
					//Else 
					//SSCC_HumanReadable1:=$area{$i}
					//End if 
					//SSCC_Barcode1:=WMS_SkidId ($area{$i};"barcode")
					
					//If ($trim)
					//SSCC_HumanReadable2:=Substring($area2{$i};5)
					//Else 
					//SSCC_HumanReadable2:=$area2{$i}
					//End if 
					//SSCC_Barcode2:=WMS_SkidId ($area2{$i};"barcode")  //BNRFG
					
					//If ($rows=9)
					//Print form([WMS_AllowedLocations];"WarehouseCatalog")
					//Else 
					//Print form([WMS_AllowedLocations];"WarehouseRackLabels")
					//End if 
					//End for 
					//PAGE BREAK
					//End while 
					
				End if   // END 4D Professional Services : January 2019 
				
			End if   //records
		End if   //std 18
		
	Else 
		uConfirm("Print One?"; "Custom"; "Search")
		If (ok=1)
			SSCC_HumanReadable:=Request:C163("Area Name?"; "BNRSC_QA_Problem"; "Print"; "Cancel")
			If (ok=1) & (Length:C16(SSCC_HumanReadable)>3)
				SSCC_Barcode:=WMS_SkidId(SSCC_HumanReadable; "barcode")  //BNRFG
				Print form:C5([WMS_AllowedLocations:73]; "WarehouseArea")
				PAGE BREAK:C6
			End if 
			
		Else   //pick
			QUERY:C277([WMS_AllowedLocations:73])
			If (Records in selection:C76([WMS_AllowedLocations:73])>0)
				ORDER BY:C49([WMS_AllowedLocations:73])
				$page_counter:=1
				PDF_setUp("barcodes-"+String:C10($page_counter)+".pdf")
				$line_counter:=0
				While (Not:C34(End selection:C36([WMS_AllowedLocations:73])))
					$line_counter:=$line_counter+1
					SSCC_HumanReadable:=[WMS_AllowedLocations:73]BarcodedID:2
					SSCC_Barcode:=WMS_SkidId(SSCC_HumanReadable; "barcode")
					Print form:C5([WMS_AllowedLocations:73]; "WarehouseArea")
					
					If ($line_counter>=4)
						PAGE BREAK:C6
						$page_counter:=$page_counter+1
						PDF_setUp("barcodes-"+String:C10($page_counter)+".pdf")
						$line_counter:=0
					End if 
					
					NEXT RECORD:C51([WMS_AllowedLocations:73])
				End while 
				
				PAGE BREAK:C6
				
			End if   //some found
		End if   //pick
	End if   //catalog
End if   //print settings