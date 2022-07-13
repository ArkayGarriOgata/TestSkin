If (Not:C34([WMS_InternalBOLs:163]loaded:9))  //no manual override once loaded
	
	
	If ([WMS_InternalBOLs:163]canPurge:10)  //user requesting purge
		uConfirm("Prepare the eliminate this BOL?"; "Yes"; "Cancel")
		If (ok=1)
			[WMS_InternalBOLs:163]bol_number:2:="---"+Substring:C12([WMS_InternalBOLs:163]bol_number:2; 4)
			SAVE RECORD:C53([WMS_InternalBOLs:163])  //trigger_Internal_BOL
			REDRAW:C174([WMS_InternalBOLs:163]bol_number:2)
		Else 
			[WMS_InternalBOLs:163]canPurge:10:=False:C215
		End if 
		
	Else   //user changed their mind
		uConfirm("Restore this BOL?"; "Yes"; "Cancel")
		If (ok=1)
			[WMS_InternalBOLs:163]bol_number:2:="BOL"+Substring:C12([WMS_InternalBOLs:163]bol_number:2; 4)
			SAVE RECORD:C53([WMS_InternalBOLs:163])  //trigger_Internal_BOL
			REDRAW:C174([WMS_InternalBOLs:163]bol_number:2)
		Else 
			[WMS_InternalBOLs:163]canPurge:10:=True:C214
		End if 
	End if 
	
Else   //was loaded
	BEEP:C151
	[WMS_InternalBOLs:163]canPurge:10:=False:C215
End if 