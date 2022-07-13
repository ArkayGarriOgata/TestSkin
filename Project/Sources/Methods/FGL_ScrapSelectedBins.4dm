//%attributes = {"publishedWeb":true}
//PM: FGL_ScrapSelectedBins() -> 
//@author mlb - 3/15/02  12:01

CONFIRM:C162("Scrap the selected "+String:C10(Records in selection:C76([Finished_Goods_Locations:35]))+" bins?"; "Scrap"; "Abort")
If (OK=1)
	READ WRITE:C146([Finished_Goods_Locations:35])
	CREATE SET:C116([Finished_Goods_Locations:35]; "ScrapThese")
	While (Records in set:C195("ScrapThese")>0)
		USE SET:C118("ScrapThese")
		FIRST RECORD:C50([Finished_Goods_Locations:35])
		sCriterion1:=[Finished_Goods_Locations:35]ProductCode:1
		sCriterion2:=[Finished_Goods_Locations:35]CustID:16
		rReal1:=[Finished_Goods_Locations:35]QtyOH:9
		sCriterion3:=[Finished_Goods_Locations:35]Location:2
		sCriterion4:="Sc:"
		If (Substring:C12([Finished_Goods_Locations:35]Location:2; 4; 1)="R")
			sCriterion4:=sCriterion4+"R"
		End if 
		sCriterion5:=[Finished_Goods_Locations:35]JobForm:19
		i1:=[Finished_Goods_Locations:35]JobFormItem:32
		sCriterion6:=""  //orderline
		sCriterion7:="Too old"  //reason comment
		sCriterion8:="FGL_ScrapSelectedBins"  //action taken
		sCriterion9:="Spr Clean"  //reason
		sCriter10:=<>zResp  //   skid ticket
		sCriter11:=<>zResp  //user
		sCriter12:=""  //release
		zwStatusMsg("FGL_ScrapSelectedBins"; sCriterion3+"  "+String:C10(Records in set:C195("ScrapThese"))+" remaining")
		FG_DestroyIfNotReferenced
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
			
			USE SET:C118("ScrapThese")
			CREATE SET:C116([Finished_Goods_Locations:35]; "ScrapThese")
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019 query selection
		
	End while 
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 next record
		
		CLEAR SET:C117("ScrapThese")
	Else 
		USE SET:C118("ScrapThese")
		CLEAR SET:C117("ScrapThese")
	End if   // END 4D Professional Services : January 2019 query selection
	
	BEEP:C151
	zwStatusMsg("FGL_ScrapSelectedBins"; "FINISHED")
End if 