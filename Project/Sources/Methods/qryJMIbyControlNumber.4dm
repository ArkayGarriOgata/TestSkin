//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 02/16/06, 14:45:14
// ----------------------------------------------------
// Method: qryJMIbyControlNumber(contorl{;"not_done"})
// ----------------------------------------------------

C_TEXT:C284($1; $2)
C_LONGINT:C283($0)

$0:=0

If (Length:C16($1)>1)
	
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ControlNumber:26=$1)
		If (Count parameters:C259=2)
			QUERY SELECTION:C341([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!)
		End if 
	Else 
		
		If (Count parameters:C259=2)
			QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]Completed:39=!00-00-00!; *)
		End if 
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ControlNumber:26=$1)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
	
	
	$0:=Records in selection:C76([Job_Forms_Items:44])
End if 