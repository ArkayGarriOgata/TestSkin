//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 10/06/05, 14:59:30
// ----------------------------------------------------
// Method: User_StatusChange
// Description
// 
//
// Parameters
// ----------------------------------------------------
If (Current user:C182="Designer")
	BEEP:C151
	<>zResp:=Request:C163("Who do you want to be today?"; <>zResp)
End if 
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	READ ONLY:C145([Users:5])
	QUERY:C277([Users:5]; [Users:5]StatusChange:43=2; *)
	QUERY:C277([Users:5];  & ; [Users:5]NeedApprovalFrom:44="@ "+<>zResp+" @")
	If (Records in selection:C76([Users:5])>0)
		<>PassThrough:=True:C214
		CREATE SET:C116([Users:5]; "◊PassThroughSet")
		REDUCE SELECTION:C351([Users:5]; 0)
		ViewSetter(2; ->[Users:5])
	Else 
		BEEP:C151
		ALERT:C41("Your approval for employee status change is not needed at the moment.")
	End if 
	
Else 
	REDUCE SELECTION:C351([Users:5]; 0)
	READ ONLY:C145([Users:5])
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	QUERY:C277([Users:5]; [Users:5]StatusChange:43=2; *)
	QUERY:C277([Users:5];  & ; [Users:5]NeedApprovalFrom:44="@ "+<>zResp+" @")
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (Records in set:C195("◊PassThroughSet")>0)
		
		<>PassThrough:=True:C214
		If (Records in selection:C76([Users:5])>0)
			REDUCE SELECTION:C351([Users:5]; 0)
		End if 
		ViewSetter(2; ->[Users:5])
		
	Else 
		
		BEEP:C151
		ALERT:C41("Your approval for employee status change is not needed at the moment.")
	End if 
	
End if   // END 4D Professional Services : January 2019 
