// _______
// Method: [Job_Forms_Items].PickJobitFromList.ListBox   ( ) ->
// By: Mel Bohince @ 09/23/19, 11:52:07
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($jobit_obj)
$jobit_obj:=Form:C1466.currItem
jobitCost:=$jobit_obj.PldCostTotal

Case of 
	: (Form event code:C388=On Double Clicked:K2:5)
		ACCEPT:C269
		
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "Select"; True:C214)
End case 
