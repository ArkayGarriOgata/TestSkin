//%attributes = {"publishedWeb":true}
// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 090695
// ----------------------------------------------------
// Method: doChangeAccess
// ----------------------------------------------------

C_TEXT:C284($tCurrUser)

$tCurrUser:=Current user:C182
OK:=0

Repeat 
	CHANGE CURRENT USER:C289  //(P) uChangeAccess
	If (OK=0)
		ALERT:C41("Sorry.  Please re-establish your login.  Do not use the Cancel button.")
	End if 
Until (OK=1)

If ($tCurrUser#Current user:C182)  //really changed
	NewWindow(200; 50; 6; 5; "Changing Login")
	MESSAGE:C88("Searching user file..."+Char:C90(13))
	
	QUERY:C277([Users:5]; [Users:5]UserName:11=Current user:C182)
	
	If (Records in selection:C76([Users:5])=1)  //otherwise leave same zResp
		<>zResp:=[Users:5]Initials:1
	End if 
	
	If (Current user:C182="Designer") | (Current user:C182="Administrator")
		gStartUp
	Else 
		MESSAGE:C88("Checking security clearance..."+Char:C90(13))
		uTest4Security
	End if 
	
	SET MENU BAR:C67(<>DefaultMenu)
	CLOSE WINDOW:C154
	
	//RedoMainPalette   // Added by: Mark Zinke (1/24/13) 
	//beforeMainEvent   // Removed by: Mark Zinke (1/23/13) 
	//CALL PROCESS(-1)  // Removed by: Mark Zinke (1/23/13) 
	
End if 

<>CurrentUser:=Current user:C182+"  "+<>zResp
zwStatusMsg("Access Chg"; " from "+$tCurrUser+" to "+<>CurrentUser)
uWinListCleanup