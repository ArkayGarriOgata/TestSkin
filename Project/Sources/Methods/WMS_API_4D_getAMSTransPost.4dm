//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: WMS_API_4D_getAMSTransPost() - Created v0.1.0-JJG (05/16/16)
// Modified by: Mel Bohince (10/21/16) do type conversion on transaction time
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_LONGINT:C283($1; $xlNumElements; $i)
C_POINTER:C301($2; $3; $psdPost; $pst1PostTime; $4; $5; $psTransTime; $ptTransTime)
C_DATE:C307($dPost)
C_TEXT:C284($ttPostTime)
$xlNumElements:=$1
$psdPost:=$2
$pst1PostTime:=$3
$psTransTime:=$4  // Modified by: Mel Bohince (10/21/16)
$ptTransTime:=$5  // Modified by: Mel Bohince (10/21/16)
$dPost:=4D_Current_date
$ttPostTime:=String:C10(4d_Current_time; HH MM SS:K7:1)

ARRAY DATE:C224($psdPost->; $xlNumElements)
ARRAY TEXT:C222($pst1PostTime->; $xlNumElements)
ARRAY TEXT:C222($psTransTime->; $xlNumElements)  // Modified by: Mel Bohince (10/21/16)
For ($i; 1; $xlNumElements)
	$psdPost->{$i}:=$dPost
	$pst1PostTime->{$i}:=$ttPostTime
	$psTransTime->{$i}:=Time string:C180($ptTransTime->{$i})  // Modified by: Mel Bohince (10/21/16) 
End for 