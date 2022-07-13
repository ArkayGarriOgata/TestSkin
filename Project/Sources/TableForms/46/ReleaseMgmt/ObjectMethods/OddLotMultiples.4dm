// ----------------------------------------------------
// Method: [Customers_ReleaseSchedules].ReleaseMgmt.OddLotMultiples   ( ) ->
// By: Mel Bohince @ 04/22/16, 09:45:06
// Description
// find odd lots in the current selection
// ----------------------------------------------------
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	CREATE EMPTY SET:C140([Customers_ReleaseSchedules:46]; "odd_lot")
	
	
	While (Not:C34(End selection:C36([Customers_ReleaseSchedules:46])))
		If (FG_getCaseCount([Customers_ReleaseSchedules:46]CustID:12; [Customers_ReleaseSchedules:46]ProductCode:11; [Customers_ReleaseSchedules:46]Sched_Qty:6)<0)
			ADD TO SET:C119([Customers_ReleaseSchedules:46]; "odd_lot")
		End if 
		NEXT RECORD:C51([Customers_ReleaseSchedules:46])
	End while 
	
	USE SET:C118("odd_lot")
	CLEAR SET:C117("odd_lot")
	
Else 
	
	ARRAY TEXT:C222($_CustID; 0)
	ARRAY TEXT:C222($_ProductCode; 0)
	ARRAY LONGINT:C221($_Sched_Qty; 0)
	ARRAY LONGINT:C221($_record_number; 0)
	ARRAY LONGINT:C221($_record_number_Finale; 0)
	
	SELECTION TO ARRAY:C260([Customers_ReleaseSchedules:46]CustID:12; $_CustID; \
		[Customers_ReleaseSchedules:46]ProductCode:11; $_ProductCode; \
		[Customers_ReleaseSchedules:46]Sched_Qty:6; $_Sched_Qty; \
		[Customers_ReleaseSchedules:46]; $_record_number)
	
	For ($Iter; 1; Size of array:C274($_CustID); 1)
		If (FG_getCaseCount($_CustID{$Iter}; $_ProductCode{$Iter}; $_Sched_Qty{$Iter})<0)
			
			APPEND TO ARRAY:C911($_record_number_Finale; $_record_number{$Iter})
			
		End if 
	End for 
	
	CREATE SELECTION FROM ARRAY:C640([Customers_ReleaseSchedules:46]; $_record_number_Finale)
	
End if   // END 4D Professional Services : January 2019 


ORDER BY:C49([Customers_ReleaseSchedules:46]; [Customers_ReleaseSchedules:46]Sched_Date:5; >; [Customers_ReleaseSchedules:46]ProductCode:11; >)
BEEP:C151

