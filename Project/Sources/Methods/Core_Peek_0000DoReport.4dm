//%attributes = {}
//Method:  Core_Peek_0000DoReport
//Description: This method will run reports

If (True:C214)
	
	C_OBJECT:C1216($oOption)
	
	$oOption:=New object:C1471()
	
	//$oOption.tQuery:="TableName"  //All forms from table zz_Control
	//$oOption.tValue:="zz_control"
	
	//$oOption.tQuery:="FormName"  //FormName SimplePick
	//$oOption.tValue:="SimplePick"
	
	$oOption.tQuery:="Distinct"  //Unique FormName
	
End if 

Core_Peek_Report($oOption)