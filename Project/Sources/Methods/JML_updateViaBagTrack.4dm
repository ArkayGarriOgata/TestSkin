//%attributes = {"publishedWeb":true}
//PM: JML_updateViaBagTrack(job;location) -> 
//@author mlb - 4/10/02  14:53

C_TEXT:C284($1)
C_TEXT:C284($2)
C_BOOLEAN:C305($wasSet; $wasSet2)

$wasSet:=False:C215
$wasSet2:=False:C215

If (Length:C16($1)=8)
	Case of 
		: ($2="Diane Altizer")
			READ WRITE:C146([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
			If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagReceived:48; 4D_Current_date)
			End if 
		: ($2="Roa Plateroom")
			READ WRITE:C146([Job_Forms_Master_Schedule:67])
			QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
			If (Records in selection:C76([Job_Forms_Master_Schedule:67])=1)
				$wasSet:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagReceived:48; 4D_Current_date)
				$wasSet2:=util_setDateIfNull(->[Job_Forms_Master_Schedule:67]DateBagApproved:49; 4D_Current_date)
			End if 
	End case 
	
	If ($wasSet) | ($wasSet2)
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
	End if 
	REDUCE SELECTION:C351([Job_Forms_Master_Schedule:67]; 0)
End if 