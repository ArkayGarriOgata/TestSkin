//%attributes = {}
// Method: FG_LaunchItemInit () -> 
// ----------------------------------------------------
// by: mel: 06/01/04, 10:39:36
// ----------------------------------------------------
// Description:
//load the array in its own process so current selection isn't screwed
// ----------------------------------------------------
// Modified by: Mel Bohince (5/6/16) change expiration from 2 hours to 1/2 hr

C_LONGINT:C283($hit; $currentExpireAt; expireAt)
C_BOOLEAN:C305($serverMethodDone; serverMethodDone)
C_TEXT:C284(process_name; $1)

process_name:="FG_LaunchItems"

Case of 
	: (Count parameters:C259=0)
		$serverMethodDone:=False:C215
		<>SERVER_PID_LAUNCH:=Process number:C372(process_name; *)
		If (<>SERVER_PID_LAUNCH#0)
			GET PROCESS VARIABLE:C371(<>SERVER_PID_LAUNCH; expireAt; $currentExpireAt)
			//add a minute to expire time to be safe
			SET PROCESS VARIABLE:C370(<>SERVER_PID_LAUNCH; expireAt; ($currentExpireAt+(60*1)))
			
		Else 
			utl_LogfileServer(<>zResp; "FG_LaunchItemInit exec"; "fg_pick.log")
			<>SERVER_PID_LAUNCH:=Execute on server:C373("FG_LaunchItemInit"; <>lMinMemPart; process_name; "init")
			If (False:C215)
				FG_LaunchItemInit
			End if 
		End if 
		
		While (Not:C34($serverMethodDone))
			DELAY PROCESS:C323(Current process:C322; 30)
			GET PROCESS VARIABLE:C371(<>SERVER_PID_LAUNCH; serverMethodDone; $serverMethodDone)
		End while 
		
		ARRAY TEXT:C222(<>FGLaunchItem; 0)
		ARRAY TEXT:C222(<>FGLaunchItemHold; 0)
		GET PROCESS VARIABLE:C371(<>SERVER_PID_LAUNCH; FGLaunchItem; <>FGLaunchItem; FGLaunchItemHold; <>FGLaunchItemHold)
		
	: ($1="init")  //fire the sucker up
		serverMethodDone:=False:C215
		//die after 0.5 hours
		expireAt:=TSTimeStamp+(60*60*0.5)
		
		ARRAY TEXT:C222(FGLaunchItem; 0)
		ARRAY TEXT:C222(FGLaunchItemHold; 0)
		
		$hit:=qryLaunch
		SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; FGLaunchItem)
		
		QUERY SELECTION:C341([Finished_Goods:26]; [Finished_Goods:26]DateLaunchApproved:85=!00-00-00!)
		SELECTION TO ARRAY:C260([Finished_Goods:26]ProductCode:1; FGLaunchItemHold)
		REDUCE SELECTION:C351([Finished_Goods:26]; 0)
		
		serverMethodDone:=True:C214
		
		While (TSTimeStamp<expireAt)  //wait for the client to get the arrays
			IDLE:C311
			DELAY PROCESS:C323(Current process:C322; (60*10))
		End while 
		//utl_Logfile ("server.log";"FG_LaunchItems ended")
		
	: ($1="die!")  //called by On Server Shutdown
		server_pid:=Process number:C372(process_name; *)
		If (server_pid#0)
			SET PROCESS VARIABLE:C370(server_pid; expireAt; 0)
			DELAY PROCESS:C323(server_pid; 0)  //give the server a moment to start
		End if 
		utl_Logfile("server.log"; "FG_LaunchItemInit (die!) pid = "+String:C10(server_pid)+" called.")
		
End case 