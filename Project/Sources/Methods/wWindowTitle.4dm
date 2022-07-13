//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 06/09/06, 10:32:16
// ----------------------------------------------------
// Method: wWindowTitle
// Description
// use wWindowTitle("push";"new window title") in on-load
// use wWindowTitle("pop") in on-unload
//
// Parameters $1=switch $2=new widnow title $3=optional winRef
// ----------------------------------------------------
C_TEXT:C284($1; windowStack; currentWindowTitle; $2)
currentWindowTitle:=""
C_TEXT:C284($delimitor)
$delimitor:="~"
C_LONGINT:C283($hit; $3)

Case of 
	: ($1="push")
		If (Length:C16(windowStack)=0)
			windowStack:="!EMPTY!"
		End if 
		windowStack:=Get window title:C450+$delimitor+windowStack
		currentWindowTitle:=$2
		
	: ($1="pop")
		$hit:=Position:C15($delimitor; windowStack)
		currentWindowTitle:=Substring:C12(windowStack; 1; $hit-1)
		windowStack:=Substring:C12(windowStack; $hit+1)
		
End case 
SET WINDOW TITLE:C213(currentWindowTitle)
