//%attributes = {}
// _______
// Method: EDI_DESADV_get_PO_Calloffs   ("Log Only" | { "Send ASN";entitySelection ) -> entSel of those that passed
// By: Mel Bohince @ 04/28/20, 16:10:45
// Description
// based on EDI_DESADV_get_Releases without the reporting
//
//BIZ RULES:
// 1) dock date in range (called off by OPN from TMC)
// 2) even lot multiple
// 3) launch OKs
// 4) in-house inventories
// 5) accepted orderline
// 6) available inventory
// 7) shipto record requests ASN


// first test and log if important requirements are met, 
// then if qualifies prepare an asn and place in EDI_outbox
// see also EDI_DESADV_PO_Notification which sets the ediASNmsgID flag
// based on enclusion in the Open PO Notification report
// ----------------------------------------------------
// Removed by: Mel Bohince (6/24/20) test for SendASN on address record
// Modified by: Mel Bohince (6/25/20) add Promise_Date to report
// Modified by: Mel Bohince (7/13/20) don't send missed shipdate
// Modified by: Mel Bohince (8/13/20) replace volume ($volumePerCase) with $casesPerSkid
// Modified by: Mel Bohince (10/14/20) give more control to user so why "not ready" can be logged
// Modified by: Mel Bohince (10/14/20) don't test for too late
// Modified by: Mel Bohince (10/15/20) uncommnet line logging the Promise date
// Modified by: Mel Bohince (1/20/21) must have TMC's EPD, report EPD if ok, our schd date otherwise
// Modified by: Mel Bohince (1/21/21) allow sending asn after having shipped, so inventory not required and orderline can be closed
// Modified by: Mel Bohince (1/26/21) add all rk & tmc dates, use shipto name not city, add country, 
//   put each shipto in a transaction to cancel if something is amiss for that shipto, like a locked release
// Modified by: Mel Bohince (2/12/21) need to add a consolidation per asn, uses process var consolidationType
// Modified by: Mel Bohince (3/4/21) waiver for odd-lot
// Modified by: Mel Bohince (3/23/21) use PK_getCaseCountByCalcOfQty to calc number of cases
// Modified by: Mel Bohince (4/2/21) Deal with O/S inventory, don't block the asn for that reason
// Modified by: Mel Bohince (4/13/21) User controlled number of pallets, added $consolidationDetail_o and call
// Modified by: Mel Bohince (9/13/21) $outbox_e added in line 537
// Modified by: Mel Bohince (11/17/21) add Mode to report
// Modified by: MelvinBohince (5/19/22) chg to number of skids from perSkid spec

C_TEXT:C284($1)  //log only option
C_BOOLEAN:C305($sendASN; $sendRFM; $sendOddLotMultiple; $roundUp; $asnWithoutInventory; $logOnly; $useConsolidation)
C_LONGINT:C283($numberOfCases; $qtyPerCase; $look_ahead_days; $weight)
C_OBJECT:C1216($relEntSel; $params; $relObj; $result; $consolidatedRels_es; $consolidation_o; $candidates_o; $2; $formObj; $consolidationDetail_o)
C_COLLECTION:C1488($criteria; $sortOrder; $rows_c; $columns_c; $shipTos_c)
C_TEXT:C284($d; $r; $shipto; $consolidationPO; $log)
C_DATE:C307($shippingFenceTooLate; $shippingFenceTooSoon)  // Modified by: Mel Bohince (7/13/20) don't send missed shipdate
//$shippingFenceTooLate:=Add to date(Current date;0;0;2)  //wrt the delivery date, don't send if unachievable
//$shippingFenceTooSoon:=Add to date(Current date;0;0;14)  //how far out can we seen them
$shippingFenceTooSoon:=!00-00-00!  // Modified by: Mel Bohince (1/20/21) comparison to TMC's EPD being set

$sendOddLotMultiple:=False:C215  //False  //True//this was for the UAT testing
If ($sendOddLotMultiple)
	$roundUp:=False:C215  //not used
