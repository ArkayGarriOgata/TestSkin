//%attributes = {}
// _______
// Method: _version210607   ( ) ->
// By: Mel Bohince @ 06/07/21, 11:00:16
// Description
// if [Users]DOT (date of termination not empty, remove Users_Record_Accesses records
// ----------------------------------------------------

C_OBJECT:C1216($user_e; $user_es; $userAccessRecords_es; $notDropped; $rtn_o)

//C_OBJECT($termenated_es)
//$termenated_es:=ds.Users.newSelection()

//clean up some inconsistencies: , 
$user_es:=ds:C1482.Users.query("UserName = :1 and DOT = :2"; ""; !00-00-00!)  //if no username, there should be a DOT
For each ($user_e; $user_es)  // terminated employee
	
	$user_e.DOT:=<>MAGIC_DATE  //this is just interesting data
	$rtn_o:=$user_e.save()
	If (Not:C34($rtn_o.success))
		TRACE:C157
	End if 
	
End for each 

$user_es:=ds:C1482.Users.query("UserName # :1 and DOT # :2"; ""; !00-00-00!)  //if there is a DOT, then should not have a username
For each ($user_e; $user_es)  // terminated employee
	
	$user_e.UserName:=""  //this prevents logging in
	$rtn_o:=$user_e.save()
	If (Not:C34($rtn_o.success))
		TRACE:C157
	End if 
	
End for each 

$user_es:=ds:C1482.Users.query("UserName = :1"; "")  //this is a selection of user that have been terminated

$userAccessRecords_es:=ds:C1482.Users_Record_Accesses.newSelection()  //these will be the gathered records to remove

//C_LONGINT($recsToDelete)
//$recsToDelete:=0

For each ($user_e; $user_es)  // terminated employee
	
	If ($user_e.RECORD_ACCESSES.length>0)  //who had been given accesses
		
		//$recsToDelete:=$recsToDelete+$user_e.RECORD_ACCESSES.length
		//$termenated_es.add($user_e)//for testing
		
		$userAccessRecords_es:=$userAccessRecords_es.or($user_e.RECORD_ACCESSES)  //gather there accesses
		
	End if 
	
End for each 

BEEP:C151  //hey, we made it to here!

If ($userAccessRecords_es.length>0)
	CONFIRM:C162("Delete "+String:C10($userAccessRecords_es.length)+" user access records?"; "Delete"; "Abort")
	If (ok=1)
		
		$notDropped:=$userAccessRecords_es.drop()
		If ($notDropped.length>0)
			ALERT:C41(String:C10($notDropped.length)+" records were locked and not removed.")
		End if 
		
	Else 
		ALERT:C41("No changes were made.")
	End if 
	
Else   //none found
	ALERT:C41("No defucnt access records found, no changes were made.")
End if 


If (False:C215)  //testing in application process
	//USE ENTITY SELECTION($user_es)
	//USE ENTITY SELECTION($termenated_es)
	//USE ENTITY SELECTION($userAccessRecords_es)
End if   //testing

