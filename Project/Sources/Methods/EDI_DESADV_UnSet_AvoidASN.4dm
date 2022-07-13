//%attributes = {}
// _______
// Method: EDI_DESADV_UnSet_AvoidASN   ( ) ->
// By: Mel Bohince @ 02/25/21, 09:43:45
// Description
// set the asn field to a positive number so an asn isn't waited on or sent later
// ----------------------------------------------------

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
	zwStatusMsg("AVOID ASN"; String:C10($i)+" of "+String:C10($rel_es.length))
	If ($rel_e.ediASNmsgID<=0)
		
		
		If ($rel_e.Milestones=Null:C1517)
			$rel_e.Milestones:=New object:C1471
		End if 
		$rel_e.Milestones.skipASN:=$now_t
		$rel_e.ediASNmsgID:=999  //psuedo asn#
		$rel_e.TrackingComment:="ediASNmsgID set to 999 so ASN is avoided.\r\r"+$rel_e.TrackingComment
		$rel_e.Mode:="Shipping without TMC"
		
		$status_o:=$rel_e.save(dk auto merge:K85:24)
		If ($status_o.success)
			$reverted_es.add($rel_e)
		Else 
			$not:=$not+1
			ALERT:C41(String:C10($rel_e.ReleaseNumber)+" was not 999'd.")
		End if 
		
	Else   //not eligible
		
	End if 
End for each 

zwStatusMsg("AVOID OPN"; "Fini "+String:C10($not)+" of "+String:C10($rel_es.length)+" was not reset")

BEEP:C151

$0:=$reverted_es