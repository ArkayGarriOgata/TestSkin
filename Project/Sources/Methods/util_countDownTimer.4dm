//%attributes = {"publishedWeb":true}
//PM: util_countDownTimer() -> 
//@author mlb - 4/9/02  11:46
C_BOOLEAN:C305(fBeep)
fBeep:=True:C214
C_TIME:C306(tEnd; tTime; $2)
C_TEXT:C284($winTitle; $1)
Case of 
	: (Count parameters:C259=2)
		$winTitle:=$1
		tEnd:=$2
	: (Count parameters:C259=1)
		$winTitle:=$1
		tEnd:=Time:C179(Time string:C180(Current time:C178+60))
		tEnd:=Time:C179(Request:C163("end at what time?"; String:C10(tEnd; HH MM SS:K7:1)))
	Else 
		$winTitle:="Countdown Timer"
		tEnd:=Time:C179(Time string:C180(Current time:C178+60))
		tEnd:=Time:C179(Request:C163("end at what time?"; String:C10(tEnd; HH MM SS:K7:1)))
End case 


tTime:=tEnd-Current time:C178
$winRef:=Open form window:C675([zz_control:1]; "CountDownTimer"; -8)
SET WINDOW TITLE:C213($winTitle)
DIALOG:C40([zz_control:1]; "CountDownTimer")
CLOSE WINDOW:C154($winRef)