//%attributes = {}
// _______
// Method: RM_ColdFoil_Reverse_Issue   ( ) ->
// By: Mel Bohince @ 10/28/21, 13:03:19
// Description
// 
// ----------------------------------------------------

C_OBJECT:C1216($1; $selectedRMX_e; $rmx_o; $newRMX_e; $rml_e; $status_o)

$selectedRMX_e:=$1  //seclected entity from cold foil list box on eBag



If ($selectedRMX_e#Null:C1517)  //trans selected in ListBox
	CONFIRM:C162("Reverse Issue "+String:C10($selectedRMX_e.Qty)+" of "+$selectedRMX_e.POItemKey+"?"; "Reverse"; "Cancel")
	If (ok=1)  //do it
		$rmx_o:=$selectedRMX_e.toObject()  //make a deep copy
		//fix some things for new transaction
		$rmx_o.Qty:=$rmx_o.Qty*-1  //reverse the qty
		$rmx_o.ActExtCost:=$rmx_o.ActExtCost*-1
		$rmx_o.XferDate:=Current date:C33  //tdy up some info fields
		$rmx_o.pk_id:=""
		$rmx_o.Reason:="REVERSED"
		$rmx_o.ModWho:=<>zResp
		$rmx_o.ModDate:=Current date:C33
		
		$newRMX_e:=ds:C1482.Raw_Materials_Transactions.new()  //create a transaction
		$newRMX_e.fromObject($rmx_o)  //fill it out
		$status_o:=$newRMX_e.save()  //commit to disk
		
		If ($status_o.success)
			
			$rml_e:=ds:C1482.Raw_Materials_Locations.query("POItemKey = :1"; $selectedRMX_e.POItemKey).first()
			
			If ($rml_e#Null:C1517)  //$rml_e.POItemKey
				$rml_e.QtyOH:=$rml_e.QtyOH+$rmx_o.Qty
				$rml_e.QtyOH:=$rmx_o.QtyAvailable+$rmx_o.Qty
				
			Else 
				$rml_e:=ds:C1482.Raw_Materials_Locations.new()  //create location
				$rml_e.Raw_Matl_Code:=$rmx_0.Raw_Matl_Code
				$rml_e.Location:=$rmx_0.Location
				$rml_e.CompanyID:=$rmx_0.CompanyID
				$rml_e.POItemKey:=$rmx_0.POItemKey
				$rml_e.QtyOH:=$rmx_o.Qty
				$rml_e.QtyAvailable:=$rmx_o.Qty
				$rml_e.ActCost:=$rmx_0.ActCost
				$rml_e.Commodity_Key:=$rmx_0.Commodity_Key
				$rml_e.POItemKey:=$rmx_o.POItemKey  //fill in the details
				$rml_e.QtyOH:=$rmx_o.Qty
				$rml_e.QtyAvailable:=$rmx_o.Qty
				//etc
			End if 
			
			$rml_eModDate:=$rmx_o.ModDate
			$rml_e.ModWho:=<>zResp
			$status_o:=$rml_e.save()  //save the update or creatation
			
			If (Not:C34($status_o.success))
				uConfirm("There was a problem saving the location, better check."; "Ok"; "You Kidding?")
			End if 
			
		End if 
		
	Else 
		uConfirm("There was a problem saving the new transaction, location record not changed."; "Ok"; "Try Later")
	End if 
	
Else 
	BEEP:C151
End if 
