//%attributes = {"publishedWeb":true}
//PM: REL_setAvailableToPromise() -> 
//@author mlb - 2/6/03  13:06

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)

If (Count parameters:C259>0)
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@")
	$today:=String:C10(4D_Current_date; System date short:K1:1)
End if 

$break:=False:C215
$numRecs:=Records in selection:C76([Customers_ReleaseSchedules:46])

APPLY TO SELECTION:C70([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]ATP_RESET:41:=False:C215)
FIRST RECORD:C50([Customers_ReleaseSchedules:46])

uThermoInit($numRecs; "Setting Available To Promise")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	atp:=REL_getAvailableToPromise([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11)
	If ([Customers_ReleaseSchedules:46]Sched_Date:5<atp)
		[Customers_ReleaseSchedules:46]ChangeLog:23:=String:C10([Customers_ReleaseSchedules:46]Sched_Date:5; System date short:K1:1)+" revised to "+String:C10(atp; System date short:K1:1)+" on "+$today+Char:C90(13)+[Customers_ReleaseSchedules:46]ChangeLog:23
		[Customers_ReleaseSchedules:46]Sched_Date:5:=atp
		[Customers_ReleaseSchedules:46]ATP_RESET:41:=True:C214
		SAVE RECORD:C53([Customers_ReleaseSchedules:46])
	End if 
	NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	uThermoUpdate($i)
End for 

uThermoClose