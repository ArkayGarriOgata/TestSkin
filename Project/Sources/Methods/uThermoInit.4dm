//%attributes = {"publishedWeb":true}
//Procedure: uThermoInit()  041996  MLB
//avoid use of external thermoSet uthemoupdate uthermoclose
//$1 Number of items done
//$2 number of items total

C_LONGINT:C283($1; ThermoMax)
C_TEXT:C284($2)
C_BOOLEAN:C305(useStatusBar)

If (Not:C34(Application type:C494=4D Server:K5:6))
	useStatusBar:=Not:C34(Semaphore:C143("$isStatusThermo"))
	If (useStatusBar)
		zwStatusTherm("init"; $2; $1)
	Else 
		ThermoMax:=$1
		NewWindow(350; 50; 6; -722; (String:C10(ThermoMax)+":"+$2))
	End if 
	
Else 
	utl_Logfile("statusbar.log"; "StatusBar: "+String:C10($1)+": "+$2)
End if 