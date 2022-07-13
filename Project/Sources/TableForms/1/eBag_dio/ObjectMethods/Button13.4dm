If (Records in set:C195("clickedIncluded")>0)
	
	CUT NAMED SELECTION:C334([Job_Forms_Items:44]; "hold")
	
	USE SET:C118("clickedIncluded")
	
	Arts_PlayVideo([Job_Forms_Items:44]OutlineNumber:43)
	
	USE NAMED SELECTION:C332("hold")
	
Else 
	
	uConfirm("Select a carton first."; "OK"; "Help")
	
End if 
