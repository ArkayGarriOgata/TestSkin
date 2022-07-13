//%attributes = {}
// _______
// Method: ToolDrawers   ( ) ->
// By: Mel Bohince @ 06/07/19, 11:26:23
// Description
// 
// ----------------------------------------------------



C_TEXT:C284($1)

If (Count parameters:C259=0)
	<>pid_ToolDrawer:=Process number:C372("ToolDrawers")
	If (<>pid_ToolDrawer=0)  //singleton
		<>pid_ToolDrawer:=New process:C317("ToolDrawers"; <>lMidMemPart; "ToolDrawers"; "init")
		If (False:C215)
			ToolDrawers
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_ToolDrawer)
		BRING TO FRONT:C326(<>pid_ToolDrawer)
	End if 
	
Else 
	Case of 
		: ($1="init")
			zSetUsageLog(->[Tool_Drawers:151]; "1"; Current method name:C684; 0)
			SET MENU BAR:C67(<>defaultMenu)
			
			C_OBJECT:C1216($form_o)
			$form_o:=New object:C1471
			$form_o.toolDrawers:=New object:C1471
			
			$winRef:=OpenFormWindow(->[Tool_Drawers:151]; "ControlCenter")
			DIALOG:C40([Tool_Drawers:151]; "ControlCenter"; $form_o)
			CLOSE WINDOW:C154($winRef)
			<>pid_ToolDrawer:=0
	End case 
End if 