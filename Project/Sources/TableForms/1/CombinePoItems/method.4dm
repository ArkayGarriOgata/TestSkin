// _______
// Method: [zz_control].CombinePoItems   ( ) ->
// By: Mel Bohince @ 05/19/20, 14:44:37
// Description
// 
// ----------------------------------------------------

Case of 
	: (Form event code:C388=On Clicked:K2:4)
		$hit:=Find in array:C230(ListBox1; True:C214)
		If ($hit>0)
			aBullet{$hit}:=(Num:C11(Not:C34(aBullet{$hit}="•"))*"•")+(Num:C11(aBullet{$hit}="•")*"")
			OBJECT SET ENABLED:C1123(*; "OkButton"; ($hit>0))
		Else 
			OBJECT SET ENABLED:C1123(*; "OkButton"; ($hit>0))
		End if 
		
	: (Form event code:C388=On Load:K2:1)
		For ($i; 1; Size of array:C274(aBullet))
			ListBox1{$i}:=False:C215
		End for 
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(ListBox1; True:C214)>0))
		
End case 

