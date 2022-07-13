//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 02/26/09, 15:58:34
// ----------------------------------------------------
// Method: RM_AllocateSensors
// ----------------------------------------------------

C_TEXT:C284($1)
C_DATE:C307($dateNeeded; $2)

$uom:="EACH"
$dateNeeded:=$2

QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=[Job_Forms_Materials:55]JobForm:1; *)  //$commodity
If (Count parameters:C259=3)  // Added by: Mark Zinke (9/30/13) 
	QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13="12@")
Else 
	QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13="09@")  // Added by: Mark Zinke (9/30/13) Cold Foil
End if 
If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
	CREATE RECORD:C68([Raw_Materials_Allocations:58])
	[Raw_Materials_Allocations:58]JobForm:3:=[Job_Forms_Materials:55]JobForm:1
	[Raw_Materials_Allocations:58]zCount:10:=1
	[Raw_Materials_Allocations:58]commdityKey:13:=[Job_Forms_Materials:55]Commodity_Key:12
Else 
	// ******* Verified  - 4D PS - January  2019 ********
	
	QUERY SELECTION:C341([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=[Job_Forms_Materials:55]Raw_Matl_Code:7)
	
	
	// ******* Verified  - 4D PS - January 2019 (end) *********
	If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
		CREATE RECORD:C68([Raw_Materials_Allocations:58])
		[Raw_Materials_Allocations:58]JobForm:3:=[Job_Forms_Materials:55]JobForm:1
		[Raw_Materials_Allocations:58]zCount:10:=1
		[Raw_Materials_Allocations:58]commdityKey:13:=[Job_Forms_Materials:55]Commodity_Key:12
	End if 
End if 
[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=[Job_Forms_Materials:55]Raw_Matl_Code:7
[Raw_Materials_Allocations:58]CustID:2:=$3
If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
	[Raw_Materials_Allocations:58]Date_Allocated:5:=$dateNeeded
End if 
[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
[Raw_Materials_Allocations:58]ModWho:9:=<>zResp

[Raw_Materials_Allocations:58]Qty_Allocated:4:=[Job_Forms_Materials:55]Planned_Qty:6
[Raw_Materials_Allocations:58]UOM:11:=$uom

SAVE RECORD:C53([Raw_Materials_Allocations:58])
UNLOAD RECORD:C212([Raw_Materials_Allocations:58])