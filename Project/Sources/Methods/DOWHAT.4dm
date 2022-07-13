//%attributes = {}
//© 2015 Footprints Inc. All Rights Reserved.
//Method: Method: DOWHAT - Created `v1.0.0-PJK (12/7/15)
C_BOOLEAN:C305(<>fDebug)
If (<>fDebug)
	DODEBUG(Current method name:C684)
End if 

//A 3-button confirmation dialog

//$0 = Return selected choice (0=Cancel, 1=Default accept btn, 2=Other accept btn
//$1 = Text message to display
//$2 = Name of the default accept button (return value 1)
//$3 = Name of the 2nd accept button (return value 2)
//$4 = {Optional} Name of the Cancel button (return value 0)
C_LONGINT:C283($0; $xiChoice)  //s4.0.0-SDG (4/8/98)
C_TEXT:C284($1; $ttText; ttText)
C_TEXT:C284($2)
C_TEXT:C284($3)
C_TEXT:C284($4)  //s4.1.0-SDG (12/29/98)-was 40char
$0:=0  //assume cancel
$xiChoice:=$0  //s4.0.0
$ttText:=ttText
ttText:=$1
ttbaOK1:=$2
ttbaOK2:=$3
If (Count parameters:C259>=4)
	ttbdCancel:=$4
Else 
	ttbdCancel:="Cancel"
End if 

//v4.0.0-PJK (9/5/14)  Window_OpenDlg (490;135;"Confirm";True;False)  //s4.1.0-WCB-replace DIALOGWINDOW

$xlWin:=Open form window:C675("DOWHAT"; Movable form dialog box:K39:8)
SET WINDOW TITLE:C213("Confirm")
DIALOG:C40("DOWHAT")
CLOSE WINDOW:C154

$xiChoice:=OK+baOK2
ttText:=$ttText

//return choice
$0:=$xiChoice