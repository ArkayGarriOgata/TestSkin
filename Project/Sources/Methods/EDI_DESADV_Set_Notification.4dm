//%attributes = {}
// _______
// Method: EDI_DESADV_Set_Notification   ( ) ->
// By: Mel Bohince @ 04/29/20, 08:34:49
// Description
// set the flag on the release to be candidate for asn
// ----------------------------------------------------
// Modified by: Mel Bohince (6/24/20) only set to -1 if currently zero, option for Designer
// Modified by: Mel Bohince (6/26/20) don't take credit for prior setting of the ediASNmsgID
// Modified by: Mel Bohince (7/13/20) add the delivery date from the OPN
// Modified by: Mel Bohince (8/13/20) change for Arkay produced OPN, by adding 5th param to call
// Modified by: Mel Bohince (11/12/20) save LPD in UserDate1
// Modified by: Mel Bohince (1/12/21)  save EPD in UserDate1
// Modified by: Mel Bohince (1/18/21) save LPD in UserDate3
// Modified by: Mel Bohince (1/26/21) save local copy of OPN.log
// Modified by: Mel Bohince (2/23/21) log out date changes on ones already called off
// Modified by: Mel Bohince (2/25/21) reprocess if OPN dates changed and remove C_BOOLEAN(updateRelSchedDate)
// Modified by: Mel Bohince (3/3/21) add task_name to the locked message

C_OBJECT:C1216($rel_es; $release_e; $0; $status_o; $notOpen; $formObj)
$release_e:=Null:C1517
C_TEXT:C284($po; $1; $date; $5; $source)
$po:=$1
C_DATE:C307($pickUpByDate; $2; $latestPickUp; $3; $deliveryDate; $4)
C_POINTER:C301($6; $ptrLockCounter)  // Modified by: Mel Bohince (3/8/21) 


If (Count parameters:C259>1)  //from the loaded OPN spreadsheet
	$pickUpByDate:=$2
	$latestPickUp:=$3
	$deliveryDate:=$4  // Modified by: Mel Bohince (7/13/20) add the delivery date from the OPN
	$source:=$5
	$ptrLockCounter:=$6
Else   //doing the manual po entry
	$pickUpByDate:=!00-00-00!
	$latestPickUp:=!00-00-00!
	$deliveryDate:=!00-00-00!
End if 

C_BOOLEAN:C305($testing; $doNotReturnReleaseObj)
//If (Current user="Designer") // Modified by: Mel Bohince (6/24/20) only set to -1 if currently zero, option for Designer
//uConfirm ("Overwrite existing ediASNmsgID?";"No";"Overwrite")
//If (ok=1)
//$testing:=False  //option to override multiple sending 
//Else 
//$testing:=True  //override multiple sending
//End if 
//Else 
$testing:=False:C215  //override multiple sending
//End if 

//If (Position("4502243827";$po)>0)
//trace
//end if

