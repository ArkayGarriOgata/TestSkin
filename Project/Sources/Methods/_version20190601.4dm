//%attributes = {}
// _______
// Method: _version20190601   ( ) ->
// By: Mel Bohince @ 05/30/19, 12:20:03
// Description
// prim the MRO db
// ----------------------------------------------------

READ WRITE:C146([Raw_Materials:21])

ALL RECORDS:C47([Raw_Materials:21])
APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]PreferedBin:37:="")
APPLY TO SELECTION:C70([Raw_Materials:21]; [Raw_Materials:21]Stocked:5:=False:C215)
UNLOAD RECORD:C212([Raw_Materials:21])

CREATE RECORD:C68([MaintRepairSupply_Bins:161])
[MaintRepairSupply_Bins:161]Bin:2:="ToPutAway"
[MaintRepairSupply_Bins:161]PartNumber:3:="Miscellaneous"
SAVE RECORD:C53([MaintRepairSupply_Bins:161])

For ($i; 1; 10)
	CREATE RECORD:C68([MaintRepairSupply_Bins:161])
	[MaintRepairSupply_Bins:161]Bin:2:="D0103-"+String:C10($i; "00")
	SAVE RECORD:C53([MaintRepairSupply_Bins:161])
End for 

For ($i; 1; 10)
	CREATE RECORD:C68([MaintRepairSupply_Bins:161])
	[MaintRepairSupply_Bins:161]Bin:2:="D0104-"+String:C10($i; "00")
	SAVE RECORD:C53([MaintRepairSupply_Bins:161])
End for 

For ($i; 1; 10)
	CREATE RECORD:C68([MaintRepairSupply_Bins:161])
	[MaintRepairSupply_Bins:161]Bin:2:="D0105-"+String:C10($i; "00")
	SAVE RECORD:C53([MaintRepairSupply_Bins:161])
End for 

UNLOAD RECORD:C212([MaintRepairSupply_Bins:161])