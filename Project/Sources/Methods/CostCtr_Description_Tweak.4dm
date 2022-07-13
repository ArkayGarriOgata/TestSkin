//%attributes = {}
// ----------------------------------------------------
// Method: CostCtr_Description_Tweak   ( ptr to field in machine table{;"save"}) ->
// By: Mel Bohince @ 01/25/16, 14:00:08
// Description
// Chg the desc of stampers and embossers to one or the other
// based on the units specified in the flex fields
// done so pln'g and mfg'g can recognize quickly since the 500s have been removed

// ----------------------------------------------------

C_POINTER:C301($ptrDescriptionField; $1)  //ideally $1 is the desc field, but not manditory
$ptrDescriptionField:=$1
$tablePtr:=Table:C252(Table:C252($ptrDescriptionField))
$table:=Table name:C256(Table:C252($ptrDescriptionField))
C_TEXT:C284($2)
C_BOOLEAN:C305($inspect)
$inspect:=True:C214

Case of 
	: ($table="Job_Forms_Machines")
		$embossUnits:=[Job_Forms_Machines:43]Flex_field1:6
		$flatUnits:=[Job_Forms_Machines:43]Flex_field2:7
		$comboUnits:=[Job_Forms_Machines:43]Flex_field3:17
		
	: ($table="Process_Specs_Machines")
		$embossUnits:=[Process_Specs_Machines:28]Flex_Field1:12
		$flatUnits:=[Process_Specs_Machines:28]Flex_Field2:13
		$comboUnits:=[Process_Specs_Machines:28]Flex_Field3:14
		
	: ($table="Estimates_Machines")
		$embossUnits:=[Estimates_Machines:20]Flex_field1:18
		$flatUnits:=[Estimates_Machines:20]Flex_Field2:19
		$comboUnits:=[Estimates_Machines:20]Flex_Field3:20
		
	Else   //not a target table
		$inspect:=False:C215
End case 


If ($inspect)
	//find the key word to use
	If ($embossUnits>0)
		$shouldUse:="Embossing"
		
	Else 
		$shouldUse:="Stamping"
	End if 
	
	$0:=$shouldUse
	
	If (Count parameters:C259=2)
		If ($ptrDescriptionField->#$shouldUse)
			$ptrDescriptionField->:=$shouldUse
			SAVE RECORD:C53($tablePtr->)
		End if 
	End if 
	
End if   //inspect

//
