//%attributes = {"publishedWeb":true}
//uTest4Security
//upr 95 10/11/94
//10/21/94 reduce IP variable size
//upr 1287 11/10/94
//this method use to limit saleman's allowable records, now use 
//[Users_Record_Accesses] with User_SetAccess, User_AllowedRecordsablename, User_GiveAccessserInitials

C_TEXT:C284(<>tSecureMsg)
C_BOOLEAN:C305(<>fisCoord; <>fisSalesRep)
C_LONGINT:C283(<>DefaultMenu)

<>fisCoord:=False:C215
<>fisSalesRep:=False:C215
If (User in group:C338(Current user:C182; "RoleRestrictedAccess"))  //keep these folk away from normal stuff
	<>DefaultMenu:=2
Else 
	<>DefaultMenu:=4
End if 
<>tSecureMsg:="You are not authorized to see this information."

//uInitPopUps proc to large
uInitPopUps1  //added to reduce proc size below 32k
ARRAY TEXT:C222(<>asWIP; 0)  // to trigger uInitPopUpsFG on FGevent before phase
uInitPopUpsRpts  //added to reduce proc size below 32k`•090195  MLB 