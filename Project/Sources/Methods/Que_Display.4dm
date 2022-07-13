//%attributes = {}
// -------
// Method: Que_Display   ( ) ->
// By: Mel Bohince @ 06/09/17, 09:15:57
// Description
// show whats waiting
// ----------------------------------------------------

C_TEXT:C284($1; $displayList)
C_LONGINT:C283($event)

If (Count parameters:C259>0)
	SORT ARRAY:C229(<>aScheduled; <>aScheduledCallback; <>aScheduledUUID; <>aScheduledContext; <>aScheduledParams; >)
End if 
$displayList:="Event Queue:\r"
For ($event; 1; Size of array:C274(<>aScheduled))
	$displayList:=$displayList+TS2String(<>aScheduled{$event})+" "+<>aScheduledCallback{$event}+"("+<>aScheduledParams{$event}+")\r"
End for 
util_FloatingAlert($displayList)
