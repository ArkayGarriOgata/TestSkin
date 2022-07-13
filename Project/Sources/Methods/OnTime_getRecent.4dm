//%attributes = {"publishedWeb":true}
//PM: OnTime_getRecent({custid};{custname}) -> 
//@author mlb - 1/30/03  16:23

C_TEXT:C284($1)
C_TEXT:C284($2)
C_TEXT:C284($0)

READ ONLY:C145([Customers_OnTimeStats:122])
Case of 
	: (Count parameters:C259=1)
		QUERY:C277([Customers_OnTimeStats:122]; [Customers_OnTimeStats:122]CustId:1=$1; *)
		QUERY:C277([Customers_OnTimeStats:122];  & ; [Customers_OnTimeStats:122]FiscalYr:3=2003)
		
	: (Count parameters:C259=2)
		QUERY:C277([Customers_OnTimeStats:122]; [Customers_OnTimeStats:122]CustomerName:2=("@"+$2); *)
		QUERY:C277([Customers_OnTimeStats:122];  & ; [Customers_OnTimeStats:122]FiscalYr:3=2003)
		
	Else 
		QUERY:C277([Customers_OnTimeStats:122]; [Customers_OnTimeStats:122]CustId:1="ALL__"; *)
		QUERY:C277([Customers_OnTimeStats:122];  & ; [Customers_OnTimeStats:122]FiscalYr:3=2003)
End case 

If (Records in selection:C76([Customers_OnTimeStats:122])>0)
	$0:=[Customers_OnTimeStats:122]LastWeek:4
Else 
	$0:="not available"
End if 
//String(65;"###%")+" ("+String(532)+" of "+String(816)+")"
REDUCE SELECTION:C351([Customers_OnTimeStats:122]; 0)