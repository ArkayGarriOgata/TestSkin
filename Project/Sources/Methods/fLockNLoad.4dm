//%attributes = {"publishedWeb":true}
//fLockNLoad(->table)->true if loaded, false if locked
//10/29/94 window size increased and message changed
//$1 - pointer - to file to check for locked record
//$2 - string - anything flag, suppress locked messsage
//• 4/23/98 cs added second parameter & suppress locked message
// was -722 `v0.1.0-JJG (02/09/16) - changed from floating window to 

C_POINTER:C301($1)  //fContinue:=fLockNLoad(»[file])
C_TEXT:C284($2)
C_BOOLEAN:C305($0; $showMsg)
<>fContinue:=True:C214

If (Count parameters:C259=1)
	$showMsg:=True:C214
Else 
	$showMsg:=False:C215
End if 

If (Application type:C494=4D Server:K5:6)
	$showMsg:=False:C215
End if 

C_LONGINT:C283($state)
C_TEXT:C284($procName; $userName; $machName; $lockProcess)
C_LONGINT:C283($time; $lockProcNo; $attempts)


If (Locked:C147($1->))
	UNLOAD RECORD:C212($1->)  //in case local procedure has record locked by read only
	READ WRITE:C146($1->)
	LOAD RECORD:C52($1->)  //re load record so that if this is only a 'read only' problem it is now fixed
	
	If ($showMsg)
		ON EVENT CALL:C190("eCancelProc")
		NewWindow(480; 115; 6; Pop up window:K34:14; "Record in Use")  // was -722 `v0.1.0-JJG (02/09/16) - changed from floating window to 
	End if 
	
	If ((Locked:C147($1->)) & (<>fContinue))
		LOCKED BY:C353($1->; $lockProcNo; $userName; $machName; $lockProcess)
		PROCESS PROPERTIES:C336(Current process:C322; $procName; $state; $time)
		
		If ($showMsg)  //• 4/23/98 cs 
			ERASE WINDOW:C160
			If ($userName#"")
				MESSAGE:C88(Char:C90(13)+"   "+$procName+" is waiting for a "+Table name:C256($1)+" record  "+Char:C90(13)+Char:C90(13)+"   locked by "+$userName+"@"+$machName+" doing "+$lockProcess+Char:C90(13)+Char:C90(13)+" Press the <esc> key to ABORT!")
			Else 
				MESSAGE:C88(Char:C90(13)+"   "+$procName+" is waiting for a "+Table name:C256($1)+" record "+Char:C90(13)+Char:C90(13)+"   YOU have locked doing "+$lockProcess+Char:C90(13)+Char:C90(13)+"   Press the <esc> key to ABORT."+Char:C90(13)+Char:C90(13)+"   Or, finish that task.")
			End if 
		End if 
		
		$attempts:=0
		While ((Locked:C147($1->)) & (<>fContinue))
			If (Not:C34($showMsg))
				If ($attempts>10)
					<>fContinue:=False:C215
				End if 
			End if 
			DELAY PROCESS:C323(Current process:C322; 30)
			LOAD RECORD:C52($1->)
			$attempts:=$attempts+1
		End while 
		
		
	End if 
	
	If ($showMsg)
		ON EVENT CALL:C190("")
		CLOSE WINDOW:C154
	End if 
	
	If (Application type:C494=4D Server:K5:6)
		If (Locked:C147($1->))
			$table:=Table name:C256($1)
			utl_Logfile("recordlock.log"; "Locked: "+$table+" by "+$userName+"@Server "+$machName+" doing "+$lockProcess)
			If (Position:C15($table; " Finished_Goods Finished_Goods_Locations Customers_ReleaseSchedules Customers_Invoices")>0)
				//ToDo_postTask ("mlb";"Locked Record Error";$table+" at "+TS2String (TSTimeStamp )+" "+$procName;"00000";Current date)
			End if 
		End if 
	End if 
	
End if 
$0:=<>fContinue
//