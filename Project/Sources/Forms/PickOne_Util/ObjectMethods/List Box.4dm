// _______
// Method: PickOne.List Box   ( ) ->
// By: Mel Bohince @ 05/05/20, 08:19:46
// Description
// 
// ----------------------------------------------------


Case of 
	: (Form event code:C388=On Load:K2:1)
		OBJECT SET ENABLED:C1123(*; "okButton"; (Form:C1466.choicePosition>0))
		
	: (Form event code:C388=On Double Clicked:K2:5)
		ACCEPT:C269
		
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "okButton"; (Form:C1466.choicePosition>0))
		
End case 
