//%attributes = {}
// _______
// Method: EDI_DESADV_PO_Notification   ( ) ->
// By: Mel Bohince @ 04/28/20, 13:50:23
// Description
// TMC sends Open PO Notification c/s needs to tag our releases that
// they have been called off
// ----------------------------------------------------
//[Customers_ReleaseSchedules]ReleaseNumber
// Added by: Mel Bohince (6/26/20) progress indicator
// Modified by: Mel Bohince (7/13/20) grab the delivery date
// Modified by: Mel Bohince (7/14/20) option to save TMC's date
// Modified by: Mel Bohince (11/12/20) save the LPD in release's userdate1
// Modified by: Mel Bohince (1/12/21) remove sk ignore empty strings option because the send blank column data sometimes
// Modified by: Mel Bohince (1/26/21) save local copy of OPN.log
// Modified by: Mel Bohince (2/25/21) remove C_BOOLEAN(updateRelSchedDate) and manual po entry
// Modified by: Mel Bohince (3/8/21) use transaction and bail if record found to be locked

C_OBJECT:C1216($rel_es; $release_e; $status_o; $rejected_es; $0)
C_COLLECTION:C1488($po_numbers_c; $columns_c)

C_TEXT:C284($row; $po; $clipboard; $beginsWith; $delimitorRow; $delimitorColumn)
$delimitorRow:="\r\n"
$delimitorColumn:="\t"

C_DATE:C307($pickUpByDate; $latestPickUp; $deliveryDate)

C_LONGINT:C283($columnWithPO; $columnWithPUbyDate; $numLocked)  //zero based collection
$columnWithPO:=0
$columnWithPUbyDate:=13-1
$columnWithLPD:=14-1
$columnWithDD:=15-1


$clipboard:=Get text from pasteboard:C524  //copied from excel, columns delimited by <tabs>, rows by <return+newline>

//convert clipboard data into a collection of rows, each concerning a different PO
$po_numbers_c:=New collection:C1472
$po_numbers_c:=Split string:C1554($clipboard; $delimitorRow; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
If (ok=1)
	
	//display ui list of changed releases at the end, so start building an es
	$rel_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()  //these are good to go
	
	//parse each row of the collection, then find and update the release of that PO
	// Modified by: Mel Bohince (1/26/21) 
	utl_LogfileServer(<>zResp; "+++ Loading OPN from clipboard+++"; "OPN.log")
	utl_Logfile("OPN_local.log"; "+++ Loading OPN from clipboard+++")
	
	C_LONGINT:C283($outerBar; $outerLoop; $out)  // Added by: Mel Bohince (6/26/20) progress indicator
	$outerBar:=Progress New  //new progress bar
	Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button
	Progress SET TITLE($outerBar; "Reading clipboard...")
	$outerLoop:=$po_numbers_c.length
	$out:=0
	
	START TRANSACTION:C239  // Modified by: Mel Bohince (3/8/21) 
	$numLocked:=0
	
	For each ($row; $po_numbers_c) While ($numLocked=0)
		
		// Modified by: Mel Bohince (1/12/21) remove sk ignore empty strings option because the send blank column data sometimes
		$columns_c:=Split string:C1554($row; $delimitorColumn; sk trim spaces:K86:2)  //sk ignore empty strings+
		If ($columns_c.length>0)
			$po:=Replace string:C233($columns_c[$columnWithPO]; "-"; ".")  //they may be using a hyphen as a delimeter
			
			$out:=$out+1
			Progress SET PROGRESS($outerBar; $out/$outerLoop)
			Progress SET MESSAGE($outerBar; "PO: "+$po+"  "+String:C10($out)+" of "+String:C10($outerLoop)+" @ "+String:C10(100*$out/$outerLoop; "###%"))
			
			If (util_isNumeric(Substring:C12($po; 1; 3)))  //($po#"PO@")  //skip the header row if it was included
				
				If ($columns_c.length>=$columnWithPUbyDate)  //Pickup date included
					$pickUpByDate:=Date:C102($columns_c[$columnWithPUbyDate])
				Else 
					$pickUpByDate:=!00-00-00!
				End if 
				
				If ($columns_c.length>=$columnWithLPD)  //Pickup date included
					$latestPickUp:=Date:C102($columns_c[$columnWithLPD])
				Else 
					$latestPickUp:=!00-00-00!
				End if 
				
				If ($columns_c.length>=$columnWithDD)  //delivery date included
					$deliveryDate:=Date:C102($columns_c[$columnWithDD])
				Else 
					$deliveryDate:=!00-00-00!
				End if 
				
				//update the release so its a ASN candidate
				$release_e:=EDI_DESADV_Set_Notification($po; $pickUpByDate; $latestPickUp; $deliveryDate; "TMC"; ->$numLocked)
				If ($release_e#Null:C1517)
					$rel_es.add($release_e)
				End if 
				
			End if   //the header row
		End if   //length>0
	End for each 
	
	Progress QUIT($outerBar)
	
	If ($numLocked=0)
		VALIDATE TRANSACTION:C240
	Else 
		CANCEL TRANSACTION:C241
		uConfirm("Because a locked record was incountered, none of the OPN's were saved."; "Try Later"; "Help")
	End if 
	
	zwStatusMsg("LOAD OPN"; String:C10($outerLoop)+" rows in the clipboard were processed marking "+String:C10($rel_es.length)+" releases as candidates for ASN")
	BEEP:C151
	//Display a list of the updated Releases
	//$thePick:=REL_PickUpList_UI ($rel_es)
	$0:=$rel_es
	
Else 
	utl_LogIt("init")
	utl_LogIt("Error occured while parsing the clipboard.")
	utl_LogIt($clipboard)
	utl_LogIt("show")
End if   //split was successful



