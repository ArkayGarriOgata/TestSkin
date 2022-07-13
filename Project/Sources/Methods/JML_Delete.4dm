//%attributes = {}
// Method: JML_Delete
// Description: Called from gValidDelete in the [Job_Forms_Master_Schedule];"Input" form
// Created by: Garri Ogata
// Date and time: 09/08/21, 13:19:39

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oAsk)
	C_LONGINT:C283($nConfirmButton)
	
	$oAsk:=New object:C1471()
	
	$oAsk.tMessage:="Do you want to remove job "+[Job_Forms_Master_Schedule:67]JobForm:4+" from the schedule?"
	$oAsk.tDefault:="No"
	$oAsk.tCancel:="Yes"
	
End if   //Done initialize

If (Core_Dialog_ConfirmN($oAsk)=CoreknCancel)  //Delete
	
	COPY NAMED SELECTION:C331([Job_Forms_Master_Schedule:67]; "hold")
	DELETE RECORD:C58([Job_Forms_Master_Schedule:67])
	CANCEL:C270
	USE NAMED SELECTION:C332("hold")
	CLEAR NAMED SELECTION:C333("hold")
	
End if   //Done delete
