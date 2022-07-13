//%attributes = {}
// Method: REL_getNextRelease () -> 
// ----------------------------------------------------
// by: mel: 09/16/04, 11:37:01
// ----------------------------------------------------
// Description:
// return first open release for an orderline
// see also JML_get1stRelease, JMI_get1stRelease
// Updates:
// Modified by Mel Bohince on 3/13/07 at 09:48:06 : don't include forecasts
// ----------------------------------------------------

// Modified by: Mel Bohince (10/22/19)//thc option


C_DATE:C307($0)
C_TEXT:C284($1; $2; $3)

$0:=!00-00-00!

QUERY:C277([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]OpenQty:16>0; *)
QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]CustomerRefer:3#"<@"; *)
Case of 
	: (Count parameters:C259=1)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$1)
		
	: (Count parameters:C259=2)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]OrderLine:4=$2)
		
	: (Count parameters:C259=3)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]THC_State:39>0; *)
		QUERY:C277([Customers_ReleaseSchedules:46];  & ; [Customers_ReleaseSchedules:46]ProductCode:11=$1)
		
		
		
End case 

If (Records in selection:C76([Customers_ReleaseSchedules:46])>0)
	
	//correct bug last release 03-28-2019
	ARRAY DATE:C224($aDate; 0)
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]Sched_Date:5; $aDate)
	REDUCE SELECTION:C351([Customers_ReleaseSchedules:46]; 0)
	SORT ARRAY:C229($aDate; >)
	$0:=$aDate{1}
	
	
End if 