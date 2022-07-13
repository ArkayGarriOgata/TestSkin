//%attributes = {}
//util_FloatingAlert(msg)
C_TEXT:C284($1; xText; <>FloatingAlert)
C_LONGINT:C283(<>FloatingAlert_PID; $winRef)

Case of 
	: (Count parameters:C259=0)
		SET MENU BAR:C67(<>DefaultMenu)
		$winRef:=Open form window:C675([zz_control:1]; "FloatingAlert"; Palette form window:K39:9; On the right:K39:3; At the top:K39:5)
		DIALOG:C40([zz_control:1]; "FloatingAlert")
		CLOSE WINDOW:C154($winRef)
		<>FloatingAlert_PID:=0
		
	: (<>FloatingAlert_PID#0)
		<>FloatingAlert:=$1
		//BEEP
		POST OUTSIDE CALL:C329(<>FloatingAlert_PID)
		
	Else 
		<>FloatingAlert:=$1
		<>FloatingAlert_PID:=New process:C317("util_FloatingAlert"; <>lMinMemPart; "$FloatingAlert")
		If (False:C215)
			util_FloatingAlert
		End if 
End case 