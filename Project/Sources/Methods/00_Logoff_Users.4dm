//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/16/06, 12:20:43
// ----------------------------------------------------
// Method: 00_Logoff_Users
// Description:
// Suggest to user to get out immediately
// ----------------------------------------------------

READ WRITE:C146([z___Kill_User_Processes:50])
ALL RECORDS:C47([z___Kill_User_Processes:50])

If (Records in selection:C76([z___Kill_User_Processes:50])=0)
	CREATE RECORD:C68([z___Kill_User_Processes:50])
End if 

CONFIRM:C162("Set [z___Kill_User_Processes]_STOP_NOW_ flag to TRUE"; "YES"; "NO")
If (OK=1)
	[z___Kill_User_Processes:50]_STOP_NOW_:2:=True:C214
	
Else 
	[z___Kill_User_Processes:50]_STOP_NOW_:2:=False:C215
End if 

SAVE RECORD:C53([z___Kill_User_Processes:50])
REDUCE SELECTION:C351([z___Kill_User_Processes:50]; 0)