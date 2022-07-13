//%attributes = {"publishedWeb":true}
//PM: SF_ShopWeekend(date) -> date
//@author mlb - 12/5/01  15:13
C_DATE:C307($1; $date; $0)
C_BOOLEAN:C305($2; $3; $wkSat; $wkSun)
$date:=$1
$wkSat:=$2
$wkSun:=$3
C_LONGINT:C283($day)

$day:=Day number:C114($date)

Case of 
	: ($day=7)
		Case of 
			: (Not:C34($wkSat)) & (Not:C34($wkSun))
				$date:=$date+2
			: (Not:C34($wkSat))
				$date:=$date+1
		End case 
		
	: ($day=1)
		If (Not:C34($wkSun))
			$date:=$date+1
		End if 
End case 

$0:=$date