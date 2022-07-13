//If (Length([Finished_Goods]ColorSpecMaster)=5)

//$webpage:="CSM"+[Finished_Goods]ColorSpecMaster+".html"

//OPEN WEB URL("http://intranet.arkay.com/ams/specs/"+$webpage)

//Else 

//OPEN WEB URL("http://intranet.arkay.com/ams/specs/")

//End if 


If (Length:C16([Finished_Goods:26]ColorSpecMaster:77)>0)
	
	//QUERY([ColorSpecMaster];[ColorSpecMaster]id=[Finished_Goods]ColorSpecMaster)
	
	
	$sFile:=sFile  //cover a side effect of Viewsetter
	
	<>PassThrough:=True:C214
	CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "◊PassThroughSet")
	//REDUCE SELECTION([ColorSpecMaster];0)
	
	ViewSetter(2; ->[Finished_Goods_Color_SpecMaster:128])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
	
	
End if 