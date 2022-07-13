//%attributes = {}

// ----------------------------------------------------
// User name (OS): Philip Keth
// Date and time: 12/07/15, 11:05:20
// ----------------------------------------------------
// Method: MULOADREC_LOOP
// Description
// 
//
// Parameters
// ----------------------------------------------------



//Repeat-load attempt loop w/ messaging
//$1 = ->[Table] to load the current record (it is locked)
//$2 = Bailout Option (0=Force Load; 1=Confirm every 5 attempts, -1=stop after 5…
//…failed attempts, see MULOADREC)
//OTHER INPUTS: <>kxiMULdExp = loop failure expiration timeout (seconds)
C_POINTER:C301($1; $pTable)
C_LONGINT:C283($2; $xiBailOpt)  //v0.1.0-JJG (03/28/17) - chaged from integer
$pTable:=$1  //s4.1.0-SDG (7/16/98). s3.4.7-SDG (9/23/97)-added
$xiBailOpt:=$2  //s3.4.7-SDG (9/23/97)-added

C_LONGINT:C283($xlCount; $xlWin)
C_BOOLEAN:C305($fLocked)
C_TIME:C306($hDayChg; $hTimeout)

OK:=1
$xlCount:=0
<>kxiMULdExp:=5  //v3.0.2-PJK (9/29/14)


$xlWin:=Open form window:C675("MULoadRecDimensions"; Movable form dialog box:K39:8; Horizontally centered:K39:1; Vertically centered:K39:4)
SET WINDOW TITLE:C213("Locked Status")

$hTimeout:=4d_Current_time+<>kxiMULdExp  //all loops expire in <>kxiMULdExp seconds.
If ($hTimeout<?24:00:00?)  //allowance for going past midnight?
	$hDayChg:=?00:00:00?  //not needed.
Else 
	$hDayChg:=?24:00:00?  //needed.
End if 

Repeat 
	If (MULOADREC_MSG($pTable))  //s4.1.0-SDG (7/16/98)-$pTable
		DELAY PROCESS:C323(Current process:C322; 120)
		LOAD RECORD:C52($pTable->)  //s4.1.0-SDG (7/16/98)-$pTable
		$xlCount:=$xlCount+1
		$fLocked:=Locked:C147($pTable->)  //s4.1.0-SDG (7/16/98)-$pTable
		
		Case of 
			: ($fLocked=False:C215)  //we got it!
				//record loaded, exit
				
			: (($xiBailOpt=1) & ($xlCount>4))  //s3.4.7-SDG (9/23/97) bound expression inside ()
				//confirm every five attempts
				OK:=Num:C11(YESNO("The record is still in use."+" Do you want to try to load it again? "))
				
				$xlCount:=0
				
			: (($xiBailOpt=-1) & ($xlCount>4))  //s3.4.7-SDG (9/23/97)
				//auto-exit after file unsuccessful attempts
				OK:=0
				
			: (4d_Current_time>=($hTimeout+$hDayChg))
				//timeout occurred before we successfully loaded the record
				OK:=0  //exit
		End case 
		
	Else 
		ALERT:C41("The record has been deleted.")
		OK:=0
	End if 
Until (Not:C34($fLocked) | (OK=0))

CLOSE WINDOW:C154  //v2.1.8-PJK `s4.1.0-WCB-was WINDOW ("Close")

//WINDOWTITLE_OFF   `s4.1.0-WCB-added