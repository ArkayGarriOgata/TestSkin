//%attributes = {"publishedWeb":true}
//PM: EMAIL_Deamon() -> 
//@author mlb - 4/17/01  15:50

C_LONGINT:C283($1; $minutes; $id)
C_TIME:C306($time)
C_BOOLEAN:C305(emailAbort)
C_TEXT:C284(pdfPath)

emailAbort:=False:C215

If (Count parameters:C259=0)
	If (Current user:C182="Administrator") | (Current user:C182="Designer")
		CONFIRM:C162("Start the email daemon?"; "Yes"; "No")
		If (OK=1)
			$id:=New process:C317("EMAIL_Daemon"; <>lMinMemPart; "EMAIL_Daemon"; 2)
			If (False:C215)
				EMAIL_Daemon
			End if 
		End if 
	End if 
	
Else 
	zwStatusMsg("EMAIL_Deamon"; "Waiting for emails sent to virtual.factory@arkay.com")
	Email_isRegisteredUser
	pdfPath:=util_DocumentPath  //Select folder("Select PDF output folder")
	$minutes:=$1
	Repeat 
		BEEP:C151
		EMAIL_Fetcher
		IDLE:C311
		$time:=4d_Current_time+(60*$minutes)
		zwStatusMsg("EMAIL"; "Check scheduled at "+Time string:C180($time))
		Case of 
			: (emailAbort)
			: (<>fQuit4D)
			Else 
				DELAY PROCESS:C323(Current process:C322; 60*60*$minutes)
		End case 
		//BEEP
	Until (<>fQuit4D) | (emailAbort)
	zwStatusMsg("EMAIL"; "Daemon stopped at "+String:C10(4d_Current_time; HH MM SS:K7:1))
End if 