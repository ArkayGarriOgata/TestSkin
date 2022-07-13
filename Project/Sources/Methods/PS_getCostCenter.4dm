//%attributes = {}

// Method: PS_getCostCenter ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/06/14, 16:10:19
// ----------------------------------------------------
// Description
// 
//
// ----------------------------------------------------

READ ONLY:C145([ProductionSchedules:110])
QUERY:C277([ProductionSchedules:110]; [ProductionSchedules:110]JobSequence:8=$1)
If (Records in selection:C76([ProductionSchedules:110])=1)
	$0:=[ProductionSchedules:110]CostCenter:1
Else 
	$0:=""
End if 
REDUCE SELECTION:C351([ProductionSchedules:110]; 0)
