//%attributes = {"publishedWeb":true}
//(P) Startup  - Standard Start-up procedure
//modified 9/26/94 for phy inv
//1/24/95 changed alert message
//•090195  MLB  put main palette in own process
//•122298  MLB  UPR offer to skip startup if designer, for creating empty datafile
//zSetUsageStat ("StartUp";"";"")
//•04/11/05 - DJC set LiveSync_Installed var to False
// Added by: Garri Ogata (11/17/20) Core_Server_LogInTest it quits if user is trying to log into
//. the test server and shouldn't be

//$pid:=New process("util_splashScreen";16*1024;"$splash")

UPDATE_INIT  //v1.0.0-PJK (12/7/15) Check for Automatic update methods to execute for this version

CompileInterP

util_SetSystemDelimitor
<>PATH_TO_LOG_FILE:=util_PathToLogFile("aMs")

<>CurrentUser:=Current user:C182

// Added by: Garri (4/1/20) //Description: This method will save the users system info 
UrWk_SaveSystemInfo
Core_Server_LogInTest  //Added to protect users from logging into the test server by mistake

HIDE TOOL BAR:C434

SET WINDOW TITLE:C213("aMs")
Case of 
	: (Semaphore:C143("InventoryFrz"))  //test for Inventory Activity, if true Inventory is Active
		ALERT:C41("Logins are Currently Disabled."+" This may be Due to a High Volume of Logins."+" Please try Logging in Again in 5 min."+Char:C90(13)+"If this is the Second Time you Have Received this Message, "+"Inventory is In Progress.  Please Try Again in 1 hour.")
		QUIT 4D:C291  //then quit
	: (Semaphore:C143("EndInventory"))  //test for Inventory Activity, if true Inventory is Active
		ALERT:C41("Logins are Currently Disabled."+" This may be Due to a High Volume of Logins."+" Please try Logging in Again in 5 min."+Char:C90(13)+"If this is the Second Time you Have Received this Message, "+"Inventory is In Progress.  Please Try Again in 1 hour.")
		QUIT 4D:C291  //then quit
		
	Else   //inventory NOT active continue
		CLEAR SEMAPHORE:C144("InventoryFrz")
		CLEAR SEMAPHORE:C144("EndInventory")
		gStartUp
		Updates  // Added by: Mark Zinke (10/22/12)
		UserPrefsWindowRecord  // Added by: Mark Zinke (1/31/13)
		<>StatusBar:=New process:C317("zwStatusBar"; <>lMinMemPart; "$StatusBar")
		
		If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))  //keep these folk away from normal stuff
			$errCode:=uSpawnPalette("Rama_OpenPalette"; "Rama Palette")
			
		Else 
			$errCode:=uSpawnPalette("mMainEvent"; "$Main Palette")
		End if 
		
		If (Substring:C12(Current user:C182; 1; 5)="Press")
			PS_PressScheduleUI
		End if 
		
		If (Substring:C12(Current user:C182; 1; 4)="Glue")  // Modified by: Mel Bohince (2/4/16) 
			PSG_All
		End if 
		
		If (User in group:C338(Current user:C182; "DataCollection"))
			//JOB_ShiftCard 
		End if 
		
		READ ONLY:C145([To_Do_Tasks:100])
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]AssignedTo:9=Current user:C182; *)
		QUERY:C277([To_Do_Tasks:100];  & ; [To_Do_Tasks:100]Done:4=False:C215)
		If (Records in selection:C76([To_Do_Tasks:100])>0)
			REDUCE SELECTION:C351([To_Do_Tasks:100]; 0)
			ToDo_UI
		End if 
End case 

SetUserDefaultWindows  //Added by: Mark Zinke (12-6-12)

If (User in group:C338(Current user:C182; "RoleSuperUser"))
	util_MainWindowVisible("Show")
End if 

IdleMonitor_Start  //v0.1.0-JJG (02/03/16) - added 