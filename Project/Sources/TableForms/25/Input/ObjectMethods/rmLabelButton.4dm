// _______
// Method: [Raw_Materials_Locations].Input.rmLabelButton   ( ) ->
// By: Mel Bohince @ 04/11/19, 12:01:57
// Description
// offer to make onhand qty equal to the positive label qty's
// ----------------------------------------------------

C_LONGINT:C283($sumLabels)

If (Not:C34(Read only state:C362([Raw_Materials_Locations:25])))
	
	ARRAY LONGINT:C221($_record_machines; 0)
	LONGINT ARRAY FROM SELECTION:C647([Raw_Material_Labels:171]; $_record_machines)
	
	QUERY SELECTION:C341([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)
	If (Records in selection:C76([Raw_Material_Labels:171])>0)
		$sumLabels:=Sum:C1([Raw_Material_Labels:171]Qty:8)
		If ([Raw_Materials_Locations:25]QtyOH:9#$sumLabels)
			uConfirm("Change the On hand quantity to "+String:C10($sumLabels)+"?"; "Change"; "Cancel")
			If (ok=1)
				[Raw_Materials_Locations:25]LastCycleCount:7:=[Raw_Materials_Locations:25]QtyOH:9
				[Raw_Materials_Locations:25]LastCycleDate:8:=Current date:C33
				[Raw_Materials_Locations:25]QtyOH:9:=$sumLabels
				SAVE RECORD:C53([Raw_Materials_Locations:25])
			End if 
			
		Else 
			uConfirm("Quantity On hand already matches the sum of the Labels' quantity."; "Ok"; "Just checking")
		End if 
	End if 
	
	CREATE SELECTION FROM ARRAY:C640([Raw_Material_Labels:171]; $_record_machines)
	
Else 
	uConfirm("Can't change without being in Modify mode."; "Ok"; "Gotcha")
End if 


