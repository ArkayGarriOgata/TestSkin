//%attributes = {}
// ----------------------------------------------------
// Method: JML_setStockReceivedSheeted   ( jobform; uom) -> success
// By: Mel Bohince @ 02/23/16, 16:20:03
// Description
// set the date when direct purchase stock is received in
// ----------------------------------------------------
C_BOOLEAN:C305($success; $0; $stateChg)
C_TEXT:C284($1; $2)
$success:=False:C215

If (Read only state:C362([Job_Forms_Master_Schedule:67]))
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	$stateChg:=True:C214
Else 
	$stateChg:=False:C215
End if 

QUERY:C277([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]JobForm:4=$1)
If (Records in selection:C76([Job_Forms_Master_Schedule:67])>0)
	If (fLockNLoad(->[Job_Forms_Master_Schedule:67]))
		[Job_Forms_Master_Schedule:67]DateStockRecd:17:=4D_Current_date
		If ($2="SHT")
			[Job_Forms_Master_Schedule:67]DateStockSheeted:47:=4D_Current_date
		End if 
		
		SAVE RECORD:C53([Job_Forms_Master_Schedule:67])
		UNLOAD RECORD:C212([Job_Forms_Master_Schedule:67])
		$success:=True:C214
	End if 
End if 

If ($stateChg)
	READ ONLY:C145([Job_Forms_Master_Schedule:67])
End if 

$0:=$success
