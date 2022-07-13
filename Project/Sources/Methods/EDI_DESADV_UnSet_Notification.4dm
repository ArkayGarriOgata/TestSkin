//%attributes = {}
// _______
// Method: EDI_DESADV_UnSet_Notification   ( ) ->
// By: Mel Bohince @ 06/23/20, 13:46:44
// Description
// undo the OPN Load
// ----------------------------------------------------
// Modified by: Mel Bohince (6/26/20) test if Milestones values are set
// Modified by: Mel Bohince (1/12/21) clear the TMC EPD

C_OBJECT:C1216($rel_es; $rel_e; $status_o; $reverted_es; $0; $1)
C_TEXT:C284($now)
$now_t:=String:C10(Current date:C33; Internal date short special:K1:4)
C_LONGINT:C283($i; $not)
//
$i:=0
$not:=0

$reverted_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()
$rel_es:=$1  //ds.Customers_ReleaseSchedules.query("ediASNmsgID = :1";-1)

For each ($rel_e; $rel_es)
	//ui counter
	$i:=$i+1
	zwStatusMsg("RESET OPN"; String:C10($i)+" of "+String:C10($rel_es.length))
	If ($rel_e.ediASNmsgID=-1)
		//reset date
		$rel_e.Sched_Date:=Date:C102($rel_e.Milestones.RKD)
		$rel_e.user_date_1:=!00-00-00!  // Modified by: Mel Bohince (1/12/21) 
		//reset comment  //OPN Changed Pickup from 06/29/20 to 06/24/20 on 06/23/20  OB Is defined ( object {; property} ) -> Function result
		If (OB Is defined:C1231($rel_e.Milestones; "RKD") & OB Is defined:C1231($rel_e.Milestones; "EPD") & OB Is defined:C1231($rel_e.Milestones; "OPN"))
			$oldTrackingComment:="OPN Changed Pickup from "+$rel_e.Milestones.RKD+" to "+$rel_e.Milestones.EPD+" on "+$rel_e.Milestones.OPN+"\r\r"
			$rel_e.TrackingComment:=Replace string:C233($rel_e.TrackingComment; $oldTrackingComment; "")
		End if 
		//reset milestones
		$rel_e.Milestones:=New object:C1471("reset"; $now_t)
		//reset id status
		$rel_e.ediASNmsgID:=0
		
		$status_o:=$rel_e.save(dk auto merge:K85:24)
		If ($status_o.success)
			$reverted_es.add($rel_e)
		Else 
			$not:=$not+1
			ALERT:C41(String:C10($rel_e.ReleaseNumber)+" was not reverted.")
		End if 
		
	Else   //not eligible
		
	End if 
End for each 

zwStatusMsg("RESET OPN"; "Fini "+String:C10($not)+" of "+String:C10($rel_es.length)+" was not reset")

BEEP:C151

$0:=$reverted_es


