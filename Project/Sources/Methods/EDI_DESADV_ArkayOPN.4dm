//%attributes = {}
// _______
// Method: EDI_DESADV_ArkayOPN   ( ) ->
// By: Mel Bohince @ 08/13/20, 09:41:59
// Description
// tag selected releases as if TMC had called off
// ----------------------------------------------------
// Modified by: Mel Bohince (1/28/21) set the TMC_EPD (user_date_1)
// Modified by: Mel Bohince (2/25/21) remove C_BOOLEAN(updateRelSchedDate)
// Modified by: Mel Bohince (3/8/21) check for locked record before beginning 

If (Form:C1466.selected.length>0)
	
	C_BOOLEAN:C305($continue)  // Modified by: Mel Bohince (3/8/21) check for locked record before beginning 
	$continue:=util_EntitySelectionLockTest(Form:C1466.selected)
	If ($continue)
		
		C_OBJECT:C1216($rel_es; $release_e; $status_o; $rejected_es; $0; $candidate_e)
		C_DATE:C307($pickUpByDate; $latestPickUp; $deliveryDate)
		//display ui list of changed releases at the end, so start building an es
		$rel_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()  //these are good to go
		//parse each row of the collection, then find and update the release of that PO
		utl_LogfileServer(<>zResp; "Open PO Notification a la Arkay"; "OPN.log")
		utl_Logfile("OPN_local.log"; "Open PO Notification a la Arkay")
		
		C_LONGINT:C283($innerBar; $innerLoop; $in; $numLocked)  //this could also be called repeativly inside the loop if the quit is also moved inside
		$innerBar:=Progress New  //new progress bar
		Progress SET BUTTON ENABLED($innerBar; False:C215)  // no stop button 
		Progress SET TITLE($innerBar; "Setting Arkay call-off")
		$in:=1
		$innerLoop:=Form:C1466.selected.length
		
		For each ($candidate_e; Form:C1466.selected)
			
			Progress SET PROGRESS($innerBar; $in/$innerLoop)  //update the thermometer
			Progress SET MESSAGE($innerBar; String:C10($in)+"/"+String:C10($innerLoop))  //optional verbose status
			$in:=$in+1
			
			$po:=$candidate_e.CustomerRefer
			$pickUpByDate:=$candidate_e.Sched_Date
			$latestPickUp:=Add to date:C393($pickUpByDate; 0; 0; 3)
			$deliveryDate:=$candidate_e.Promise_Date
			//update the release so its a ASN candidate
			$release_e:=EDI_DESADV_Set_Notification($po; $pickUpByDate; $latestPickUp; $deliveryDate; "Arkay"; ->$numLocked)
			If ($release_e#Null:C1517)
				$rel_es.add($release_e)
			End if 
			
		End for each 
		
		Progress QUIT($innerBar)  //remove the thermometer
		
		BEEP:C151
		//Display a list of the updated Releases
		//$thePick:=REL_PickUpList_UI ($rel_es)
		$0:=$rel_es
		
	Else 
		$0:=Form:C1466.selected
	End if   //locked record detected
	
Else 
	uConfirm("Please select the releases that should be considered for ASN."; "Ok"; "Help")
End if 

