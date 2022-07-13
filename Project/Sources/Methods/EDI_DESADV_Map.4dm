//%attributes = {}
// _______
// Method: EDI_DESADV_Map   ( shippedReleaseObj) -> $edi_Outbox_id
// By: Mel Bohince @ 02/06/20, 17:46:27
// Description
// 
// ----------------------------------------------------
// Modified by: Mel Bohince (4/20/20) final tweeks, ( : and + )'s
// Modified by: Mel Bohince (7/13/20) send blank temperature, remove the 2 before segDelimitor
// Modified by: Mel Bohince (2/18/21) round Kg weight after summing the cases, protect 150 threshold on UPS parcel shipments
// Modified by: Mel Bohince (4/2/21) deal with outside service warehousing,base shipFrom on inventory location
// Modified by: Mel Bohince (4/5/21) chg contact from perry to lisa
// Modified by: Mel Bohince (5/5/21) add TMC's W-Code (SHTO), but not enabled
// Modified by: Mel Bohince (9/3/21) prefer TMC_DD over Promise date

Begin SQL  //sample output
	/* Latest working sample
	UNB+UNOA:2+001635622:01:001635622+6314547000Q:12:6314547000Q+200427:1249+1170836++DESADV+A+++1'
	UNH+270835+DESADV:D:14A:UN:EDIFCT'
	BGM++351+4591006+9'
	DTM+234:20200429:102'
	DTM+235:150000:402'
	DTM+17:00000000:102'
	RFF+ON:4501995487'
	RFF+VR:10011470'
	NAD+SE+:ARKAY PACKAGING CORP+872 LEE Highway:::ROANOKE+VA:::US+24019'
	CTA+1+Perry Gates'
	COM+TE:540 278 2597'
	TOD+6++EXW'
	TDT+146+Self Loaded consolidation number'
	TDT+21+Self loaded container type'
	CPS+3++NA Pallet - 48x40'
	PAC+020+2'
	PAC+3+CAS'
	MEA+OD++48:IN'
	LIN+1++37X0011112:IN+:00010'
	MEA+HT++9.375:IN'
	MEA+LN++19:IN'
	MEA+WD++8.375:IN'
	MEA+AAB++60:LBR'
	MEA+AAF++60:LBR'
	MEA+AAE++2:LBR'
	MEA+AAW++2:LBR'
	MEA+AAX++2:LBR'
	MEA+TC++2'
	MEA+AAU++2'
	MEA+CEL++CELCIUS'
	QTY+12:1000:EA'
	FTX+STR++:NO'
	FTX+HAZ++:NO'
	FTX+LIN++:FOLDING CARTON'
	FTX+PRD++:Super Line Preventor'
	RFF+AVU:202002041'
	NAD+DP+:Asr Warehouse+71 Maxess Road+Melville+NY:::USA+11747'
	DGS+AAC+HAZMAT CLASS'
	DGS+ADR+UN 4 digit number'
	DGS+1+Hazmat Pkg Group'
	FTX+AAD++:HAZMAT NAME'
	FTX+AAA++:Hazmat Tech Name'
	CNT+11:0:C62'
	CNT+15:40:C62'
	UNT+44+270835'
	UNZ+1+1170836'
	*/
End SQL

C_TEXT:C284($segDelimitor; $test_indicator)
C_TEXT:C284($message; $arkayRelease; $senders_id; $arkays_vendor_id; $arkays_edi_id)
$arkays_edi_id:="001635622"
C_LONGINT:C283($segment_counter; $message_counter; $processLeadTime; $pickAndPackLeadTime; $edi_Outbox_id; $0)
C_DATE:C307($now)
C_REAL:C285($kilogramConversion; $centimeterConverion; $weightOfCaseKG)  //some constants for conversions  //$cubicDecimeterConversion
$kilogramConversion:=0.453592
$centimeterConverion:=2.54
//$cubicDecimeterConversion:=61.024
C_OBJECT:C1216($shippedReleaseObj; $1)
$shippedReleaseObj:=$1
$edi_Outbox_id:=-3  //return value
C_BOOLEAN:C305($continue; $allowZeroQty)
$continue:=True:C214  //used for folding sections of this method
$allowZeroQty:=False:C215

