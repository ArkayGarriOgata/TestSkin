//Class: PrintingCostCenter.4dm
//https://developer.4d.com/docs/en/Concepts/classes.html#function-get-and-function-set
Class extends CostCenter

Function getWaste($jobDetail_o : Object) : Integer
	
	If (Count parameters:C259#1)
		return -1
	End if 
	
	If (This:C1470.WasteTable_o=Null:C1517)
		return -3
	End if 
	
	var $sheetCountBoundary : Text  //these are the step points for percentage changes
	
	For each ($sheetCountBoundary; This:C1470.WasteTable_o)
		
		If ($jobDetail_o.netSheets<Num:C11($sheetCountBoundary))
			return $jobDetail_o.netSheets*This:C1470.WasteTable_o[$sheetCountBoundary]
		End if 
		
	End for each   //entry in the waste table
	
	
	
Function getMakeReadyHours($sequenceDetail_o : Object)->$makeReadyHrs : Real
	
	If (Count parameters:C259#1)
		return -1
	End if 
	
	If ($sequenceDetail_o=Null:C1517)
		return -2
	End if 
	
	If (This:C1470.MR_Table_o=Null:C1517)
		return -3
	End if 
	
	var $makeReadyHrs : Real
	
	$makeReadyHrs:=0  //accumulate hours based on attributes of the job's sequence
	
	If (OB Is defined:C1231($sequenceDetail_o; "numberColors"))
		$makeReadyHrs+=This:C1470.MR_Table_o.perColor*$sequenceDetail_o.numberColors
	End if 
	
	If (OB Is defined:C1231($sequenceDetail_o; "numberPlateChanges"))
		$makeReadyHrs+=This:C1470.MR_Table_o.perPlateChange*$sequenceDetail_o.numberPlateChanges
	End if 
	
	If (OB Is defined:C1231($sequenceDetail_o; "spotColor"))
		$makeReadyHrs+=This:C1470.MR_Table_o.spotColor
	End if 
	
	If (OB Is defined:C1231($sequenceDetail_o; "solidColor"))
		$makeReadyHrs+=This:C1470.MR_Table_o.solidColor
	End if 
	
	If ($makeReadyHrs<This:C1470.MR_Table_o.minimum)
		$makeReadyHrs:=This:C1470.MR_Table_o.minimum
	End if 
	
	
	
Function getRunHours($jobDetail_o : Object; $sequenceDetail_o : Object)->$runHrs : Real
	$runHrs:=0
	
	
	
Function getRate($jobDetail_o : Object; $sequenceDetail_o : Object)->$rate : Integer
	$rate:=0
	
	