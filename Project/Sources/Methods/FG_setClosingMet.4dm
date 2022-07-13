//%attributes = {}

// ----------------------------------------------------
// User name (OS): Mel Bohince
// Date and time: 06/11/15, 14:00:41
// ----------------------------------------------------
// Method: FG_setClosingMet
// Description
// make sure all closings met, such as after an item already shipped
// assumes your sitting on a f/g record, like trigger_FinishedGoods, or in an apply to selection
// ----------------------------------------------------


If (Count parameters:C259=1)
	$date:=$1
Else 
	$date:=Current date:C33
End if 


//Stuff for Final Art Approved
util_setDateIfNull(->[Finished_Goods:26]DateArtApproved:46; $date)

//Stuff for Final Tooling Approved
util_setDateIfNull(->[Finished_Goods:26]DateSnS_Approved:83; $date)
util_setDateIfNull(->[Finished_Goods:26]DateColorApproved:86; $date)
util_setDateIfNull(->[Finished_Goods:26]DateSpecApproved:89; $date)
