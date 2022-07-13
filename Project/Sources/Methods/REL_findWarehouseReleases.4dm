//%attributes = {}
// Method: REL_findWarehouseReleases () -> 
// ----------------------------------------------------
// by: mel: 04/28/04, 15:59:58
// ----------------------------------------------------
// Description:
// find releases against JIT warehouse items
// ----------------------------------------------------

C_LONGINT:C283($1)
C_TEXT:C284($2)

READ ONLY:C145([Finished_Goods:26])
QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]WarehouseProgram:75=True:C214)
zwStatusMsg("Warehouse"; String:C10(Records in selection:C76([Customers_ReleaseSchedules:46]))+" F/G items reviewed")
RELATE MANY SELECTION:C340([Customers_ReleaseSchedules:46]ProductCode:11)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
	//SET WINDOW TITLE(String(Records in selection([ReleaseSchedule]))+" F/G Releases (Warehouse Program)")
	
	If (Count parameters:C259=1)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0)
		//SET WINDOW TITLE(String(Records in selection([ReleaseSchedule]))+" Open F/G Releases (Warehouse Program)")
	End if 
	
Else 
	
	If (Count parameters:C259=1)
		QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	End if 
	
	QUERY SELECTION:C341([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5#!00-00-00!)
	
End if   // END 4D Professional Services : January 2019 query selection
