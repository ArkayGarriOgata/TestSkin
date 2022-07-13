//%attributes = {}
// Method: MT_ShiftCard
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/04/14, 16:30:01
// ----------------------------------------------------
// Description
// 
//
// Parameters
// ----------------------------------------------------
// Modified by: Mel Bohince (3/18/17) crashing server, 2x increase memory, make sure empty array not used in search
// Modified by: Mel Bohince (7/6/21) init cost centers so groups work

C_TEXT:C284($1)

If (Count parameters:C259=0)
	$pid:=New process:C317("MT_ShiftCard"; <>lBigMemPart; "Shift Card"; "init")
	If (False:C215)
		MT_ShiftCard
	End if 
	
Else 
	Case of 
		: ($1="init")
			If (User in group:C338(Current user:C182; "RoleLineManager")) | (User in group:C338(Current user:C182; "DataCollection"))
				
				CostCtrInit  // Modified by: Mel Bohince (7/6/21) init cost centers so groups work
				
				READ WRITE:C146([Job_Forms_Machine_Tickets:61])
				
				REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
				
				SET MENU BAR:C67(<>defaultmenu)
				tWindowTitle:="Shift Card"
				$winRef:=OpenFormWindow(->[Job_Forms_Machine_Tickets:61]; "ShiftCard"; ->tWindowTitle; tWindowTitle)
				DIALOG:C40([Job_Forms_Machine_Tickets:61]; "ShiftCard")
				CLOSE WINDOW:C154($winRef)
				
				REDUCE SELECTION:C351([Job_Forms_Machine_Tickets:61]; 0)
				
			Else 
				utl_LogfileServer(<>zResp; "Shift Card - Access restricted")
				BEEP:C151
				ALERT:C41("Access restricted to Line Managers and Data Collection groups."; "Dang")
			End if 
			
	End case 
	
End if 
