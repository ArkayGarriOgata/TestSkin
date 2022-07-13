//%attributes = {}
// _______
// Method: RIM_ReconcileInventoryAuto   ( ) ->
// By: Mel Bohince @ 04/15/19, 11:29:07
// Description
// do what the ui in RIM_ReconcileInventory does for all locations with labels
// ----------------------------------------------------


C_TEXT:C284($1)
C_LONGINT:C283(<>pid_RIM_Auto)

If (Count parameters:C259=0)
	<>pid_RIM_Auto:=Process number:C372("RIM_ReconcileInventoryAuto")
	If (<>pid_RIM_Auto=0)  //singleton
		<>pid_RIM_Auto:=New process:C317("RIM_ReconcileInventoryAuto"; <>lMidMemPart; "RIM_ReconcileInventoryAuto"; "init")
		If (False:C215)
			RIM_ReconcileInventoryAuto
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_RIM_Auto)
		BRING TO FRONT:C326(<>pid_RIM_Auto)
	End if 
	
Else 
	Case of 
		: ($1="init")
			
			READ ONLY:C145([Raw_Material_Labels:171])
			READ WRITE:C146([Raw_Materials_Locations:25])
			
			//only look at labels with a positive qty
			QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)
			//get the location records into an arrray
			RELATE ONE SELECTION:C349([Raw_Material_Labels:171]; [Raw_Materials_Locations:25])
			ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)
			
			
			While (Not:C34(End selection:C36([Raw_Materials_Locations:25])))
				//get its labels
				RELATE MANY:C262([Raw_Materials_Locations:25]pk_id:32)
				$numLabels:=Records in selection:C76([Raw_Material_Labels:171])
				zwStatusMsg([Raw_Materials_Locations:25]Raw_Matl_Code:1; String:C10($numLabels)+" labels")
				
				$sumLabels:=0
				QUERY SELECTION:C341([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)  //that have a positive qty
				If ($numLabels>0)
					$sumLabels:=Sum:C1([Raw_Material_Labels:171]Qty:8)
					
					If ([Raw_Materials_Locations:25]QtyOH:9#$sumLabels)
						RIM_ReconcileApplyChange($sumLabels)
					End if 
				End if 
				
				
				
				NEXT RECORD:C51([Raw_Materials_Locations:25])
			End while 
			zwStatusMsg("Match"; "Fini")
			<>pid_RIM_Auto:=0
			
	End case 
End if 
