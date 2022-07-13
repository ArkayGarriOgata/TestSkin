//%attributes = {}
// _______
// Method: EDI_DESADV_BookingConf_clipboar   ( ) ->
// By: Mel Bohince @ 07/16/20, 08:16:01
// Description
// sets $release_e.Mode:=$mode+"-"+$loadNumber and .Expedite:=$carrier and 
//  .Milestones.IBD:=String(Current date... and .Milestones.Carrier:=$carrier
// ----------------------------------------------------
// Modified by: Mel Bohince (7/17/20) option to allow overwrites
// Modified by: Mel Bohince (7/21/20) pass the mode off to the BOL
// Modified by: Mel Bohince (2/10/21) make adjustments for new report version "EsteeLauderNAIBDCreationAlertBot_Past48Hours - Arkay - 2021-02-09T220456.276Z.xlxs"
// Modified by: Mel Bohince (2/12/21) tweek load and mode
// Modified by: Mel Bohince (3/30/21) check for locked records

C_OBJECT:C1216($rel_es; $release_e; $status_o; $rejected_es; $relWithMode_es; $notOpen)
C_TEXT:C284($mode; $loadNumber)
C_BOOLEAN:C305($allowRevisions)
//uConfirm ("Allow mode/carrier overwrite?";"No";"Yes")
//If (ok=1)
//$allowRevisions:=False
//Else 
$allowRevisions:=True:C214
//End if 

C_COLLECTION:C1488($po_numbers_c; $columns_c)

C_TEXT:C284($row; $po; $clipboard; $beginsWith; $delimitorRow; $delimitorColumn)
$delimitorRow:="\r\n"
$delimitorColumn:="\t"


$clipboard:=Get text from pasteboard:C524  //copied from excel, columns delimited by <tabs>, rows by <return+newline>

// Added by: Mel Bohince (1/14/21) defaults as of Jan 13
//$columnWithStatus:=2
//$columnWithPO:=3
//$columnWithMode:=5
//$columnWithLoad:=1
//$columnWithCarrier:=26
// Modified by: Mel Bohince (2/10/21) new columns
$columnWithStatus:=9
$columnWithPO:=3
$columnWithMode:=10
$columnWithLoad:=8
$columnWithCarrier:=11

//remove these when TMC finalizes the report
//$columnWithStatus:=Num(Request("Column containing Status:";String($columnWithStatus)))
//$columnWithPO:=Num(Request("Column containing PO:";String($columnWithPO)))
//$columnWithMode:=Num(Request("Column containing mode:";String($columnWithMode)))
//$columnWithLoad:=Num(Request("Column containing load number:";String($columnWithLoad)))
//$columnWithCarrier:=Num(Request("Column containing carrier:";String($columnWithCarrier)))
//waiting finalization

//subtract 1 because collections first element starts with 0
$columnWithStatus:=$columnWithStatus-1
$columnWithPO:=$columnWithPO-1
$columnWithMode:=$columnWithMode-1
$columnWithLoad:=$columnWithLoad-1
$columnWithCarrier:=$columnWithCarrier-1

