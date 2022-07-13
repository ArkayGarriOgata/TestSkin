//%attributes = {}
// ----------------------------------------------------
// Method: REL_RequestForModePerDest   ( ) ->
// By: Mel Bohince @ 04/22/16, 15:50:14
// Description
// automate the RFM process, send it twice a day, separate email per destination
// see also REL_RequestForMode, REL_RequestForModeOnDemand
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/16) sub lisa for brendan on $from & $reply; send list of waiting launch appv
// Modified by: Mel Bohince (6/15/16) read only fg locations
// Modified by: Mel Bohince (6/17/16) add Kamini.advani to errdistribution
// Modified by: Mel Bohince (6/21/16) exclude if no case count can be found
// Modified by: Mel Bohince (3/1/17) remove 7am run to see if crashing stops, not related, was the shift card
// Modified by: Mel Bohince (5/30/17) change email 'from' and 'reply' address
// Modified by: Mel Bohince (8/20/17) don't include releases with ordline still in contract, or if shipto is n/a
// Modified by: Mel Bohince (1/30/19) use QSWA instead of looping query

C_TEXT:C284($tSubject; $text; $docName; $preheader; $tText; $now; $json_file)
C_TIME:C306($wait_until; $startUpAt; $docRef; $time_to_run)
C_DATE:C307($wait_date; $dateBegin; $dateEnd)
C_BOOLEAN:C305(<>run_rfm; $testForCaseCount)  //so it can be killed on client
$testForCaseCount:=True:C214  // Modified by: Mel Bohince (6/21/16) exclude if no case count can be found
C_LONGINT:C283($delay_in_seconds; $i; $numElements; $minutes; $loops; <>pid_RFM; $times_sent; $look_ahead_days; $wght_per_case; $hit)
C_TEXT:C284($1)

If (Count parameters:C259=0)
	<>pid_RFM:=Process number:C372("Request-For-Mode2")
	If (<>pid_RFM=0)  //singleton
		<>pid_RFM:=New process:C317("REL_RequestForModePerDest"; <>lBigMemPart; "Request-For-Mode2"; "init")
		If (False:C215)
			REL_RequestForModePerDest
		End if 
		
	Else 
		If (Not:C34(<>fQuit4D))  // Added by: Mel Bohince (7/12/19) 
			uConfirm("Request-For-Mode is already running on this client."; "Just Checking"; "Kill")
			If (ok=0)
				<>run_rfm:=False:C215
			End if 
		Else   //help it die
			<>run_wms:=False:C215
		End if 
	End if 
	