If (Length:C16($po)>0)
	zwStatusMsg("FIND"; "Looking for Releases for PO: "+$po)
	$beginsWith:=$po+"@"
	$rel_es:=ds:C1482.Customers_ReleaseSchedules.query("CustomerRefer = :1 and OpenQty > 0"; $beginsWith)
	Case of   //working with open Releases
		: ($rel_es.length=1)  //tag it
			$release_e:=$rel_es.first()
			$status_o:=$release_e.lock()  //make sure we can save any changes
			If ($status_o.success)  //lock is granted
				// Modified by: Mel Bohince (2/25/21) reprocess if OPN dates changed
				//treat re occurrance on the OPN report differently than first time
				Case of 
					: ($release_e.ediASNmsgID=0) | ($testing)  //not already tagged, or designer doing and overwrite
						
						$release_e.ediASNmsgID:=-1
						If ($release_e.Milestones=Null:C1517)
							$release_e.Milestones:=New object:C1471
						End if 
						$release_e.Milestones.OPN:=String:C10(4D_Current_date; Internal date short special:K1:4)
						$release_e.Milestones.RKD:=String:C10($release_e.Sched_Date; Internal date short special:K1:4)
						$release_e.Milestones.RKP:=String:C10($release_e.Promise_Date; Internal date short special:K1:4)
						If ($source="TMC")  //5th param is a flag that this is an Arkay produced OPN
							$release_e.Milestones.EPD:=String:C10($pickUpByDate; Internal date short special:K1:4)
							$release_e.Milestones.LPD:=String:C10($latestPickUp; Internal date short special:K1:4)
							$release_e.Milestones.EDD:=String:C10($deliveryDate; Internal date short special:K1:4)  // Modified by: Mel Bohince (7/13/20) add the delivery date from the OPN
							$release_e.Milestones.SRC:="TMC"
						Else 
							$release_e.Milestones.SRC:="Arkay"
						End if 
						
						If ($pickUpByDate#!00-00-00!)  // Modified by: Mel Bohince (1/12/21) 
							$release_e.user_date_1:=$pickUpByDate  // Modified by: Mel Bohince (11/12/20) 
						Else 
							$release_e.user_date_1:=$release_e.Sched_Date
							$release_e.TrackingComment:="TMC EPD was blank, Arkay Sched_Date was used."+"\r\r"+$release_e.TrackingComment
						End if 
						
						If ($latestPickUp#!00-00-00!)  // Modified by: Mel Bohince (1/18/21) 
							$release_e.user_date_3:=$latestPickUp
						End if 
						
						If ($source="TMC")  //5th param is a flag that this is an Arkay produced OPN
							utl_LogfileServer(<>zResp; "PO "+$po+" EPD date changed from "+String:C10($release_e.Sched_Date; Internal date short special:K1:4)+" to "+String:C10($pickUpByDate; Internal date short special:K1:4); "OPN.log")
							utl_Logfile("OPN_local.log"; "PO "+$po+" EPD date changed from "+String:C10($release_e.Sched_Date; Internal date short special:K1:4)+" to "+String:C10($pickUpByDate; Internal date short special:K1:4))
							$release_e.TrackingComment:="OPN Set Earliest Pickup to "+String:C10($pickUpByDate; Internal date short special:K1:4)+"\r\r"+$release_e.TrackingComment
						Else 
							utl_LogfileServer(<>zResp; "PO "+$po+" set EPD to Arkay date "+String:C10($pickUpByDate; Internal date short special:K1:4); "OPN.log")
							utl_Logfile("OPN_local.log"; "PO "+$po+" set EPD to Arkay date "+String:C10($pickUpByDate; Internal date short special:K1:4))
						End if 
						
						$status_o:=$release_e.save(dk auto merge:K85:24)
						If ($status_o.success)
							zwStatusMsg("SUCCESS"; "Release "+String:C10($release_e.ReleaseNumber)+" marked for ASN submittal.")
							utl_LogfileServer(<>zResp; "PO "+$po+" SUCCESS marking for ASN"; "OPN.log")
							utl_Logfile("OPN_local.log"; "PO "+$po+" SUCCESS marking for ASN")
							
						Else 
							BEEP:C151
							zwStatusMsg("FAIL"; "Release "+String:C10($release_e.ReleaseNumber)+" could NOT be marked for ASN submittal.")
							utl_LogfileServer(<>zResp; "PO "+$po+" FAILED to mark for ASN"; "OPN.log")
							utl_Logfile("OPN_local.log"; "PO "+$po+" FAILED to mark for ASN")
						End if 
						
					: ($release_e.ediASNmsgID=-1)  // Modified by: Mel Bohince (2/25/21) reprocess if OPN dates changed
						//then update the attributes if changed
						C_BOOLEAN:C305($touched)  // Modified by: Mel Bohince (2/25/21) save if necessary
						$touched:=False:C215
						
						If ($release_e.Milestones=Null:C1517)  //so there is something to test with the if stmt
							$release_e.Milestones:=New object:C1471("EPD"; "00/00/00"; "LPD"; "00/00/00"; "EDD"; "00/00/00"; "SRC"; "reTMC")
							
						Else   // Modified by: Mel Bohince (3/9/21) check for the properties so they can be compared below
							If (Not:C34(OB Is defined:C1231($release_e.Milestones; "EPD")))
								$release_e.Milestones.EPD:="00/00/00"
							End if 
							If (Not:C34(OB Is defined:C1231($release_e.Milestones; "LPD")))
								$release_e.Milestones.LPD:="00/00/00"
							End if 
							If (Not:C34(OB Is defined:C1231($release_e.Milestones; "EDD")))
								$release_e.Milestones.EDD:="00/00/00"
							End if 
						End if 
						
						If ($pickUpByDate=!00-00-00!)  // Modified by: Mel Bohince (1/12/21) 
							$pickUpByDate:=$release_e.Sched_Date
							$release_e.TrackingComment:="TMC EPD was blank, Arkay Sched_Date will be used."+"\r\r"+$release_e.TrackingComment
						End if 
						
						If ($pickUpByDate#Date:C102($release_e.Milestones.EPD))  //update and log if changed
							$release_e.TrackingComment:="TMC EPD changed from "+$release_e.Milestones.EPD+" to "+String:C10($pickUpByDate; Internal date short special:K1:4)+" on "+String:C10(4D_Current_date; Internal date short special:K1:4)+"\r\r"+$release_e.TrackingComment
							$release_e.Milestones.EPD:=String:C10($pickUpByDate; Internal date short special:K1:4)
							$release_e.user_date_1:=$pickUpByDate
							$touched:=True:C214
						End if 
						
						If ($latestPickUp#Date:C102($release_e.Milestones.LPD))  //update and log if changed
							$release_e.TrackingComment:="TMC LPD changed from "+$release_e.Milestones.LPD+" to "+String:C10($latestPickUp; Internal date short special:K1:4)+" on "+String:C10(4D_Current_date; Internal date short special:K1:4)+"\r\r"+$release_e.TrackingComment
							$release_e.Milestones.LPD:=String:C10($latestPickUp; Internal date short special:K1:4)
							$release_e.user_date_3:=$latestPickUp
							$touched:=True:C214
						End if 
						
						If ($deliveryDate#Date:C102($release_e.Milestones.EDD))  //update and log if changed
							$release_e.TrackingComment:="TMC EDD changed from "+$release_e.Milestones.EDD+" to "+String:C10($deliveryDate; Internal date short special:K1:4)+" on "+String:C10(4D_Current_date; Internal date short special:K1:4)+"\r\r"+$release_e.TrackingComment
							$release_e.Milestones.EDD:=String:C10($deliveryDate; Internal date short special:K1:4)
							$touched:=True:C214
						End if 
						
						If ($touched)  //something changed
							$status_o:=$release_e.save(dk auto merge:K85:24)
							If ($status_o.success)
								zwStatusMsg("SUCCESS"; "Release "+String:C10($release_e.ReleaseNumber)+" updated for ASN submittal.")
								utl_LogfileServer(<>zResp; "PO "+$po+" SUCCESS updated for ASN"; "OPN.log")
								utl_Logfile("OPN_local.log"; "PO "+$po+" SUCCESS updated for ASN")
								
							Else 
								BEEP:C151
								zwStatusMsg("FAIL"; "Release "+String:C10($release_e.ReleaseNumber)+" could NOT be updated for ASN submittal.")
								utl_LogfileServer(<>zResp; "PO "+$po+" FAILED to update for ASN"; "OPN.log")
								utl_Logfile("OPN_local.log"; "PO "+$po+" FAILED to update for ASN")
							End if 
							
						Else 
							utl_LogfileServer(<>zResp; "PO "+$po+" had no change"; "OPN.log")
							utl_Logfile("OPN_local.log"; "PO "+$po+" had no change")
							$doNotReturnReleaseObj:=True:C214
						End if 
						
					Else 
						zwStatusMsg("WARNING"; "ASN has already been sent for Release "+String:C10($release_e.ReleaseNumber)+".")
						utl_LogfileServer(<>zResp; "PO "+$po+" ASN has already been sent "+String:C10($release_e.ediASNmsgID); "OPN.log")
						utl_Logfile("OPN_local.log"; "PO "+$po+" ASN has already been sent "+String:C10($release_e.ediASNmsgID))
						$doNotReturnReleaseObj:=True:C214  // Modified by: Mel Bohince (6/26/20) don't take credit for prior setting of the ediASNmsgID
				End case 
				
				$status_o:=$release_e.unlock()
				
				If ($doNotReturnReleaseObj)  //do not want it displayed in listing of releases that were updated, but make sure it gets unlocked
					$release_e:=Null:C1517
				End if 
				
				
			Else   //can't get the lock
				If ($status_o.status=dk status locked:K85:21)  // Modified by: Mel Bohince (12/8/20) 
					utl_LogfileServer(<>zResp; "PO "+$po+" locked by "+$status_o.lockInfo.user_name+" process:"+$status_o.lockInfo.task_name+" update failed"; "OPN.log")
					utl_Logfile("OPN_local.log"; "PO "+$po+" locked by "+$status_o.lockInfo.user_name+" process:"+$status_o.lockInfo.task_name+" update failed")
					$formObj:=$status_o.lockInfo
					$formObj.button:="Try Later"
					$formObj.message:="CPN: "+$release_e.ProductCode+"\rPO: "+$release_e.CustomerRefer
					util_EntityLocked($formObj)
					$ptrLockCounter->:=$ptrLockCounter->+1
					
				Else 
					utl_LogfileServer(<>zResp; "PO "+$po+" locked "+$status_o.statusText+" update failed"; "OPN.log")
					utl_Logfile("OPN_local.log"; "PO "+$po+" locked "+$status_o.statusText+" update failed")
					$formObj:=$status_o.lockInfo
					$formObj.button:="Try Later"
					$formObj.message:="CPN: "+$release_e.ProductCode+"\rPO: "+$release_e.CustomerRefer
					util_EntityLocked($formObj)
					$ptrLockCounter->:=$ptrLockCounter->+1
				End if 
				
			End if   //locked
			
			
		: ($rel_es.length>1)  //display a list
			utl_LogfileServer(<>zResp; "PO "+$po+" multiple releases found, not changed"; "OPN.log")
			utl_Logfile("OPN_local.log"; "PO "+$po+" multiple releases found, not changed")
			
		Else   //check in releases that may have shipped
			
			$notOpen:=ds:C1482.Customers_ReleaseSchedules.query("CustomerRefer = :1"; $beginsWith)
			Case of 
				: ($notOpen.length=1)
					$date:=String:C10($notOpen.first().Actual_Date; Internal date short special:K1:4)
					utl_LogfileServer(<>zResp; "PO "+$po+" was found to have shipped on "+$date; "OPN.log")
					utl_Logfile("OPN_local.log"; "PO "+$po+" was found to have shipped on "+$date)
				: ($notOpen.length>1)
					utl_LogfileServer(<>zResp; "PO "+$po+" multiple shipped releases found"; "OPN.log")
					utl_Logfile("OPN_local.log"; "PO "+$po+" multiple shipped releases found")
				Else 
					utl_LogfileServer(<>zResp; "No PO was found begining with "+$po; "OPN.log")
					utl_Logfile("OPN_local.log"; "No PO was found begining with "+$po)
			End case 
			
	End case 
	
Else 
	uConfirm("Please enter a PO or click Done."; "Try again"; "Done")
End if 

$0:=$release_e
