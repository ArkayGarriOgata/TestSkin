// _______
// Method: [Job_Forms_Items].PickJobitFromList.ListBox   ( ) ->
// By: Mel Bohince @ 09/23/19, 11:52:07
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($user_obj)
$user_obj:=Form:C1466.currItem
C_TEXT:C284(userInitials)
userInitials:=$user_obj.Initials

Case of 
	: (Form event code:C388=On Double Clicked:K2:5)
		ACCEPT:C269
		
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "Select"; True:C214)
End case 
