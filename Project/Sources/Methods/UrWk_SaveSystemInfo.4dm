//%attributes = {}
//Method: UrWk_SaveSystemInfo
//Description: This mehtod will save the users system info 
// as they log onto the aMs

If (True:C214)  //Initialize
	
	C_OBJECT:C1216($oSystemInfo)
	
	$oSystemInfo:=Get system info:C1571
	
End if   //Done Initialize

QUERY BY ATTRIBUTE:C1331([User_Workstation:95]; \
[User_Workstation:95]SystemInformation:2; \
"machineName"; "="; $oSystemInfo.machineName; *)
QUERY BY ATTRIBUTE:C1331([User_Workstation:95];  & ; \
[User_Workstation:95]SystemInformation:2; \
"accountName"; "="; $oSystemInfo.accountName; *)
QUERY BY ATTRIBUTE:C1331([User_Workstation:95];  & ; \
[User_Workstation:95]SystemInformation:2; \
"userName"; "="; $oSystemInfo.userName)

Util_UniqueRecord(->[User_Workstation:95])  //Assure combination of machineName, accountName and userName are unique

[User_Workstation:95]SystemInformation:2:=$oSystemInfo

[User_Workstation:95]RecordedOn:3:=Current date:C33(*)
[User_Workstation:95]RecordedAt:4:=Current time:C178(*)

[User_Workstation:95]Platform:5:=Util_GetPlatformN

Util_Save(->[User_Workstation:95])
