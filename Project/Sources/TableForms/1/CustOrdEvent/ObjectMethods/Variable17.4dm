//(S) [CONTROL]CustOrderEvent'ibOther
// Modified by: Mel Bohince (12/20/21) remove "old" option of the Bookings report

If (User in group:C338(Current user:C182; "RoleAccounting"))
	//$which:=YesNoCancel ("Which method of grouping do you want to use on the export?";"By Customer";"By BillTo";"Pick Export Type")
	//Case of 
	//: ($which="Yes")
	//uConfirm ("Use which version?";"Old";"New")
	//If (ok=1)
	//uSpawnProcess ("Bookings";<>lMinMemPart;"Booking Report";True;False)
	//Else 
	Bookings2
	//End if 
	
	//: ($which="No")
	//uSpawnProcess ("Bookings_by_BillTo";<>lMinMemPart;"Booking Report";True;False)
	
	//Else 
	//BEEP
	//End case 
	
Else 
	uNotAuthorized
End if 

If (False:C215)  //list called procedures for 4D Insider  
	Bookings
	Bookings_by_BillTo
	Bookings2
End if 
//EOS