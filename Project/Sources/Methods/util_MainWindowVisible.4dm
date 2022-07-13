//%attributes = {}

// Method: util_MainWindowVisible ( )  -> 
// ----------------------------------------------------
// Author: PNGA
// renamed to fit conventions
// ----------------------------------------------------
// Description
// 
//  can't remember/care why //SHOW/Hide WINDOW(◊MainWindowRef) doesn't work
// ----------------------------------------------------

C_TEXT:C284($1; $msg)

//DELAY PROCESS(Current process;30)
// for testing: GET WINDOW RECT(<>MainWindowLeft;<>MainWindowTop;<>MainWindowRight;<>MainWindowBottom;<>MainWindowRef)
If (Count parameters:C259=1)
	$msg:=$1
Else 
	$msg:="Show"
End if 

If ($msg="Hide")
	<>MainWindowLeft:=20
	<>MainWindowTop:=40
	<>MainWindowRight:=<>MainWindowLeft+10
	<>MainWindowBottom:=<>MainWindowTop+10
	SET WINDOW RECT:C444(<>MainWindowLeft; <>MainWindowTop; <>MainWindowRight; <>MainWindowBottom; <>MainWindowRef)
	
Else   //"Show"//If (User in group(Current user;"RoleSuperUser"))  //show it
	<>MainWindowLeft:=55
	<>MainWindowTop:=Menu bar height:C440+123
	<>MainWindowRight:=<>MainWindowLeft+990
	<>MainWindowBottom:=<>MainWindowTop+700
	SET WINDOW RECT:C444(<>MainWindowLeft; <>MainWindowTop; <>MainWindowRight; <>MainWindowBottom; <>MainWindowRef)
End if 

<>IsMainWindowHidden:=(<>MainWindowTop<=0)