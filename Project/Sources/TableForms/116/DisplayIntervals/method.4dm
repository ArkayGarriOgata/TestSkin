If (Form event code:C388=On Load:K2:1)
	C_LONGINT:C283($firstRow)
	
	//scroll to the first used interval
	$firstRow:=Form:C1466.intervals.findIndex(0; "SF_CalendarIntervalsFirstUsed"; 0)
	OBJECT SET SCROLL POSITION:C906(*; "ListBox"; $firstRow; 4; *)  // displays 4th row of 2nd column of list box in the first position
End if 