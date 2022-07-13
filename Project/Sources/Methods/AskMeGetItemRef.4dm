//%attributes = {}
// ----------------------------------------------------
// User name (OS): Mark Zinke
// Date and time: 12/12/12, 11:15:17
// ----------------------------------------------------
// Method: AskMeGetItemRef
// Description:
// Determines where in the list the item should go.
// See AskMeHistory

// Today
// Yesterday
// This Week
// Last Week
// This Month
// Older
// ----------------------------------------------------

C_DATE:C307($dDate; $1)
C_TEXT:C284($tText; $2)
C_LONGINT:C283($xlDay; xlToday; xlYesterday; xlThisWeek; xlLastWeek; xlThisMonth; xlOlder)

$dDate:=$1
$tText:=$2
$xlDay:=Day number:C114(Current date:C33)

Case of 
	: ($dDate=Current date:C33)  //Today
		xlToday:=xlToday+1
		APPEND TO LIST:C376(xlSublistRef1; $tText; xlToday)
		
	: ($dDate=(UtilGetDate(Current date:C33; "Yesterday")))  //Yesterday
		xlYesterday:=xlYesterday+1
		APPEND TO LIST:C376(xlSublistRef2; $tText; xlYesterday)
		
	: ($dDate>=(UtilGetDate(Current date:C33; "ThisWeek")))  //This Week
		xlThisWeek:=xlThisWeek+1
		APPEND TO LIST:C376(xlSublistRef3; $tText; xlThisWeek)
		
	: ($dDate>=(UtilGetDate(Current date:C33; "LastWeek")))  //Last Week
		xlLastWeek:=xlLastWeek+1
		APPEND TO LIST:C376(xlSublistRef4; $tText; xlLastWeek)
		
	: ($dDate>=(UtilGetDate(Current date:C33; "ThisMonth")))  //Last Month
		xlThisMonth:=xlThisMonth+1
		APPEND TO LIST:C376(xlSublistRef5; $tText; xlThisMonth)
		
	Else   //Older
		xlOlder:=xlOlder+1
		APPEND TO LIST:C376(xlSublistRef6; $tText; xlOlder)
End case 