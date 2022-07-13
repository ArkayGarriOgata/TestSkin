//%attributes = {"publishedWeb":true}
//PM:  Barcode_SSCC_PnG(switch{;jobit;qty;po;numberPallets;skid;})  10/25/00  mlb
//print Serialized Shipping Container Coded label
//103007 mlb make all label show Roanoke prefix
// Modified by: Mel Bohince (5/20/16) match 2 char only when case_status_code is determined
// Modified by: Mel Bohince (3/22/17) allow edit to cust name, line, and desc to support multi-cust jobs

C_TEXT:C284(sArkayUCCid; sArkayLotPrefix; $7; $10)
C_TEXT:C284($2; $4; $5; $jobit; $po)
C_TEXT:C284($6; $8; $9; $customer; $line)
C_LONGINT:C283($1; $3; $qty; $numLabels; $numOfPallets; $winRef)

READ WRITE:C146([WMS_SerializedShippingLabels:96])

Case of 
	: (Count parameters:C259=0)
		windowTitle:="Create SSCC Labels"
		$winRef:=OpenFormWindow(->[WMS_SerializedShippingLabels:96]; "NewLabel"; ->windowTitle; windowTitle)
		DIALOG:C40([WMS_SerializedShippingLabels:96]; "NewLabel")  // Modified by: Mel Bohince (3/22/17) allow edit to cust name, line, and desc to support multi-cust jobs
		CLOSE WINDOW:C154($winRef)
		
		If (OK=1)
			app_Log_Usage("log"; "SSCC"; "New "+sCriterion1)
			wms_api_SendJobits  // Modified by: Mel Bohince (10/23/13) make sure jobit is in wms.jobits
			//params->      1    2             3                 4          5           6      7       8      9        10      {11}
			Barcode_SSCC_PnG(0; sCriterion1; Num:C11(sCriterion2); sCriterion3; sCriterion4; sCriterion5; ""; sCustName; sLine; sArkayUCCid; sDesc)
		End if 
		
	: (Count parameters:C259=1)
		QUERY:C277([WMS_SerializedShippingLabels:96]; [WMS_SerializedShippingLabels:96]ShippingUnitSerialNumber:1=$1)
		
	: ($1=0) | ($1=1)  // 1 if called from wms_api_Send_aMs_inventory
		If (cbSuperCase=1)
			$success:=wms_api_Send_Super_Case("init")
		Else 
			$success:=True:C214
		End if 
		
		If ($success)
			
			$jobit:=$2
			$qty:=$3
			$po:=$4
			$numOfPallets:=Num:C11($5)
			$numLabels:=Num:C11($6)
			$skid:=$7
			$customer:=$8
			$line:=$9
			sArkayUCCid:=$10
			If (Count parameters:C259>10)
				$desc:=$11
			Else 
				$desc:=""  //use f/g record's desc
			End if 
			
			If (Length:C16(sArkayUCCid)=0)  //assume normal sscc
				sArkayUCCid:="0020808292"  //sscc app code+containerType+UCCregistration#
			End if 
			
			If (Position:C15("Proct"; $customer)>0)  //p&g always gets this one
				sArkayUCCid:="0010808292"  //sscc app code+containerType+UCCregistration#
			End if 
			
			If (sArkayUCCid="0010808292")
				$labelFormat:="Spec2005"
				sArkayLotPrefix:="AP"  //assigned by P&G, plus RV for Roanoke, HN for Hauppauge
			Else 
				If (rb7=0)
					$labelFormat:="SSCC_Arkay"
					sArkayLotPrefix:=""
				Else 
					$labelFormat:="SSCC_PFS"
					sArkayLotPrefix:=""
				End if 
			End if 
			
			If ($1<2)
				If ($1=0)
					util_PAGE_SETUP(->[WMS_SerializedShippingLabels:96]; $labelFormat)
					//util_PAGE_SETUP(->[WMS_SerializedShippingLabels];"Spec2005")
					//util_PAGE_SETUP(->[WMS_SerializedShippingLabels];"SSCC_Arkay")
					
					$printerName:=Get current printer:C788
					
					SET PRINT OPTION:C733(Number of copies option:K47:4; $numLabels)
					PRINT SETTINGS:C106
					
				Else 
					OK:=1
					wms_bin_id:=wms_bin_id  // set in wms_api_Send_aMs_inventory
					$printerName:=""
				End if 
				
			Else 
				OK:=1
			End if 
			
			If (OK=1)
				
				For ($i; 1; $numOfPallets)
					CREATE RECORD:C68([WMS_SerializedShippingLabels:96])
					$serialnumber:=app_set_id_as_string(Table:C252(->[WMS_SerializedShippingLabels:96]); "00000000")  //fGetNextID (->[WMS_SerializedShippingLabels];9)
					$chkMod10:=fBarCodeMod10Digit(sArkayUCCid+$serialnumber)
					
					//[WMS_SerializedShippingLabels]ShippingUnitSerialNumber:=fBarCodeSym (128;sArkayUCCid+$serialnumber+$chkMod10)
					[WMS_SerializedShippingLabels:96]ShippingUnitSerialNumber:1:=fBarCodeSym(129; sArkayUCCid+$serialnumber+$chkMod10)
					
					[WMS_SerializedShippingLabels:96]HumanReadable:5:=sArkayUCCid+$serialnumber+$chkMod10
					If (True:C214)  //(User in group(Current user;"Roanoke"))`103007 mlb make all label show Roanoke prefix
						[WMS_SerializedShippingLabels:96]PlantNumber:8:="RV"
					Else 
						[WMS_SerializedShippingLabels:96]PlantNumber:8:="HN"
					End if 
					[WMS_SerializedShippingLabels:96]Jobit:3:=$jobit
					[WMS_SerializedShippingLabels:96]LotNumber:6:=sArkayLotPrefix+[WMS_SerializedShippingLabels:96]PlantNumber:8+Replace string:C233($jobit; "."; "")
					
					If ([Job_Forms_Items:44]Jobit:4#$jobit)
						READ WRITE:C146([Job_Forms_Items:44])  // going to force a reload on the record in R/W
						QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Jobit:4=$jobit)
						$numFound:=Records in selection:C76([Job_Forms_Items:44])
					Else 
						$numFound:=1
					End if 
					
					If ($numFound>0)
						[WMS_SerializedShippingLabels:96]CPN:2:=[Job_Forms_Items:44]ProductCode:3
						$numFound:=qryFinishedGood("#CPN"; [WMS_SerializedShippingLabels:96]CPN:2)
						If ($numFound>0)
							[WMS_SerializedShippingLabels:96]CartonDesc:7:=Uppercase:C13(Substring:C12([Finished_Goods:26]CartonDesc:3; 1; 25))
						Else 
							[WMS_SerializedShippingLabels:96]CartonDesc:7:=""
						End if 
						
						If (Length:C16($desc)>0)  // Modified by: Mel Bohince (3/22/17) allow edit to cust name, line, and desc to support multi-cust jobs
							[WMS_SerializedShippingLabels:96]CartonDesc:7:=$desc
						End if 
						
					Else 
						[WMS_SerializedShippingLabels:96]CPN:2:=""
						[WMS_SerializedShippingLabels:96]CartonDesc:7:=""
					End if 
					[WMS_SerializedShippingLabels:96]Quantity:4:=$qty
					wms_glued:=JMI_getGlueDate($jobit)
					If (wms_glued=!00-00-00!)
						wms_glued:=4D_Current_date
					End if 
					[WMS_SerializedShippingLabels:96]CreateDate:9:=wms_glued  // set in wms_api_Send_aMs_inventory
					If ([WMS_SerializedShippingLabels:96]CreateDate:9=!00-00-00!)
						[WMS_SerializedShippingLabels:96]CreateDate:9:=4D_Current_date
					End if 
					[WMS_SerializedShippingLabels:96]CreatedBy:27:=<>zResp
					[WMS_SerializedShippingLabels:96]POnumber:10:=$po
					[WMS_SerializedShippingLabels:96]SkidNumber:11:=$skid
					[WMS_SerializedShippingLabels:96]ContainerType:13:="SKID"
					[WMS_SerializedShippingLabels:96]Customer:24:=$customer
					[WMS_SerializedShippingLabels:96]Line:25:=$line
					SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
					
					$sscc:=BarCode_HumanReadableSSCC([WMS_SerializedShippingLabels:96]HumanReadable:5)
					
					If ($1<2)
						zwStatusMsg("PRINTING"; "SSCC = "+$sscc+" to "+$printerName)
						Print form:C5([WMS_SerializedShippingLabels:96]; $labelFormat)
					End if 
					
					If (cbSuperCase=1)
						$jobit_stripped:=Replace string:C233($jobit; "."; "")  //clear out the periods
						//$ams_location:=Substring(wms_bin_id;4;2) 
						$ams_location:=wms_convert_bin_id("ams"; wms_bin_id)  // Modified by: Mel Bohince (5/20/16) convert then match 2 char only
						$ams_location:=Substring:C12($ams_location; 1; 2)
						Case of 
							: ($ams_location="FG")
								$case_status_code:=100
							: ($ams_location="CC")
								$case_status_code:=1
							: ($ams_location="EX")
								$case_status_code:=10
							: ($ams_location="XC")
								$case_status_code:=350
							: ($ams_location="FG")
								$case_status_code:=100
							: ($ams_location="FX")
								$case_status_code:=250
							: ($ams_location="PX")
								$case_status_code:=350
							Else 
								$case_status_code:=500
						End case 
						$insert_datetime:=wms_glued
						$update_datetime:=4D_Current_date
						$warehouse:="R"
						$case_id:=[WMS_SerializedShippingLabels:96]HumanReadable:5  //having skid# for case# triggers super_case behavior
						$success:=wms_api_Send_Super_Case("insert"; $case_id; wms_glued; $qty; $jobit_stripped; $case_status_code; $ams_location; wms_bin_id; $insert_datetime; $update_datetime; "aMs"; $warehouse; [WMS_SerializedShippingLabels:96]HumanReadable:5)
					End if 
					
					If (cbReceiveAMS=1)  //do an fg receipt
						$success:=FG_Receive_via_SSCC
					Else 
						If (cbMoveOS=1) & (wms_qty_moved>0)
							rReal1:=wms_qty_moved
							sJobit:=sCriterion1
							$numRecs:=qryJMI(sJobit)
							If ($numRecs>0)  //5/4/95 
								sCriterion1:=[Job_Forms_Items:44]ProductCode:3
								sCriterion2:=[Job_Forms_Items:44]CustId:15
								sCriterion5:=[Job_Forms_Items:44]JobForm:1
								sCriterion6:=[Job_Forms_Items:44]OrderItem:2
								i1:=[Job_Forms_Items:44]ItemNumber:7
								
								sCriterion3:=fromLocation
								sCriterion4:=toLocation
								iMode:=1
								//FG_Move 
								
							Else 
								sJobit:=""
							End if 
							
							
							
							
						End if 
					End if 
					
					
					
				End for 
				
				If (cbSuperCase=1)
					$success:=wms_api_Send_Super_Case("kill")
				End if 
				
				If (cbReceiveAMS=1)  //clean up
					If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) REDUCE SELECTION
						
						UNLOAD RECORD:C212([Finished_Goods:26])
						UNLOAD RECORD:C212([Job_Forms_Items:44])
						UNLOAD RECORD:C212([Finished_Goods_Locations:35])
						UNLOAD RECORD:C212([Customers_Order_Lines:41])
						UNLOAD RECORD:C212([Customers_Orders:40])
						
						REDUCE SELECTION:C351([Finished_Goods:26]; 0)
						REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
						REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
						REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
						REDUCE SELECTION:C351([Customers_Orders:40]; 0)
						
					Else 
						REDUCE SELECTION:C351([Finished_Goods:26]; 0)
						REDUCE SELECTION:C351([Job_Forms_Items:44]; 0)
						REDUCE SELECTION:C351([Finished_Goods_Locations:35]; 0)
						REDUCE SELECTION:C351([Customers_Order_Lines:41]; 0)
						REDUCE SELECTION:C351([Customers_Orders:40]; 0)
						
					End if   // END 4D Professional Services : January 2019 
					
				End if 
				
			Else 
				ALERT:C41("Print Cancelled.")
			End if 
		End if   //wms connect OK if necessary
		
	: ($1=3)
		util_PAGE_SETUP(->[WMS_SerializedShippingLabels:96]; "SSCC_MIXED")
		PRINT SETTINGS:C106
		If (ok=1)
			sArkayUCCid:="0050808292"
			CREATE RECORD:C68([WMS_SerializedShippingLabels:96])
			$serialnumber:=app_set_id_as_string(Table:C252(->[WMS_SerializedShippingLabels:96]); "00000000")  //fGetNextID (->[WMS_SerializedShippingLabels];9)
			$chkMod10:=fBarCodeMod10Digit(sArkayUCCid+$serialnumber)
			
			[WMS_SerializedShippingLabels:96]ShippingUnitSerialNumber:1:=fBarCodeSym(129; sArkayUCCid+$serialnumber+$chkMod10)
			[WMS_SerializedShippingLabels:96]HumanReadable:5:=sArkayUCCid+$serialnumber+$chkMod10
			[WMS_SerializedShippingLabels:96]Jobit:3:=$2
			[WMS_SerializedShippingLabels:96]CreateDate:9:=4D_Current_date
			[WMS_SerializedShippingLabels:96]CreatedBy:27:=<>zResp
			[WMS_SerializedShippingLabels:96]ContainerType:13:="SKID"
			[WMS_SerializedShippingLabels:96]Customer:24:="MIXED"
			[WMS_SerializedShippingLabels:96]Line:25:="MIXED"
			
			
			
			WMS_API_LoginLookup
			If (WMS_API_4D_DoLogin)
				C_TEXT:C284($initials; $skid)
				C_BOOLEAN:C305($built)
				$skid:=[WMS_SerializedShippingLabels:96]HumanReadable:5
				$built:=True:C214
				$initials:=<>zResp
				
				Begin SQL
					insert into Skids (SkidNumber, FinishedBuilding, update_initials) values (:$skid, :$built, :$initials)
				End SQL
				If (ok=1)
					SAVE RECORD:C53([WMS_SerializedShippingLabels:96])
					zwStatusMsg("PRINTING"; "SSCC = "+[WMS_SerializedShippingLabels:96]HumanReadable:5)
					Print form:C5([WMS_SerializedShippingLabels:96]; "SSCC_MIXED")
					UNLOAD RECORD:C212([WMS_SerializedShippingLabels:96])
					
				Else 
					uConfirm("Insert skid into WMS failed, try again later."; "Ok"; "Shucks")
				End if 
				WMS_API_4D_DoLogout
				$fSuccess:=(OK=1)
			Else 
				uConfirm("Login to WMS failed, try again later."; "Ok"; "Shucks")
			End if 
			
			
		End if 
		
End case 