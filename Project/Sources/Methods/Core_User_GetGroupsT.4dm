//%attributes = {}
//Method:  Core_User_GetGroupsT({tUserName}{;patGroup}{;panGroupID})=>tGroups
//Description:  This method 

If (True:C214)  //Initialize 
	
	C_POINTER:C301($2; $patGroup; $3; $panGroupID)
	C_TEXT:C284($1; $tUserName; $0; $tGroups)
	
	C_LONGINT:C283($nNumberOfParameters)
	C_TEXT:C284($tUserName; $tPassword)
	C_LONGINT:C283($nNumberOfLogins; $nUserGroupOwner)
	C_LONGINT:C283($nGroupID; $nNumberOfGroupIDs)
	C_DATE:C307($dLastLogin)
	
	ARRAY TEXT:C222($atGroup; 0)
	ARRAY LONGINT:C221($anGroupID; 0)
	
	$nNumberOfParameters:=Count parameters:C259
	
	$tUserName:=Current user:C182
	$patGroup:=->$atGroup
	$panGroupID:=->$anGroupID
	
	If ($nNumberOfParameters>=1)  //Parameters
		$tUserName:=$1
		If ($nNumberOfParameters>=2)
			$patGroup:=$2
			If ($nNumberOfParameters>=3)
				$panGroupID:=$3
			End if 
		End if 
	End if   //Done parameters
	
End if   //Done Initialize

$nUserId:=Core_User_GetIdN($tUserName)

GET USER PROPERTIES:C611($nUserID; \
$tUserName; \
$tStartUp; \
$tPassword; \
$nNumberOfLogins; \
$dLastLogin; \
$panGroupID->; \
$nUserGroupOwner)

GET GROUP LIST:C610($atAllGroupName; $anAllGroupID)

$nNumberOfGroupIDs:=Size of array:C274($panGroupID->)

For ($nGroupID; 1; $nNumberOfGroupIDs)  //Loop through GroupID
	
	$nGroupIdLocation:=Find in array:C230($anAllGroupID; $panGroupID->{$nGroupID})
	
	If ($nGroupIdLocation#CoreknNoMatchFound)
		APPEND TO ARRAY:C911($patGroup->; $atAllGroupName{$nGroupIdLocation})
	Else 
		APPEND TO ARRAY:C911($patGroup->; "Not a Group")
	End if 
	
	$tGroups:=$tGroups+\
		$patGroup->{$nGroupID}+\
		CorektSpace+CorektLeftParen+\
		String:C10($panGroupID->{$nGroupID})+\
		CorektRightParen+CorektComma+CorektSpace
	
End for   //Done looping through GroupID

$tGroups:=Substring:C12($tGroups; 1; Length:C16($tGroups)-2)  //Remove CorektComma+CorektSpace

$0:=$tGroups