If ($shippedReleaseObj.qty>0) | ($allowZeroQty)
	
	If ($continue)  //something to map
		//string some dates
		$now:=Current date:C33
		$documentDate:=fYYMMDD(($now); 4)
		
		If (True:C214)  // Modified by: Mel Bohince (10/14/20) 
			$earliestPickupDate:=fYYMMDD(epd; 4)
		Else 
			$processLeadTime:=1  //how many days do we wait for "Booking Confirmation" from TMC/DSV
			$pickAndPackLeadTime:=1  //how long will it take to pick and stage the inventory and shipping documentation
			$asap:=$now+$processLeadTime+$pickAndPackLeadTime
			$asap:=util_DateNotWeekend($asap)
			$requested:=util_DateNotWeekend($shippedReleaseObj.releaseInfo.Sched_Date)
			If ($requested>$asap)
				$earliestPickupDate:=fYYMMDD($requested; 4)
			Else 
				$earliestPickupDate:=fYYMMDD($asap; 4)
			End if 
		End if 
		$earliestPickupTime:="15?:00?:00"  //late afternoon pickups are the norm
		
		////flatten out the parameter object
		$bol:=$shippedReleaseObj.bol
		$quantity:=String:C10($shippedReleaseObj.qty)
		
		$length:=String:C10(Round:C94($shippedReleaseObj.length*$centimeterConverion; 0))+":CM"
		$width:=String:C10(Round:C94($shippedReleaseObj.width*$centimeterConverion; 0))+":CM"
		$height:=String:C10(Round:C94($shippedReleaseObj.height*$centimeterConverion; 0))+":CM"
		
		$cases:=String:C10($shippedReleaseObj.numCases)
		
		$pallets:=String:C10($shippedReleaseObj.skids)
		
		$weightOfCaseKG:=$shippedReleaseObj.weight*$kilogramConversion  //Round( ;0)  // Modified by: Mel Bohince (2/18/21) round Kg weight after summing the cases
		$weightTotal:=String:C10(Round:C94(($weightOfCaseKG*$shippedReleaseObj.numCases); 0))+":KG"
		
		$contactPerson:="Lisa Dirsa"  // Modified by: Mel Bohince (4/5/21) 
		$contactPhone:="631 297 3381"
		$arkays_vendor_id:="0010011470"  //elc assigned to arkay
		
		If ($shippedReleaseObj.releaseInfo.ReleaseNumber>-1)
			$arkayRelease:=String:C10($shippedReleaseObj.releaseInfo.ReleaseNumber)
			$arkayOrderline:=$shippedReleaseObj.releaseInfo.OrderLine
			// Modified by: Mel Bohince (7/8/20) prefer Promise date over edi_dock_date
			// Modified by: Mel Bohince (9/3/21) prefer TMC_DD over Promise date
			C_DATE:C307($TMC_DD)
			$TMC_DD:=Date:C102($shippedReleaseObj.releaseInfo.Milestones.EDD)
			$dockDate:=fYYMMDD($TMC_DD; 4)
			
			If ($dockDate="00000000")  //use old method with Promise date
				$dockDate:=fYYMMDD(($shippedReleaseObj.releaseInfo.Promise_Date); 4)
			End if 
			
			If ($shippedReleaseObj.releaseInfo.ORDER_LINE#Null:C1517)
				If ($dockDate="00000000")
					$dockDate:=fYYMMDD(($shippedReleaseObj.releaseInfo.ORDER_LINE.edi_dock_date); 4)
				End if 
				$Orders_ICN:=$shippedReleaseObj.releaseInfo.ORDER_LINE.edi_ICN
				
			Else 
				$dockDate:="00000000"
				$Orders_ICN:="ORDER NOT FOUND"
			End if 
			$customersRelease:=$shippedReleaseObj.releaseInfo.CustomerRefer  //123456.00010.001
			
			$dot:=Position:C15("."; $customersRelease)  //[Customers_Orders]PONumber
			$purchaseOrder:=Substring:C12($customersRelease; 1; $dot-1)  //123456
			$line:=Substring:C12($customersRelease; $dot+1; 5)
			
			$productCode:=Replace string:C233($shippedReleaseObj.releaseInfo.ProductCode; "-"; "")
			If ($shippedReleaseObj.releaseInfo.FINISHED_GOOD#Null:C1517)
				$description:=$shippedReleaseObj.releaseInfo.FINISHED_GOOD.CartonDesc
			Else 
				$description:="Folding Carton"
			End if 
			
			If ($shippedReleaseObj.releaseInfo.SHIPTO_ADDR#Null:C1517)
				
				//clean up country, must be ISO 3166 alpha 2
				$country:=Uppercase:C13($shippedReleaseObj.releaseInfo.SHIPTO_ADDR.Country)
				// Removed by: Mel Bohince (4/2/21) case stmt with country abrevs
				// Modified by: Mel Bohince (5/5/21) add TMC's W-Code (SHTO)
				$shipto:=$shippedReleaseObj.releaseInfo.SHIPTO_ADDR.Name+"+"+$shippedReleaseObj.releaseInfo.SHIPTO_ADDR.Address1+"::"+$shippedReleaseObj.releaseInfo.SHIPTO_ADDR.Address3+":"+$shippedReleaseObj.releaseInfo.SHIPTO_ADDR.City+"+"+$shippedReleaseObj.releaseInfo.SHIPTO_ADDR.State+":::"+$country+"+"+$shippedReleaseObj.releaseInfo.SHIPTO_ADDR.Zip
				If (Position:C15("US"; $country)>0)
					//$palletType:="NA Pallet - 48"+Char(Double quote)+"x40"+Char(Double quote)  //util_Quote()
					$palletType:="NA Pallet - 48inx40in"
					$palletHeight:="122:CM"  //$palletHeight:="48:IN"
					$ttlLinearFoot:=String:C10(40*48)+":CM"  //looks like wrong uom, but they insist
					$volumeUOM:="CM"  //actually the area, not the volume
					
				Else 
					$palletType:="Wooden 4 ways HT - 120cmx100cm"  //util_Quote()
					$palletHeight:="122:CM"
					$ttlLinearFoot:=String:C10(40*48)+":CM"  //looks like wrong dims used, but they insist
					$volumeUOM:="CM"  //actually the area, not the volume
					
				End if 
			Else 
				$shipto:="SHIP-TO NOT FOUND"
				$palletType:="NA Pallet - 48inx40in"
				$palletHeight:="122:CM"  //$palletHeight:="48:IN"
				$palletHeight:="48:IN"
				$ttlLinearFoot:=String:C10(40*48)+":CM"
				$volumeUOM:="CM"  //actually the area, not the volume
			End if 
			
		Else   //well aint this some weird $h!t, no release record???
			$arkayOrderline:="REL NOT FOUND"
			$dockDate:="N/F"
			$purchaseOrder:="REL NOT FOUND"
			$Orders_ICN:="REL NOT FOUND"
			$customersRelease:="REL NOT FOUND"
			$line:="N/F"
			$productCode:="REL NOT FOUND"
			$description:="REL NOT FOUND"
		End if   //got a release record's info
		
	End if 
	
	If (consolidation_o#Null:C1517)  // Modified by: Mel Bohince (7/8/20) 
		If ($shippedReleaseObj.releaseInfo.ReleaseNumber=consolidation_o.lastRelease)  //overriden when consolidation_o.lastRelease=0
			$ttlLinearFoot:=String:C10(40*48)+":CM"
			$pallets:=String:C10(consolidation_o.totalPallets)
		End if 
	End if 
	
	//$rel:=$shippedReleaseObj.releaseInfo.toObject()
	//$json:=JSON Stringify($rel;*)
	//$shipinfo:=JSON Stringify($shippedReleaseObj;*)
	//$json:=$json+char(13)+$shipinfo
	//ALERT($json)
	
	//fill in the map
	If ($continue)  //envelop and and beginning of msg
		$senders_id:=""
		If ($shippedReleaseObj.releaseInfo.ORDER_LINE#Null:C1517)
			If ($shippedReleaseObj.releaseInfo.ORDER_LINE.ORDER#Null:C1517)
				$senders_id:=$shippedReleaseObj.releaseInfo.ORDER_LINE.ORDER.edi_sender_id
			End if 
		End if 
		
		If (Length:C16($senders_id)=0)
			$senders_id:="6315311578"
		End if 
		
		$errText:=EDI_AccountInfo("init")
		$test_indicator:=EDI_AccountInfo("getACK"; $senders_id)
		$segDelimitor:=Char:C90(Num:C11(EDI_AccountInfo("getSegDelim"; $senders_id)))  //"'"  `+Char(13)
		$partner:=EDI_AccountInfo("getAcctName"; $senders_id)
		
		$message:=""  //start a new message
		
		$tActualICN:=String:C10(EDI_GetNextIDfromPreferences("ICN_"+$senders_id); "0000000")
		$lUniqueMessageID:=String:C10(EDI_GetNextIDfromPreferences("TXN_"+$senders_id))
		
		$message:=$message+"UNB+UNOA:2+"+$arkays_edi_id+":01:"+$arkays_edi_id+"+"+$senders_id+":12:"+$senders_id+"+"
		$message:=$message+fYYMMDD(Current date:C33)+":"+Replace string:C233(String:C10(Current time:C178; <>HHMM); ":"; "")
		$message:=$message+"+"+$tActualICN+"++DESADV+A"+$test_indicator+$segDelimitor  //unique sequence number  +0+
		
		$message:=$message+"UNH+"+$lUniqueMessageID+"+DESADV:D:14A:UN:EDIFCT"+$segDelimitor
		$message_counter:=1  //there will be only one due to po ref in header
		$segment_counter:=0  //unh to unt inclusive, hard code at the end
		
		$message:=$message+"BGM++351+"+$arkayRelease+$bol+"+9"+$segDelimitor
	End if   //envelop
	
	If ($continue)  //DTM's
		$message:=$message+"DTM+234:"+$earliestPickupDate+":102"+$segDelimitor  // earliest pickup date
		$message:=$message+"DTM+235:"+"150000:402"+$segDelimitor  // earliest pickup time
		$message:=$message+"DTM+17:"+$dockDate+":102"+$segDelimitor
	End if 
	
	If ($continue)  //RFF's
		$message:=$message+"RFF+ON:"+$purchaseOrder+$segDelimitor
		$message:=$message+"RFF+VR:"+$arkays_vendor_id+$segDelimitor
	End if 
	
	
	If ($continue)  //ARKAY NAD's contact and terms
		$message:=$message+$shippedReleaseObj.shipFromWarehouse+$segDelimitor  // Modified by: Mel Bohince (4/2/21) 
		
		$message:=$message+"CTA+1+"+$contactPerson+$segDelimitor
		$message:=$message+"COM+TE:"+$contactPhone+$segDelimitor
		$message:=$message+"TOD+6++EXW"+$segDelimitor
	End if 
	
	If ($continue)  //unknown stuff
		If (consolidation_o#Null:C1517)  // Modified by: Mel Bohince (7/8/20) 
			$message:=$message+"TDT+146+"+consolidation_o.id+$segDelimitor  //self loading//CONSOLIDATION#
		Else 
			$message:=$message+"TDT+146+"+""+$segDelimitor
		End if 
		$message:=$message+"TDT+21+"+$segDelimitor  //self loading
		$message:=$message+"CPS+3++"+$palletType+$segDelimitor
		$message:=$message+"PAC+020+"+$cases+$segDelimitor  //outer pack qty
		$message:=$message+"PAC+3+CAS"+$segDelimitor  //UOM
		$message:=$message+"MEA+OD++"+$palletHeight+$segDelimitor
	End if 
	
	If ($continue)  //item section
		$message:=$message+"LIN+1++"+$productCode+":IN+:"+$line+$segDelimitor  //Part No.
		
		$message:=$message+"MEA+HT++"+$height+$segDelimitor
		$message:=$message+"MEA+LN++"+$length+$segDelimitor
		$message:=$message+"MEA+WD++"+$width+$segDelimitor
		
		$message:=$message+"MEA+AAB++"+$weightTotal+$segDelimitor  //gross wgt
		$message:=$message+"MEA+AAF++"+$weightTotal+$segDelimitor  //min wgt
		$message:=$message+"MEA+AAE++2:KG"+$segDelimitor  //wgt uom pounds
		$message:=$message+"MEA+AAX++"+$ttlLinearFoot+$segDelimitor  //ttl linar footage
		$message:=$message+"MEA+AAW++10:"+$volumeUOM+$segDelimitor  //gross volumn 
		
		$message:=$message+"MEA+TC++"+$segDelimitor  // Modified by: Mel Bohince (7/13/20) send blank temperature, remove the 2 before segDelimitor
		$message:=$message+"MEA+AAU++"+$segDelimitor  // Modified by: Mel Bohince (7/13/20) send blank temperature, remove the 2 before segDelimitor
		$message:=$message+"MEA+CEL++CELCIUS"+$segDelimitor
		
		$message:=$message+"QTY+12:"+$quantity+":EA"+$segDelimitor
		
		$message:=$message+"FTX+STR++:NO"+$segDelimitor
		$message:=$message+"FTX+HAZ++:NO"+$segDelimitor
		
		$message:=$message+"FTX+LIN++:FOLDING CARTON"+$segDelimitor
		$message:=$message+"FTX+PRD++:"+$description+$segDelimitor
		
		$message:=$message+"RFF+AVU:202002041"+$segDelimitor  //?????
		
		
		$message:=$message+"NAD+DP+:"+$shipto+$segDelimitor
		
	End if 
	
	If ($continue)  //more unknown stuff
		$message:=$message+"DGS+AAC+"+$segDelimitor
		$message:=$message+"DGS+ADR+"+$segDelimitor
		$message:=$message+"DGS+1+"+$segDelimitor
		$message:=$message+"FTX+AAD++:"+$segDelimitor
		$message:=$message+"FTX+AAA++:"+$segDelimitor
		$message:=$message+"CNT+11:"+$pallets+":C62"+$segDelimitor  //  //CNT+11:1:C62'  total number of pallets
		$message:=$message+"CNT+15:"+$pallets+":C62"+$segDelimitor  //  //CNT+15:25:MTQ'  cases per pallet "#of std pallet spaces"
	End if 
	
	If ($continue)  //trailer section
		$segment_counter:=44  //UNH to UNT inclusive
		$message:=$message+"UNT+"+String:C10($segment_counter)+"+"+$lUniqueMessageID+$segDelimitor  //need the number of segments in message
		$message:=$message+"UNZ+"+String:C10($message_counter)+"+"+$tActualICN+$segDelimitor  //need the number of messages in interchange
	End if 
	
	If ($continue)
		$edi_Outbox_id:=EDI_DESADV_SaveToOutbox($senders_id; $tActualICN; $customersRelease; $arkayOrderline; $Orders_ICN; ->$message)
	End if 
	
End if   //item has qty

$0:=$edi_Outbox_id