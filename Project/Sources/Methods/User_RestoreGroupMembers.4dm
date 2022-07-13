//%attributes = {}
//-------------------------------------------------------------------------
//from Yvan at 4D,inc
//Method: RestoreGroupMembers
//Description: This method resaves the members of your group. 

ARRAY TEXT:C222($GroupNames; 0)
ARRAY LONGINT:C221($GroupNumbers; 0)
ARRAY LONGINT:C221($CurrentGroupMembers; 0)
ARRAY LONGINT:C221($ResetGroupMembers; 0)

GET GROUP LIST:C610($GroupNames; $GroupNumbers)

For ($i; 1; Size of array:C274($GroupNumbers))
	GET GROUP PROPERTIES:C613($GroupNumbers{$i}; $name; $owner; $CurrentGroupMembers)
	//Clear members of your groups
	Set group properties:C614($GroupNumbers{$i}; $GroupNames{$i}; $owner; $ResetGroupMembers)
	//Restore group members of the groups
	Set group properties:C614($GroupNumbers{$i}; $name; $owner; $CurrentGroupMembers)
End for 

BEEP:C151
BEEP:C151