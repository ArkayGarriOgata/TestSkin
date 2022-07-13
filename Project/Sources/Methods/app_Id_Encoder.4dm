//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 06/09/09, 16:58:14
// ----------------------------------------------------
// Method: app_Id_Encoder(server-designation) -> str:10
// Description
// Make a replacement for GNT_DateTime so component can be removed
// for v11 migration
// this generates a key locally without a db call and can include a server designation for synchronization
// called like:
//C_TEXT($0)
//C_TEXT($station)
//$station:=String(Num(◊SERVER_DESIGNATION)+1)  ` assuming haup as 0 and roan as 2
//$0:=GNT_DateTime ("TimeStampGet";$station+"/8")

//here is what were trying to duplicate:
//$ReturnedValue:=GNT_Strings ("Encode:3";"/36";String($Days))+GNT_Strings ("Encode:4";"/36";String(($Seconds*18)+($Counter\46000)))+GNT_Strings ("Encode:3";"/36";String($Counter%46000))
// ----------------------------------------------------

C_LONGINT:C283($1; $server; $numServers; $range)  //used to offset based on server#

If (Count parameters:C259>0)
	$server:=$1  //use 0 for hauppauge, 1 for roanoke, n for next
Else 
	$server:=7
End if 
//$numServers:=8
$range:=100000  //Int((800000/$numServers)+0.999)  `100,000 in this config, so each second can be sliced 100000 times

C_LONGINT:C283(<>GNT_STR_LS_Count; <>GNT_STR_LS_LastSec)  //used to offset same second evokes
C_LONGINT:C283($days; $seconds; $counter; $lenBase36)  //encoded segments of the key
C_TEXT:C284($base36)
$base36:="0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ"  //base 36, typical return may look lie 5H8 M941 001 (no spaces)
$lenBase36:=36

// ----------------------------------------------------

If (Not:C34(Semaphore:C143("◊TimeStampSemaphore"; 180)))  //insure only one unique is calcuated at a time, was a local sem in orig code
	Repeat 
		$days:=4D_Current_date-!1990-01-01!
		$seconds:=4d_Current_time-0
		
		If ($seconds#<>GNT_STR_LS_LastSec)  //at least a second has elapsed since last evoke
			<>GNT_STR_LS_LastSec:=$seconds
			<>GNT_STR_LS_Count:=1
			
		Else   //build the offset if necessary
			<>GNT_STR_LS_Count:=<>GNT_STR_LS_Count+1
		End if 
	Until (<>GNT_STR_LS_Count<=$range)
	
	$counter:=<>GNT_STR_LS_Count+($server*$range)  //just the counter for server 0, 100000+counter for server 1
	CLEAR SEMAPHORE:C144("◊TimeStampSemaphore")
End if 

C_TEXT:C284($dayCode; $counterCode)
C_TEXT:C284($timeCode)
C_TEXT:C284($0; $temp)
//-----
// $0 returns the concates 3 chars for date, 4 chars for time, and 3 chars for offset counter
//next get these 3 segments:

//in-lined on purpose
$temp:=""
$number:=$days
While ($number>=1)
	$temp:=$base36[[($number-($lenBase36*($number\$lenBase36)))+1]]+$temp
	$number:=$number\$lenBase36
End while 
If (Length:C16($temp)>3)  //out of range
	$dayCode:="∆"
Else 
	$dayCode:=($base36[[1]]*(3-Length:C16($temp)))+$temp
End if 

$temp:=""
$number:=($seconds*18)+($counter\46000)
While ($number>=1)
	$temp:=$base36[[($number-($lenBase36*($number\$lenBase36)))+1]]+$temp
	$number:=$number\$lenBase36
End while 
If (Length:C16($temp)>4)  //out of rang
	$timeCode:="†"
Else 
	$timeCode:=($base36[[1]]*(4-Length:C16($temp)))+$temp
End if 

$temp:=""
$number:=$counter%46000
While ($number>=1)
	$temp:=$base36[[($number-($lenBase36*($number\$lenBase36)))+1]]+$temp
	$number:=$number\$lenBase36
End while 
If (Length:C16($temp)>3)  //out of rang
	$counterCode:="∑"
Else 
	$counterCode:=($base36[[1]]*(3-Length:C16($temp)))+$temp
End if 

$0:=$dayCode+$timeCode+$counterCode