//%attributes = {"publishedWeb":true}
//PM: User_NotifySet() -> 
//@author mlb - 4/10/02  15:43
// Description
// set a flag on user record that a relevant change to the schedule has occurred.
// ----------------------------------------------------
//see also User_NotifyCheck, User_NotifyAll, User_NotifySet
// Modified by: Mel Bohince (7/16/21) rewrite with orda

C_OBJECT:C1216($form_o; $user; $subscribedUsers_es; $entity; $status_o)

//these are folk who care to know
$subscribedUsers_es:=ds:C1482.Users.query("NotifyMe = :1 and UserName # :2"; True:C214; "").orderBy("UserName")

//prep them for a dialog so that if the change isn't pertinent they don't need know, by toggling on/off
$form_o:=New object:C1471
$form_o.subscribedUsers_c:=$subscribedUsers_es.toCollection("UserName,NotifyPressSchdChg"; dk with primary key:K85:6)

//default that suggests everyone should be notified, 
For each ($user; $form_o.subscribedUsers_c)
	If ($user.NotifyPressSchdChg=0)  //leave old notices
		$user.NotifyPressSchdChg:=TSTimeStamp
	End if 
End for each 

$winRef:=Open form window:C675([Users:5]; "NotifyPicker_ES")  //present the ui
DIALOG:C40([Users:5]; "NotifyPicker_ES"; $form_o)  //allows toggling of NotifyPressSchdChg displayed as a checkmark

If (ok=1)
	//save the state of the NotifyPressSchdChg tstimestamp that the User_NotifyCheck warns user of changes
	For each ($user; $form_o.subscribedUsers_c)
		
		$entity:=ds:C1482.Users.get($user.__KEY)  //load the record
		
		If ($user.NotifyPressSchdChg#0)  //then they should be notified, save it in their user record
			$entity.NotifyPressSchdChg:=$user.NotifyPressSchdChg
		Else 
			$entity.NotifyPressSchdChg:=0  //zero out the timestamp
		End if 
		
		$status_o:=$entity.save(dk auto merge:K85:24)
		If (Not:C34($status_o.success))
			ALERT:C41("Could not set "+$entity.UserName+"'s notification flag")
		End if 
		
	End for each 
	
End if 


CLOSE WINDOW:C154($winRef)


If (False:C215)  //original method
	
	//C_TEXT($1)
	//READ WRITE([Users])
	
	//C_LONGINT($winRef;$i;$numUsers)
	//QUERY([Users];[Users]NotifyMe=True;*)
	//QUERY([Users]; & ;[Users]UserName#"")
	//ARRAY TEXT(aUserName;0)
	//ARRAY TEXT(aBullet;0)
	//ARRAY LONGINT(aRecNo;0)
	//SELECTION TO ARRAY([Users];aRecNo;[Users]UserName;aUserName)
	//REDUCE SELECTION([Users];0)
	//SORT ARRAY(aUserName;aRecNo;>)
	//$numUsers:=Size of array(aUserName)
	//ARRAY TEXT(aBullet;$numUsers)
	//If (Count parameters=1)
	//For ($i;1;$numUsers)
	//If (Position($1;aUserName{$i})>0)
	//aBullet{$i}:="•"
	//End if   //bulleted        
	//End for 
	//End if 
	
	//$winRef:=OpenSheetWindow (->[Users];"NotifyPicker")
	//DIALOG([Users];"NotifyPicker")
	//If (ok=1)
	
	//For ($i;1;$numUsers)
	//If (aBullet{$i}="•")
	//GOTO RECORD([Users];aRecNo{$i})
	//If (fLockNLoad (->[Users]))
	//[Users]NotifyPressSchdChg:=TSTimeStamp 
	//SAVE RECORD([Users])
	//End if   //locked
	//End if   //bulleted        
	//End for 
	
	//End if   //ok
	
	//CLOSE WINDOW($winRef)
	//ARRAY TEXT(aUserName;0)
	//ARRAY TEXT(aBullet;0)
	//ARRAY LONGINT(aRecNo;0)
	
	//REDUCE SELECTION([Users];0)
	
End if   //original method

