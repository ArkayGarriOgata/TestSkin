If (Size of array:C274(aPriority)>0)
	[Finished_Goods_SizeAndStyles:132]Priority:47:=Num:C11(aPriority{0})
	
Else 
	BEEP:C151
	[Finished_Goods_SizeAndStyles:132]Priority:47:=Old:C35([Finished_Goods_SizeAndStyles:132]Priority:47)
	aPriority{0}:=String:C10([Finished_Goods_SizeAndStyles:132]Priority:47)
End if 