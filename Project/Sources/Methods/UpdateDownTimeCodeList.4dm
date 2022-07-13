//%attributes = {}
// ----------------------------------------------------
// User name: Mel Bohince
// Created: 02/23/07, 16:35:11
// ----------------------------------------------------
// Method: UpdateDownTimeCodeList()  --> 
// Description
// 
//
// ----------------------------------------------------
// Modified by Mel Bohince on 3/9/07 at 08:51:14 : fix sort order
// ----------------------------------------------------
C_LONGINT:C283($i)
MESSAGES OFF:C175
ALL RECORDS:C47([Cost_Ctr_Down_Times:139])
SELECTION TO ARRAY:C260([Cost_Ctr_Down_Times:139]DisplayOrder:3; $aId; [Cost_Ctr_Down_Times:139]DownTimeCategory:2; $List)
SORT ARRAY:C229($aId; $List; >)
uClearSelection(->[Cost_Ctr_Down_Times:139])

ARRAY TO LIST:C287($List; "Downtime")
MESSAGES ON:C181