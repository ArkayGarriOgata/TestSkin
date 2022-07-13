//OM: Button4() -> 
//@author mlb - 8/20/01  15:54
If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
	
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=(sCustId+":"+sCPN))
	If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		CREATE SET:C116([Finished_Goods_Specifications:98]; "◊PassThroughSet")
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		ViewSetter(2; ->[Finished_Goods_Specifications:98])
		sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit 
	Else 
		uConfirm("No Control # records found for "+sCustId+":"+sCPN; "OK"; "Help")
	End if 
	
Else 
	
	SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]FG_Key:1=(sCustId+":"+sCPN))
	SET QUERY DESTINATION:C396(Into current selection:K19:1)
	
	If (Records in set:C195("◊PassThroughSet")>0)
		$sFile:=sFile  //cover a side effect of Viewsetter
		<>PassThrough:=True:C214
		ViewSetter(2; ->[Finished_Goods_Specifications:98])
		sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit 
		If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
			REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
		End if 
	Else 
		uConfirm("No Control # records found for "+sCustId+":"+sCPN; "OK"; "Help")
	End if 
	
End if   // END 4D Professional Services : January 2019 
