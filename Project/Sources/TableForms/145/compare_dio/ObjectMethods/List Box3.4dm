Case of 
	: (Form event code:C388=On Clicked:K2:4)
		If (Count in array:C907(ListBox3; True:C214)=1)
			$ol:=OL_findOpenMatch
			
		Else 
			
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		$ol:=OL_findOpenMatch
		For ($i; 1; Size of array:C274(ListBox2))
			If (aOrderItem{$i}=$ol)
				ListBox2{$i}:=True:C214
			Else 
				ListBox2{$i}:=False:C215
			End if 
		End for 
		
		If (Count in array:C907(ListBox2; True:C214)=1)
			OBJECT SET ENABLED:C1123(b2Edit; True:C214)
			OBJECT SET ENABLED:C1123(bDelete; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(b2Edit; False:C215)
			OBJECT SET ENABLED:C1123(bDelete; False:C215)
		End if 
		
		If (Count in array:C907(ListBox1; True:C214)=1) & (Count in array:C907(ListBox2; True:C214)=1)
			OBJECT SET ENABLED:C1123(bMatch; True:C214)
		Else 
			OBJECT SET ENABLED:C1123(bMatch; False:C215)
		End if 
		
End case 
