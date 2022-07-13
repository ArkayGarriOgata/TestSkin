//OM: bShowOL() -> 
//@author mlb - 9/18/02  15:04
//◊jobform:="80669.01"

//ARRAY TEXT($aVolumes;0)
//VOLUME LIST($aVolumes)
//$hit:=Find in array($aVolumes;"EngDraw")
C_TEXT:C284($stdin; $stdout; $stderr)
$stdin:=""  //not used
$stdout:=""  //not used
$stderr:=""

If (util_MountNetworkDrive("EngDraw"))  //($hit>-1)
	
	If (aOutlineNum#0)
		
		If (<>DELIMITOR=":")  //mac
			$path:="/Volumes/EngDraw/"+aOutlineNum{aOutlineNum}+".pdf"
			zwStatusMsg("OPEN PDF"; $path)
			LAUNCH EXTERNAL PROCESS:C811("open "+$path; $stdin; $stdout; $stderr)
		Else 
			If (Length:C16(<>EngDrawing_Volume)=0)
				<>EngDrawing_Volume:=Select folder:C670("Find the EngDrawing Volume")
			End if 
			If (Length:C16(<>AdobeAcrobat)=0)
				<>AdobeAcrobat:=Select document:C905(""; "exe"; "Find the Adobe Acrobat"; Multiple files:K24:7)
			End if 
			$doc:=aOutlineNum{aOutlineNum}+".pdf"
			zwStatusMsg("OPEN PDF"; $doc+" with "+<>AdobeAcrobat)
			LAUNCH EXTERNAL PROCESS:C811(<>AdobeAcrobat+" "+<>EngDrawing_Volume+"\\"+$doc; $stdin; $stdout; $stderr)
		End if 
		If (Length:C16($stderr)>0)
			ALERT:C41("Error: "+$stderr)
		End if 
	Else 
		BEEP:C151
		ALERT:C41("Select an Size&Style File# first.")
	End if 
	
Else 
	BEEP:C151
	ALERT:C41("Couldn'd mount the ''EngDraw'' volume."; "I knew that")
End if 