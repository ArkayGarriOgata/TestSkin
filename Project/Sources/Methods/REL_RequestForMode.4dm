//%attributes = {}
// ----------------------------------------------------
// NOT USED SEE REL_RequestForModePerDest
//
//
// Method: REL_RequestForMode   ( ) ->
// By: Mel Bohince @ 04/19/16, 09:50:01
// Description
// automate the RFM process, send it twice a day
// see also REL_RequestForModePerDest
// ----------------------------------------------------

C_TEXT:C284($tSubject; $text; $docName; $preheader; $tText; $now)
C_TIME:C306($docRef)
C_TIME:C306($wait_until; $startUpAt)
C_DATE:C307($wait_date)
C_BOOLEAN:C305(<>run_rfm)
C_LONGINT:C283($delay_in_seconds; $i; $numElements; $minutes; $loops; <>pid_RFM; $times_sent; $look_ahead_days; $wght_per_case)
C_TEXT:C284($1)

If (Count parameters:C259=0)
	<>pid_RFM:=Process number:C372("Request-For-Mode")
	If (<>pid_RFM=0)  //singleton
		<>pid_RFM:=New process:C317("REL_RequestForMode"; <>lBigMemPart; "Request-For-Mode"; "init")
		If (False:C215)
			REL_RequestForMode
		End if 
		
	Else 
		uConfirm("Request-For-Mode is already running on this client."; "Just Checking"; "Kill")
		If (ok=0)
			<>run_rfm:=False:C215
		End if 
	End if 
	
