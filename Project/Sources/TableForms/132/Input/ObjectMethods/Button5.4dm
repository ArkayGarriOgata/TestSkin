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
	If (<>DELIMITOR=":")  //mac
		$path:="/Volumes/EngDraw/"+[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+".pdf"
		zwStatusMsg("OPEN PDF"; $path)
		LAUNCH EXTERNAL PROCESS:C811("open "+$path; $stdin; $stdout; $stderr)
	Else 
		If (Length:C16(<>EngDrawing_Volume)=0)
			<>EngDrawing_Volume:=Select folder:C670("Find the EngDrawing Volume")
		End if 
		If (Length:C16(<>AdobeAcrobat)=0)
			<>AdobeAcrobat:=Select document:C905(""; "exe"; "Find the Adobe Acrobat"; Multiple files:K24:7)
		End if 
		$doc:=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1+".pdf"
		zwStatusMsg("OPEN PDF"; $path)
		LAUNCH EXTERNAL PROCESS:C811(<>AdobeAcrobat+" "+<>EngDrawing_Volume+"\\"+$doc; $stdin; $stdout; $stderr)
	End if 
	
	Case of 
		: (ok=1)
			//should have worked
		: (Length:C16($error)>0)
			ALERT:C41("Error: "+$error)
			
		: (ok=0)
			BEEP:C151
			ALERT:C41($path+" could not be found. Contact Imaging."; "Shucks")
			
		: ($errCode#1)
			BEEP:C151
			ALERT:C41("Error# "+String:C10($errCode)+" occurred opening "+$path; "Dang")
			
	End case 
	
Else 
	BEEP:C151
	ALERT:C41("Couldn'd mount the ''EngDraw'' volume."; "I knew that")
End if 