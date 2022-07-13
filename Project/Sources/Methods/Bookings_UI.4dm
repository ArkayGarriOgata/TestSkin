//%attributes = {}
// _______
// Method: Bookings_UI   ( ) ->
// By: Mel Bohince @ 12/01/21, 07:59:40
// Description
// build a pivot view of customers' bookings for
//  a date range, up to 12 months
// ----------------------------------------------------
C_DATE:C307($1; $2; $dateBegin; $dateEnd)

If (Count parameters:C259=2)
	dDateBegin:=$1
	dDateEnd:=$2
Else 
	If (User in group:C338(Current user:C182; "RoleAccounting")) | (User in group:C338(Current user:C182; "SalesManager"))
		dDateBegin:=Date:C102("01-01-"+String:C10(Year of:C25(Current date:C33)))
		dDateEnd:=Current date:C33
		$winRef:=OpenFormWindow(->[zz_control:1]; "DateRange2"; ->windowTitle; windowTitle)
		DIALOG:C40([zz_control:1]; "DateRange2")
		CLOSE WINDOW:C154($winRef)
		
	Else 
		dDateBegin:=!00-00-00!
		dDateEnd:=!00-00-00!
		uConfirm("Access denied.")
	End if 
	
End if 

C_COLLECTION:C1488($bookings_c)
$bookings_c:=Bookings_Pivot_EOS(dDateBegin; dDateEnd)

//now build the csv by
//taking the collection of customer objects and
//covert to a collection of rows each with a 
//collections of columns

uConfirm("To File or Display"; "File"; "Display")
If (ok=1)  //$buildReport
	
	C_TEXT:C284($csv_t; $title)
	$title:="Booked orders (accepted or closed) from "+String:C10(dDateBegin; Internal date short special:K1:4)+" to "+String:C10(dDateEnd; Internal date short special:K1:4)
	$csv_t:=Booking_Collection_To_CSV($bookings_c; $title)
	
	$docName:="BookingsPivot"+fYYMMDD(Current date:C33)+"_"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")+".csv"
	$docShortName:=$docName  //capture before path is prepended
	$docRef:=util_putFileName(->$docName)
	CLOSE DOCUMENT:C267($docRef)
	
	TEXT TO DOCUMENT:C1237($docName; $csv_t)
	
	$err:=util_Launch_External_App($docName)
	
Else   //$build4DView
	//not Booking_Collection_To_ViewPro
	Bookings_Display($bookings_c; dDateBegin; dDateEnd)
	
End if 


