//%attributes = {"publishedWeb":true}
//Procedure: zTS_Duration()  020597  MLB
//calculate the days, hours, minutes, and seconds 
//between two time stamps
C_LONGINT:C283($1; $2; $seconds; $days; $hrs; $mins; $secs; $params; $3)
$seconds:=0
$params:=Count parameters:C259
$0:="0days 0hrs 0mins 0secs"
Case of 
	: ($params>=2)
		$seconds:=$2-$1
	: ($params=1)
		$seconds:=$1
	Else 
		BEEP:C151
		//$seconds:=Num(Request("Enter the number of seconds (no kidding):"))
		$seconds:=Num:C11(uSmRequest("Enter the number of seconds (no kidding):"))
End case 

If ($seconds#0)
	$days:=$seconds\86400
	$hrs:=($seconds-($days*86400))\3600
	$mins:=($seconds-($days*86400)-($hrs*3600))\60
	$secs:=($seconds-($days*86400)-($hrs*3600)-($mins*60))
	If ($params<=2)
		$0:=String:C10($days)+"days "+String:C10($hrs)+"hrs "+String:C10($mins)+"mins "+String:C10($secs)+"secs"
	Else 
		$0:=String:C10(Round:C94((((24*$days)+$hrs)+($mins/60)+($secs/3600)); 2); "##0.00")
	End if 
End if 

//