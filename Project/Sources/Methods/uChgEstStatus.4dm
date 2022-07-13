//%attributes = {"publishedWeb":true}
//uChgEstStatus
//•031297  mBohince  reduce the selection
//• 3/12/98 cs modified so that Ralph can see who is locking an estimate when a 
//   change is being attempted
//•081800  mlb  use flockNload correctly
C_TEXT:C284($est; $status)  //1/25/95
$est:=<>EstNo
$status:=<>EstStatus
//OPEN WINDOW(250;120;600;160;-722;"Changing status of estimate "+$est+" to "+$sta
NewWindow(350; 25; 5; -722; "Changing status of estimate "+$est+" to "+$status)
READ WRITE:C146([Estimates:17])  //uChgEstSTatus
QUERY:C277([Estimates:17]; [Estimates:17]EstimateNo:1=$est)
If (Records in selection:C76([Estimates:17])=1)
	//Repeat 
	//   LOAD RECORD([ESTIMATE]) `• 3/12/98 cs 
	//`  DELAY PROCESS(Current process;360)
	//` MESSAGE("Waiting...  ")
	
	
	//Until (fLockNLoad (->[ESTIMATE]))  `(Not(Locked([ESTIMATE]))) `• 3/12/98 cs 
	If (fLockNLoad(->[Estimates:17]))
		[Estimates:17]Status:30:=$status
		If ($status="Quoted")
			If ([Estimates:17]DateQuoted:61=!00-00-00!)
				[Estimates:17]DateQuoted:61:=4D_Current_date
			End if 
		End if 
		SAVE RECORD:C53([Estimates:17])
	End if 
	
Else 
	If ($est#"0-0000.00")  //•062795  MLB
		BEEP:C151
		ALERT:C41("Could not mark estimate "+$est+" as '"+$status+"'.")
	End if 
	
End if 

UNLOAD RECORD:C212([Estimates:17])
<>EstStatus:=""
<>EstNo:=""
CLOSE WINDOW:C154
//