//convert clipboard data into a collection of rows, each concerning a different PO
$po_numbers_c:=New collection:C1472
$po_numbers_c:=Split string:C1554($clipboard; $delimitorRow; sk ignore empty strings:K86:1+sk trim spaces:K86:2)
If (ok=1)
	
	//display ui list of changed releases at the end, so start building an es
	$relWithMode_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()  //these are good to go
	
	//parse each row of the collection, then find and update the release of that PO
	utl_LogfileServer(<>zResp; "Inbound delivery being loaded"; "IBD.log")
	
	C_LONGINT:C283($outerBar; $outerLoop; $out; $numLocked)  // Added by: Mel Bohince (6/26/20) progress indicator
	$outerBar:=Progress New  //new progress bar
	Progress SET BUTTON ENABLED($outerBar; True:C214)  // stop button
	Progress SET TITLE($outerBar; "Reading clipboard...")
	$outerLoop:=$po_numbers_c.length
	$out:=0
	
	START TRANSACTION:C239  // Modified by: Mel Bohince (3/30/21) check for locked records
	$numLocked:=0
	
	For each ($row; $po_numbers_c)
		
		$columns_c:=Split string:C1554($row; $delimitorColumn; sk trim spaces:K86:2)  //sk ignore empty strings+
		If ($columns_c.length>0)
			$po:=Replace string:C233($columns_c[$columnWithPO]; "-"; ".")  //they may be using a hyphen as a delimeter
			// Modified by: Mel Bohince (2/10/21) they added spaces
			$po:=Replace string:C233($po; " "; "")  //they may be adding spaces
			
			$out:=$out+1
			Progress SET PROGRESS($outerBar; $out/$outerLoop)
			Progress SET MESSAGE($outerBar; "PO: "+$po+"  "+String:C10($out)+" of "+String:C10($outerLoop)+" @ "+String:C10(100*$out/$outerLoop; "###%"))
			
			If ($po#"PO@")  //skip the header row if it was included
				
				If ($columns_c[$columnWithStatus]="Booked") | ($columns_c[$columnWithStatus]="Air Freight Pending")  //if ordered it doesn't have a load number AND carrier, so skip
					If ($columns_c.length>=$columnWithMode)  //Pickup date included
						$mode:=$columns_c[$columnWithMode]
					Else 
						$mode:=""
					End if 
					// Modified by: Mel Bohince (2/10/21) they changed to "LTL Transportation"
					Case of 
						: (Position:C15("LTL"; $mode)>0)  //Less Than Load, not helpful, practiaclly everything is LTL
							$mode:=""
							// Modified by: Mel Bohince (2/12/21) 
						: (Position:C15("Air"; $mode)>0)  //Domestic Air Transportation, not helpful, shorten
							$mode:="Air"
							
						: (Position:C15("Parcel"; $mode)>0)  //Small Parcel, not helpful, shorten
							$mode:="Parcel"
							
					End case 
					
					
					If ($columns_c.length>=$columnWithLoad)  //Pickup date included
						$loadNumber:=$columns_c[$columnWithLoad]
					Else 
						$loadNumber:=""
					End if 
					
					If ($columns_c.length>=$columnWithCarrier)  //Pickup date included
						$carrier:=$columns_c[$columnWithCarrier]
					Else 
						$carrier:=""
					End if 
					
					//update the release so with its booking confirmation
					
					$beginsWith:=$po+"@"
					$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("CustomerRefer = :1 and OpenQty > 0"; $beginsWith)
					Case of 
						: ($rel_es.length=1)  //tag it
							$release_e:=$rel_es.first()
							
							$status_o:=$release_e.lock()  // Modified by: Mel Bohince (3/30/21)//make sure we can save any changes
							If ($status_o.success)  //lock is granted
								
								//If ($release_e.Mode="") | ($allowRevisions)  //not already tagged, or designer doing and overwrite
								//$release_e:=Null  // Modified by: Mel Bohince (6/26/20) don't take credit for prior setting of the ediASNmsgID
								//zwStatusMsg ("WARNING";"Mode has already been sent for Release "+String($release_e.ReleaseNumber)+".")
								//utl_LogfileServer (<>zResp;"PO "+$po+" Mode has already been set";"IBD.log")
								If (Length:C16($loadNumber)>1)  // Modified by: Mel Bohince (2/12/21) 
									$loadNumber:=" TMC#"+$loadNumber
								End if   //received a load#
								
								If (IBD_Append_b)  // Modified by: Mel Bohince (1/9/21) 
									$release_e.Mode:=$release_e.Mode+" "+$mode+$loadNumber
									
								Else 
									$release_e.Mode:=$mode+$loadNumber
								End if 
								
								If ($release_e.Milestones=Null:C1517)
									$release_e.Milestones:=New object:C1471
								End if 
								$release_e.Milestones.IBD:=String:C10(Current date:C33; Internal date short special:K1:4)
								$release_e.Milestones.Carrier:=$carrier
								
								$release_e.Expedite:=$carrier  //this can replace consolidation, which is already in Milestones
								
								// Modified by: Mel Bohince (7/21/20) pass the mode off to the BOL
								$release_e.RemarkLine2:=$loadNumber  //get the number
								$release_e.RemarkLine1:=$mode
								
								$status_o:=$release_e.save(dk auto merge:K85:24)
								If ($status_o.success)
									zwStatusMsg("SUCCESS"; "Release "+String:C10($release_e.ReleaseNumber)+" mode applied.")
									//utl_LogfileServer (<>zResp;"PO "+$po+" SUCCESS marking for ASN";"OPN.log")
									
								Else 
									BEEP:C151
									zwStatusMsg("FAIL"; "Release "+String:C10($release_e.ReleaseNumber)+" could NOT set mode.")
									utl_LogfileServer(<>zResp; "PO "+$po+" FAILED to set mode"; "IBD.log")
								End if 
								
								$status_o:=$release_e.unlock()
								
							Else   //can't get the lock
								If ($status_o.status=dk status locked:K85:21)  // Modified by: Mel Bohince (12/8/20) 
									utl_LogfileServer(<>zResp; "PO "+$po+" locked by "+$status_o.lockInfo.user_name+" process:"+$status_o.lockInfo.task_name+" update failed"; "OPN.log")
									utl_Logfile("OPN_local.log"; "PO "+$po+" locked by "+$status_o.lockInfo.user_name+" process:"+$status_o.lockInfo.task_name+" update failed")
									$formObj:=$status_o.lockInfo
									$formObj.button:="Try Later"
									$formObj.message:="CPN: "+$release_e.ProductCode+"\rPO: "+$release_e.CustomerRefer
									util_EntityLocked($formObj)
									$numLocked:=$numLocked+1
									
								Else 
									utl_LogfileServer(<>zResp; "PO "+$po+" locked "+$status_o.statusText+" update failed"; "OPN.log")
									utl_Logfile("OPN_local.log"; "PO "+$po+" locked "+$status_o.statusText+" update failed")
									$formObj:=$status_o.lockInfo
									$formObj.button:="Try Later"
									$formObj.message:="CPN: "+$release_e.ProductCode+"\rPO: "+$release_e.CustomerRefer
									util_EntityLocked($formObj)
									$numLocked:=$numLocked+1
								End if 
								
							End if   //locked
						: ($rel_es.length>1)  //display a list
							utl_LogfileServer(<>zResp; "PO "+$po+" multiple releases found"; "IBD.log")
							$release_e:=Null:C1517
							
						Else 
							$release_e:=Null:C1517
							$notOpen:=ds:C1482.Customers_ReleaseSchedules.query("CustomerRefer = :1"; $beginsWith)
							Case of 
								: ($notOpen.length=1)
									$date:=String:C10($notOpen.first().Actual_Date; Internal date short special:K1:4)
									utl_LogfileServer(<>zResp; "PO "+$po+" was found to have shipped on "+$date; "IBD.log")
								: ($notOpen.length>1)
									utl_LogfileServer(<>zResp; "PO "+$po+" multiple closed releases found"; "IBD.log")
								Else 
									utl_LogfileServer(<>zResp; "No PO was found begining with "+$po; "IBD.log")
							End case 
							
					End case 
					
					/////////////////////////
					//$release_e:=EDI_DESADV_Set_Notification ($po;$pickUpByDate;$latestPickUp;$deliveryDate)
					If ($release_e#Null:C1517)
						$relWithMode_es.add($release_e)
					End if 
					
				End if   //booked
			End if   //the header row
		End if   //length>0
		
	End for each 
	
	Progress QUIT($outerBar)
	
	If ($numLocked=0)
		VALIDATE TRANSACTION:C240
	Else 
		CANCEL TRANSACTION:C241
		uConfirm("Because a locked record was incountered, none of the IBD's were saved."; "Try Later"; "Help")
	End if 
	
	zwStatusMsg("LOAD IBD"; String:C10($outerLoop)+" rows in the clipboard were processed marking "+String:C10($rel_es.length)+" releases booked for shipment")
	BEEP:C151
	//Display a list of the updated Releases
	//$thePick:=REL_PickUpList_UI ($rel_es)
	//$0:=$rel_es
	Form:C1466.listBoxEntities:=$relWithMode_es
	Form:C1466.message:="PO's given Mode by TMC"
	asQueryTypes{0}:="Quick search..."
	
	OBJECT SET ENABLED:C1123(*; "select@"; False:C215)
	Release_ShipMgmt_calcFooters
	
Else 
	utl_LogIt("init")
	utl_LogIt("Error occured while parsing the clipboard.")
	utl_LogIt($clipboard)
	utl_LogIt("show")
End if   //split was successful