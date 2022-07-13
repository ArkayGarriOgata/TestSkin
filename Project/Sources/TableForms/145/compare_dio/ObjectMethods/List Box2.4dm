If (Count in array:C907(ListBox2; True:C214)=1)
	OBJECT SET ENABLED:C1123(b2Edit; True:C214)
	OBJECT SET ENABLED:C1123(bDelete; True:C214)
	$hit:=Find in array:C230(aOrderLine; aOrderItem{ListBox2})
	For ($i; 1; Size of array:C274(ListBox3))
		ListBox3{$i}:=False:C215
	End for 
	If ($hit>-1)
		ListBox3{$hit}:=True:C214
	End if 
	
Else 
	OBJECT SET ENABLED:C1123(b2Edit; False:C215)
	OBJECT SET ENABLED:C1123(bDelete; False:C215)
	OBJECT SET ENABLED:C1123(bMatch; False:C215)
End if 