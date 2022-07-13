//%attributes = {}
// _______
// Method: Job_LoadLabel   ( ) ->
// By: Mel Bohince @ 04/30/19, 15:52:59
// Description
// make and track labels to put on the load tags and create
//   coorisponding records for each load
//  option to send to wms solely for sending internal BOL to o/s
// ----------------------------------------------------
// Modified by: MelvinBohince (3/28/22) add po item key
// Modified by: MelvinBohince (3/29/22) update label format, Avery 5162. 1.33x4 (14) up
// Modified by: MelvinBohince (4/20/22) print to Dymo, chg LoadID composition, fix extended cost
// Modified by: MelvinBohince (4/29/22) favor r/m's caliper on new loads over jobform's caliper
// Modified by: MelvinBohince (5/12/22) chg Use to Move

If (Count parameters:C259=0)
	$msg:="New"
	$jobForm:="13278.02"
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobForm)
Else 
	$msg:=$1
	
	If (Count parameters:C259>1)  // Modified by: MelvinBohince (3/28/22) add po item key
		$jobForm:=$2
	Else 
		$jobForm:=""
	End if 
	
	If (Count parameters:C259>2)  // Modified by: MelvinBohince (3/28/22) add po item key
		$po:=$3  //will trigger an issue
	Else 
		$po:=""
	End if 
	
End if 

//what is the context
$tabNumber:=Selected list items:C379(ieBagTabs)
GET LIST ITEM:C378(ieBagTabs; $tabNumber; $itemRef; $itemText)
If ($itemRef>=0)
	$currentSequence:=Substring:C12($itemText; 1; 3)
	$currentCC:=Substring:C12($itemText; 5; 3)  //should be the c/c
Else 
	$currentSequence:="000"
	$currentCC:="aeorator"
End if 

//so we can return the selection
ARRAY LONGINT:C221($_load_records; 0)
LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Loads:162]; $_load_records)

If (Records in set:C195("$ListboxSet")>0)
	USE SET:C118("$ListboxSet")
End if 

