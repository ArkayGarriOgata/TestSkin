//%attributes = {}
// _______
// Method: SF_CalendarIntervalsSettings   (msg {;intervalsPerHr} ) ->  <>intervalsPerHour
// By: Mel Bohince @ 02/28/20, 10:39:34
// Description
// so the client and server can use <>intervalsPerHour set in one place
//see SF_CalendarIntervals and SF_ConvertSecondsToIntervals
// ----------------------------------------------------

C_LONGINT:C283(<>intervalsPerHour)

Case of 
	: (Count parameters:C259=0)  //init
		<>intervalsPerHour:=4  //15 minutes
		$0:=<>intervalsPerHour
		
	: ($1="set")
		<>intervalsPerHour:=$2
		$0:=<>intervalsPerHour
		
	: ($1="get")
		$0:=<>intervalsPerHour
		
	: ($1="intervalInSeconds")
		$0:=3600/<>intervalsPerHour
		
	Else   //init
		<>intervalsPerHour:=4  //15 minutes
		$0:=<>intervalsPerHour
End case 
