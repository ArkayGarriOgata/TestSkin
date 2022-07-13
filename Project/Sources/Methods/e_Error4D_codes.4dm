//%attributes = {"publishedWeb":true}
C_BOOLEAN:C305($Terminate; $Continue)  //(P) uError4D: Interpret 4D error message and display custom message to user  
C_TEXT:C284($ContactMsg; $ContactNot; $CheckDB)
C_TEXT:C284($message)

$Terminate:=False:C215
$Continue:=False:C215
$ContactMsg:=<>sCR+"(SNAPSHOT this message with Cmd-Shift-3 and NOTIFY Technical Support.)"
$ContactNot:=<>sCR+"(NOTIFY Technical Support.)"
$CheckDB:=<>sCR+"Session terminating.  CHECK database integrity before re-starting."

Case of 
	: (error=0)
		$Continue:=True:C214
		$message:="Oops! No error!  Continue."
	: (error=52)
		$message:="Procedure code/Communication error."+$ContactMsg  //undocumented code for undefined array
	: (error=53)
		$message:="Procedure code/Data error: Index involved."+$ContactMsg  //i.e., out of range
	: ((error>0) & (error<60))
		$message:="Procedure code error."+$ContactMsg
	: ((error=2000) | (error=-9996))  //2000 is undocumented code for trying to push record when selection is empty
		BEEP:C151
		$Terminate:=True:C214
		$message:="Procedure code/File error"+<>sCR+"Session terminating as precaution after which RE-START."+$ContactMsg
	: (error=-9998)
		$message:="File error: DUPLICATE Key"+<>sCR+"CORRECT and RE-ENTER data."
	: (error=-9999)
		BEEP:C151
		BEEP:C151
		$Terminate:=True:C214
		$message:="I/O Error: INSUFFICIENT SPACE on disk to save record!"+$CheckDB+<>sCR+"INCREASE SPACE for database."+$ContactNot
	: (error=-9991)
		$Continue:=True:C214
		$message:="SECURITY violation: Insufficient privilege for function requested."
	: (error=-9992)
		$Continue:=True:C214
		$message:="SECURITY violation: Incorrect password for User indicated."
	: ((error=-9994) | (error=1006))
		$Continue:=True:C214
		$message:="User-generated interruption.  Repeat function and/or continue."
	: (error=-9989)
		BEEP:C151
		BEEP:C151
		$Terminate:=True:C214
		$message:="DAMAGED database."+$CheckDB+$ContactMsg
	: ((error<=-10000) & (error>=-10004))
		BEEP:C151
		BEEP:C151
		$Terminate:=True:C214
		$message:="DAMAGED database."+$CheckDB+$ContactMsg
	: ((error<=-33) & (error>=-61))
		BEEP:C151
		BEEP:C151
		$Terminate:=True:C214
		$message:="Macintosh File Manager error."+$CheckDB+$ContactNot
	: (error=-108)
		$Terminate:=True:C214
		$message:="Macintosh Memory Manager error."+<>sCR+"Application tuning necessary."+$CheckDB+$ContactNot
	: ((error=-1) | (error=-17))
		$Continue:=True:C214
		$message:="Macintosh Printing Manager error. "
	: ((error=-27) | (error=-4100) | (error=-4101) | (error=-8150) | (error=-8151))
		$Continue:=True:C214
		$message:="Macintosh Printing Manager error:"+<>sCR+"CHECK printer connection/selection/driver"
	: (error=-128)
		$Continue:=True:C214
		$message:="Macintosh Printing Manager error:"+<>sCR+"Printing interrupted by user."
	Else 
		$Terminate:=True:C214
		$message:="Unlabeled error encountered."+<>sCR+"Session terminating as precaution after which RE-START."+$ContactMsg
End case 
ALERT:C41("Application Error # "+String:C10(error)+<>sCR+$message)
If ($Continue)
Else 
	If ($Terminate)
		QUIT 4D:C291
	Else 
		If (Current user:C182="Designer")
			CONFIRM:C162("Error occured in procedure '"+zProcName+"'! Continue?")
			If (OK=0)
				ABORT:C156
			End if 
		Else 
			ABORT:C156
		End if 
	End if 
End if 