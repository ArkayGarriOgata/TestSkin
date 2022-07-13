//%attributes = {}
// ----------------------------------------------------
// User name (OS): mel
// Date and time: 11/19/09, 14:47:00
// ----------------------------------------------------
// Method: util_Launch_External_App(path)
// Description
// replace the functionality of AP Sublaunch
//// and $err:=AP ShellExecute (docName)
// Parameters
// Modified by: Garri Ogata (9/14/21) Add $2:$bAlert so Alerts can be suppressed
// ----------------------------------------------------

C_TEXT:C284($stdin; $stdout; $stderr; $path; $1; $tPathName)
C_BOOLEAN:C305($2; $bAlert)
C_LONGINT:C283($0)  //error occurred if not zero

$tPathName:=$1

$bAlert:=True:C214

If (Count parameters:C259>=2)
	$bAlert:=$2
End if 

$stdin:=""  //not used
$stdout:=""  //not used
$stderr:=""

If (<>DELIMITOR=":")  //mac
	$path:="/Volumes/"+Replace string:C233($tPathName; ":"; "/")  //"/Volumes/EngDraw/"+aOutlineNum{aOutlineNum}+".pdf"
	$path:=Replace string:C233($path; " "; "\\ ")  //doesn't like spaces
	zwStatusMsg("OPEN"; $path)
	LAUNCH EXTERNAL PROCESS:C811("open "+$path; $stdin; $stdout; $stderr)
	///Volumes/laptop/Users/mel/Documents/AMS_Documents/FG_Inv_Ord_Fcst091119_1522
Else   //Windows
	$path:=util_getPathFromLongName($tPathName)
	$doc:=HFSShortName($1)  //aOutlineNum{aOutlineNum}+".pdf"
	
	If (Position:C15(".pdf"; $doc)>0)
		If (Length:C16(<>AdobeAcrobat)=0)
			<>AdobeAcrobat:=Select document:C905(""; "exe"; "Find the Adobe Acrobat"; Multiple files:K24:7)
		End if 
		zwStatusMsg("OPEN PDF"; $doc+" with "+<>AdobeAcrobat)
		LAUNCH EXTERNAL PROCESS:C811(<>AdobeAcrobat+" "+$path+"\\"+$doc; $stdin; $stdout; $stderr)
		
	Else 
		
		If ($bAlert)
			
			BEEP:C151
			ALERT:C41("Can only open pdf's on Windows")
			
		End if 
		
	End if 
	
End if   //Done mac

If ((Length:C16($stderr)>0) & ($bAlert))
	ALERT:C41("Error: "+$stderr)
End if 
$0:=Length:C16($stderr)