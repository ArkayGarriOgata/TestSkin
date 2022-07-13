//%attributes = {}
// _______
// Method: util_RGB_to_decimal(r;g;b ) -> d
// By: Mel Bohince @ 05/14/20, 08:57:46
// Description
// calculate the decimal rgb from the digital component colors
// use in conjunction with Digital Color Meter.app 
// ----------------------------------------------------
//sample: 253r 194g 12b = 16630284

C_LONGINT:C283($1; $2; $3; $0)  //red;green;blue;returned

$0:=($1*256*256)+($2*256)+$3


