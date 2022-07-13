//%attributes = {}
// _______
// Method: FG_AskMe_orda   ( ) ->
// By: Mel Bohince @ 09/27/19, 12:10:06
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid_:=New process:C317("FG_AskMe_orda"; <>lMidMemPart; "Ask Me 'Testing'"; "init")
	If (False:C215)
		FG_AskMe_orda
	End if 
	
Else 
	Case of 
		: ($1="init")
			zSetUsageLog(->[zz_control:1]; "1"; Current method name:C684; 0)
			//<>run_rfm:=False
			SET MENU BAR:C67(<>defaultMenu)
			$winRef:=Open form window:C675("AskMeORDA")
			DIALOG:C40("AskMeORDA")
			CLOSE WINDOW:C154($winRef)
			$pid_:=0
	End case 
End if 