Else   //fire this sucker up
	
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Addresses:30])
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	<>run_rfm:=True:C214
	$minutes:=15
	$loops:=0
	$delay_in_seconds:=$minutes*60*60  //wake up every 15 minutes
	$wght_per_case:=30  //this was the prior assumption
	$from:="lisa.dirsa@arkay.com"
	$errDistribution:="mel.bohince@arkay.com"+", "+"lisa.dirsa@arkay.com"+", "+"trisha.oconnor@arkay.com"+","
	$reply:="lisa.dirsa@arkay.com"
	$addressWarehouse:="Arkay, 872 LEE Highway Roanoke VA 24019"
	$addressGlobe:="Globe, ??? "
	$addressMultifold:="Multifold, ???"
	
	//set up some table tags, b as in before, t as in <tab> between, r as in eol
	//table data tags
	$r:="</td></tr>\r"
	$b:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	$t:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:400\">"
	
	//table header tags
	$db:="<tr style=\"background-color:#e5e4e2\"><th colspan=\"5\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:600;color:#666\">"
	$dr:="</th></tr>\r"
	
	//this will style the pickup@ bans, 
	$pb:="<tr style=\"background-color:#ffffff\"><th colspan=\"5\" style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:600;color:#666\">"
	
	//table column tags
	$cb:="<tr style=\"background-color:#ffffff\"><td style=\"text-align:left;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	$ct:="</td><td style=\"text-align:right;padding:4px 6px;border:1px solid #d6dde6;font-weight:300;color:#666\">"
	
	
	$wait_date:=4D_Current_date
	//init the first running
	$startUpAt:=4d_Current_time  // Modified by: Mel Bohince (4/22/16) refactor for clarity
	Case of 
		: ($startUpAt>=?00:00:00?) & ($startUpAt<?06:55:00?)  //you sick bastard, why would you fire this up at this time
			$wait_until:=?06:55:00?  //wait till morning
			$times_sent:=0  //assume none sent today
			
		: ($startUpAt>?06:55:00?) & ($startUpAt<?15:05:00?)  //missed morning run, go in afternoon
			$wait_until:=?15:05:00?
			$times_sent:=1
			
		: ($startUpAt>?15:05:00?) & ($startUpAt<?23:59:59?)  //most likely with a deployment at 9pm
			$wait_until:=?06:55:00?  //wait till morning
			$times_sent:=2  //assume already sent today
	End case 
	
	utl_Logfile("RFM.Log"; "Started; waiting for "+String:C10($wait_until; HH MM AM PM:K7:5)+", checking every "+String:C10($minutes)+" minutes.")
	
	//Loop twice daily
	While (Not:C34(<>fQuit4D)) & (<>run_rfm)
		zwStatusMsg("RFM"; "Running...")
		$loops:=$loops+1
		
		If (4D_Current_date>$wait_date)  //its a new day
			$wait_date:=4D_Current_date
			$times_sent:=0
			$wait_until:=?06:55:00?  //wait for morning
			utl_Logfile("RFM.Log"; "Focus date advanced to "+String:C10($wait_date)+", waiting for "+String:C10($wait_until; HH MM AM PM:K7:5))
		End if 
		
		If (4d_Current_time>=$wait_until) & ($times_sent<2) & (<>run_rfm)  //do the deed
			
			///////////
			///////////
			///////////
			///////////
			//query params
			$look_ahead_days:=5
			$dateBegin:=FiscalYear("start"; Current date:C33)
			$dateEnd:=Add to date:C393(4D_Current_date; 0; 0; $look_ahead_days)
			
			$boolean:=FG_LaunchItem("init")
			
			//Get Destinations requiring RFM with their to and cc addresses
			QUERY:C277([Addresses:30]; [Addresses:30]RequestForModeEmailTo:17#"")
			SELECTION TO ARRAY:C260([Addresses:30]ID:1; $aAddressID; [Addresses:30]RequestForModeEmailTo:17; $aEmailAddress; [Addresses:30]RequestForModeEmailCC:45; $aEmailAddressCC; [Addresses:30]Name:2; $aAddressName; [Addresses:30]City:6; $aAddressCity; [Addresses:30]Country:9; $aAddressCountry)
			REDUCE SELECTION:C351([Addresses:30]; 0)
			If (Size of array:C274($aAddressID)>0)
				///////////
				///////////
				///////////
				///////////
				//Get releases in date range going to those destinations that have thc = 0 (suffient qty)
				// and where [Customers_ReleaseSchedules]user_date_1 is 00/00/00
				//? separate by destination or email receipiant ?
				QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10=$aAddressID{1}; *)
				For ($address; 2; Size of array:C274($aAddressID))
					QUERY:C277([Customers_ReleaseSchedules:46];  | ; [Customers_ReleaseSchedules:46]Shipto:10=$aAddressID{$address}; *)
				End for 
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
				
				///
				//// isolate the outside service rels
				ARRAY TEXT:C222($aCPN; 0)
				DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)  //these are the target codes
				QUERY WITH ARRAY:C644([Finished_Goods_Locations:35]ProductCode:1; $aCPN)  //this is their inventory
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Finished_Goods_Locations:35]; [Finished_Goods_Locations:35]Location:2="FG:OS@")  //if any of them have inventory outside
				
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				If (Records in selection:C76([Finished_Goods_Locations:35])>0)
					utl_Logfile("RFM.Log"; "######### Outside Service inventory, "+[Finished_Goods_Locations:35]ProductCode:1+" maybe others")
					$subject:="RFM-WARNING-OUTSIDE/SERVICE"+"-"+$now
					$body:="Outside Service inventory detected for "+[Finished_Goods_Locations:35]ProductCode:1
					$body:=$body+", maybe others released between "+String:C10($dateBegin)+" and "+String:C10($dateEnd)
					$body:=$body+". You must send a RFM manually once you decide where the pickup will be."
					EMAIL_Sender($subject; ""; $body; $errDistribution; "")
					// preparing to subtract records out of the original query
					
					
					DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $aCPN)  //these are product locations outside
					QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)  //prep to call back to releases
					If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
						
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //find the ones that could have been candidates
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
						CREATE SET:C116([Customers_ReleaseSchedules:46]; "haveOutsideInventory")  //these need to be excluded
						
						
					Else 
						
						SET QUERY DESTINATION:C396(Into set:K19:2; "haveOutsideInventory")
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //find the ones that could have been candidates
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
						SET QUERY DESTINATION:C396(Into current selection:K19:1)
						
						
					End if   // END 4D Professional Services : January 2019 query selection
					DIFFERENCE:C122("RFM_candidates"; "haveOutsideInventory"; "RFM_candidates")
					USE SET:C118("RFM_candidates")
					CLEAR SET:C117("haveOutsideInventory")
					
				End if 
				
				
				//<>FGLaunchItemHold
				QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; <>FGLaunchItemHold)  //all the releases on launch hold see FG_LaunchItem ("hold")
				// ******* Verified  - 4D PS - January  2019 ********
				
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //find the ones that could have been candidates
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
				QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
				
				// ******* Verified  - 4D PS - January 2019 (end) *********
				
				If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
					utl_Logfile("RFM.Log"; "######### Launch Hold inventory, "+[Finished_Goods_Locations:35]ProductCode:1+" maybe others")
					$subject:="RFM-WARNING-LAUNCH HOLD"+"-"+$now
					$body:="Launch-hold inventory detected for "+[Finished_Goods_Locations:35]ProductCode:1
					$body:=$body+", maybe others released between "+String:C10($dateBegin)+" and "+String:C10($dateEnd)
					$body:=$body+". You must set the Launch Approved date on the F/G record."
					EMAIL_Sender($subject; ""; $body; $errDistribution; "")
					CREATE SET:C116([Customers_ReleaseSchedules:46]; "onLaunchHold")  //these need to be excluded
					DIFFERENCE:C122("RFM_candidates"; "onLaunchHold"; "RFM_candidates")
					USE SET:C118("RFM_candidates")
					CLEAR SET:C117("RFM_candidates")
				End if 
				
				$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
				utl_Logfile("RFM.Log"; String:C10($numRels)+" candidates")
				
				If ($numRels>0)
					
					ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
					
					$now:=TS_ISO_String_TimeStamp
					
					$tSubject:="RFM-"+$now
					$preheader:="The following item releases are ready to ship as of "+$now+":\r\r"
					$tText:=""
					
					//prep the email
					//for each release, if suffient fg quantity exists, collect it for batch email
					//utl_LogIt ("init")
					$destination:=""
					$json_file:="{ rfm: '"+$now+"', pickup: '"+$addressWarehouse+"', phone: '1-540-278-2596', load: [  \r"
					While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
						If ($destination#[Customers_ReleaseSchedules:46]Shipto:10)  //stating a new one
							If ($destination#"")
								//utl_LogIt ("}")
								$len:=Length:C16($json_file)-1
								$ch:=$json_file[[$len]]
								If ($ch=",")
									$json_file[[$len]]:=" "
								End if 
								
								$json_file:=$json_file+"   ]\r  },\r"
							End if 
							$destination:=[Customers_ReleaseSchedules:46]Shipto:10
							$hit:=Find in array:C230($aAddressID; $destination)
							$tText:=$tText+$db+"ShipTo---> "+$aAddressName{$hit}+", "+$aAddressCity{$hit}+", "+$aAddressCountry{$hit}+$dr
							
							//utl_LogIt ("{ shipto_id: "+$destination+", city: "+ADDR_getCity ($destination))
							$json_file:=$json_file+"  { name: '"+ADDR_getName($destination)+"', city: '"+ADDR_getCity($destination)+"', country: '"+ADDR_getCountry($destination)+"', id: '"+$destination+"', bol: [\r"
						End if 
						
						$po:=Substring:C12([Customers_ReleaseSchedules:46]CustomerRefer:3; 1; (Position:C15("."; [Customers_ReleaseSchedules:46]CustomerRefer:3)-1))
						$caseCnt:=0
						$cases:=0
						$qty:=0
						$wght:=0
						$packing:="n/a"
						$i:=qryFinishedGood([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
						If ($i>0)
							$caseCnt:=PK_getCaseCount([Finished_Goods:26]OutLine_Num:4)
							If ($caseCnt>0)
								$cases:=Int:C8([Customers_ReleaseSchedules:46]Sched_Qty:6/$caseCnt)  //check for odd lot
								$qty:=$cases*$caseCnt  //use a even lot multiple, rounded down
								If ($qty#[Customers_ReleaseSchedules:46]Sched_Qty:6)
									$cases:=$cases+1  //round up
									$qty:=$cases*$caseCnt  //use a even lot multiple, rounded up
								End if 
								$wght:=$cases*$wght_per_case  //an approximation
								$packing:=String:C10($cases)+" x "+String:C10($caseCnt)
								If ($qty#[Customers_ReleaseSchedules:46]Sched_Qty:6)
									$packing:=$packing+"*"
								End if 
							End if 
						End if 
						$tText:=$tText+$b+[Customers_ReleaseSchedules:46]ProductCode:11+$t+$po+$t+String:C10($qty; "#,###,##0")+$t+$packing+$t+String:C10($wght)+$r
						//utl_LogIt ("   { item: "+[Customers_ReleaseSchedules]ProductCode+", po: "+$po+", qty: "+String($qty;"#,###,##0")+", pack: "+$packing+", weight: "+String($wght)+", depart: "+String([Customers_ReleaseSchedules]Sched_Date;System date short)+"}")
						$json_file:=$json_file+"    { item: '"+[Customers_ReleaseSchedules:46]ProductCode:11+"', po: '"+$po+"', qty: "+String:C10($qty)+", pack: '"+$packing+"', weight: "+String:C10($wght)+", depart: '"+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+"'},\r"
						
						//compose, send, and mark userdate1
						If (fLockNLoad(->[Customers_ReleaseSchedules:46]; "no"))
							[Customers_ReleaseSchedules:46]user_date_1:48:=4D_Current_date
							[Customers_ReleaseSchedules:46]Expedite:35:="rfm"+[Customers_ReleaseSchedules:46]Expedite:35
							SAVE RECORD:C53([Customers_ReleaseSchedules:46])
						Else 
							$distributionList:="mel.bohince@arkay.com,"+"Lisa.Dirsa@arkay.com,"
							EMAIL_Sender("RFM Error, Release "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" locked"; ""; [Customers_ReleaseSchedules:46]ProductCode:11; $distributionList; "")
						End if 
						
						NEXT RECORD:C51([Customers_ReleaseSchedules:46])
					End while   //rel to send
					
					$len:=Length:C16($json_file)-1
					$ch:=$json_file[[$len]]
					If ($ch=",")
						$json_file[[$len]]:=" "
					End if 
					$json_file:=$json_file+"   ]\r  }\r"
					$json_file:=$json_file+" ]\r}\r"
					$docName:="RFM_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; <>HHMM); ":"; "")+".json"
					$docRef:=util_putFileName(->$docName)
					If ($docRef#?00:00:00?)
						SEND PACKET:C103($docRef; $json_file)
						$json_file:=""
						CLOSE DOCUMENT:C267($docRef)
					End if 
					//utl_LogIt ("}")
					//utl_LogIt ("show")
					
					If (Length:C16($tText)>0)  //something to send, so pack it with a ribbon and bow
						//this will style the pickup@ bans, 
						$headings:=$pb+"FROM: "+$dr  //https://goo.gl/maps/34s1bfyHTtB2
						$headings:=$headings+$pb+"---------> "+$addressWarehouse+$dr
						$headings:=$headings+$pb+"             PHONE: 1-540-278-2596 or 1-540-278-2597"+$dr
						$headings:=$headings+$pb+"             FAX: 1-540-977-9555"+$dr
						
						//change the weight of tags for column headers
						$headings:=$headings+$cb+"PRODUCT CODE"+$ct+"PURCHASE ORDER"+$ct+"QUANTITY"+$ct+"PACKING"+$ct+"WEIGHT"+$r  //now add the column headings
						
						$tText:=$headings+$tText  //slap it together
						
						$to:=Replace string:C233($aEmailAddress{$hit}; ", \r"; ", ")  //clean up the input for delimiters//
						$cc:=Replace string:C233($aEmailAddressCC{$hit}; ", \r"; ", ")  //clean up the input for delimiters//
						If (Length:C16($to)>0)
							Email_html_table($tSubject; $preheader; $tText; 600; $to; $docName; $reply; $from; $cc)
							util_deleteDocument($docName)
						End if 
					End if 
					///////////
					///////////
					///////////
					///////////
				End if   //candidate releases
				
			End if   //addresses to check
			
			$times_sent:=$times_sent+1
			
			If ($wait_until=?06:55:00?)
				$wait_until:=?15:05:00?
			Else 
				$wait_until:=?06:55:00?
			End if 
			
			utl_Logfile("RFM.Log"; "Waiting for "+String:C10($wait_until; HH MM AM PM:K7:5)+", checking every "+String:C10($minutes)+" minutes.")
			
		End if   //time to run
		
		zwStatusMsg("RFM"; "Delaying for "+String:C10($minutes)+" minutes")
		DELAY PROCESS:C323(Current process:C322; $delay_in_seconds)  //take a nap
		
	End while   //waiting to run
	utl_Logfile("RFM.Log"; "ENDED loops:"+String:C10($loops))
	<>pid_RFM:=0
	
End if   //params
