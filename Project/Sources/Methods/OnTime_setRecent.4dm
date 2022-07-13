//%attributes = {"publishedWeb":true}
//PM: OnTime_setRecent() -> 
//@author mlb - 1/30/03  16:30

READ WRITE:C146([Customers_OnTimeStats:122])
If (Count parameters:C259=2)
	QUERY:C277([Customers_OnTimeStats:122]; [Customers_OnTimeStats:122]CustId:1="ALL__"; *)
	QUERY:C277([Customers_OnTimeStats:122];  & ; [Customers_OnTimeStats:122]FiscalYr:3=2003)
	If (Records in selection:C76([Customers_OnTimeStats:122])=0)
		CREATE RECORD:C68([Customers_OnTimeStats:122])
		[Customers_OnTimeStats:122]CustId:1:="ALL__"
		[Customers_OnTimeStats:122]CustomerName:2:="Overall"
		[Customers_OnTimeStats:122]FiscalYr:3:=2003
	End if 
Else 
	QUERY:C277([Customers_OnTimeStats:122]; [Customers_OnTimeStats:122]CustId:1=$3; *)
	QUERY:C277([Customers_OnTimeStats:122];  & ; [Customers_OnTimeStats:122]FiscalYr:3=2003)
	If (Records in selection:C76([Customers_OnTimeStats:122])=0)
		CREATE RECORD:C68([Customers_OnTimeStats:122])
		[Customers_OnTimeStats:122]CustId:1:=$3
		[Customers_OnTimeStats:122]CustomerName:2:=$4
		[Customers_OnTimeStats:122]FiscalYr:3:=2003
	End if 
End if 

Case of 
	: ($1<20)
		[Customers_OnTimeStats:122]LastWeek:4:=$2
	Else 
		[Customers_OnTimeStats:122]LastMonth:5:=$2
End case 

SAVE RECORD:C53([Customers_OnTimeStats:122])
REDUCE SELECTION:C351([Customers_OnTimeStats:122]; 0)