//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 03/25/13, 16:41:55
// ----------------------------------------------------
// Method: GetStartEndDates
// Description:
// Even though the program tells the user to enter dates as
// MM/YY, it allows them to skip the leading zero.
// Returns the date needed for the query.
// ----------------------------------------------------

C_TEXT:C284($tWhichOne; $1; $tDate; $2)
C_POINTER:C301($pDate; $3)
C_LONGINT:C283($xlPosition; $xlLastDay)

$tWhichOne:=$1
$tDate:=$2
$pDate:=$3

$xlPosition:=Position:C15("/"; $tDate)

If ($tWhichOne="Start")  //Start Date
	If ($xlPosition=2)  //They didn't include the leading 0
		$pDate->:=Date:C102(Substring:C12($tDate; 1; 1)+"/01/"+Substring:C12($tDate; 3))
		
	Else 
		$pDate->:=Date:C102(Substring:C12($tDate; 1; 2)+"/01/"+Substring:C12($tDate; 4))
	End if 
	
Else   //End Date
	If ($xlPosition=2)  //They didn't include the leading 0
		$xlLastDay:=Util_GetLastDayOfMonth(Num:C11(Substring:C12($tDate; 1; 1)))
		$pDate->:=Date:C102(Substring:C12($tDate; 1; 1)+"/"+String:C10($xlLastDay)+"/"+Substring:C12($tDate; 3))
		
	Else 
		$xlLastDay:=Util_GetLastDayOfMonth(Num:C11(Substring:C12($tDate; 1; 2)))
		$pDate->:=Date:C102(Substring:C12($tDate; 1; 2)+"/"+String:C10($xlLastDay)+"/"+Substring:C12($tDate; 4))
	End if 
End if 