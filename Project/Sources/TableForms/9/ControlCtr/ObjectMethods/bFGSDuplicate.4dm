// ----------------------------------------------------
// Object Method: [Customers_Projects].ControlCtr.bFGSDuplicate
// ----------------------------------------------------

QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=atID{abColorLB})  // Added by: Mark Zinke (3/26/13)
Pjt_setReferId(pjtId)
$tablePtr:=->[Finished_Goods_Color_SpecMaster:128]
If (Records in set:C195("clickedIncludeRecord")>0)
	UNLOAD RECORD:C212($tablePtr->)
	CUT NAMED SELECTION:C334($tablePtr->; "hold")
	USE SET:C118("clickedIncludeRecord")
	
	
	$newCSM:=CSM_duplicate([Finished_Goods_Color_SpecMaster:128]id:1)
	If (Length:C16($newCSM)=5)
		READ ONLY:C145([Finished_Goods_Color_SpecMaster:128])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=$newCSM)
			CREATE SET:C116([Finished_Goods_Color_SpecMaster:128]; "◊PassThroughSet")
			
			
		Else 
			
			SET QUERY DESTINATION:C396(Into set:K19:2; "◊PassThroughSet")
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]id:1=$newCSM)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			
		End if   // END 4D Professional Services : January 2019 
		<>PassThrough:=True:C214
		ViewSetter(2; ->[Finished_Goods_Color_SpecMaster:128])
		If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
			
			QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4=pjtId)
			ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecMaster:128]name:2; >)
			
		Else 
			
			
		End if   // END 4D Professional Services : January 2019
		
	End if 
	QUERY:C277([Finished_Goods_Color_SpecMaster:128]; [Finished_Goods_Color_SpecMaster:128]projectId:4=pjtId)
	ORDER BY:C49([Finished_Goods_Color_SpecSolids:129]; [Finished_Goods_Color_SpecMaster:128]name:2; >)
	
	//USE NAMED SELECTION("hold")
	
Else 
	uConfirm("Please select a "+"Color Spec Master"+" record(s) to update."; "OK"; "Help")
End if 