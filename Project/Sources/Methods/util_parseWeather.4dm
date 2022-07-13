//%attributes = {"publishedWeb":true}
//PM: util_parseWeather(->rawWebResponce;->URI) -> void
//@author mlb - 4/28/01  22:48
//sample:  util_parseWeather (->[Trials]response;->[Trials]requestLine)
//where: is a raw response from the host
//       and [Trials]requestLine is like "GET /iwin/ny/state.html HTTP/1.0"
//*=QCP Marker Symbol
//clean up a response from the National Weather Website

C_POINTER:C301($rawTextPtr; $1; $uri; $2)
$rawTextPtr:=$1
$uri:=$2
C_TEXT:C284($3)  //optional custom begin tag
C_TEXT:C284($cr; $crlf; $stationDelimitor)
$cr:=Char:C90(13)  //magic character of noaa.gov to delimit weather stations
$crlf:=$cr+Char:C90(10)
$stationDelimitor:=Char:C90(3)

C_TEXT:C284($data; $tagStart; $tagEnd)
$data:=$rawTextPtr->
C_LONGINT:C283($start; $end; $length)

//*Lose the linefeeds
$data:=Replace string:C233($data; $crlf; $cr)

// *Get the city of interest (within a region)
$location:=""
Case of 
	: (Position:C15("NY"; $uri->)>0)
		$reportingStation:="NATIONAL WEATHER SERVICE NEW YORK NY"
		$tagStart:="LONG ISLAND"  //"ISLIP"
		$tagEnd:="LAGUARDIA AIRPORT"  //"LOWER HUDSON VALLEY"
		
	: (Position:C15("VA"; $uri->)>0)
		$reportingStation:="NATIONAL WEATHER SERVICE WAKEFIELD, VA"
		$tagStart:="BLACKSBURG"  //"BLACKSBURG"  `"ROANOKE"
		$tagEnd:="...NORTHERN VIRGINIA"
		
	Else 
		$reportingStation:="NATIONAL WEATHER SERVICE"
		$tagStart:=""
		$tagEnd:=""
End case 

//*Get to the appropriate weather station
$start:=Position:C15($reportingStation; $data)
If ($start>0)
	$data:=Substring:C12($data; $start)
End if 
$length:=Length:C16($data)

$end:=Position:C15($stationDelimitor; $data)-3
If ($end<=0)
	$end:=$length
End if 
$data:=Substring:C12($data; 1; $end)
$length:=Length:C16($data)

//*Lose notes
$start:=Position:C15("ROWS INCLUDE..."; $data)-1
$end:=Position:C15("FCST"+$cr; $data)+5
$delete:=Substring:C12($data; $start; ($end-$start))
$data:=Replace string:C233($data; $delete; "")
$length:=Length:C16($data)

//*Get the column titles
$titles:=""
$start:=1
$end:=Position:C15("CITY"; $data)-1
$titles:=Substring:C12($data; $start; $end)

//*Get the city's forecast
$length:=Length:C16($data)
$start:=Position:C15($tagStart; $data)
If ($start=0)
	$start:=1
End if 

$end:=Position:C15($tagEnd; $data)
If ($end<=0)
	$end:=$length
End if 
$end:=$end-$start
$location:=Substring:C12($data; $start; $end)

//*Return the payload
$rawTextPtr->:=$titles+$location
//REDRAW($rawTextPtr->)
//HIGHLIGHT TEXT($rawTextPtr->;1;1)
//*****