//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/01/06, 11:44:54
// ----------------------------------------------------
// Method: TSDateTimeShort
// Description
// 
//
// Parameters
// ----------------------------------------------------
C_TEXT:C284($0; $date; $time)
$date:=String:C10(4D_Current_date; Internal date short:K1:7)
$time:=String:C10(4d_Current_time; HH MM SS:K7:1)
$0:=$date[[9]]+$date[[10]]+$date[[1]]+$date[[2]]+$date[[4]]+$date[[5]]+$time[[1]]+$time[[2]]+$time[[4]]+$time[[5]]
