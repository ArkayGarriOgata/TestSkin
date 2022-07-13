//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 07/26/12, 11:15:16
// ----------------------------------------------------
// Method: Rama_Event_Notifier("list_box_click";source pid;cpn)
// ----------------------------------------------------

C_LONGINT:C283($2; <>AskMePID; <>pid_RamaSF; <>pid_RamaGS; <>pid_RamaIT; <>pid_RamaSI; <>pid_RamaDS)
C_TEXT:C284(<>rama_cpn; $3; $1)

Case of 
	: ($1="list_box_click")
		<>rama_cpn:=$3
		If ($2#<>pid_RamaSF) & (<>pid_RamaSF>0)  //don't call self
			POST OUTSIDE CALL:C329(<>pid_RamaSF)
		End if 
		If ($2#<>pid_RamaGS) & (<>pid_RamaGS>0)
			POST OUTSIDE CALL:C329(<>pid_RamaGS)
		End if 
		If ($2#<>pid_RamaIT) & (<>pid_RamaIT>0)
			POST OUTSIDE CALL:C329(<>pid_RamaIT)
		End if 
		If ($2#<>pid_RamaSI) & (<>pid_RamaSI>0)
			POST OUTSIDE CALL:C329(<>pid_RamaSI)
		End if 
		If ($2#<>pid_RamaDS) & (<>pid_RamaDS>0)
			POST OUTSIDE CALL:C329(<>pid_RamaDS)
		End if 
		
		If (<>AskMePID<1)
			<>AskMePID:=uProcessID("AskMe:F/G")
		End if 
		
		If (<>AskMePID>0)
			<>AskMeCust:="00199"
			<>AskMeFG:=<>rama_cpn
			POST OUTSIDE CALL:C329(<>AskMePID)
		End if 
		
End case 