//%attributes = {"publishedWeb":true}
//fCalcStdWaste()   -JML  8/4/93, 3/25/94
//used by fCalc...() Procedures- standard method for calclating waste.
//mod 3/23/94 upr1043a change min waste to apply to running component, not total

C_LONGINT:C283($Waste; $Net; $0; $1)

$Net:=$1
$waste:=0

Case of 
	: ($net<=[Cost_Centers:27]WA_running1to:19)
		$waste:=$waste+($net*([Cost_Centers:27]WA_running1:20/100))
	: ($net<=[Cost_Centers:27]WA_running2to:21)
		$waste:=$waste+($net*([Cost_Centers:27]WA_running2:22/100))
	: ($net<=[Cost_Centers:27]WA_running3to:23)
		$waste:=$waste+($net*([Cost_Centers:27]WA_running3:24/100))
End case 

If ($waste<[Cost_Centers:27]WA_min:18)  //this minium applies only to the running waste component
	$waste:=[Cost_Centers:27]WA_min:18
End if 

$waste:=$waste+[Cost_Centers:27]WA_Startup:30

If ([Estimates_Machines:20]WasteAdj_Percen:40>0)
	$waste:=([Estimates_Machines:20]WasteAdj_Percen:40/100)*$Waste
End if 

$0:=$Waste