Case of 
	: ($msg="New")
		C_LONGINT:C283($lastLabelNumber)
		QUERY:C277([Job_Forms_Loads:162]; [Job_Forms_Loads:162]JobForm:2=$jobForm)
		If (Records in selection:C76([Job_Forms_Loads:162])>0)
			SELECTION TO ARRAY:C260([Job_Forms_Loads:162]LoadNumber:9; $existingLoads)
			SORT ARRAY:C229($existingLoads; <)
			$lastLabelNumber:=$existingLoads{1}
			UNLOAD RECORD:C212([Job_Forms_Loads:162])  // Modified by: Mel Bohince (7/16/21) 
		Else 
			$lastLabelNumber:=0
		End if 
		
		// Modified by: MelvinBohince (4/20/22) skip arkay id
		$ArkayUCCid:=""  //"000808292"  //I'm cheating here, should be 0000808292 but I need room for over 99 loads yet want to stay at 20 digits
		
		C_OBJECT:C1216($formData)
		$formData:=New object:C1471
		$formData.grossSheets:=[Job_Forms:42]EstGrossSheets:27
		$formData.height:=45
		// Modified by: MelvinBohince (4/29/22) job caliper may not match rm, use rm
		$rmCode:=t7
		$rm_e:=ds:C1482.Raw_Materials.query("Raw_Matl_Code = :1"; $rmCode).first()  //validate RM
		If ($rm_e#Null:C1517)  //valid RM code
			$formData.caliper:=$rm_e.Flex1/1000
		Else 
			$formData.caliper:=[Job_Forms:42]Caliper:49
		End if 
		$formData.qty:=Trunc:C95($formData.height/$formData.caliper; -1)  //round to 10's
		$formData.numberLoads:=Job_ConvertSheetsToLoads($formData.grossSheets; $formData.caliper; $formData.height)
		$formData.calcGross:=$formData.qty*$formData.numberLoads
		$formData.sequence:=$currentSequence
		$formData.location:=$currentCC  //"BNR_Near"+
		$formData.po:=$po  // Modified by: MelvinBohince (3/28/22) add po item key
		$windowTitle:="Create Load Labels"
		SET MENU BAR:C67(<>defaultmenu)
		$winRef:=OpenFormWindow(->[Job_Forms_Loads:162]; "NewLoadDialog"; ->$windowTitle; $windowTitle)
		DIALOG:C40([Job_Forms_Loads:162]; "NewLoadDialog"; $formData)
		CLOSE WINDOW:C154($winRef)
		
		If (ok=1)
			For ($load; 1; $formData.numberLoads)
				$loadNumber:=$load+$lastLabelNumber  //increment to one higher than last session
				$labelId:=Replace string:C233($jobForm; "."; "")+String:C10($loadNumber; "000")
				$chkMod10:=fBarCodeMod10Digit($ArkayUCCid+$labelId)
				
				CREATE RECORD:C68([Job_Forms_Loads:162])
				[Job_Forms_Loads:162]LoadID:1:=$ArkayUCCid+$labelId+$chkMod10
				[Job_Forms_Loads:162]LoadID_Barcoded:8:=fBarCodeSym(129; $ArkayUCCid+$labelId+$chkMod10)
				[Job_Forms_Loads:162]JobForm:2:=$jobForm
				[Job_Forms_Loads:162]Qty:4:=$formData.qty
				[Job_Forms_Loads:162]Subform:3:=$formData.subform
				[Job_Forms_Loads:162]LastSequence:5:=$formData.sequence
				[Job_Forms_Loads:162]LoadNumber:9:=$loadNumber
				[Job_Forms_Loads:162]Location:10:=$formData.location
				[Job_Forms_Loads:162]POItemKey:11:=$formData.po
				SAVE RECORD:C53([Job_Forms_Loads:162])
			End for 
			UNLOAD RECORD:C212([Job_Forms_Loads:162])  // Modified by: Mel Bohince (7/16/21) 
			
			If (Length:C16($formData.po)=9) & ($formData.calcGross>0)  // Modified by: MelvinBohince (3/28/22) add po item key
				
				C_OBJECT:C1216($poi_e)
				$poi_e:=ds:C1482.Purchase_Orders_Items.query("POItemKey = :1"; $formData.po).first()
				If ($poi_e#Null:C1517)
					CREATE RECORD:C68([Raw_Materials_Transactions:23])
					[Raw_Materials_Transactions:23]XferDate:3:=Current date:C33
					[Raw_Materials_Transactions:23]Xfer_Type:2:="Issue"
					[Raw_Materials_Transactions:23]XferTime:25:=Current time:C178
					[Raw_Materials_Transactions:23]Location:15:="WIP"
					[Raw_Materials_Transactions:23]ModDate:17:=[Raw_Materials_Transactions:23]XferDate:3
					[Raw_Materials_Transactions:23]ModWho:18:=<>zResp
					[Raw_Materials_Transactions:23]zCount:16:=1
					[Raw_Materials_Transactions:23]Reason:5:="RMX_Issue_Dialog"
					[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=$poi_e.Raw_Matl_Code
					[Raw_Materials_Transactions:23]Qty:6:=$formData.calcGross*-1  //issues are negative
					[Raw_Materials_Transactions:23]POItemKey:4:=$formData.po
					$bin_e:=ds:C1482.Raw_Materials_Locations.query("POItemKey = :1"; [Raw_Materials_Transactions:23]POItemKey:4).first()
					If ($bin_e#Null:C1517)
						[Raw_Materials_Transactions:23]ActCost:9:=$bin_e.ActCost
						[Raw_Materials_Transactions:23]ActExtCost:10:=Round:C94([Raw_Materials_Transactions:23]Qty:6*[Raw_Materials_Transactions:23]ActCost:9; 2)  // Modified by: MelvinBohince (4/20/22) correct unit
						[Raw_Materials_Transactions:23]viaLocation:11:=$bin_e.Location
					End if 
					[Raw_Materials_Transactions:23]JobForm:12:=$jobForm
					[Raw_Materials_Transactions:23]Sequence:13:=0
					[Raw_Materials_Transactions:23]CommodityCode:24:=$poi_e.CommodityCode
					[Raw_Materials_Transactions:23]Commodity_Key:22:=$poi_e.Commodity_Key
					[Raw_Materials_Transactions:23]ReferenceNo:14:=[Raw_Materials_Transactions:23]CostCenter:19+fYYMMDD([Raw_Materials_Transactions:23]XferDate:3)
					SAVE RECORD:C53([Raw_Materials_Transactions:23])
					
				End if   //po valid
				
			End if   //po and qty given
			
		End if   //ok
		
		//If ($addPartial)
		//$loadNumber:=$load+$currentNumberOfLabels
		//$labelId:=Replace string($jobForm;".";"")+String($loadNumber;"000")
		//$chkMod10:=fBarCodeMod10Digit ($ArkayUCCid+$labelId)
		
		//CREATE RECORD([Job_Forms_Loads])
		//[Job_Forms_Loads]LoadID:=$ArkayUCCid+$labelId+$chkMod10
		//[Job_Forms_Loads]LoadID_Barcoded:=fBarCodeSym (129;$ArkayUCCid+$labelId+$chkMod10)
		//[Job_Forms_Loads]JobForm:=$jobForm
		//[Job_Forms_Loads]Qty:=$grossSheets-($numberLoads*$qty)
		//[Job_Forms_Loads]Subform:=$subform
		//[Job_Forms_Loads]LastSequence:=$lastSeq
		//[Job_Forms_Loads]LoadNumber:=$loadNumber
		//[Job_Forms_Loads]Location:=$where
		//SAVE RECORD([Job_Forms_Loads])
		//End if 
		Job_LoadLabel("find"; $jobForm)
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Loads:162]; $_load_records)
		
		
	: ($msg="find")
		READ WRITE:C146([Job_Forms_Loads:162])  //so easy direct updates in listbox
		
		QUERY:C277([Job_Forms_Loads:162]; [Job_Forms_Loads:162]JobForm:2=$jobForm)  // Modified by: Mel Bohince (5/1/19) 
		ORDER BY:C49([Job_Forms_Loads:162]; [Job_Forms_Loads:162]LoadNumber:9; >)
		
		LONGINT ARRAY FROM SELECTION:C647([Job_Forms_Loads:162]; $_load_records)
		
		UNLOAD RECORD:C212([Job_Forms_Loads:162])
		
	: ($msg="move")
		
		$where:=Request:C163("Where to?"; $currentCC; "Move"; "Cancel")
		
		Case of 
			: (ok=0)
				//pass, move cancelled
				
			: (Length:C16($where)=0)
				BEEP:C151
				uConfirm("Need to enter a location for the Move."; "Try again"; "Help")
				//pass
				
			: (Size of array:C274($_load_records)=0)  //none selected
				$loadScan:=Request:C163("Enter load# or scan Load label:"; ""; "Move"; "Cancel")
				
				If (Length:C16($loadScan)<4)  //load number entered
					QUERY SELECTION:C341([Job_Forms_Loads:162]; [Job_Forms_Loads:162]LoadNumber:9=$loadScan)
				Else   //try label id
					QUERY SELECTION:C341([Job_Forms_Loads:162]; [Job_Forms_Loads:162]LoadID:1=$loadScan)
				End if 
				
				[Job_Forms_Loads:162]LastSequence:5:=$currentSequence
				[Job_Forms_Loads:162]Location:10:=$where
				SAVE RECORD:C53([Job_Forms_Loads:162])
				ARRAY TO SELECTION:C261($_LastSequence; [Job_Forms_Loads:162]LastSequence:5; $_Location; [Job_Forms_Loads:162]Location:10)
				
			: (Size of array:C274($_load_records)>0)  //one or more selected
				SELECTION TO ARRAY:C260([Job_Forms_Loads:162]LastSequence:5; $_LastSequence; [Job_Forms_Loads:162]Location:10; $_Location)
				For ($load; 1; Size of array:C274($_LastSequence))
					$_LastSequence{$load}:=$currentSequence
					$_Location{$load}:=$where
				End for 
				ARRAY TO SELECTION:C261($_LastSequence; [Job_Forms_Loads:162]LastSequence:5; $_Location; [Job_Forms_Loads:162]Location:10)
		End case 
		
		UNLOAD RECORD:C212([Job_Forms_Loads:162])
		
	: ($msg="wms")
		WMS_API_LoginLookup  //make sure <>WMS variables are up to date.
		$fSuccess:=WMS_API_4D_DoLogin
		If ($fSuccess)
			
			ORDER BY:C49([Job_Forms_Loads:162]; [Job_Forms_Loads:162]LoadID:1; >)
			$numberLoads:=Records in selection:C76([Job_Forms_Loads:162])
			
			$sql:="INSERT INTO `cases` (`case_id`, `glue_date`, `qty_in_case`, `jobit`, "
			$sql:=$sql+"`case_status_code`, `bin_id`, `update_initials`, "
			$sql:=$sql+"`warehouse`,`skid_number`) VALUES \r"
			C_TEXT:C284($t; $r; $t2)
			$t:="', '"
			$t2:=", "
			$t3:=", '"
			$r:="'),\r"
			$values:=""
			$glue_date:=String:C10(Current date:C33)
			
			For ($load; 1; $numberLoads)
				$loadID:=[Job_Forms_Loads:162]LoadID:1
				$existing:=0
				Begin SQL
					select count(case_id) from cases where case_id = :$loadID into :$existing
				End SQL
				If ($existing=0)
					$jobit:=Replace string:C233([Job_Forms_Loads:162]JobForm:2; "."; "")+"00"
					$values:=$values+"('"+$loadID+$t+$glue_date+"'"+$t2+String:C10([Job_Forms_Loads:162]Qty:4)+$t3+$jobit+"'"+$t2+"0"+$t3+[Job_Forms_Loads:162]Location:10+$t+<>zResp+$t+"R"+$t+$loadID+$r
				End if 
				NEXT RECORD:C51([Job_Forms_Loads:162])
			End for 
			
			If (Length:C16($values)>0)
				$last_delimiter:=Length:C16($values)-1
				$values[[$last_delimiter]]:=";"
				SQL EXECUTE:C820($sql+$values)
				SQL CANCEL LOAD:C824
			End if 
			
			
			
			WMS_API_4D_DoLogout
			
		Else 
			uConfirm("WMS is not available."; "Try Later"; "Cancel")
		End if 
		
	: ($msg="print")
		
		$choice:=uYesNoCancel("Dymo or Avery 14-up?"; "Dymo 30252"; "Avery 5162"; "Cancel")
		
		Case of 
			: ($choice="Dymo 30252")  //dymo
				app_SelectPrinter("pick")
				
				app_SelectPrinter("load-label")
				
				PRINT SETTINGS:C106
				
				FIRST RECORD:C50([Job_Forms_Loads:162])
				
				sCustomer:=CUST_getName([Jobs:15]CustID:2; "elc")
				sLine:=[Customers_Projects:9]Name:2  //[Jobs]Line
				sOf:=String:C10(Records in selection:C76([Job_Forms_Loads:162]))
				sDimensions:=String:C10([Job_Forms:42]Width:23; "#0.###W")+"x"+String:C10([Job_Forms:42]Lenth:24; "#0.###L")
				
				While (Not:C34(End selection:C36([Job_Forms_Loads:162])))
					sBC1:=[Job_Forms_Loads:162]LoadID_Barcoded:8
					If ([Job_Forms_Loads:162]Subform:3=0)
						sSF1:=""
					Else 
						sSF1:=String:C10([Job_Forms_Loads:162]Subform:3)
					End if 
					
					sLoad1:="# "+String:C10([Job_Forms_Loads:162]LoadNumber:9)
					If (Length:C16([Job_Forms_Loads:162]POItemKey:11)>0)
						sPO1:="PO:"+[Job_Forms_Loads:162]POItemKey:11
					Else 
						sPO1:=""
					End if 
					sQty1:="Qty: "+String:C10([Job_Forms_Loads:162]Qty:4; "###,##0")
					
					//Combined form
					//Print form([Job_Forms_Loads];"LabelWriter1Up";0;70)
					//PAGE BREAK(>)
					
					//job cust portion form
					Print form:C5([Job_Forms_Loads:162]; "LabelWriterHalfInch"; 0; 58)  //   9/16 x 3-7/16
					//board portion form
					Print form:C5([Job_Forms_Loads:162]; "LabelWriterHalfInch"; 100; 158)  //   9/16 x 3-7/16
					
					//job cust portion form
					//Print form([Job_Forms_Loads];"LabelWriterOneInch";100;170) //1-1/8 x 3-1/2
					
					//board portion form
					//Print form([Job_Forms_Loads];"LabelWriterOneInch";200;270) //1-1/8 x 3-1/2
					
					NEXT RECORD:C51([Job_Forms_Loads:162])
				End while 
				
				PAGE BREAK:C6  //force last
				
				app_SelectPrinter("reset")
				
			: ($choice="Avery 5162")  //avery
				
				//Formatted to Avery 5162. 1.33x4 (14) up
				util_PAGE_SETUP(->[Job_Forms_Loads:162]; "Labels14Up")
				PRINT SETTINGS:C106
				If (ok=1)
					PDF_setUp("load-labels"+".pdf")
					//CUT NAMED SELECTION([Job_Forms_Loads];"hold")
					//USE SET($ListboxSet)
					ORDER BY:C49([Job_Forms_Loads:162]; [Job_Forms_Loads:162]LoadID:1; >)
					
					$count:=Records in selection:C76([Job_Forms_Loads:162])
					If (($count%2)>0)
						$count:=$count+1
					End if 
					
					//do them side by side
					C_TEXT:C284(sBC1; sBC2; sSF1; sSF2; sLoad1; sLoad2; sOf)
					sBC1:=""
					sSF1:=""
					sLoad1:=""
					
					sBC2:=""
					sSF2:=""
					sLoad2:=""
					
					sCustomer:=CUST_getName([Jobs:15]CustID:2; "elc")
					sLine:=[Customers_Projects:9]Name:2  //[Jobs]Line
					sOf:=String:C10(Records in selection:C76([Job_Forms_Loads:162]))
					sDimensions:=String:C10([Job_Forms:42]Width:23; "#0.### ''W")+" x "+String:C10([Job_Forms:42]Lenth:24; "#0.### ''L")
					//sCriterion1:= {all ready set}
					
					// labels are about 3/4" down from top
					Print form:C5([zz_control:1]; "BlankPix32")
					Print form:C5([zz_control:1]; "BlankPix16")
					Print form:C5([zz_control:1]; "BlankPix4")
					$rowCounter:=1
					
					For ($row; 1; $count; 2)
						sBC1:=[Job_Forms_Loads:162]LoadID_Barcoded:8
						sSF1:=String:C10([Job_Forms_Loads:162]Subform:3)
						sLoad1:=String:C10([Job_Forms_Loads:162]LoadNumber:9)
						sPO1:="PO:"+[Job_Forms_Loads:162]POItemKey:11
						sQty1:="Qty: "+String:C10([Job_Forms_Loads:162]Qty:4; "###,##0")
						
						If (Selected record number:C246([Job_Forms_Loads:162])<Records in selection:C76([Job_Forms_Loads:162]))
							NEXT RECORD:C51([Job_Forms_Loads:162])
							sBC2:=[Job_Forms_Loads:162]LoadID_Barcoded:8
							sSF2:=String:C10([Job_Forms_Loads:162]Subform:3)
							sLoad2:=String:C10([Job_Forms_Loads:162]LoadNumber:9)
							sPO2:="PO:"+[Job_Forms_Loads:162]POItemKey:11
							sQty2:="Qty: "+String:C10([Job_Forms_Loads:162]Qty:4; "###,##0")
							
						Else 
							sBC2:=""
							sSF2:=""
							sLoad2:=""
							sPO2:=""
							sQty2:=""
						End if 
						
						Print form:C5([Job_Forms_Loads:162]; "Labels14Up")
						$rowCounter:=$rowCounter+1
						
						If ($rowCounter>7) & (($row+1)<$count)  //start a new page
							PAGE BREAK:C6(>)
							Print form:C5([zz_control:1]; "BlankPix32")
							Print form:C5([zz_control:1]; "BlankPix16")
							Print form:C5([zz_control:1]; "BlankPix4")
							$rowCounter:=1
						End if 
						
						NEXT RECORD:C51([Job_Forms_Loads:162])
					End for 
					PAGE BREAK:C6
					
				End if   //printsettings ok
				
		End case 
		
		//If (Size of array($_load_records)>0)
		//CREATE SELECTION FROM ARRAY([Job_Forms_Loads];$_load_records)
		//End if 
		
End case 

If (Size of array:C274($_load_records)>0)
	CREATE SELECTION FROM ARRAY:C640([Job_Forms_Loads:162]; $_load_records)
End if 
