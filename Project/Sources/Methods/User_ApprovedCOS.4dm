//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 11/29/05, 09:20:02
// ----------------------------------------------------
// Method: User_ApprovedCOS
// Description
// 
//
// Parameters
// ----------------------------------------------------
READ ONLY:C145([Users:5])
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Users:5]; [Users:5]StatusChange:43=3)
	If (Records in selection:C76([Users:5])>0)
		<>PassThrough:=True:C214
		CREATE SET:C116([Users:5]; "◊PassThroughSet")
		REDUCE SELECTION:C351([Users:5]; 0)
		ViewSetter(2; ->[Users:5])
	Else 
		BEEP:C151
		ALERT:C41("No Approved Status Changes waiting.")
	End if 
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	QUERY:C277([Users:5]; [Users:5]StatusChange:43=3)
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (Records in set:C195("◊PassThroughSet")>0)
		
		If (Records in selection:C76([Users:5])>0)
			REDUCE SELECTION:C351([Users:5]; 0)
		End if 
		<>PassThrough:=True:C214
		ViewSetter(2; ->[Users:5])
	Else 
		
		BEEP:C151
		ALERT:C41("No Approved Status Changes waiting.")
	End if 
	
End if   // END 4D Professional Services : January 2019 
