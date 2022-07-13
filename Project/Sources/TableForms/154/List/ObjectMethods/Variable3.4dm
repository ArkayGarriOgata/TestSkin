//Object Method: bdel 
uConfirm("Delete all reports and logs?"; "Delete"; "Cancel")
If (ok=1)
	CUT NAMED SELECTION:C334([edi_Inbox:154]; "beforeDelete")
	READ WRITE:C146([edi_Inbox:154])
	QUERY:C277([edi_Inbox:154]; [edi_Inbox:154]ICN:4="Log@"; *)
	QUERY:C277([edi_Inbox:154];  | ; [edi_Inbox:154]ICN:4="Rpt@"; *)
	QUERY:C277([edi_Inbox:154];  | ; [edi_Inbox:154]ICN:4="Sess@")
	DELETE SELECTION:C66([edi_Inbox:154])
	USE NAMED SELECTION:C332("beforeDelete")
End if 
