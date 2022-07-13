//%attributes = {"publishedWeb":true}
//PM: util_getWeather() -> 

//@author mlb - 4/30/01  13:10

$base:="http://www.weather.com/outlook/driving/local/"
Case of 
	: (User in group:C338(Current user:C182; "Roanoke"))
		$zip:="24019?lswe=24019&lwsa=WeatherLocalDriving"
		
	: (Current user:C182="Designer")
		$zip:="15085?lswe=15085&lwsa=WeatherLocalDriving"
		
	Else 
		$zip:="11788?lswe=11788&lwsa=WeatherLocalDriving"
End case 
OPEN URL:C673($base+$zip; *)

If (False:C215)
	C_TEXT:C284(xTitle; xText; URI; $url)
	utl_LogIt("init")
	$url:="iwin.nws.noaa.gov"  // but Jim restricts DNS so try:
	
	$url:="205.156.51.137"  //or
	
	//$url:="140.90.165.35"
	
	zwStatusMsg("WEATHER RPT"; "Trying 'iwin.nws.noaa.gov' at '"+$url+"'")
	
	URI:="GET /iwin/va/state.html HTTP/1.0"
	xText:=tcp_SubmitRequest($url; 80; URI; "")
	If (Position:C15("error#"; xText)=0)
		util_parseWeather(->xText; ->URI; "CITY")
	End if 
	
	URI:="GET /iwin/ny/state.html HTTP/1.0"
	xTitle:=tcp_SubmitRequest($url; 80; URI; "")
	If (Position:C15("error#"; xTitle)=0)
		util_parseWeather(->xTitle; ->URI)
	End if 
	
	If (User in group:C338(Current user:C182; "Roanoke"))
		utl_LogIt(xText; 0)
		utl_LogIt(xTitle; 0)
	Else 
		utl_LogIt(xTitle; 0)
		utl_LogIt(xText; 0)
	End if 
	
	utl_LogIt("show")
	
	utl_LogIt("init")
	xTitle:=""
	xText:=""
	//
	
End if 

