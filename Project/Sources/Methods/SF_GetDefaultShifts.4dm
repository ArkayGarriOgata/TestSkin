//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: SF_GetDefaultShifts - Created `v1.0.0- (12/23/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 
//$1=Date
C_DATE:C307($1; $dDate)
C_TEXT:C284($0)
$dDate:=$1
$xlWeekDay:=Day number:C114($dDate)

$0:="0"
Case of 
	: (SF_ShopHolidays($dDate)#$dDate)  //holiday
		
	: ($xlWeekDay=1)
		
	: ($xlWeekDay=7)
		$0:="1"
	: ($xlWeekDay=2)
		$0:="2"
	Else 
		$0:="3"
End case 
