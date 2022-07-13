//OM: bShow() -> 
//@author mlb - 9/18/02  15:04
//OM: bShowOL() -> 
//@author mlb - 9/18/02  15:04
//◊jobform:="80669.01"
//ARRAY TEXT($aVolumes;0)
//VOLUME LIST($aVolumes)
//$hit:=Find in array($aVolumes;"PDF")

If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	USE SET:C118("clickedIncluded")
	
	If (util_MountNetworkDrive("Released PDF"))  //($hit>-1)
		$path:="Released PDF:"+[Job_Forms_Items:44]ProductCode:3+".pdf"
		zwStatusMsg("Launch"; $path)
		$errCode:=util_Launch_External_App($path)
		
		Case of 
			: ($errCode=-43)
				BEEP:C151
				ALERT:C41($path+" could not be found. Contact Imaging."; "Shucks")
				
			: ($errCode#0)
				BEEP:C151
				ALERT:C41("Error# "+String:C10($errCode)+" occurred opening"+$path; "Dang")
		End case 
		
	Else 
		BEEP:C151
		ALERT:C41("Connect to 192.168.2.50(viewer:view), and mount Released PDF"; "I knew that")
	End if 
	
	USE NAMED SELECTION:C332("hold")
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 