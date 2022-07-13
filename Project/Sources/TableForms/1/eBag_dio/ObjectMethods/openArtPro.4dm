If (Records in set:C195("clickedIncluded")>0)
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	USE SET:C118("clickedIncluded")
	
	qryFinishedGood([Job_Forms_Items:44]CustId:15; [Job_Forms_Items:44]ProductCode:3)
	zwStatusMsg("ArtPro"; " Open image of "+[Finished_Goods:26]ProductCode:1)
	
	FG_ArtProPath("view")
	
	USE NAMED SELECTION:C332("hold")
Else 
	uConfirm("Select a carton first."; "OK"; "Help")
End if 