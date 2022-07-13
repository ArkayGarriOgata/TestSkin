//PM: FG_PrepServiceExisting() -> 
//@author mlb - 8/20/01  15:44
If (Length:C16([Finished_Goods:26]OutLine_Num:4)>0)
	
	//QUERY([SizeAndStyle];[SizeAndStyle]FileOutlineNum=[Finished_Goods]OutLine_Num)
	
	$sFile:=sFile  //cover a side effect of Viewsetter
	<>PassThrough:=True:C214
	CREATE SET:C116([Finished_Goods_SizeAndStyles:132]; "◊PassThroughSet")
	//REDUCE SELECTION([SizeAndStyle];0)
	ViewSetter(2; ->[Finished_Goods_SizeAndStyles:132])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
	
End if 