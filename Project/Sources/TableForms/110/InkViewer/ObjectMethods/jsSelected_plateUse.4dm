// _______
// Method: [ProductionSchedules].PrePressViewer.plateUse_BTL   ( ) ->
// By: MelvinBohince @ 03/02/22, 09:22:11
// Description
// 
// ----------------------------------------------------

If (Length:C16(Form:C1466.activeJobSequence_t)=12)  //12345.78.012
	
	//[Job_PlatingMaterialUsage] assumes that we're have a [ProductionSchedules] loaded for edit
	READ WRITE:C146([ProductionSchedules:110])
	QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=Form:C1466.activeJobSequence_t)
	
	iMode:=1
	$winRef:=OpenSheetWindow(->[Job_PlatingMaterialUsage:175]; "Input")
	FORM SET INPUT:C55([Job_PlatingMaterialUsage:175]; "Input")  //insure 
	FORM SET OUTPUT:C54([Job_PlatingMaterialUsage:175]; "List")
	ADD RECORD:C56([Job_PlatingMaterialUsage:175])
	CLOSE WINDOW:C154($winRef)
	If (ok=1)  //make transaction
		$pltRec:=Record number:C243([Job_PlatingMaterialUsage:175])
		UNLOAD RECORD:C212([Job_PlatingMaterialUsage:175])
		
		RMX_PlatesPost($pltRec; "XL")  //"OKWBD000")
		RMX_PlatesPost($pltRec; "Large")
		RMX_PlatesPost($pltRec; "Cyrel")
	End if 
	
	REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
	READ ONLY:C145([ProductionSchedules:110])
	
	PS_PrePressRefreshLBs
	
Else   //btn is disabled, this shouldn't happen
	ALERT:C41("Select a JobSequence first."; "Ok")
End if 