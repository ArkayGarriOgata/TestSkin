//%attributes = {}
// -------
// Method: RIM_ReconcileInventory   ( ) ->
// By: Mel Bohince @ 08/22/18, 13:44:09
// Description
// Display a list of RM_Locations whose qty doesn't match the positive Rm_labels qty's
// ----------------------------------------------------
// Modified by: Mel Bohince (4/11/19) rewrite
C_TEXT:C284($1)
C_LONGINT:C283($pid; $numProblems)
C_BOOLEAN:C305($display)


If (Count parameters:C259=0)
	$pid:=New process:C317(Current method name:C684; 0; Current method name:C684; "init"; *)
	SHOW PROCESS:C325($pid)
	
Else 
	Case of 
		: ($1="init")
			zSetUsageLog(->[zz_control:1]; "1"; Current method name:C684; 0)
			SET MENU BAR:C67(<>defaultMenu)
			READ WRITE:C146([Raw_Material_Labels:171])
			READ WRITE:C146([Raw_Materials_Locations:25])
			$display:=True:C214
			windowTitle:="Raw Material Location Reconciliation"
			$winRef:=OpenFormWindow(->[Raw_Materials_Locations:25]; "Reconciliation"; ->windowTitle; windowTitle)
			$numProblems:=RIM_ReconcileQtyProblems(2000)
			
			If ($numProblems=0)
				uConfirm("All Labels match their Location record (±2,000)."; "Good"; "Show All")
				If (ok=1)
					$display:=False:C215
					
				Else   //get all
					//only look at labels with a positive qty
					QUERY:C277([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Qty:8>0)
					ORDER BY:C49([Raw_Material_Labels:171]; [Raw_Material_Labels:171]Label_id:2; >)
					
					//get the [Raw_Material_Labels]POItemKey records into an arrray for query
					SELECTION TO ARRAY:C260([Raw_Material_Labels:171]POItemKey:3; $_POItemKey)  // Modified by: Mel Bohince (11/13/21) 
					QUERY WITH ARRAY:C644([Raw_Materials_Locations:25]POItemKey:19; $_POItemKey)
					
					ORDER BY:C49([Raw_Materials_Locations:25]; [Raw_Materials_Locations:25]Raw_Matl_Code:1; >)
				End if 
				
				
			End if 
			
			
			If ($display)
				DIALOG:C40([Raw_Materials_Locations:25]; "Reconciliation")
				CLOSE WINDOW:C154($winRef)
			End if 
			
			
			ARRAY LONGINT:C221($_aProblemRecNumbers; 0)
			REDUCE SELECTION:C351([Raw_Materials_Locations:25]; 0)
			REDUCE SELECTION:C351([Raw_Material_Labels:171]; 0)
	End case 
End if 




