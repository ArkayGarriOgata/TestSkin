//%attributes = {}
//Method: Core_GetGroupAccessC=>cGroupsUserBelongsTo
//Description:  This method will return the groups the current user
//   belongs to.  (Prep for v19 where it can be replaced

If (True:C214)  //Initialize
	
	C_COLLECTION:C1488($0; $cGroups)
	
	C_TEXT:C284($tSeperator; $tGroups)
	
	$cGroup:=New collection:C1472()
	
	$tSeperator:=CorektComma+CorektSpace
	
	$tGroups:=CorektBlank
	
End if   //Done initialize

$tGroups:=Core_User_GetGroupsT()

$cGroups:=Split string:C1554($tGroups; $tSeperator)

$0:=$cGroups