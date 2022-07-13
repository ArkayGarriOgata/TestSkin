
GET MOUSE:C468($clickX; $clickY; $mouse_btn; *)
If (True:C214)  //(<>NEW_FEATURE)
	
	wmss_uiMoveMulti($clickX; $clickY)
	
Else 
	wmss_uiMove($clickX; $clickY)
End if 




