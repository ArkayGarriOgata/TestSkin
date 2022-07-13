//Class: CostCenter.4dm
//https://developer.4d.com/docs/en/Concepts/classes.html#function-get-and-function-set

//Define constructor and interface for all cost centers
Class constructor($id : Text)
	
	$cc_e:=ds:C1482.Cost_Centers.query("ID = :1"; $id).first()
	If ($cc_e#Null:C1517)  //load from cc record
		This:C1470.CostCenterType:=$cc_e.cc_Group
		This:C1470.MHR_labor:=$cc_e.MHRlaborSales
		This:C1470.MHR_overhead:=$cc_e.MHRburdenSales
		
		//setup a default
		This:C1470.WasteTable_o:=New object:C1471("999999"; -4)
		This:C1470.MR_Table_o:=New object:C1471("minimum"; -5)
		This:C1470.RunTable_o:=New object:C1471("999999"; -5000)
		
		If ($cc_e.UsageStandards#Null:C1517)
			If (OB Is defined:C1231($cc_e.UsageStandards; "waste"))
				This:C1470.WasteTable_o:=$cc_e.UsageStandards.waste
			End if 
			
			If (OB Is defined:C1231($cc_e.UsageStandards; "makeReady"))
				This:C1470.MR_Table_o:=$cc_e.UsageStandards.makeReady
			End if 
			
			If (OB Is defined:C1231($cc_e.UsageStandards; "running"))
				This:C1470.RunTable_o:=$cc_e.UsageStandards.running
			End if 
			
		End if 
		
	Else 
		This:C1470.MHR_labor:=0
		This:C1470.MHR_overhead:=0
		This:C1470.WasteTable_o:=New object:C1471("999999"; 0.007)
		This:C1470.MR_Table_o:=New object:C1471("minimum"; 0.5)
		This:C1470.RunTable_o:=$cc_e.RunTable_o
		This:C1470.CostCenterType:="generic"
	End if 
	
Function getWaste($jobDetail_o : Object) : Integer
/*
a waste table from the cost center record might look like the object below:
	
{
15000: 0.05,
30000: 0.03,
999999: 0.007,
perColor: 125,
perPlate: 200,
minimum: 450,
smallNumberUp: 0.05
}
	
*/
	
	If (This:C1470.WasteTable_o=Null:C1517)
		return -3
	End if 
	
	return 0
	
Function getMakeReadyHours($sequenceDetail_o : Object)->$makeReadyHrs : Real
/*
a makeready table from the cost center record might look like the object below:
	
{
spotColor: 1.25,
solidColor: 1,
perColor: 0.33,
perPlateChange: 1,
minimum: 1.5
}
	
*/
	
	If (This:C1470.MR_Table_o=Null:C1517)
		return -3
	End if 
	
	return 0
	
Function getRunHours($jobDetail : Object; $sequenceDetail_o : Object) : Real
	
	If (This:C1470.RunTable_o=Null:C1517)
		return -3
	End if 
	
	return 0
	
Function getRate($jobDetail : Object; $sequenceDetail_o : Object) : Integer
	
	If (This:C1470.RunTable_o=Null:C1517)
		return -3
	End if 
	
	return 0
	
Function getSizeConstraints() : Object  //length & width in inches
	return New object:C1471("width"; 28; "length"; 40)
	
Function getCostLabor() : Real
	return This:C1470.MHR_labor
	
Function getCostOverhead() : Real
	return This:C1470.MHR_overhead
	
Function getMachineHourRate() : Real
	return This:C1470.MHR_labor+This:C1470.MHR_overhead
	
Function CostCenter_test  //see also CostCenter_driver
	return 
	
	
	