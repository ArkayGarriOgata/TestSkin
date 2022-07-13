//%attributes = {}
// _______
// Method: SF_CalendarIntervalsFindTime   ( ) ->
// By: Mel Bohince @ 02/26/20, 09:42:11
// Description
// return the index of the first slot that would be a match
// then brute force your way to an available slot there or after
// see https://doc.4d.com/4Dv17/4D/17.4/collectionfindIndex.305-4883377.en.html
//C_OBJECT($1)
//C_TEXT($2)
// $1.result:=$1.value.name=$2
// ----------------------------------------------------

C_OBJECT:C1216($1)
C_LONGINT:C283($2)

$1.result:=($1.value.timeStampSeconds>=$2) & ($1.value.available=True:C214)

