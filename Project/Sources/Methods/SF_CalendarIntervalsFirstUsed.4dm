//%attributes = {}
// _______
// Method: SF_CalendarIntervalsFirstUsed   ( ) ->
// By: Mel Bohince @ 03/09/20, 16:31:51
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($1)
C_LONGINT:C283($2)

$1.result:=($1.value.timeStampSeconds>=$2) & ($1.value.available=False:C215)

