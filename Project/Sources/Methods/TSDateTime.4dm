//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/01/06, 11:03:37
// ----------------------------------------------------
// Method: TSDateTime
// Description
// return the servers current date time in a sortable string format
// CCYY_MM_DD_HH_MM_SS
C_TEXT:C284($0; $date; $time; $delim)
$delim:="_"
If (Count parameters:C259=0)
	$date:=String:C10(4D_Current_date; Internal date short:K1:7)
	$time:=String:C10(4d_Current_time; HH MM SS:K7:1)
Else 
	$date:=String:C10($1; Internal date short:K1:7)
	$time:=String:C10($2; HH MM SS:K7:1)
End if 
$0:=$date[[7]]+$date[[8]]+$date[[9]]+$date[[10]]+$delim+$date[[1]]+$date[[2]]+$delim+$date[[4]]+$date[[5]]+$delim+$time[[1]]+$time[[2]]+$delim+$time[[4]]+$time[[5]]+$delim+$time[[7]]+$time[[8]]
