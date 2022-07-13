// -------
// Method: [zz_control].PressSchedule.PlateUse   ( ) ->
// By: Mel Bohince @ 05/30/17, 18:00:30
// Description
// Modified by: Mel Bohince (11/14/18) chg to 09u7r000 and 07q1f000
// Modified by: Mel Bohince (9/6/19) change to data based control
// Modified by: Mel Bohince (12/10/19) remove CD74 and Small since CD74 is gone
// ----------------------------------------------------

If (app_LoadIncludedSelection("init"; ->[ProductionSchedules:110]JobSequence:8)>0)
	$imode:=iMode
	iMode:=1
	$winRef:=OpenSheetWindow(->[Job_PlatingMaterialUsage:175]; "Input")
	FORM SET INPUT:C55([Job_PlatingMaterialUsage:175]; "Input")  //insure 
	FORM SET OUTPUT:C54([Job_PlatingMaterialUsage:175]; "List")
	ADD RECORD:C56([Job_PlatingMaterialUsage:175])
	CLOSE WINDOW:C154($winRef)
	If (ok=1)  //make transaction
		$pltRec:=Record number:C243([Job_PlatingMaterialUsage:175])
		UNLOAD RECORD:C212([Job_PlatingMaterialUsage:175])
		
		// Modified by: Mel Bohince (9/6/19) change to data based control
		//RMX_PlatesPost ($pltRec;"09u7r000")  //"OO8L7000")
		//RMX_PlatesPost ($pltRec;"07q1f000")  //"OKWBD000")
		//RMX_PlatesPost ($pltRec;"33-15/16x 43-1/4")
		//RMX_PlatesPost ($pltRec;"28-1/2x 31-1/4")
		//RMX_PlatesPost ($pltRec;"PH77144")
		//RMX_PlatesPost ($pltRec;"CD74")
		//RMX_PlatesPost ($pltRec;"Small")
		RMX_PlatesPost($pltRec; "XL")  //"OKWBD000")
		RMX_PlatesPost($pltRec; "Large")
		RMX_PlatesPost($pltRec; "Cyrel")
	End if 
	iMode:=$imode
	
	app_LoadIncludedSelection("clear"; ->[ProductionSchedules:110]JobSequence:8)
End if 