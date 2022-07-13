If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	USE SET:C118("clickedIncluded")
	
	<>JOBIT:=[Job_Forms_Items:44]Jobit:4
	If (Length:C16(<>JOBIT)=11)
		$i:=qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
		If ($i>0)
			If (Length:C16([Finished_Goods:26]ColorSpecMaster:77)>0)
				READ ONLY:C145([Finished_Goods_Color_SpecMaster:128])
				If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
					
					QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=[Finished_Goods:26]ColorSpecMaster:77)
					
					$sFile:=sFile  //cover a side effect of Viewsetter
					<>PassThrough:=True:C214
					CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "◊PassThroughSet")
					
				Else 
					
					SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
					QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=[Finished_Goods:26]ColorSpecMaster:77)
					SET QUERY DESTINATION:C396(Into current selection:K19:1)
					
					$sFile:=sFile  //cover a side effect of Viewsetter
					<>PassThrough:=True:C214
					
				End if   // END 4D Professional Services : January 2019 
				
				//REDUCE SELECTION([ColorSpecMaster];0)
				ViewSetter(2; ->[Finished_Goods_Color_SpecMaster:128])
				sFile:=$sFile  //Table name(->[Request])  `reset this for normal exit
				
				//End if 
				//
				//If (Length([Finished_Goods]ColorSpecMaster)=5)
				//$webpage:="CSM"+[Finished_Goods]ColorSpecMaster+".html"
				//OPEN WEB URL("http://intranet.arkay.com/ams/specs/"+$webpage)
			Else 
				uConfirm("Color spec not designated for "+[Job_Forms_Items:44]ProductCode:3; "OK"; "Help")
			End if 
		Else 
			uConfirm("Product Code "+[Job_Forms_Items:44]ProductCode:3+" was not found."; "OK"; "Help")
		End if 
	Else 
		uConfirm("Jobit "+<>JOBIT+" is not the corrent length."; "OK"; "Help")
	End if 
	
	USE NAMED SELECTION:C332("hold")
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 