//%attributes = {"publishedWeb":true}
//PM: JTB_bagTrack_UI() -> 
//@author mlb - 1/29/02  14:18

C_TEXT:C284($1)

If (Count parameters:C259=0)
	If (<>pid_bagTrack=0)
		<>pid_bagTrack:=New process:C317("JTB_bagTrack_UI"; <>lMidMemPart; "bagTrack"; "init")
		If (False:C215)
			JTB_bagTrack_UI
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_bagTrack)
		BRING TO FRONT:C326(<>pid_bagTrack)
	End if 
	
Else 
	Case of 
		: ($1="init")
			SET MENU BAR:C67(<>defaultMenu)
			C_LONGINT:C283(iBagTabs)
			$winRef:=OpenFormWindow(->[zz_control:1]; "bagTrack_dio")
			ADD RECORD:C56([zz_control:1]; *)
			//DIALOG([zz_control];"bagTrack_dio")
			CLOSE WINDOW:C154($winRef)
			FORM SET INPUT:C55([zz_control:1]; "Input")
			<>pid_bagTrack:=0
	End case 
End if 