//%attributes = {"publishedWeb":true}
//PM: User_NotifyCheck() -> 
//@author mlb - 4/10/02  15:51
//see also User_NotifyCheck, User_NotifyAll, User_NotifySet
// Modified by: Mel Bohince (7/16/21) try to reduce rec locked msgs on press schedule
C_OBJECT:C1216($user_e; $status_o)

$user_e:=ds:C1482.Users.query("NotifyPressSchdChg > :1 and UserName = :2"; 0; Current user:C182).first()
If ($user_e#Null:C1517)  //notification requested
	BEEP:C151
	zwStatusMsg("NOTIFY"; "CHECK PRODUCTION SCHEDULE CHANGE as of "+TS2String($user_e.NotifyPressSchdChg))
	uConfirm("CHECK PRODUCTION SCHEDULE CHANGE as of "+TS2String($user_e.NotifyPressSchdChg); "Update Info"; "Help")
	
	$user_e.NotifyPressSchdChg:=0  //reset flag
	$status_o:=$user_e.save(dk auto merge:K85:24)
	If (Not:C34($status_o.success))
		ALERT:C41("Could not reset "+$entity.UserName+"'s notification flag")
	End if 
	
	JML_cacheInfoUpdate
End if 

If (False:C215)  //1st rewrite
	//READ ONLY([Users])  // Modified by: Mel Bohince (7/16/21) try to reduce rec locked msgs on press schedule
	//QUERY([Users];[Users]UserName=Current user)
	//If (Records in selection([Users])>0)
	//If ([Users]NotifyPressSchdChg#0)  //display notice to Update info, then reset flag
	//BEEP
	//zwStatusMsg ("NOTIFY";"CHECK PRODUCTION SCHEDULE CHANGE as of "+TS2String ([Users]NotifyPressSchdChg))
	//uConfirm ("CHECK PRODUCTION SCHEDULE CHANGE as of "+TS2String ([Users]NotifyPressSchdChg);"Update Info";"Help")
	
	//READ WRITE([Users])
	//QUERY([Users];[Users]UserName=Current user)
	//[Users]NotifyPressSchdChg:=0
	//SAVE RECORD([Users])
	//REDUCE SELECTION([Users];0)
	
	//JML_cacheInfoUpdate 
	
	//End if 
	
	//End if 
End if   //false


// Modified by: Mel Bohince (7/16/21) old:
//READ WRITE([Users])
//QUERY([Users];[Users]UserName=Current user)
//If (Records in selection([Users])>0) & (fLockNLoad (->[Users]))
//If ([Users]NotifyPressSchdChg#0)
//BEEP

//            $pathToChangeNotice:=Get 4D folder(Current resources folder)+"change.png"
//            If (Test path name($pathToChangeNotice)=1)
//              $errCode:=util_Launch_External_App ($pathToChangeNotice;1)
//             End if 

//zwStatusMsg ("NOTIFY";"CHECK PRODUCTION SCHEDULE CHANGE as of "+TS2String ([Users]NotifyPressSchdChg))
//uConfirm ("CHECK PRODUCTION SCHEDULE CHANGE as of "+TS2String ([Users]NotifyPressSchdChg);"Update Info";"Help")

//          If (fLockNLoad (->[Users]))

//[Users]NotifyPressSchdChg:=0
//SAVE RECORD([Users])

//             End if 

//JML_cacheInfoUpdate 

//Else   //not set
//  //               zwStatusMsg ("NOTIFY";"no change as of "+TS2String (TSTimeStamp ))
//End if 

//REDUCE SELECTION([Users];0)
//End if   //found userreco
