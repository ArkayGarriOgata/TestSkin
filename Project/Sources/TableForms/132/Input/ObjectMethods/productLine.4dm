If (Size of array:C274(aBrand)>0)
	If (Find in array:C230(aBrand; aBrand{0})>-1)
		[Finished_Goods_SizeAndStyles:132]Line:11:=aBrand{0}
	Else 
		BEEP:C151
		[Finished_Goods_SizeAndStyles:132]Line:11:=Old:C35([Finished_Goods_SizeAndStyles:132]Line:11)
		aBrand{0}:=[Finished_Goods_SizeAndStyles:132]Line:11
	End if 
	
Else 
	BEEP:C151
	[Finished_Goods_SizeAndStyles:132]Line:11:=Old:C35([Finished_Goods_SizeAndStyles:132]Line:11)
	aBrand{0}:=[Finished_Goods_SizeAndStyles:132]Line:11
End if 

//EOS