Else   //you got to decide, defaulting to ship short
	$roundUp:=False:C215
End if 

If ($1="Log Only")
	$useConsolidation:=False:C215
Else 
	$useConsolidation:=True:C214  //see EDI_DESADV_Consolidation
End if 

$asnWithoutInventory:=False:C215  //True //this was for the UAT testing not production

$d:=","  //csv delimiter
$r:="\r"

//build the query
$params:=New object:C1471
$criteria:=New collection:C1472

$criteria.push(0)  //:1 release is still open
$criteria.push(-1)  //:7 not already processed, ediASNmsgID 
$criteria.push("Estée Lauder Companies")  //:8 parentCorp

$params.parameters:=$criteria

//build the sort order
$sortOrder:=New collection:C1472
$sortOrder.push(New object:C1471("propertyPath"; "Shipto"; "descending"; False:C215))
$sortOrder.push(New object:C1471("propertyPath"; "Sched_Date"; "descending"; False:C215))

//get the interesting releases
If (Count parameters:C259>0)
	If ($1="Log Only")
		// Modified by: Mel Bohince (10/14/20) give more control to user so why "not ready" can be logged
		//$logOnly:=True
		//$relEntSel:=ds.Customers_ReleaseSchedules.query("OpenQty > :1 and ediASNmsgID = :2  and  CUSTOMER.ParentCorp = :3 ";$params).orderBy($sortOrder)
		If (Count parameters:C259>1)
			$logOnly:=True:C214
			$relEntSel:=$2
			$relEntSel:=$relEntSel.orderBy($sortOrder)
			
		Else 
			uConfirm("Missing parameter, doing a Log Only"; "Ok"; "What?")
			$logOnly:=True:C214
			$relEntSel:=ds:C1482.Customers_ReleaseSchedules.query("OpenQty > :1 and ediASNmsgID = :2  and  CUSTOMER.ParentCorp = :3 "; $params).orderBy($sortOrder)
		End if 
		
	Else   //try to use the selected release in arg 2
		If (Count parameters:C259>1)
			$logOnly:=False:C215
			$relEntSel:=$2
			$relEntSel:=$relEntSel.orderBy($sortOrder)
			
		Else 
			uConfirm("Missing parameter, doing a Log Only"; "Ok"; "What?")
			$logOnly:=True:C214
			$relEntSel:=ds:C1482.Customers_ReleaseSchedules.query("OpenQty > :1 and ediASNmsgID = :2  and  CUSTOMER.ParentCorp = :3 "; $params).orderBy($sortOrder)
		End if 
	End if 
	
Else 
	$logOnly:=True:C214
	$relEntSel:=ds:C1482.Customers_ReleaseSchedules.query("OpenQty > :1 and ediASNmsgID = :2  and  CUSTOMER.ParentCorp = :3 "; $params).orderBy($sortOrder)
End if 

//will need to consolidate by shipto
$shipTos_c:=$relEntSel.distinct("Shipto")

//if ui list is wanted by "logonly" start an es to use at the end
$candidates_o:=ds:C1482.Customers_ReleaseSchedules.newSelection()

If (True:C214)  //set up the log file headers
	$rows_c:=New collection:C1472  //there will be a row for each release tested
	//start with the column headings
	$columns_c:=New collection:C1472
	$columns_c.push("PO_ref")
	$columns_c.push("rkSched_Date")
	$columns_c.push("rkPromise_Date")
	$columns_c.push("rk_EPD")
	$columns_c.push("TMC_EPD")
	$columns_c.push("TMC_LPD")
	$columns_c.push("TMC_DD")
	$columns_c.push("Release")
	$columns_c.push("Product")
	$columns_c.push("PO_Qty")
	$columns_c.push("SHIP_Qty")
	$columns_c.push("CaseQty")
	$columns_c.push("Cases")
	//$columns_c.push("PerSkid")  // Modified by: Mel Bohince (8/13/20) replace volume ($volumePerCase) with $casesPerSkid
	$columns_c.push("#Skid")  // Modified by: MelvinBohince (5/19/22) chg to number of skids
	$columns_c.push("LAUNCH")
	$columns_c.push("Inventory")
	$columns_c.push("OrderStatus")
	$columns_c.push("SenderID")
	$columns_c.push("THC_Inventory")
	$columns_c.push("Shipto")
	$columns_c.push("Destination")
	$columns_c.push("Country")
	$columns_c.push("SendASN")
	//$columns_c.push("PO_ref")
	$columns_c.push("Results")
	$columns_c.push("ASN_ID")
	$columns_c.push("Mode")
	
	$rows_c.push($columns_c.join($d))  //add the headers
