// _______
// Method: [zz_control].eBag_dio.load_move   ( ) ->
// By: Mel Bohince @ 05/01/19, 15:29:56
// Description
// 
// ----------------------------------------------------
// Modified by: MelvinBohince (5/12/22) chg 'use' to 'move' and don't require being on a operations page

//$tabNumber:=Selected list items(ieBagTabs)
//GET LIST ITEM(ieBagTabs;$tabNumber;$itemRef;$itemText)
//If ($itemRef>=0)
Job_LoadLabel("move"; sCriterion1)

//Else 
//uConfirm ("Go to operation's page on the eBag first.";"Ok";"Cancel")
//End if 