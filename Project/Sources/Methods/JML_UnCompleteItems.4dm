//%attributes = {}
// -------
// Method: JML_UnCompleteItems   ( ) ->
// By: Mel Bohince @ 03/06/18, 14:59:39
// Description
// instead of running 3 applies to seleciton
// ----------------------------------------------------
//set qty to zero so trigger doesn't change the item back to completed
[Job_Forms_Items:44]Qty_Actual:11:=0

[Job_Forms_Items:44]Completed:39:=!00-00-00!
[Job_Forms_Items:44]CompletedTimeStamp:56:=0