End if 

If (True:C214)  // Added by: Mel Bohince (6/26/20) progress indicators
	C_LONGINT:C283($outerBar; $outerLoop; $out)
	$outerBar:=Progress New  //new progress bar
	Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button, see $continueInteration
	
	C_LONGINT:C283($innerBar; $innerLoop; $in)  //this could also be called repeativly inside the loop if the quit is also moved inside
	$innerBar:=Progress New  //new progress bar
	Progress SET BUTTON ENABLED($innerBar; False:C215)  // no stop button 
	
	$out:=0  //init a counter for status message
	$outerLoop:=$shipTos_c.length  //set a limit for status message
	$continueInteration:=True:C214  //option to break out of ForEach
End if   //progress bar setup

For each ($shipto; $shipTos_c) While ($continueInteration)
	//descending order so pallet size lots are more likely to go first
	$consolidatedRels_es:=$relEntSel.query("Shipto = :1"; $shipto).orderBy("OpenQty desc")
	
	If (True:C214)  // Added by: Mel Bohince (6/26/20) progress indicators
		$out:=$out+1  //update a counter
		Progress SET PROGRESS($outerBar; $out/$outerLoop)  //update the thermometer
		Progress SET TITLE($outerBar; "Shipto: "+$shipto)  //optional update of the thermoeters title
		Progress SET MESSAGE($outerBar; String:C10($out)+" of "\
			+String:C10($outerLoop)+" @ "+String:C10(100*$out/$outerLoop; "###%"))  //optional verbose status
		
		$continueInteration:=(Not:C34(Progress Stopped($outerBar)))  //test if cancel button clicked
	End if 
	
	If ($continueInteration)  //respect the cancel if necessary
		
		$in:=0
		$innerLoop:=$consolidatedRels_es.length
		//
		
		//need to set accumulator for last release going to a ship-to
		// Modified by: Mel Bohince (5/28/20) add consolidation algo
		If ($useConsolidation)  //set it up
			If (consolidationType="PerShipto")  //original way, grouping all po's going to the same shipto
				//if consolidationType="PerASN" or "Parcel", then see init later in ForEach PO loop
				$defaultCasesPerSkid:=24
				EDI_DESADV_Consolidation(New object:C1471("msg"; "init"; "lastRelease"; $consolidatedRels_es.last().ReleaseNumber; "casesPerPallet"; $defaultCasesPerSkid))
			End if 
			
		Else   //just logging
			EDI_DESADV_Consolidation(New object:C1471("msg"; "init"; "lastRelease"; 0; "casesPerPallet"; 0))  // ("init";0;0;"")  //don't consolidation, use to tie odd lot qtys together
		End if   //consolidation
		
		If (Not:C34($logOnly))  //start transaction
			START TRANSACTION:C239
			$allGood:=True:C214
		End if 
		
		For each ($relObj; $consolidatedRels_es)
			// Added by: Mel Bohince (6/26/20) progress indicators
			$in:=$in+1  //update a counter
			Progress SET PROGRESS($innerBar; $in/$innerLoop)  //update the thermometer
			Progress SET MESSAGE($innerBar; String:C10($in)+"/"+String:C10($innerLoop))  //optional verbose status
			//
			//test if on launch hold, inventory not in-house, and if rfm email should be sent
			$sendASN:=True:C214  //optimistic
			
			$columns_c:=New collection:C1472  //set up for the next row of date
			//$columns_c.push($relObj.Shipto)
			$columns_c.push($relObj.CustomerRefer)
			
			If (True:C214)  //Test timing of the shipping date
				$columns_c.push(String:C10($relObj.Sched_Date; Internal date short special:K1:4))
				$columns_c.push(String:C10($relObj.Promise_Date; Internal date short special:K1:4))
				
				If ($relObj.user_date_2=!00-00-00!)  //arkay EPD
					$columns_c.push(String:C10(epd; Internal date short special:K1:4))  //global, passed in from button
				Else 
					$columns_c.push(String:C10($relObj.user_date_2; Internal date short special:K1:4))
				End if 
				$columns_c.push(String:C10($relObj.user_date_1; Internal date short special:K1:4))
				$columns_c.push(String:C10($relObj.user_date_3; Internal date short special:K1:4))
				//If ($relObj.Milestones#Null)
				If (OB Is defined:C1231($relObj.Milestones; "EDD"))
					$columns_c.push($relObj.Milestones.EDD)
				Else 
					$columns_c.push("00-00-0000")
				End if 
				
				//If ($relObj.Sched_Date>$shippingFenceTooSoon)  // Modified by: Mel Bohince (7/13/20) don't send asn too soon, BIZ#1
				If ($relObj.user_date_1=$shippingFenceTooSoon)  //use OPNs EPD
					$sendASN:=False:C215
					//$columns_c.push(String($relObj.Sched_Date;Internal date short special)+"*TS")
					//$columns_c.push("Not on OPN")
				Else 
					//$columns_c.push(String($relObj.user_date_1;Internal date short special))
				End if 
				// Modified by: Mel Bohince (10/14/20) don't test for too late
				//If ($relObj.Promise_Date<$shippingFenceTooLate)  // Modified by: Mel Bohince (7/13/20) don't send missed shipdate BIZ#2
				//$sendASN:=False
				//$columns_c.push(String($relObj.Promise_Date;Internal date short special)+"*TL")
				//Else 
				//$columns_c.push(String($relObj.Promise_Date;Internal date short special))  // Modified by: Mel Bohince (10/15/20) uncommnet
				//End if 
			End if   // test timing
			
			$columns_c.push(String:C10($relObj.ReleaseNumber))
			$columns_c.push($relObj.ProductCode)
			$columns_c.push(String:C10($relObj.Sched_Qty))
			
			
			//log some shipping metrics
			$packingSpecID:=FG_getOutline($relObj.ProductCode)
			//$volumePerCase:=PK_getVolumePerCase ($packingSpecID)
			$casesPerSkid:=PK_getSpecByCPN($relObj.ProductCode)
			
			Case of 
				: (consolidationType="PerASN")
					$po:=Substring:C12($relObj.CustomerRefer; 1; (Position:C15("."; $relObj.CustomerRefer)-1))
					//EDI_DESADV_Consolidation ("init";$relObj.ReleaseNumber;$casesPerSkid;$po)
					EDI_DESADV_Consolidation(New object:C1471("msg"; "init"; "lastRelease"; $relObj.ReleaseNumber; "casesPerPallet"; $casesPerSkid; "purchaseOrder"; $po))
					
				: (consolidationType="Parcel")
					//EDI_DESADV_Consolidation ("init";$relObj.ReleaseNumber;0;"")
					EDI_DESADV_Consolidation(New object:C1471("msg"; "init"; "lastRelease"; $relObj.ReleaseNumber; "casesPerPallet"; 0))
					
			End case 
			
			If (True:C214)  //Test packing
				If ($relObj.FINISHED_GOOD#Null:C1517)
					
					If ($relObj.FINISHED_GOOD.PACKING_SPEC#Null:C1517)
						$qtyPerCase:=$relObj.FINISHED_GOOD.PACKING_SPEC.CaseCount  //PK_getCaseCount ($packingSpecID)PK_getCaseCount ($packingSpecID)
						//$numberOfCases:=Int($relObj.Sched_Qty/$qtyPerCase)
						$numberOfCases:=PK_getCaseCountByCalcOfQty($relObj.Sched_Qty; $qtyPerCase)  // Modified by: Mel Bohince (3/23/21) 
						
						//$casesPerLayer:=$relObj.FINISHED_GOOD.PACKING_SPEC.CasesPerLayer
						//If ($numberOfCases<$casesPerLayer)  //then add to the consolidation
						
						//Else //treat as a skid
						
						//end if
						
						If ($sendOddLotMultiple)  //*###### THis is a point of contention, show an ASN be sent for an odd lot multiple???
							If (($numberOfCases*$qtyPerCase)<$relObj.Sched_Qty)
								If ($roundUp)  //round up? or ship short?
									$numberOfCases:=$numberOfCases+1
								End if 
							End if 
							
							$columns_c.push(String:C10(($numberOfCases*$qtyPerCase)))
							$columns_c.push(String:C10($qtyPerCase))
							$columns_c.push(String:C10($numberOfCases))
							//$columns_c.push(String($numberOfCases*$volumePerCase))
							//$columns_c.push(String($casesPerSkid))
							$numberOfSkids:=Round:C94($numberOfCases/$casesPerSkid; 2)  // Modified by: MelvinBohince (5/19/22) chg to number of skids
							$columns_c.push(String:C10($numberOfSkids))  // Modified by: MelvinBohince (5/19/22) chg to number of skids
							
						Else   //even lots only
							If (($numberOfCases*$qtyPerCase)=$relObj.Sched_Qty)  //back-test, because  is now used, it should end up being >= Sched_Qty
								$columns_c.push(String:C10($relObj.Sched_Qty))
								$columns_c.push(String:C10($qtyPerCase))
								$columns_c.push(String:C10($numberOfCases))
								//$columns_c.push(String($casesPerSkid))
								$numberOfSkids:=Round:C94($numberOfCases/$casesPerSkid; 2)  // Modified by: MelvinBohince (5/19/22) chg to number of skids
								$columns_c.push(String:C10($numberOfSkids))  // Modified by: MelvinBohince (5/19/22) chg to number of skids
								
							Else 
								
								If ($relObj.UserDefined_1="odd-OK")  // Modified by: Mel Bohince (3/4/21) waiver for odd-lot
									$columns_c.push(String:C10($relObj.Sched_Qty))
									$columns_c.push(String:C10($qtyPerCase))
									$columns_c.push(String:C10(PK_getCaseCountByCalcOfQty($relObj.Sched_Qty; $qtyPerCase; "odd")))  //use decimal to indicate odd lot will be used and an extra case will be mapped
									//$columns_c.push(String($casesPerSkid))
									$numberOfSkids:=Round:C94($numberOfCases/$casesPerSkid; 2)  // Modified by: MelvinBohince (5/19/22) chg to number of skids
									$columns_c.push(String:C10($numberOfSkids))  // Modified by: MelvinBohince (5/19/22) chg to number of skids
									
								Else 
									$numberOfCases:=0
									$sendASN:=False:C215
									$columns_c.push("0")  //schd qty
									$columns_c.push(String:C10($qtyPerCase))
									$columns_c.push("odd-lot")  //num cases
									$columns_c.push("0")  //cases/skid
								End if 
							End if 
						End if   //*###### THis is a point of contention, show an ASN be sent for an odd lot multiple???
						
					Else 
						$sendASN:=False:C215
						$qtyPerCase:=0
						$numberOfCases:=0
						$columns_c.push("0")
						$columns_c.push("0")
						$columns_c.push("!PACSPC")
						$columns_c.push("0")
					End if 
					
				End if   //test packing
				
				
				
				If (True:C214)  //test launch status on the related f/g record for 
					If (($relObj.FINISHED_GOOD.DateLaunchReceived#!00-00-00!) & \
						($relObj.FINISHED_GOOD.DateLaunchApproved=!00-00-00!) & \
						($relObj.FINISHED_GOOD.OriginalOrRepeat="Original"))  //unapproved launch, don't send, see FG_LaunchItem and qryLaunch
						$sendASN:=False:C215
						$columns_c.push("LAUNCH")
						
					Else 
						$columns_c.push("OK")
					End if 
				End if   //test launch
				
				
				If (True:C214)  //test inventory, location not outside service
					
					If ($relObj.FINISHED_GOOD.LOCATIONS#Null:C1517)
						If ($relObj.FINISHED_GOOD.LOCATIONS.query("Location = :1"; "@:OS@").length>0)  // outside service inventory, don't send, this needs to be handled with phone calls
							//$sendASN:=False  // Modified by: Mel Bohince (4/2/21) Deal with O/S inventory
							$columns_c.push("@OS")
							
						Else 
							$columns_c.push("@RK")
						End if 
						
					Else   //no location
						$sendASN:=False:C215
						$columns_c.push("!BINS")
					End if 
					
				Else   //fg not found
					$sendASN:=False:C215
					$qtyPerCase:=0
					$numberOfCases:=0
					$columns_c.push("0")
					$columns_c.push("0")
					$columns_c.push("!FG")
					$columns_c.push("0")
					$columns_c.push("")
					$columns_c.push("")
				End if 
			End if   //test inventory
			
			//Next section is to evaluate whether this candidate release should be acted on
			//. testing or orderline status, launch status, o/s inventory, adequit inventory, RFM requested, ASN requested
			//test if order has been booked
			If ($relObj.ORDER_LINE#Null:C1517)
				$columns_c.push($relObj.ORDER_LINE.Status)
				If ($relObj.ORDER_LINE.Status#"Accepted")  //booked?
					If ($relObj.Actual_Qty=0)  // Modified by: Mel Bohince (1/21/21) allow sending asn after having shipped
						$sendASN:=False:C215
					End if 
				End if 
				
				If ($relObj.ORDER_LINE.ORDER#Null:C1517)
					$senders_id:=$relObj.ORDER_LINE.ORDER.edi_sender_id
					If (Length:C16($senders_id)>0)
						$columns_c.push($senders_id)
					Else   //sender id
						$senders_id:="6315311578"
						$columns_c.push($senders_id)
						//$sendASN:=False
						//$columns_c.push("NO SENDERID")
					End if   //sender id
					
				Else   //order header
					$sendASN:=False:C215
					$columns_c.push("NO ORDERHEADER")
				End if   //header
			Else 
				$sendASN:=False:C215
				$columns_c.push("NO ORDERLINE")
				$columns_c.push("NO SENDERID")
			End if 
			
			If ($relObj.THC_State=0) | ($relObj.Actual_Qty>0)  // Modified by: Mel Bohince (1/21/21) allow sending asn after having shipped
				$columns_c.push(String:C10("OK"))
				
			Else   //not enough inventory
				If ($asnWithoutInventory)
					$columns_c.push("SHORT - "+String:C10($relObj.THC_State))
				Else 
					$columns_c.push("NOGO - "+String:C10($relObj.THC_State))
					$sendASN:=False:C215
				End if 
			End if 
			
			$columns_c.push($relObj.Shipto)
			
			If ($relObj.SHIPTO_ADDR#Null:C1517)
				If ($relObj.SHIPTO_ADDR.edi_Send_ASN)
					$columns_c.push(txt_ToCSV_attribute($relObj.SHIPTO_ADDR; "Name"))
					$columns_c.push(txt_ToCSV_attribute($relObj.SHIPTO_ADDR; "Country"))
				Else 
					$columns_c.push("ASN NOT REQUIRED "+txt_ToCSV_attribute($relObj.SHIPTO_ADDR; "Name"))
					$columns_c.push("ASN NOT REQUIRED "+txt_ToCSV_attribute($relObj.SHIPTO_ADDR; "Country"))
					$sendASN:=False:C215
				End if 
				
			Else   //no shipto
				$sendASN:=False:C215
				$columns_c.push("NO SHIP-TO")
				$columns_c.push("NO Country")
			End if 
			
			$columns_c.push(String:C10($sendASN))
			//$columns_c.push($relObj.CustomerRefer)
			
			//$rel:=$relObj.toObject()
			//$json:=JSON Stringify($rel;*)
			//ALERT($json)
			
			If ($sendASN)
				$candidates_o.add($relObj)
				If ($logOnly)  //preflighting
					$columns_c.push("LOG ONLY")
					
				Else   //attempting to send asn's
					
					// Modified by: Mel Bohince (1/26/21) can fail if release is locked or edi inbox has a problem, so roll back if either happens
					//first try to get a lock on the release
					$result:=$relObj.lock()
					If ($result.success)
						
						EDI_DESADV_Consolidation(New object:C1471("msg"; "incrementCases"; "incrementCases"; $numberOfCases))
						// Modified by: Mel Bohince (4/13/21) User controlled number of pallets, added $consolidationDetail_o and call
						$consolidationDetail_o:=New object:C1471("po"; $relObj.CustomerRefer; "cpn"; $relObj.ProductCode; "numCases"; $numberOfCases; "caseSpaces"; $casesPerSkid)
						EDI_DESADV_Consolidation(New object:C1471("msg"; "addDetail"; "consolDetail"; $consolidationDetail_o))
						
						EDI_DESADV_Consolidation(New object:C1471("msg"; "close?"; "currentRelease"; $relObj.ReleaseNumber))
						
						$edi_Outbox_id:=EDI_DESADV_By_Release($relObj)
						If ($edi_Outbox_id>0)  //mark this release so that we know that the asn has been sent
							$relObj.ediASNmsgID:=$edi_Outbox_id
							If (consolidation_o#Null:C1517)  // Modified by: Mel Bohince (7/8/20) 
								$relObj.Expedite:=consolidation_o.id
								$consolidationNumber:=consolidation_o.id
							Else 
								$consolidationNumber:="n/a"
							End if 
							
							$relObj.user_date_2:=epd  //earliest pickup date given by Arkay
							
							If ($relObj.Milestones=Null:C1517)
								$relObj.Milestones:=New object:C1471
							End if 
							$relObj.Milestones.ASN:=String:C10(Current date:C33; Internal date short special:K1:4)
							$relObj.Milestones.Cnsl:=$consolidationNumber
							
							$result:=$relObj.save()
							If ($result.success)
								$columns_c.push("SENT")
								
							Else 
								$relObj.ediASNmsgID:=-1  // Modified by: Mel Bohince (1/26/21) 
								$columns_c.push("EDI Msg ID Not Saved to release "+String:C10($relObj.ReleaseNumber))
								$allGood:=False:C215
							End if 
							
						Else   //inbox fail
							$relObj.ediASNmsgID:=-1  // Modified by: Mel Bohince (1/26/21) 
							$columns_c.push("INBOX FAILURE")
							$allGood:=False:C215
						End if   // inbox fail
						
						$relObj.unlock()
						
					Else   //lock not granted
						$relObj.ediASNmsgID:=-1  // Modified by: Mel Bohince (1/26/21) 
						$columns_c.push("Release Locked")
						//If ($result.status=dk status locked)
						If (OB Is defined:C1231($result; "lockInfo"))  // Modified by: Mel Bohince (3/9/21) provide message if can't be saved
							$formObj:=$result.lockInfo
						Else 
							$formObj:=New object:C1471("user_name"; "Close"; "task_name"; "and"; "host_name"; "Re Send ASN")
						End if 
						$formObj.button:="Try Later"
						$formObj.message:="CPN: "+$relObj.ProductCode+"\rPO: "+$relObj.CustomerRefer
						util_EntityLocked($formObj)
						
						$allGood:=False:C215
						
					End if   //get lock()
					
				End if   //$log only
				
			Else   //tests failed
				$columns_c.push("NOT SENT")
			End if 
			
			$columns_c.push(String:C10($relObj.ediASNmsgID))  // Modified by: Mel Bohince (1/20/21) 
			$columns_c.push(String:C10($relObj.Mode))  // Modified by: Mel Bohince (11/17/21) 
			
			// Modified by: Mel Bohince (9/13/21) 
			C_OBJECT:C1216($outbox_e)
			If ($relObj.ediASNmsgID>0)
				$outbox_e:=ds:C1482.edi_Outbox.query("ID = :1 and SentTimeStamp > :2"; $relObj.ediASNmsgID; 100).first()  //not already sent
				If ($outbox_e#Null:C1517)
					$ediSent_t:="EDI Sent: "+TS2String($outbox_e.SentTimeStamp)
				Else   //msg was not in the sent status or missing
					$ediSent_t:="EDI NOT Sent"
				End if   //outbox record found
				
			Else   //asn not prep'd
				$ediSent_t:=""
			End if   //has a msg id
			
			
			$columns_c.push($ediSent_t)
			// End Modified by: Mel Bohince (9/13/21) 
			
			$rows_c.push($columns_c.join($d))  //add this row
			
		End for each   //each release
		
	Else   //bailed  // Added by: Mel Bohince (6/26/20) progress indicators cancel
		ALERT:C41("Aborted before working on shipto "+$shipto)  //optional debrief
		$allGood:=False:C215
	End if   //$continueInteration
	
	If (Not:C34($logOnly))
		If ($allGood)
			VALIDATE TRANSACTION:C240
			
		Else 
			CANCEL TRANSACTION:C241
			uConfirm("ASN's for ShipTo "+$shipto+" could not be processed. Check Spreadsheet for Error message."; "Try Later"; "Oh well")
		End if 
	End if 
	
End for each   //shipto

Progress QUIT($innerBar)  //remove the thermometer  // Added by: Mel Bohince (6/26/20) progress indicators
Progress QUIT($outerBar)  //remove the thermometer

EDI_DESADV_Consolidation(New object:C1471("msg"; "kill"))  // ("kill";0)  //cleanup

$log:=$rows_c.join($r)  //prep the text to send to file

C_TEXT:C284($title; $text; $docName; $millidiff)
C_LONGINT:C283($millinow; $millithen)
C_TIME:C306($docRef)

$title:=""
$text:=""
$docName:="ASN_Log_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".csv"
$docRef:=util_putFileName(->$docName)

If ($docRef#?00:00:00?)
	SEND PACKET:C103($docRef; $log)
	SEND PACKET:C103($docRef; "\r\r")
	
	SEND PACKET:C103($docRef; "\r\r------ END OF FILE ------")
	CLOSE DOCUMENT:C267($docRef)
	
	$subject:="ASN Log for "+String:C10(4D_Current_date; Internal date short special:K1:4)
	$preheader:="ASN/RFM Log. Open attached with Excel.\rReport run each morning at 6:40am. See EDI_DESADV_get_PO_Calloffs."
	$body:="Open firm ELC Releases called off that haven't already generated an ASN.\r"
	$body:=$body+" The purpose is to reveal reasons why an ASN was not sent, such as order status, packing spec, launch status, inventory available, O/S inventory."
	$distributionList:=Batch_GetDistributionList("ASN/RFM Report")
	//Email_html_body ($subject;$preheader;$body;500;$distributionList;$docName)
	$err:=util_Launch_External_App($docName)
	//util_deleteDocument ($docName)
	If ($candidates_o.length>0)
		//Display a list of the updated Releases
		$0:=$candidates_o
	End if 
End if   //docref
