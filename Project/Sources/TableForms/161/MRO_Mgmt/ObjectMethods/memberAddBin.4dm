// _______
// Method: [MaintRepairSupply_Bins].ControlCenter.AddBin   ( ) ->
// By: Mel Bohince @ 08/14/19, 12:13:20
// Description
// 
// ----------------------------------------------------

$binName:=Request:C163("Bin's name?"; ""; "Save"; "Cancel")
If (ok=1)
	If (Length:C16($binName)>0) & (Length:C16($binName)<21)
		C_OBJECT:C1216($binObj; $status)
		$binObj:=ds:C1482.MaintRepairSupply_Bins.new()  //create a reference
		$binObj.Bin:=$binName  //store some information
		$status:=$binObj.save()  //save the entity
		
		If ($status.success)
			Form:C1466.bins:=ds:C1482.MaintRepairSupply_Bins.all()
			
			//Select the created bin in the list box
			// The indexOf() method will be detailed in another How do I
			LISTBOX SELECT ROW:C912(*; "ListBoxBins"; $binObj.indexOf(Form:C1466.bins)+1)
			OBJECT SET SCROLL POSITION:C906(*; "ListBoxBins"; $binObj.indexOf(Form:C1466.bins)+1)
		End if 
		
		
	Else 
		uConfirm("Bin's name can be up to 20 characters,but not blank."; "Ok"; "Help")
	End if 
End if 
