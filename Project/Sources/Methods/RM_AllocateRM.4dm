//%attributes = {}

// Method: RM_AllocateRM (jobform;date;custid;rmcode;commkey;qty;uom )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 10/01/13, 13:47:32
// ----------------------------------------------------
// Description
// based on RM_AllocateSensors
//rely on the data in the JFM record
// ----------------------------------------------------

C_TEXT:C284($jobform; $1)
C_DATE:C307($dateNeeded; $2)
C_TEXT:C284($custid; $3)
C_TEXT:C284($rm_code; $comm_key; $uom; $4; $5; $7)
C_REAL:C285($qty; $6)  //[Job_Forms_Materials]Planned_Qty

$jobform:=$1
$dateNeeded:=$2
$custid:=$3
$rm_code:=$4  //[Job_Forms_Materials]Raw_Matl_Code
$comm_key:=$5  //[Job_Forms_Materials]Commodity_Key
$qty:=$6
$uom:=$7  //[Job_Forms_Materials]UOM

QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]JobForm:3=$jobform; *)
QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]commdityKey:13=$comm_key; *)
QUERY:C277([Raw_Materials_Allocations:58];  & ; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=$rm_code)
If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
	CREATE RECORD:C68([Raw_Materials_Allocations:58])
	[Raw_Materials_Allocations:58]JobForm:3:=$jobform
	[Raw_Materials_Allocations:58]zCount:10:=1
	[Raw_Materials_Allocations:58]commdityKey:13:=$comm_key
	[Raw_Materials_Allocations:58]Raw_Matl_Code:1:=$rm_code
End if 

[Raw_Materials_Allocations:58]CustID:2:=$custid
If ([Raw_Materials_Allocations:58]Date_Allocated:5=!00-00-00!)
	[Raw_Materials_Allocations:58]Date_Allocated:5:=$dateNeeded
End if 

[Raw_Materials_Allocations:58]Qty_Allocated:4:=$qty

If (Length:C16($uom)>0)
	[Raw_Materials_Allocations:58]UOM:11:=$uom
Else 
	[Raw_Materials_Allocations:58]UOM:11:="EACH"
End if 

[Raw_Materials_Allocations:58]ModDate:8:=4D_Current_date
[Raw_Materials_Allocations:58]ModWho:9:=<>zResp

SAVE RECORD:C53([Raw_Materials_Allocations:58])
UNLOAD RECORD:C212([Raw_Materials_Allocations:58])