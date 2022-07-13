// _______
// Method: [Raw_Materials_Locations].Input.rmLabelButton   ( ) ->
// By: Mel Bohince @ 04/11/19, 12:01:57
// Description
// offer to make onhand qty equal to the positive label qty's
// ----------------------------------------------------
//see also RIM_ReconcileInventoryAuto

C_LONGINT:C283($sumLabels)

If (Not:C34(Read only state:C362([Raw_Materials_Locations:25])))
	
	ARRAY LONGINT:C221($_record_labels; 0)
	LONGINT ARRAY FROM SELECTION:C647([Raw_Material_Labels:171]; $_record_labels)
	
	QUERY SELECTION:C341([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)
	$numLabels:=Records in selection:C76([Raw_Material_Labels:171])
	If ($numLabels>0)
		$newLabelQty:=Round:C94([Raw_Materials_Locations:25]QtyOH:9/$numLabels; 0)
		uConfirm("Change the qty of "+String:C10($numLabels)+" rolls to "+String:C10($newLabelQty)+"?")
		If (ok=1)
			APPLY TO SELECTION:C70([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8:=$newLabelQty)
		End if 
		
		//$sumLabels:=Sum([Raw_Material_Labels]Qty)
		//If ([Raw_Materials_Locations]QtyOH#$sumLabels)
		//  //uConfirm ("Change the On hand quantity to "+String($sumLabels)+"?";"Change";"Cancel")
		//  //If (ok=1)
		//  //RIM_ReconcileApplyChange ($sumLabels)
		//  //REDRAW(list_Box1)
		//  //End if 
		
		//Else 
		//uConfirm ("Quantity On hand already matches the sum of the Labels' quantity.";"Ok";"Just checking")
		//End if 
	End if 
	
	CREATE SELECTION FROM ARRAY:C640([Raw_Material_Labels:171]; $_record_labels)
	
Else 
	uConfirm("Can't change without being in Modify mode."; "Ok"; "Gotcha")
End if 


