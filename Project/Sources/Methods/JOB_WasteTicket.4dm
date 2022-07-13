//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 02/08/06, 09:51:23
// ----------------------------------------------------
// Method: JOB_WasteTicket
// Description
// record production waste
// ----------------------------------------------------

C_TEXT:C284($1)

Case of 
	: (Count parameters:C259=0)
		$pid:=New process:C317("JOB_WasteTicket"; <>lMinMemPart; "Job Waste Ticket"; "init")
		If (False:C215)
			JOB_WasteTicket
		End if 
		
	: (Count parameters:C259=1)
		SET MENU BAR:C67(<>DefaultMenu)
		READ WRITE:C146([Raw_Materials_Transactions:23])
		READ ONLY:C145([Job_Forms:42])
		READ ONLY:C145([Job_Forms_Machines:43])
		READ ONLY:C145([Cost_Centers:27])
		READ ONLY:C145([Jobs:15])
		
		$winRef:=OpenFormWindow(->[Raw_Materials_Transactions:23]; "WasteTicket_dio")
		FORM SET INPUT:C55([Raw_Materials_Transactions:23]; "WasteTicket_dio")
		Repeat 
			ADD RECORD:C56([Raw_Materials_Transactions:23]; *)
			If (OK=1)
				zwStatusMsg("WASTE"; "Defect recorded.")
			End if 
		Until (OK=0)
		
		REDUCE SELECTION:C351([Raw_Materials_Transactions:23]; 0)
		REDUCE SELECTION:C351([Job_Forms:42]; 0)
		REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)
		REDUCE SELECTION:C351([Cost_Centers:27]; 0)
		REDUCE SELECTION:C351([Jobs:15]; 0)
		
		zwStatusMsg("WASTE"; "Done.")
		CLOSE WINDOW:C154($winRef)
		
End case 