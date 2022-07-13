//%attributes = {}
// _______
// Method: EDI_DESADV_UnSet_SentASN   (form.selected ) -> chg ent sel
// By: Mel Bohince @ 06/24/20, 15:05:37
// Description
// undo the sending of the ASN
// ----------------------------------------------------

C_OBJECT:C1216($rel_es; $rel_e; $status_o; $reverted_es; $0; $status_o; $outbox_es; $outbox_e; $1)
C_TEXT:C284($whenSent)  //$now_t
//$now_t:=String(Current date;Internal date short special)
C_LONGINT:C283($i; $not; $ediMsgId)
//
$i:=0
$not:=0
//$whenSent:=Request("What ASN date?";String(Current date;Internal date short special);"Continue";"Cancel")
$reverted_es:=ds:C1482.Customers_ReleaseSchedules.newSelection()
//if(ok=1)
$rel_es:=$1  //ds.Customers_ReleaseSchedules.query("ediASNmsgID > :1 and Milestones.ASN = :2";0;$whenSent)

For each ($rel_e; $rel_es)
	//ui counter
	$i:=$i+1
	zwStatusMsg("RESET ASN"; String:C10($i)+" of "+String:C10($rel_es.length))
	
	If ($rel_e.ediASNmsgID>0)
		//retain msg id
		$ediMsgId:=$rel_e.ediASNmsgID
		//reset id status
		$rel_e.ediASNmsgID:=-1
		
		//reset milestones
		$rel_e.Milestones.ASN:="reset"
		
		
		$status_o:=$rel_e.save(dk auto merge:K85:24)
		If ($status_o.success)
			$reverted_es.add($rel_e)
			
			$outbox_es:=ds:C1482.edi_Outbox.query("ID = :1 and SentTimeStamp < :2"; $ediMsgId; 33)  //not already sent
			If ($outbox_es.length>0)
				$outbox_e:=$outbox_es.first()
				$outbox_e.SentTimeStamp:=31
				$outbox_e.CrossReference:="Unsent"
				C_OBJECT:C1216($status_o)
				$status_o:=$outbox_e.save(dk auto merge:K85:24)
				If ($status_o.success)
					zwStatusMsg("SUCCESS"; "edi_Outbox Changes saved ")
				Else 
					zwStatusMsg("FAIL"; "edi_Outbox Changes NOT saved")
				End if 
				
			End if 
			
		Else 
			$not:=$not+1
			ALERT:C41(String:C10($rel_e.ReleaseNumber)+" was not reverted.")
		End if 
		
	Else   //not eligiable
		
	End if 
	
End for each 

zwStatusMsg("RESET ASN"; "Fini "+String:C10($not)+" of "+String:C10($rel_es.length)+" was not reset")

BEEP:C151
//End if 

$0:=$reverted_es

