//OM: MAD() -> 

//@author mlb - 3/4/03  12:35

If (Records in selection:C76([Job_Forms_Items:44])>0)
	$mad:=[Job_Forms_Items:44]MAD:37
	If (Not:C34(<>modification4D_28_02_19))  // BEGIN 4D Professional Services : January 2019 Sets 4 
		
		CREATE SET:C116([Job_Forms_Items:44]; "setMad")
		APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37:=$mad)
		USE SET:C118("setMad")
		CLEAR SET:C117("setMad")
		
	Else 
		
		$position_in_selection:=Selected record number:C246([Job_Forms_Items:44])
		APPLY TO SELECTION:C70([Job_Forms_Items:44]; [Job_Forms_Items:44]MAD:37:=$mad)
		GOTO SELECTED RECORD:C245([Job_Forms_Items:44]; $position_in_selection)
		
	End if   // END 4D Professional Services : January 2019 
	
End if 