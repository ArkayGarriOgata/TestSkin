// ----------------------------------------------------
// Method: [Job_Forms_Machines].ProductionClose   ( ) ->

If (Form event code:C388=On Display Detail:K2:22)
	// C_LONGINT($i)
	// $i:=Selected record number([Machine_Job])
	//gFindCC (CostCenterID)
	// TRACE
	//[Job_Forms_Machines]
	If ((Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>EMBOSSERS)>0) | (Position:C15([Job_Forms_Machines:43]CostCenterID:4; <>STAMPERS)>0))
		zzDESC:=CostCtr_Description_Tweak(->[Job_Forms_Machines:43]CostCenterID:4)
		
	Else 
		If (Substring:C12([Job_Forms_Machines:43]CostCenterID:4; 1; 1)#"!")
			C_TEXT:C284($description)  // Modified by: Mel Bohince (11/24/21) 
			$description:=""
			$i:=CostCtrCurrent("Desc"; [Job_Forms_Machines:43]CostCenterID:4; ->$description)
			If ($i>0)
				zzDESC:=$description  //aCostCtrDes{$i}
			Else 
				zzDESC:=[Job_Forms_Machines:43]CostCenterID:4+" not found"
			End if 
		Else 
			zzDESC:="Not Budgeted"
		End if 
	End if 
	
	If ([Job_Forms_Machines:43]Actual_MR_Hrs:24>0)
		real2:=Round:C94([Job_Forms_Machines:43]Actual_MR_Hrs:24-[Job_Forms_Machines:43]Planned_MR_Hrs:15; 0)
		If (real2>0)
			Core_ObjectSetColor(->real2; -3)
		Else 
			Core_ObjectSetColor(->real2; -15)
		End if 
		
	Else 
		real2:=0
		Core_ObjectSetColor(->real2; -15)
	End if 
	//ayB2{$i}:=real2
	
	If ([Job_Forms_Machines:43]Actual_RunHrs:40>0)
		real3:=Round:C94([Job_Forms_Machines:43]Actual_RunHrs:40-[Job_Forms_Machines:43]Planned_RunHrs:37; 0)
		If (real3>0)
			Core_ObjectSetColor(->real3; -3)
		Else 
			Core_ObjectSetColor(->real3; -15)
		End if 
		
		
	Else 
		real3:=0
		Core_ObjectSetColor(->real3; -15)
	End if 
	// ayB3{$i}:=real3
	//ayB4{$i}:=real2+real3
	If ([Job_Forms_Machines:43]Actual_Qty:19>0)
		real4:=[Job_Forms_Machines:43]Actual_Qty:19-[Job_Forms_Machines:43]Planned_Qty:10
	Else 
		real4:=0
	End if 
	//ayB5{$i}:=real4
End if 
//