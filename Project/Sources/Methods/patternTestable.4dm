//%attributes = {}
// _______
// Method: patternTestable   ( ) ->
// By: Mel Bohince @ 04/05/19, 09:04:53
// Description
// allow testing for methods designed to be called with arguments
// ----------------------------------------------------

C_TEXT:C284($1; $2; $localOne; $localTwo)  //use this in your code, not the $1,$2, $3...
C_OBJECT:C1216($3; $localThree)

If (Count parameters:C259>0)  //use the arguments
	$localOne:=$1
	$localTwo:=$2
	$localThree:=$3
Else   //must be tracing, make shit up
	$localOne:="myTest1"
	$localTwo:=TS_ISO_String_TimeStamp
	
	//SET DATABASE PARAMETER(Dates inside objects;Date type)
	//$stringOb_t:="{\"date\":\"2018-01-24\"}"
	$localThree:=New object:C1471
	$localThree.dateBegin:=!2019-04-13!  //note: database settings date type instead of ISO in objects
	$localThree.timeBegin:=?13:55:55?  //milliseconds from midnight internally
	$localThree._timeStamp:=TS_ISO_String_TimeStamp($localThree.dateBegin; $localThree.timeBegin)
End if   //params





