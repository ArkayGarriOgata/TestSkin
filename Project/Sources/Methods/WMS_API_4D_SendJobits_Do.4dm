//%attributes = {}
//©2016 Footprints Inc. All Rights Reserved.
//Method: wms_api_4D_SendJobits_Do - Created v0.1.0-JJG (05/05/16)
//expects loaded jobit record to send
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

C_TEXT:C284($ttJobit)
C_LONGINT:C283($xlCaseCount)
C_DATE:C307($dGlueDate)

$xlCaseCount:=-1
$ttJobit:=Replace string:C233([Job_Forms_Items:44]Jobit:4; "."; "")  //wms doesn't use decimals in jobit

If ([Job_Forms_Items:44]Glued:33#!00-00-00!)
	$dGlueDate:=[Job_Forms_Items:44]Glued:33
Else 
	$dGlueDate:=4D_Current_date
End if 

Begin SQL
	SELECT COUNT(*) FROM cases WHERE jobit=:$ttJobit INTO :$xlCaseCount
End SQL

If ($xlCaseCount=0)
	SQL SET PARAMETER:C823($ttJobit; SQL param in:K49:1)
	SQL EXECUTE:C820("DELETE FROM jobits WHERE jobit=?")
	SQL CANCEL LOAD:C824
	
	If (OK=1)
		WMS_API_4D_SendJobits_DoSend($ttJobit; $dGlueDate)
	End if 
End if 