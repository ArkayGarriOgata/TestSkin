//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/17/13, 15:14:18
// ----------------------------------------------------
// Method: Rel_MustShip
// Description
// When MustShip is set on a release, an email notice should be sent 
//    if it hasn't shipped by 3pm that day
// ----------------------------------------------------

// Modified by: Mel Bohince (4/8/15) html'ize
// Modified by: Mel Bohince (4/21/16) don't run it if deploying after 3pm, wait til tomorrow

C_TIME:C306($wait_until)
C_DATE:C307($wait_date; $tomorrow)
C_BOOLEAN:C305($not_sent_yet; <>run_must_ship)
C_TEXT:C284($r)
C_LONGINT:C283($delay_in_seconds; $i; $numElements; $minutes; $loops; <>MUST_SHIP_PID)
C_TEXT:C284($1)

$wait_until:=?14:55:00?  //3pm
$wait_date:=4D_Current_date
$tomorrow:=Add to date:C393($wait_date; 0; 0; 1)
If (4d_Current_time>?15:20:00?)
	$not_sent_yet:=False:C215  //this is it for today
Else 
	$not_sent_yet:=True:C214
End if 
$r:=Char:C90(13)
$minutes:=15
$loops:=0
$delay_in_seconds:=$minutes*60*60  //wake up every 15 minutes

If (Count parameters:C259=0)
	<>MUST_SHIP_PID:=Process number:C372("Rel_MustShip")
	If (<>MUST_SHIP_PID=0)  //not already running
		<>run_must_ship:=True:C214
		//If (Application type=4D Server )  `(Application type#4D Client )
		<>MUST_SHIP_PID:=New process:C317("Rel_MustShip"; <>lMinMemPart; "Rel_MustShip"; "init")
		If (False:C215)
			Rel_MustShip
		End if 
		//End if 
	Else 
		If (Not:C34(<>fQuit4D))  // Added by: Mel Bohince (6/11/19) 
			uConfirm("Rel_MustShip is already running on this client."; "Just Checking"; "Kill")
			If (ok=0)
				<>run_must_ship:=False:C215
			End if 
			
		Else   //help it die
			<>run_wms:=False:C215
		End if 
	End if 
	
Else   //init
	READ ONLY:C145([y_batches:10])
	utl_Logfile("Must Ship.Log"; "Started; waiting for "+String:C10($wait_until; HH MM AM PM:K7:5)+", checking every "+String:C10($minutes)+" minutes.")
	$preheader:="Listing of product that must ship today and a preview of tomorrow's manditories."
	While (Not:C34(<>fQuit4D)) & (<>run_must_ship)
		zwStatusMsg("Must Ship"; "Running...")
		$loops:=$loops+1
		If (4D_Current_date>$wait_date)  //its a new day
			$wait_date:=4D_Current_date
			$tomorrow:=Add to date:C393($wait_date; 0; 0; 1)
			$not_sent_yet:=True:C214
			utl_Logfile("Must Ship.Log"; "Focus date advanced to "+String:C10($wait_date))
		End if 
		
		If (4d_Current_time>=$wait_until) & ($not_sent_yet) & (<>run_must_ship)
			
			
			ARRAY TEXT:C222($aProductCodes; 0)
			ARRAY TEXT:C222($aLines; 0)
			ARRAY TEXT:C222($aDest; 0)
			$textToday:=""
			//must ship today
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5=$wait_date; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]MustShip:53=True:C214)
			
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				//send notice
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $aProductCodes; [Customers_ReleaseSchedules:46]CustomerLine:28; $aLines; [Customers_ReleaseSchedules:46]Shipto:10; $aDest)
				SORT ARRAY:C229($aLines; $aProductCodes; $aDest; >)
				$numElements:=Size of array:C274($aProductCodes)
				
				$textToday:="<p style=\"padding:0 1em;\">The following items need to be shipped today: "+String:C10($wait_date; System time long abbreviated:K7:10)+"</p>"+$r
				$textToday:=$textToday+"<ul>\r"
				uThermoInit($numElements; "Processing Array")
				For ($i; 1; $numElements)
					$textToday:=$textToday+"<li style=\"padding-bottom:12px;\">"+$aProductCodes{$i}+" '"+$aLines{$i}+"' to "+ADDR_getCity($aDest{$i})+"</li>"+$r
					uThermoUpdate($i)
				End for 
				uThermoClose
				$textToday:=$textToday+"</ul>\r"
				
			End if 
			
			//must ship tomorrow
			ARRAY TEXT:C222($aProductCodes; 0)
			ARRAY TEXT:C222($aLines; 0)
			ARRAY TEXT:C222($aDest; 0)
			$textTomorrow:=""
			
			QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5=$tomorrow; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]Actual_Date:7=!00-00-00!; *)
			QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]MustShip:53=True:C214)
			If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
				//send notice
				SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]ProductCode:11; $aProductCodes; [Customers_ReleaseSchedules:46]CustomerLine:28; $aLines; [Customers_ReleaseSchedules:46]Shipto:10; $aDest)
				SORT ARRAY:C229($aLines; $aProductCodes; $aDest; >)
				$numElements:=Size of array:C274($aProductCodes)
				$textTomorrow:=$r+"<p style=\"padding:0 1em;\">The following items need to be shipped tomorrow: "+String:C10($tomorrow; System time long abbreviated:K7:10)+"</p>"+$r
				$textTomorrow:=$textTomorrow+"<ul>\r"
				uThermoInit($numElements; "Processing Array")
				For ($i; 1; $numElements)
					$textTomorrow:=$textTomorrow+"<li style=\"padding-bottom:12px;\">"+$aProductCodes{$i}+" '"+$aLines{$i}+"' to "+ADDR_getCity($aDest{$i})+"</li>"+$r
					
					uThermoUpdate($i)
				End for 
				uThermoClose
				$textTomorrow:=$textTomorrow+"</ul>\r"
			End if 
			
			If (Length:C16($textToday)>0) | (Length:C16($textTomorrow)>0)
				distribution:=Batch_GetDistributionList("Must Ship")
				//distribution:="mel.bohince@arkay.com"
				//EMAIL_Sender ("Must Ship for "+String($wait_date;System date short);"";$textToday+$textTomorrow;distribution)
				Email_html_body("Must Ship for "+String:C10($wait_date; System date short:K1:1); $preheader; $textToday+$textTomorrow; 500; distribution)
				
			End if 
			
			REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
			
			$not_sent_yet:=False:C215  //this is it for today
			
		End if   //time to run
		
		zwStatusMsg("Must Ship"; "Delaying for "+String:C10($minutes)+" minutes")
		DELAY PROCESS:C323(Current process:C322; $delay_in_seconds)  //take a nap
		
	End while 
	utl_Logfile("Must Ship.Log"; "ENDED loops:"+String:C10($loops))
End if 