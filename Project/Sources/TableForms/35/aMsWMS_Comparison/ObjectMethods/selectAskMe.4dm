// _______
// Method: [Finished_Goods_Locations].aMsWMS_Comparison.selectAskMe   ( ) ->
// By: Mel Bohince @ 11/12/20, 07:03:26
// Description
// 
// ----------------------------------------------------

If (Length:C16(<>AskMeFG)>0)
	displayAskMe("New")
Else 
	uConfirm("Please select a row first."; "Ok"; "Help")
End if 
