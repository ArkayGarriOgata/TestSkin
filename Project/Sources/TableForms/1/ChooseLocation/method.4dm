// _______
// Method: [zz_control].ChooseLocation   ( ) ->
// By: Mel Bohince @ 05/18/20, 16:11:32
// Description
// 
// ----------------------------------------------------
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(addressListBox; True:C214)>0))
		
	: (Form event code:C388=On Double Clicked:K2:5)
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(addressListBox; True:C214)>0))
		ACCEPT:C269
		
	: (Form event code:C388=On Load:K2:1)
		For ($i; 1; Size of array:C274(asState))
			addressListBox{$i}:=False:C215
		End for 
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(addressListBox; True:C214)>0))
		
End case 

