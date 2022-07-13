Class extends Entity
/*
By: MelvinBohince @ 06/10/22, 10:43:38
Description
           functions to calculate attributes
Example:
    $jobDetail_o:=New object
    $jobDetail_o.spotColor:=True
    $jobDetail_o.numberColors:=7
    $jobDetail_o.sheets:=25000

    $costCtr_o:=cs.CostCenter.new("420")
    $waste:=$costCtr_o.getWaste($jobDetail_o)
    $hours:=$costCtr_o.getMakeReadyHours($jobDetail_o)

*/


Function getWaste($jobDetail_o : Object) : Integer
	
	var $sheetCountBoundary : Text
	
	If (This:C1470.WasteTable_o=Null:C1517)  //load waste table from cc record
		This:C1470.WasteTable_o:=New object:C1471  //cc_e.wasteTable
		This:C1470.WasteTable_o["15000"]:=0.05
		This:C1470.WasteTable_o["30000"]:=0.03
		This:C1470.WasteTable_o["999999"]:=0.007
		This:C1470.WasteTable_o.perColor:=125
		This:C1470.WasteTable_o.perPlate:=200
		This:C1470.WasteTable_o.minimum:=450
		This:C1470.WasteTable_o.smallNumberUp:=0.05
		This:C1470.save()
	End if 
	
	
	For each ($sheetCountBoundary; This:C1470.WasteTable_o)
		
		If ($jobDetail_o.sheets<Num:C11($sheetCountBoundary))
			return $jobDetail_o.sheets*This:C1470.WasteTable_o[$sheetCountBoundary]
		End if 
		
	End for each 
	
Function getMakeReadyHours($jobDetail : Object)->$makeReadyHrs : Real
	
	var $makeReadyHrs : Real
	
	//printings make ready table
	If (This:C1470.MR_Table_o=Null:C1517)  //load waste table from cc record
		This:C1470.MR_Table_o:=New object:C1471
		This:C1470.MR_Table_o.spotColor:=1.25
		This:C1470.MR_Table_o.solidColor:=1
		This:C1470.MR_Table_o.perColor:=0.33
		This:C1470.MR_Table_o.perPlateChange:=1
		This:C1470.MR_Table_o.minimum:=1.5
		This:C1470.save()
	End if 
	
	$makeReadyHrs:=0
	
	If (OB Is defined:C1231($jobDetail; "numberColors"))
		$makeReadyHrs+=This:C1470.MR_Table_o.perColor*$jobDetail.numberColors
	End if 
	
	If (OB Is defined:C1231($jobDetail; "numberPlateChanges"))
		$makeReadyHrs+=This:C1470.MR_Table_o.perPlateChange*jobDetail.numberPlateChanges
	End if 
	
	If (OB Is defined:C1231($jobDetail; "spotColor"))
		$makeReadyHrs+=This:C1470.MR_Table_o.spotColor
	End if 
	
	If (OB Is defined:C1231($jobDetail; "solidColor"))
		$makeReadyHrs+=This:C1470.MR_Table_o.solidColor
	End if 
	
	If ($makeReadyHrs<This:C1470.MR_Table_o.minimum)
		$makeReadyHrs:=This:C1470.MR_Table_o.minimum
	End if 
	
	
Function getRunHours($jobDetail : Object)->$runHrs : Real
	$runHrs:=0
	
Function getRate($jobDetail : Object)->$rate : Integer
	$rate:=0
	