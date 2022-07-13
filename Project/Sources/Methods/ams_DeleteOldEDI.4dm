//%attributes = {}
// -------
// Method: ams_DeleteOldEDI   ( ) ->
// By: Mel Bohince @ 06/14/16, 14:17:16
// Description
// 
// ----------------------------------------------------

C_DATE:C307($cutOff; $1)
$cutOff:=$1  //!04/01/01!
C_LONGINT:C283($cutOffTS)

READ WRITE:C146([edi_Inbox:154])
QUERY:C277([edi_Inbox:154]; [edi_Inbox:154]Date_Received:9<$cutOff)
util_DeleteSelection(->[edi_Inbox:154])

$cutOffTS:=TSTimeStamp($cutOff)
READ WRITE:C146([edi_Outbox:155])
QUERY:C277([edi_Outbox:155]; [edi_Outbox:155]SentTimeStamp:4<$cutOffTS)
util_DeleteSelection(->[edi_Outbox:155])
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 ams_DeleteWithoutHeaderRecord
	
	ams_DeleteWithoutHeaderRecord(->[edi_po_list:182]inbox_id:2; ->[edi_Inbox:154]ID:1)
	
Else 
	
	
	If (<>fContinue)
		
		READ ONLY:C145([edi_Inbox:154])
		ALL RECORDS:C47([edi_Inbox:154])
		READ WRITE:C146([edi_po_list:182])
		RELATE MANY SELECTION:C340([edi_po_list:182]inbox_id:2)
		CREATE SET:C116([edi_po_list:182]; "keepThese")
		ALL RECORDS:C47([edi_po_list:182])
		CREATE SET:C116([edi_po_list:182]; "allRecords")
		DIFFERENCE:C122("allRecords"; "keepThese"; "keepThese")
		USE SET:C118("keepThese")
		CLEAR SET:C117("allRecords")
		CLEAR SET:C117("keepThese")
		
		
		util_DeleteSelection(->[edi_po_list:182])
		
	End if 
	
End if   // END 4D Professional Services : January 2019 query selection
