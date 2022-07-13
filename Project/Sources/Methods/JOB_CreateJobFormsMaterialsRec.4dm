//%attributes = {}
// Method: JOB_CreateJobFormsMaterialsRec
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 11/07/13, 14:16:48
// ----------------------------------------------------
// ----------------------------------------------------
// Modified by: Mel Bohince (11/18/13) add comment if component, passed as optional arg 3
// Modified by: Mel Bohince (11/20/13) make it more obvious, and exclude from jobbag

C_LONGINT:C283($xlJobID; $1)
C_TEXT:C284($tRawMtlCode; $2; $3)

$xlJobID:=$1
$tRawMtlCode:=$2

CREATE RECORD:C68([Job_Forms_Materials:55])
[Job_Forms_Materials:55]JobForm:1:=String:C10($xlJobID; "00000")+"."+Substring:C12([Estimates_Materials:29]DiffFormID:1; 12; 2)
[Job_Forms_Materials:55]Sequence:3:=[Estimates_Materials:29]Sequence:12
[Job_Forms_Materials:55]ModDate:10:=4D_Current_date
[Job_Forms_Materials:55]ModWho:11:=<>zResp
[Job_Forms_Materials:55]Comments:4:=[Estimates_Materials:29]Comments:13
[Job_Forms_Materials:55]CostCenterID:2:=[Estimates_Materials:29]CostCtrID:2
[Job_Forms_Materials:55]UOM:5:=[Estimates_Materials:29]UOM:8
[Job_Forms_Materials:55]Planned_Qty:6:=[Estimates_Materials:29]Qty:9
[Job_Forms_Materials:55]Raw_Matl_Code:7:=$tRawMtlCode
[Job_Forms_Materials:55]Planned_Cost:8:=[Estimates_Materials:29]Cost:11
[Job_Forms_Materials:55]Commodity_Key:12:=[Estimates_Materials:29]Commodity_Key:6
[Job_Forms_Materials:55]Real1:17:=[Estimates_Materials:29]Real1:14  //see sSetMatlEstFlex
[Job_Forms_Materials:55]Real2:18:=[Estimates_Materials:29]Real2:15
[Job_Forms_Materials:55]Real3:19:=[Estimates_Materials:29]Real3:16
[Job_Forms_Materials:55]Real4:20:=[Estimates_Materials:29]Real4:17
[Job_Forms_Materials:55]Alpha20_2:21:=[Estimates_Materials:29]alpha20_2:18
[Job_Forms_Materials:55]Alpha20_3:22:=[Estimates_Materials:29]alpha20_3:19
If (Count parameters:C259>2)  // Modified by: Mel Bohince (11/18/13) add comment if component, passed as optional arg 3
	[Job_Forms_Materials:55]Comments:4:="Component of "+$3+", mix %: "+String:C10([Raw_Materials_Components:60]MixPercent:8; "##0.0000")+" of "+String:C10([Estimates_Materials:29]Qty:9)+" LB"
	[Job_Forms_Materials:55]Planned_Qty:6:=Round:C94([Raw_Materials_Components:60]MixPercent:8; 3)
	[Job_Forms_Materials:55]CostCenterID:2:="INX"  // Modified by: Mel Bohince (11/20/13) make it more obvious, and exclude from jobbag
End if 
SAVE RECORD:C53([Job_Forms_Materials:55])
RM_AllocationChk([Jobs:15]CustID:2)