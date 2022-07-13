//%attributes = {}
//Method:  User_GetSystemInfoT=>tUserInformation
//Description:  This method will return user information to identify the computer
//   the request came from.

If (True:C214)  //Initialize
	
	C_TEXT:C284($0; $tUserInformation)
	
	C_OBJECT:C1216($oSystemInfo)
	
	$tUserInformation:=CorektBlank
	
	$oSystemInfo:=Get system info:C1571
	
End if   //Done Initialize

$tUserInformation:=CorektDoubleSpace+("_"*20)+CorektDoubleSpace

$tUserInformation:=$tUserInformation+"Machine Name:  "+$oSystemInfo.machineName+CorektCR
$tUserInformation:=$tUserInformation+"Account Name:  "+$oSystemInfo.accountName+CorektCR
$tUserInformation:=$tUserInformation+"User Name:  "+Current user:C182+CorektLeftParen+String:C10(Core_User_GetIdN)+CorektRightParen+CorektCR
$tUserInformation:=$tUserInformation+"Groups:  "+Core_User_GetGroupsT+CorektDoubleSpace

$tUserInformation:=$tUserInformation+"Operating System:  "+$oSystemInfo.osVersion+CorektCR
$tUserInformation:=$tUserInformation+"4D:  "+Application version:C493(*)+CorektCR
$tUserInformation:=$tUserInformation+"Processor:  "+$oSystemInfo.model+CorektCR
$tUserInformation:=$tUserInformation+"Memory:  "+String:C10($oSystemInfo.physicalMemory)+CorektCR

$0:=$tUserInformation