// _______
// Method: [Users].NotifyPicker_ES.users_LB   ( ) ->
// By: Mel Bohince @ 07/16/21, 09:57:33
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		
		If (Form:C1466.currentItem.NotifyPressSchdChg<=0)
			Form:C1466.currentItem.NotifyPressSchdChg:=TSTimeStamp
		Else 
			Form:C1466.currentItem.NotifyPressSchdChg:=0
		End if 
		
End case 
