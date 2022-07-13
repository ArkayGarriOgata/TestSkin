//%attributes = {}
// Method: Batch_OrderLineNeedDate () -> 
// ----------------------------------------------------
// by: mel: 09/26/03, 12:25:37
// ----------------------------------------------------
// Description:
// Adjust Orderline need date to match next firm release
//or 00//00 if no firm release
// ----------------------------------------------------

C_LONGINT:C283($i; $numRecs)
C_BOOLEAN:C305($break)
C_TEXT:C284(xText; xTitle)

$break:=False:C215

MESSAGES OFF:C175
READ WRITE:C146([Customers_Order_Lines:41])
$numRecs:=qryOpenOrdLines
If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
	
	FIRST RECORD:C50([Customers_Order_Lines:41])
	
	
Else 
	
	// you invoke a query on qryOpenOrdLines line 18
	
	
End if   // END 4D Professional Services : January 2019 First record
// 4D Professional Services : after Order by , query or any query type you don't need First record  
//utl_LogIt ("init")

uThermoInit($numRecs; "Updating Orderline Need Dates")
For ($i; 1; $numRecs)
	If ($break)
		$i:=$i+$numRecs
	End if 
	
	QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OrderLine:4=[Customers_Order_Lines:41]OrderLine:3; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
	QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<F@")
	If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
		ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >)
		If ([Customers_Order_Lines:41]NeedDate:14#[Customers_ReleaseSchedules:46]Sched_Date:5)  //utl_LogIt ([OrderLines]OrderLine+Char(9)+String([OrderLines]NeedDate;MM DD YYYY Forced )+Char(9)+"set to"+Char(9)+String([ReleaseSchedule]Sched_Date;MM DD YYYY Forced )+Char(9)+String([ReleaseSchedule]Sched_Date-[OrderLines]NeedDate))
			
			[Customers_Order_Lines:41]NeedDateOld:51:=[Customers_Order_Lines:41]NeedDate:14
			[Customers_Order_Lines:41]NeedDate:14:=[Customers_ReleaseSchedules:46]Sched_Date:5
			SAVE RECORD:C53([Customers_Order_Lines:41])
			
		End if 
	Else 
		If ([Customers_Order_Lines:41]NeedDate:14#!00-00-00!)  //utl_LogIt ([OrderLines]OrderLine+Char(9)+"set to 00/00/00")
			[Customers_Order_Lines:41]NeedDateOld:51:=[Customers_Order_Lines:41]NeedDate:14
			[Customers_Order_Lines:41]NeedDate:14:=!00-00-00!
			SAVE RECORD:C53([Customers_Order_Lines:41])
		End if 
	End if 
	
	NEXT RECORD:C51([Customers_Order_Lines:41])
	uThermoUpdate($i)
End for 
uThermoClose

BEEP:C151