If (aGlueListBox>0)
	READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
	QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=aOutline{aGlueListBox})
	pattern_PassThru(->[Finished_Goods_SizeAndStyles:132])
	ViewSetter(3; ->[Finished_Goods_SizeAndStyles:132])
	
Else 
	uConfirm("You Must a row first."; "OK"; "Help")
End if 