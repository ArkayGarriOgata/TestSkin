//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 08/24/06, 15:34:53
// ----------------------------------------------------
// Method: WO_WorkOrder
// Description
// 
//
// Parameters
// ----------------------------------------------------

C_LONGINT:C283(<>pid_Workorder; $winRef)
C_TEXT:C284($1)

Case of 
	: (Count parameters:C259=0)
		<>pid_Workorder:=New process:C317("WO_WorkOrder"; <>lMinMemPart; "WO_WorkOrder"; "init")
		If (False:C215)
			WO_WorkOrder
		End if 
		
	: (Count parameters:C259=1)
		<>iMode:=2
		<>filePtr:=->[Work_Orders:37]
		uSetUp(1; 1)
		CONFIRM:C162("Create a New Work Order or update existing?"; "New"; "Update")
		If (ok=1)
			ViewSetter(1; ->[Work_Orders:37])
		Else 
			If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
				
				QUERY:C277([Work_Orders:37]; [Work_Orders:37]Finished:4="")
				CREATE SET:C116([Work_Orders:37]; "◊PassThroughSet")
				
				
			Else 
				
				SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
				QUERY:C277([Work_Orders:37]; [Work_Orders:37]Finished:4="")
				SET QUERY DESTINATION:C396(Into current selection:K19:1)
				
				
			End if   // END 4D Professional Services : January 2019 
			<>PassThrough:=True:C214
			ViewSetter(2; ->[Work_Orders:37])
		End if 
		
		<>pid_Workorder:=0
		
	: (Count parameters:C259>=2)
		Case of 
			: ($2="")
				
		End case 
		
End case 