Else   //fire this sucker up
	
	READ ONLY:C145([Finished_Goods:26])
	READ ONLY:C145([Finished_Goods_Locations:35])
	READ ONLY:C145([Addresses:30])
	READ WRITE:C146([Customers_ReleaseSchedules:46])
	<>run_rfm:=True:C214
	$minutes:=15
	$loops:=0
	$delay_in_seconds:=$minutes*60*60  //wake up every 15 minutes
	$wght_per_case:=30  //this was the prior assumption
	$time_to_run:=?07:00:00?  // Modified by: Mel Bohince (7/22/19) 
	$from:="arkay_rfm@arkay.com"  //"lisa.dirsa@arkay.com" // Modified by: Mel Bohince (5/30/17) 
	$errDistribution:="TMC_Arkay@arkay.com,"
	$reply:=$from
	$addressWarehouse:="Arkay, 872 LEE Highway Roanoke VA 24019"
	//$addressGlobe:="Globe, ??? "
	//$addressMultifold:="Multifold, ???"
	
	
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
	$times_sent:=0
	//init the first running
	$startUpAt:=4d_Current_time  // Modified by: Mel Bohince (4/22/16) refactor for clarity
	//Case of //twice a day
	//: ($startUpAt>=?00:00:00?) & ($startUpAt<?06:55:00?)  //you sick bastard, why would you fire this up at this time
	//$wait_until:=?06:55:00?  //wait till morning
	//$times_sent:=0  //assume none sent today
	
	//: ($startUpAt>?06:55:00?) & ($startUpAt<?15:05:00?)  //missed morning run, go in afternoon
	//$wait_until:=?15:05:00?
	//$times_sent:=1
	
	//: ($startUpAt>?15:05:00?) & ($startUpAt<?23:59:59?)  //most likely with a deployment at 9pm
	//$wait_until:=?06:55:00?  //wait till morning
	//$times_sent:=2  //assume already sent today
	//End case 
	
	//$wait_until:=?15:05:00?  // Modified by: Mel Bohince (3/1/17) 
	$wait_until:=$time_to_run  // Modified by: Mel Bohince (7/22/19) 
	
	utl_Logfile("RFM.Log"; "Started; waiting for "+String:C10($wait_until; HH MM AM PM:K7:5)+", checking every "+String:C10($minutes)+" minutes.")
	
	//Loop twice daily
	While (Not:C34(<>fQuit4D)) & (<>run_rfm)
		zwStatusMsg("RFM"; "Running...")
		$loops:=$loops+1
		
		If (4D_Current_date>$wait_date)  //its a new day
			$wait_date:=4D_Current_date
			$times_sent:=0
			//$wait_until:=?06:55:00?  //wait for morning
			//$wait_until:=?15:05:00?  // Modified by: Mel Bohince (3/1/17)
			$wait_until:=$time_to_run  // Modified by: Mel Bohince (7/22/19)  
			utl_Logfile("RFM.Log"; "Focus date advanced to "+String:C10($wait_date)+", waiting for "+String:C10($wait_until; HH MM AM PM:K7:5))
		End if 
		
		If (4d_Current_time>=$wait_until) & ($times_sent<2) & (<>run_rfm)  //do the deed
			//If (Day number($wait_date)>Sunday) & (Day number($wait_date)<Saturday)  //skip weekends
			///////////
			///////////
			///////////
			///////////
			//query params
			//if(Day number($wait_date)=Friday)
			//$look_ahead_days:=7
			//Else 
			$look_ahead_days:=7  // Modified by: Mel Bohince (10/27/20) was set to 5 days 
			//end if
			$dateBegin:=Date:C102(FiscalYear("start"; Current date:C33))
			$dateBegin:=Add to date:C393($dateBegin; 0; -1; 0)
			
			$dateEnd:=Add to date:C393(4D_Current_date; 0; 0; $look_ahead_days)
			//for testing o/s
			//$dateBegin:=!06/06/2016!
			//$dateEnd:=Add to date($dateBegin;0;0;$look_ahead_days)
			
			$boolean:=FG_LaunchItem("init")
			
			//Get Destinations requiring RFM with their to and cc addresses
			QUERY:C277([Addresses:30]; [Addresses:30]RequestForModeEmailTo:17#"")  //clearing emailto field would remove it from rotation
			SELECTION TO ARRAY:C260([Addresses:30]ID:1; $aAddressID; [Addresses:30]RequestForModeEmailTo:17; $aEmailAddress; [Addresses:30]RequestForModeEmailCC:45; $aEmailAddressCC; [Addresses:30]Name:2; $aAddressName; [Addresses:30]City:6; $aAddressCity; [Addresses:30]Country:9; $aAddressCountry)
			REDUCE SELECTION:C351([Addresses:30]; 0)
			If (Size of array:C274($aAddressID)>0)
				///////////
				///////////
				///////////
				///////////
				$now:=TS_ISO_String_TimeStamp
				
				//Get releases in date range going to those destinations that have thc = 0 (suffient qty)
				// and where [Customers_ReleaseSchedules]user_date_1 is 00/00/00
				// ******* possible bug  - 4D PS - January  2019 ********
				
				// Removed by: Mel Bohince (1/30/19) see QSWA below after constraint
				//QUERY([Customers_ReleaseSchedules];[Customers_ReleaseSchedules]Shipto=$aAddressID{1};*)
				//For ($address;2;Size of array($aAddressID))
				//QUERY([Customers_ReleaseSchedules]; | ;[Customers_ReleaseSchedules]Shipto=$aAddressID{$address};*)
				//End for 
				
				// ******* possible bug  - 4D PS - January 2019 (end) *********
				
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Shipto:10#"N/A"; *)  // Modified by: Mel Bohince (8/20/17) 
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]user_date_1:48=!00-00-00!; *)  //not already rfm'd
				QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)  //if suffient fg quantity exists
				
				QUERY SELECTION WITH ARRAY:C1050([Customers_ReleaseSchedules:46]Shipto:10; $aAddressID)  // Modified by: Mel Bohince (1/30/19) 
				
				CREATE SET:C116([Customers_ReleaseSchedules:46]; "RFM_candidates")
				
				// Modified by: Mel Bohince (8/20/17) don't include releases with ordline still in contract
				ARRAY TEXT:C222($aStillContract; 0)
				If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
					
					SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]OrderLine:4; $aOrdLines)
					QUERY WITH ARRAY:C644([Customers_Order_Lines:41]OrderLine:3; $aOrdLines)
					QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="Contract")
					SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aStillContract)
					QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]OrderLine:4; $aStillContract)
					
					
				Else 
					
					If (Not:C34(<>modification4D_10_05_19))  // BEGIN 4D Professional Services : Query With array
						
						RELATE ONE SELECTION:C349([Customers_ReleaseSchedules:46]; [Customers_Order_Lines:41])
						QUERY SELECTION:C341([Customers_Order_Lines:41]; [Customers_Order_Lines:41]Status:9="Contract")
						SELECTION TO ARRAY:C260([Customers_Order_Lines:41]OrderLine:3; $aStillContract)
						QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]OrderLine:4; $aStillContract)
						
						
					Else 
						
						QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_Order_Lines:41]Status:9="Contract")
						
					End if   // END 4D Professional Services : January 2019 
					
				End if   // END 4D Professional Services : January 2019 query selection
				CREATE SET:C116([Customers_ReleaseSchedules:46]; "not_ready")
				DIFFERENCE:C122("RFM_candidates"; "not_ready"; "RFM_candidates")
				USE SET:C118("RFM_candidates")
				CLEAR SET:C117("not_ready")
				// Modified by: Mel Bohince (5/24/18) email ones still in contract
				If (Size of array:C274($aStillContract)>0)
					$subject:="RFM-WARNING-CONTRACT-STATUS"+"-"+$now
					SORT ARRAY:C229($aStillContract; >)
					$problemCPNs:=util_textFromArray_implode(->$aStillContract; ", ")
					$body:="Contract status detected for "+$problemCPNs
					$body:=$body+" released between "+String:C10($dateBegin)+" and "+String:C10($dateEnd)
					$body:=$body+". You must have these orders excepted."
					EMAIL_Sender($subject; ""; $body; $errDistribution; "")
				End if 
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
					
					// preparing to subtract records out of the original query
					DISTINCT VALUES:C339([Finished_Goods_Locations:35]ProductCode:1; $aCPN)  //these are product locations outside
					QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)  //prep to call back to releases
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //find the ones that could have been candidates
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
					QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
					CREATE SET:C116([Customers_ReleaseSchedules:46]; "haveOutsideInventory")  //these need to be excluded
					DIFFERENCE:C122("RFM_candidates"; "haveOutsideInventory"; "RFM_candidates")
					USE SET:C118("RFM_candidates")
					CLEAR SET:C117("haveOutsideInventory")
					
					$subject:="RFM-WARNING-OUTSIDE/SERVICE"+"-"+$now
					SORT ARRAY:C229($aCPN; >)
					$problemCPNs:=util_textFromArray_implode(->$aCPN; ", ")
					$body:="Outside Service inventory detected for "+$problemCPNs
					$body:=$body+" released between "+String:C10($dateBegin)+" and "+String:C10($dateEnd)
					$body:=$body+". You must send a RFM manually once you decide where the pickup will be."
					EMAIL_Sender($subject; ""; $body; $errDistribution; "")
					
				End if   //outside service invnetory
				
				
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
					utl_Logfile("RFM.Log"; "######### Launch Hold inventory, "+[Customers_ReleaseSchedules:46]ProductCode:11+" maybe others")
					
					DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)  //these are product on launch hold
					$subject:="RFM-WARNING-LAUNCH HOLD"+"-"+$now
					SORT ARRAY:C229($aCPN; >)
					$problemCPNs:=util_textFromArray_implode(->$aCPN; ", ")
					$body:="Launch-hold inventory detected for "+$problemCPNs
					$body:=$body+" released between "+String:C10($dateBegin)+" and "+String:C10($dateEnd)
					$body:=$body+". You must set the Launch Approved date on the F/G record."
					EMAIL_Sender($subject; ""; $body; $errDistribution; "")
					CREATE SET:C116([Customers_ReleaseSchedules:46]; "onLaunchHold")  //these need to be excluded
					DIFFERENCE:C122("RFM_candidates"; "onLaunchHold"; "RFM_candidates")
					USE SET:C118("RFM_candidates")
				End if   //launch hold
				
				If ($testForCaseCount)  // Modified by: Mel Bohince (6/21/16) exclude if no case count can be found
					USE SET:C118("RFM_candidates")
					DISTINCT VALUES:C339([Customers_ReleaseSchedules:46]ProductCode:11; $aCPN)
					ARRAY TEXT:C222($aCPNwithOutSpec; 0)
					
					C_LONGINT:C283($cpn; $casecount)
					$numElements:=Size of array:C274($aCPN)
					For ($cpn; 1; $numElements)
						$casecount:=PK_getCaseCount(FG_getOutline($aCPN{$cpn}))
						If ($casecount=0)
							APPEND TO ARRAY:C911($aCPNwithOutSpec; $aCPN{$cpn})
						End if 
					End for 
					
					If (Size of array:C274($aCPNwithOutSpec)>0)  //got some missing casecounts
						QUERY WITH ARRAY:C644([Customers_ReleaseSchedules:46]ProductCode:11; $aCPNwithOutSpec)  //prep to call back to releases
						If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
							
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //find the ones that could have been candidates
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
							CREATE SET:C116([Customers_ReleaseSchedules:46]; "noPakSpec")  //these need to be excluded
							
							
						Else 
							
							SET QUERY DESTINATION:C396(Into set:K19:2; "noPakSpec")
							
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)  //find the ones that could have been candidates
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5>=$dateBegin; *)
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Sched_Date:5<=$dateEnd; *)
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#("<@"); *)
							QUERY SELECTION:C341([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39=0)
							
							SET QUERY DESTINATION:C396(Into current selection:K19:1)
							
							
							
						End if   // END 4D Professional Services : January 2019 query selection
						DIFFERENCE:C122("RFM_candidates"; "noPakSpec"; "RFM_candidates")
						USE SET:C118("RFM_candidates")
						CLEAR SET:C117("noPakSpec")
						
						$subject:="RFM-WARNING-NO PACKING SPEC"+"-"+$now
						SORT ARRAY:C229($aCPNwithOutSpec; >)
						$problemCPNs:=util_textFromArray_implode(->$aCPNwithOutSpec; ", ")
						utl_Logfile("RFM.Log"; "######### no packing spec for "+$problemCPNs)
						$body:="Packing specs missing or zero for "+$problemCPNs
						$body:=$body+" released between "+String:C10($dateBegin)+" and "+String:C10($dateEnd)
						$body:=$body+"."
						EMAIL_Sender($subject; ""; $body; $errDistribution; "")
					End if 
				End if   //test for case count
				
				CLEAR SET:C117("RFM_candidates")
				
				$numRels:=Records in selection:C76([Customers_ReleaseSchedules:46])
				
				utl_Logfile("RFM.Log"; String:C10($numRels)+" candidates")
				
				If ($numRels>0)
					
					ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Shipto:10; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
					
					$preheader:="The following item releases are ready to ship as of "+$now+":\r\r"
					$tText:=""  //cleared before each destination
					
					//prep the emails
					//for each release, to the same shipto, group them and send them
					//utl_LogIt ("init")
					
					$destination:=""  //prime the pump
					
					While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
						If ($destination#[Customers_ReleaseSchedules:46]Shipto:10)  //stating a new one
							
							If (Length:C16($destination)=5)  //ending a real one, skip this on the first loop
								//utl_LogIt ("}")
								$len:=Length:C16($json_file)-1
								$ch:=$json_file[[$len]]
								If ($ch=",")
									$json_file[[$len]]:=" "
								End if 
								
								$json_file:=$json_file+"   ]\r  }\r"  //end the json
								$json_file:=$json_file+" ]\r}\r"
								//save the json
								$docName:="RFM_"+$aAddressCity{$hit}+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".json"
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
									$headings:=$headings+$pb+"---------> PHONE: 1-540-278-2596 or 1-540-278-2597"+$dr
									$headings:=$headings+$pb+"---------> FAX: 1-540-977-9555"+$dr
									
									$headings:=$headings+$db+"SHIPTO: "+$dr
									$headings:=$headings+$db+"---------> "+$aAddressName{$hit}+", "+$aAddressCity{$hit}+", "+$aAddressCountry{$hit}+$dr
									$headings:=$headings+$db+""+$dr
									
									//change the weight of tags for column headers
									$headings:=$headings+$cb+"PRODUCT CODE"+$ct+"PURCHASE ORDER"+$ct+"QUANTITY"+$ct+"PACKING"+$ct+"WEIGHT"+$r  //now add the column headings
									
									$tText:=$headings+$tText  //slap it together
									
									//? separate by destination or email receipiant ?
									$to:=Replace string:C233($aEmailAddress{$hit}; ", \r"; ", ")  //clean up the input for delimiters//
									$cc:=Replace string:C233($aEmailAddressCC{$hit}; ", \r"; ", ")  //clean up the input for delimiters//
									If (Length:C16($to)>0)
										Email_html_table($tSubject; $preheader; $tText; 600; $to; $docName; $reply; $from; $cc)
										util_deleteDocument($docName)
									End if 
								End if 
								
							End if   //finsh prior
							
							
							//start the next destination
							$destination:=[Customers_ReleaseSchedules:46]Shipto:10
							$hit:=Find in array:C230($aAddressID; $destination)
							$tSubject:="RFM-"+$aAddressCity{$hit}+"-"+$now
							$tText:=""
							//$json_file:="{ "+txt_quote ("rfm")+": "+txt_quote ($now)+", "+txt_quote ("pickup")+": "+txt_quote ($addressWarehouse)+", "+txt_quote ("phone")+": "+txt_quote ("1-540-278-2596")+", "+txt_quote ("load")+": [ \r"
							
							//utl_LogIt ("{ shipto_id: "+$destination+", city: "+ADDR_getCity ($destination))
							$json_file:="{ \"rfm\": \""+$now+"\", \"pickup\": \""+$addressWarehouse+"\", \"phone\": \"1-540-278-2596\", \"load\": [ \r"
							$json_file:=$json_file+"  { \"shipto\": \""+$aAddressName{$hit}+"\", \"city\": \""+$aAddressCity{$hit}+"\", \"country\": \""+$aAddressCountry{$hit}+"\", \"id\": \""+$destination+"\", \"bol\": [\r"
						End if   //new destingation
						
						//lay in the releases
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
						$json_file:=$json_file+"    { \"item\": \""+[Customers_ReleaseSchedules:46]ProductCode:11+"\", \"po\": \""+$po+"\", \"qty\": "+String:C10($qty)+", \"pack\": \""+$packing+"\", \"weight\": "+String:C10($wght)+", \"depart\": \""+String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+"\"},\r"
						
						
						//XXXXXXXXXX
						//XXXXXXXXXX
						//compose, send, and mark userdate1
						If (fLockNLoad(->[Customers_ReleaseSchedules:46]; "no"))
							[Customers_ReleaseSchedules:46]user_date_1:48:=4D_Current_date
							[Customers_ReleaseSchedules:46]Expedite:35:="rfm"+[Customers_ReleaseSchedules:46]Expedite:35
							SAVE RECORD:C53([Customers_ReleaseSchedules:46])
						Else 
							$distributionList:="TMC_Arkay@arkay.com,"
							EMAIL_Sender("RFM Error, Release "+String:C10([Customers_ReleaseSchedules:46]ReleaseNumber:1)+" locked"; ""; [Customers_ReleaseSchedules:46]ProductCode:11; $distributionList; "")
						End if 
						
						//XXXXXXXXXX
						//XXXXXXXXXX
						
						
						NEXT RECORD:C51([Customers_ReleaseSchedules:46])
					End while   //rel to send
					
					//finish the last destination
					$len:=Length:C16($json_file)-1
					$ch:=$json_file[[$len]]
					If ($ch=",")
						$json_file[[$len]]:=" "
					End if 
					
					$json_file:=$json_file+"   ]\r  }\r"  //end the json
					$json_file:=$json_file+" ]\r}\r"
					$docName:="RFM_"+$aAddressCity{$hit}+"_"+fYYMMDD(4D_Current_date)+"_"+Replace string:C233(String:C10(4d_Current_time; HH MM SS:K7:1); ":"; "")+".json"
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
						$headings:=$headings+$pb+"---------> PHONE: 1-540-278-2596 or 1-540-278-2597"+$dr
						$headings:=$headings+$pb+"---------> FAX: 1-540-977-9555"+$dr
						
						$headings:=$headings+$db+"SHIPTO: "+$dr
						$hit:=Find in array:C230($aAddressID; $destination)
						$headings:=$headings+$db+"---------> "+$aAddressName{$hit}+", "+$aAddressCity{$hit}+", "+$aAddressCountry{$hit}+$dr
						$headings:=$headings+$db+""+$dr
						
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
			
			UNLOAD RECORD:C212([Finished_Goods:26])
			UNLOAD RECORD:C212([Finished_Goods_Locations:35])
			UNLOAD RECORD:C212([Addresses:30])
			//If (Not(<>modification4D_25_03_19))  // BEGIN 4D Professional Services : UNLOAD RECORD
			//UNLOAD RECORD([Customers_ReleaseSchedules])
			//Else
			//  // SEE LINE 450
			//End if   // END 4D Professional Services : January 2019 
			
			//If ($wait_until=?06:55:00?)//twice a day
			//$wait_until:=?15:05:00?
			//Else 
			//$wait_until:=?06:55:00? 
			//End if 
			
			
			//$wait_until:=?15:05:00?  // Modified by: Mel Bohince (3/1/17) 
			$wait_until:=$time_to_run  // Modified by: Mel Bohince (7/22/19) 
			
			utl_Logfile("RFM.Log"; "Waiting for "+String:C10($wait_until; HH MM AM PM:K7:5)+", checking every "+String:C10($minutes)+" minutes.")
			
			//Else 
			//utl_Logfile ("RFM.Log";"Skipping weekend.")
			//End if   //weekend
		End if   //time to run
		
		
		zwStatusMsg("RFM"; "Delaying for "+String:C10($minutes)+" minutes")
		DELAY PROCESS:C323(Current process:C322; $delay_in_seconds)  //take a nap
		
	End while   //waiting to run
	utl_Logfile("RFM.Log"; "ENDED loops:"+String:C10($loops))
	<>pid_RFM:=0
	
End if   //params
