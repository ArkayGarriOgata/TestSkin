// _______
// Method: [Customers_ReleaseSchedules].ShipMgmt.memberCopy   ( ) ->
// By: Mel Bohince @ 06/10/20, 08:19:42
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($releaseNumber)

If (Form:C1466.position>0)
	$releaseNumber:=String:C10(Form:C1466.editEntity.ReleaseNumber)
	SET TEXT TO PASTEBOARD:C523($releaseNumber)
	zwStatusMsg("COPIED"; "Release Number "+$releaseNumber+" is ready to Paste")
	
Else 
	uConfirm("Select a Release to copy/paste."; "Ok"; "Help")
End if 
