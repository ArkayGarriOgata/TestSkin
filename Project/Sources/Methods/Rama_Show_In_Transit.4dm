//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/15/12, 16:06:38
// ----------------------------------------------------
// Method: Rama_Show_In_Transit
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaIT; $bin; $numBin; $winRef)

If (Count parameters:C259=0)
	If (<>pid_RamaIT=0)
		app_Log_Usage("log"; "RAMA"; "Rama_Show_In_Transit")
		<>pid_RamaIT:=New process:C317("Rama_Show_In_Transit"; <>lMinMemPart; "Rama In-Transit"; "init")
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaIT)
		BRING TO FRONT:C326(<>pid_RamaIT)
	End if 
	
Else 
	If (Rama_Find_CPNs("transit")>0)
		$winRef:=Open form window:C675([Finished_Goods_Locations:35]; "SimpleInventory"; Plain form window:K39:10)
		SET WINDOW TITLE:C213("In Transit"; $winRef)
		
		MESSAGE:C88("Please Wait, Loading Shipments...")
		Rama_Load_Inventory
		
		FORM SET INPUT:C55([Finished_Goods_Locations:35]; "SimpleInventory")
		ADD RECORD:C56([Finished_Goods_Locations:35]; *)
		CLOSE WINDOW:C154($winRef)
		FORM SET INPUT:C55([Finished_Goods_Locations:35]; "Input")
		
	Else 
		uConfirm("No shipments found."; "OK"; "Help")
	End if 
	
	<>pid_RamaIT:=0
End if 