//If (Length([Finished_Goods]ColorSpecMaster)=5)
//$webpage:="CSM"+[Finished_Goods]ColorSpecMaster+".html"
//OPEN WEB URL("http://intranet.arkay.com/ams/specs/"+$webpage)
//Else 
//OPEN WEB URL("http://intranet.arkay.com/ams/specs/")
//End if 

If (Length:C16([Finished_Goods_Specifications:98]ColorSpecMaster:70)>0)
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=[Finished_Goods_Specifications:98]ColorSpecMaster:70)
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "◊PassThroughSet")
		
		
	Else 
		
		SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
		QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=[Finished_Goods_Specifications:98]ColorSpecMaster:70)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		
	End if   // END 4D Professional Services : January 2019 
	//REDUCE SELECTION([ColorSpecMaster];0)
	ViewSetter(2; ->[Finished_Goods_Color_SpecMaster:128])
	sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
	
Else 
	uConfirm("Enter the unique id for ColorSpecificationMaster first."; "OK"; "Help")
End if 