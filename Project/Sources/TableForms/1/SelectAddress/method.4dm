//jml 7/6/93  used by gSetAddrType()
Case of 
	: (Form event code:C388=On Clicked:K2:4)
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(ListBox1; True:C214)>0))
		
	: (Form event code:C388=On Double Clicked:K2:5)
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(ListBox1; True:C214)>0))
		ACCEPT:C269
		
	: (Form event code:C388=On Load:K2:1)
		For ($i; 1; Size of array:C274(asAddrTypes))
			ListBox1{$i}:=False:C215
		End for 
		OBJECT SET ENABLED:C1123(*; "OkButton"; (Find in array:C230(ListBox1; True:C214)>0))
		
End case 