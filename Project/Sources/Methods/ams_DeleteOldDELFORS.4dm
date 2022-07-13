//%attributes = {}

// Method: ams_DeleteOldDELFORS ( )  -> 
// ----------------------------------------------------
// Author: Mel Bohince
// Created: 06/19/14, 08:30:13
// ----------------------------------------------------
// Description
// only need to keep a years worth, can't claim older than that
// avoid the PnG ones as they take care of them selves and the "AS_OF" is a different formate
// ----------------------------------------------------
// Modified by: Mel Bohince (6/15/16) keep more

C_DATE:C307($yearAgo; $1)
C_LONGINT:C283($days)
C_TEXT:C284($cutoff)

$days:=(Day of:C23(Current date:C33)-1)*-1

$yearAgo:=$1  //Add to date(Current date;-1;-1;$days)

$cutoff:=String:C10(Year of:C25($yearAgo); "0000")+String:C10(Month of:C24($yearAgo); "00")+String:C10(Day of:C23($yearAgo); "00")

READ WRITE:C146([Finished_Goods_DeliveryForcasts:145])
QUERY:C277([Finished_Goods_DeliveryForcasts:145]; [Finished_Goods_DeliveryForcasts:145]Custid:12#"00199"; *)
QUERY:C277([Finished_Goods_DeliveryForcasts:145];  & ; [Finished_Goods_DeliveryForcasts:145]asOf:9<$cutoff)

util_DeleteSelection(->[Finished_Goods_DeliveryForcasts:145])
