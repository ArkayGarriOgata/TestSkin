//%attributes = {"publishedWeb":true}
//(P) NotifyPrefDlog
//open user preference dlog, let user set what notifications to use
//6/24/97 cs created
//• 7/31/97 cs added many delay process to try to get the notifier window to close
// when needed

NewWindow(240; 265; 0; 8; "Notification Preferences")
READ WRITE:C146([Users:5])
QUERY:C277([Users:5]; [Users:5]Initials:1=<>zResp)
//load/lock record
DIALOG:C40([Users:5]; "Preferences")

If (OK=1)  //user set preferences
	$Pref:=""
	
	If (Find in array:C230(aBullet; "√")>0)
		For ($i; 1; Size of array:C274(aBullet))  //for each item in the bullet array
			If (aBullet{$i}="√")  //check whether the user wants that noticifcation
				$Pref:=$Pref+(";"*Num:C11($Pref#""))  //if so set it up
				$Pref:=$Pref+<>aUserPrefs{$i}
			End if 
		End for 
		$Pref:=$Pref+"•"+String:C10(iMinutes)  //add the time interval
	End if 
	[Users:5]Preference:14:=$Pref  //save into user record
	SAVE RECORD:C53([Users:5])
	$Id:=uProcessID("$•NotifyDeamon")  //update notification deamon
	<>xPrefText:=[Users:5]Preference:14
	<>PrefTime:=iMinutes
	DELAY PROCESS:C323(Current process:C322; 10)  //dedlay to allow var to be updated for other processes
	
	If ($ID>0)
		Case of 
			: (<>PrefTime>0) & (<>xPrefText#"")
				RESUME PROCESS:C320($ID)
				DELAY PROCESS:C323(Current process:C322; 60)  //dedlay to allow var to be updated for other processes
				POST OUTSIDE CALL:C329($ID)
				
			: (<>PrefTime=0) | (<>xPrefText="")
				<>fQuitNotify:=True:C214  //set this flag so that the following processes are closed down
				<>xMsgText:=""
				DELAY PROCESS:C323(Current process:C322; 10)  //dedlay to allow var to be updated for other processes      
				RESUME PROCESS:C320($ID)  //call and cancel notifier window
				DELAY PROCESS:C323(Current process:C322; 60)  //dedlay to allow var to be updated for other processes
				POST OUTSIDE CALL:C329($ID)
				$Id:=uProcessID("$•Notifier")  //update notification deamo
				
				If ($ID>0)  //notifier window open
					RESUME PROCESS:C320($ID)  //call and cancel notifier window
					DELAY PROCESS:C323(Current process:C322; 10)  //dedlay to allow var to be updated for other processes
					POST OUTSIDE CALL:C329($ID)
				End if 
				<>fQuitNotify:=False:C215  //reset - do not close other proceses
		End case 
	Else 
		If (<>PrefTime=0) | (<>xPrefText="")  //• 7/31/97 cs make sure that system closeds notifier if tim e= zero
			<>fQuitNotify:=True:C214  //set this flag so that the following processes are closed down
			<>xMsgText:=""
			DELAY PROCESS:C323(Current process:C322; 10)  //dedlay to allow var to be updated for other processes
			
			RESUME PROCESS:C320($ID)  //call and cancel notifier deamon
			DELAY PROCESS:C323(Current process:C322; 60)  //dedlay to allow var to be updated for other processes      
			POST OUTSIDE CALL:C329($ID)
			$Id:=uProcessID("$•Notifier")  //update notification deamo
			
			If ($ID>0)  //notifier window open
				RESUME PROCESS:C320($ID)  //call and cancel notifier window
				DELAY PROCESS:C323(Current process:C322; 10)  //dedlay to allow var to be updated for other processes      
				POST OUTSIDE CALL:C329($ID)
			End if 
			<>fQuitNotify:=False:C215  //reset - do not close other proceses      
		Else 
			NotifierSpawn
		End if 
	End if 
	
End if 
uClearSelection(->[Users:5])
CLOSE WINDOW:C154
ARRAY TEXT:C222(aBullet; 0)
uWinListCleanup