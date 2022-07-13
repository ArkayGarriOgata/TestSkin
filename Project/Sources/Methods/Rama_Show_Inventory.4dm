//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 05/11/12, 09:07:19
// ----------------------------------------------------
// Method: Rama_Show_Inventory
// ----------------------------------------------------

C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RamaSI; $winRef)

If (Count parameters:C259=0)
	If (<>pid_RamaSI=0)
		app_Log_Usage("log"; "RAMA"; "Rama_Show_Inventory")
		<>pid_RamaSI:=New process:C317("Rama_Show_Inventory"; <>lMinMemPart; "Rama Inventory"; "init")
		
	Else 
		SHOW PROCESS:C325(<>pid_RamaSI)
		BRING TO FRONT:C326(<>pid_RamaSI)
	End if 
	
Else 
	If (Rama_Find_CPNs("inventory")>0)
		$winRef:=Open form window:C675([Finished_Goods_Locations:35]; "SimpleInventory"; Plain form window:K39:10)
		SET WINDOW TITLE:C213("XC and KILL Inventory"; $winRef)
		
		MESSAGE:C88("Please Wait, Loading Inventory...")
		Rama_Load_Inventory
		
		FORM SET INPUT:C55([Finished_Goods_Locations:35]; "SimpleInventory")
		ADD RECORD:C56([Finished_Goods_Locations:35]; *)
		CLOSE WINDOW:C154($winRef)
		FORM SET INPUT:C55([Finished_Goods_Locations:35]; "Input")
		
	Else 
		uConfirm("No inventory found."; "OK"; "Help")
	End if 
	
	<>pid_RamaSI:=0
End if 