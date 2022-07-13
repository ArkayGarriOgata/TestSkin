//%attributes = {}
// _______
// Method: orda_action_open   ( ) ->
// By: Mel Bohince @ 08/12/19, 17:02:20
// Description
// from JPR's Invoice example
// ----------------------------------------------------

C_OBJECT:C1216($status)

$status:=Form:C1466.bins.clickedEntity.reload()
If ($status.success)
	Form:C1466.editEntity:=Form:C1466.bins.clickedEntity
	orda_util_EntityLoad(Form:C1466.editEntity; Form:C1466.objectsNames)
	Form:C1466.recordCanBeSaved:=False:C215
	//If (Form.settings.Modes.multiRecords)
	////Util_RecordInNewWindow("OPEN")
	//Else 
	FORM GOTO PAGE:C247(2)
	//End if 
	
Else 
	Case of 
		: ($status.status=dk status entity does not exist anymore:K85:23)
			ALERT:C41("Get localized string(\"Recordnotexist\")")  //$status.statusText)
			
		Else 
			ALERT:C41("Get localized string(\"unexpected problem\")")
			
	End case 
End if 
