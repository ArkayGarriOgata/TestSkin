//%attributes = {}
// Method: est0_indexOfMethods () -> 
// ----------------------------------------------------
// by: mel: 06/07/05, 14:45:40
// ----------------------------------------------------
// Description:
// so the main methods can be found in one place

If (False:C215)
	Est_Calculate
	
	Est_FormCostsCalculation
	Est_DifferencialCostsRollup
	If (<>NewAlloccat)  //•072998  MLB  UPR 1966
		Est_CartonCostAllocationNew  //get rid of thermoint!
	Else 
		Est_CartonCostAllocationOld
	End if 
	//CostCtrCurrent ("kill")
	rRptEstimate
End if 