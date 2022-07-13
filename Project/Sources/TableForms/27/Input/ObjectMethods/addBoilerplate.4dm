/*
 Method: [Cost_Centers].Input.addBoilerplate   ( ) ->
 By: MelvinBohince @ 06/24/22, 15:38:41
 Description: create a starting point for the Usage Std Obj field
*/


var $usageTable; $wasteTable; $makeReadyTable; $runningTable : Object
var $doIt : Boolean

$doIt:=True:C214
If ([Cost_Centers:27]UsageStandards:73#Null:C1517)
	uConfirm("Overwrite the existing standards?"; "No"; "Overwrite")
	$doIt:=(ok=0)
End if 

If ($doIt)
	$wasteTable:=New object:C1471()
	$wasteTable["15000"]:=0.05
	$wasteTable["30000"]:=0.03
	$wasteTable["1000000"]:=0.007
	$wasteTable.perColor:=125
	$wasteTable.perPlate:=200
	$wasteTable.minimum:=450
	$wasteTable.smallNumberUp:=0.05
	
	$makeReadyTable:=New object:C1471()
	$makeReadyTable.spotColor:=1.25
	$makeReadyTable.solidColor:=1
	$makeReadyTable.perColor:=0.33
	$makeReadyTable.perPlateChange:=1
	$makeReadyTable.minimum:=1.5
	
	$runningTable:=New object:C1471()
	$runningTable["15000"]:=4000
	$runningTable["30000"]:=6000
	$runningTable["1000000"]:=8000
	
	$usageTable:=New object:C1471
	$usageTable.waste:=$wasteTable
	$usageTable.makeReady:=$makeReadyTable
	$usageTable.running:=$runningTable
	
	
	[Cost_Centers:27]UsageStandards:73:=$usageTable
End if 
