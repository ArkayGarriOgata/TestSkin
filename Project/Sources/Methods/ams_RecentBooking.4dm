//%attributes = {"publishedWeb":true}
//PM: ams_RecentBooking(fiscalYear) -> set  name
//@author mlb - 7/1/02  10:21

//*Test booking by fiscal year

C_LONGINT:C283($fiscalYear; $1)
C_TEXT:C284($0)

$0:=""

If (Count parameters:C259=1)
	$fiscalYear:=$1
	READ ONLY:C145([Customers_Bookings:93])
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2>=$fiscalYear)
		CREATE SET:C116([Customers_Bookings:93]; "recentBooking")
		$0:="recentBooking"
		REDUCE SELECTION:C351([Customers_Bookings:93]; 0)
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "recentBooking")
		QUERY:C277([Customers_Bookings:93]; [Customers_Bookings:93]FiscalYear:2>=$fiscalYear)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$0:="recentBooking"
		
	End if   // END 4D Professional Services : January 2019 
	
Else 
	CLEAR SET:C117("recentBooking")
End if 