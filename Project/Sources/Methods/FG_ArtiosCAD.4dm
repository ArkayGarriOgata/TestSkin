//%attributes = {}
// -------
// Method: FG_ArtiosCAD   ( ) ->
// By: Mel Bohince @ 07/15/16, 13:15:02
// Description
// 
// ----------------------------------------------------

C_TEXT:C284($1; $tFileName)

C_TEXT:C284($stdin; $stdout; $stderr)

$tFileName:=$1

$stdin:=""  //not used
$stdout:=""  //not used
$stderr:=""

If (util_MountNetworkDrive("EngDraw"))  //EngDraw
	
	If (<>DELIMITOR=":")  //mac
		
		$path:="/Volumes/EngDraw/"+$tFileName+".pdf"
		
		zwStatusMsg("OPEN PDF"; $path)
		LAUNCH EXTERNAL PROCESS:C811("open "+$path; $stdin; $stdout; $stderr)
		
	Else   //windows
		
		If (Length:C16(<>EngDrawing_Volume)=0)
			<>EngDrawing_Volume:=Select folder:C670("Find the EngDrawing Volume")
		End if 
		
		If (Length:C16(<>AdobeAcrobat)=0)
			<>AdobeAcrobat:=Select document:C905(""; "exe"; "Find the Adobe Acrobat"; Multiple files:K24:7)
		End if 
		
		$doc:=$tFileName+".pdf"
		
		zwStatusMsg("OPEN PDF"; $doc+" with "+<>AdobeAcrobat)
		LAUNCH EXTERNAL PROCESS:C811(<>AdobeAcrobat+" "+<>EngDrawing_Volume+"\\"+$doc; $stdin; $stdout; $stderr)
		
		
	End if   //Done mac
	
	If (Length:C16($stderr)>0)
		ALERT:C41("Error: "+$stderr)
	End if 
	
Else   //No engdraw
	
	BEEP:C151
	ALERT:C41("Couldn'd mount the ''EngDraw'' volume."; "Dang")
	
End if   //Done engdraw
