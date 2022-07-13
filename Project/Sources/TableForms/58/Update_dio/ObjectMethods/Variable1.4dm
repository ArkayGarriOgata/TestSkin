//12/6/94 test for records before doing calcs
sCriterion3:=""
rReal1:=0
READ ONLY:C145([Raw_Materials:21])
QUERY:C277([Raw_Materials:21]; [Raw_Materials:21]Raw_Matl_Code:1=sCriterion2)
If (Records in selection:C76([Raw_Materials:21])=1)
	If (iMode=4)  //delete
		QUERY:C277([Raw_Materials_Allocations:58]; [Raw_Materials_Allocations:58]Raw_Matl_Code:1=sCriterion2)
		If (Records in selection:C76([Raw_Materials_Allocations:58])=0)
			BEEP:C151
			ALERT:C41(sCriterion2+" has no allocations to remove. Please try again.")
			sCriterion2:=""
			sCriterion1:="Enter an allocated Raw Material Code."
			GOTO OBJECT:C206(sCriterion2)
		Else 
			sCriterion1:=String:C10(Sum:C1([Raw_Materials_Allocations:58]Qty_Allocated:4); "###,###,##0")+" allocated; "+String:C10(Sum:C1([Raw_Materials_Allocations:58]Qty_Issued:6); "###,###,##0")+" issued."
		End if 
		
	Else 
		C_BOOLEAN:C305($available)
		$available:=RM_AllocationCalc(sCriterion2)
		If (Not:C34($available))
			BEEP:C151
			ALERT:C41(sCriterion2+" has no available quantity. Please try another r/m or make a requisition.")
		End if 
		//If (RM_AllocationCalc (sCriterion2))
		sCriterion1:=String:C10(iOnOrder; "###,###,##0")+" on-order; "+String:C10(iOnHand; "###,###,##0")+" on-hand; "+String:C10(iOpen; "###,###,##0")+" available. "
		GOTO OBJECT:C206(sCriterion3)
		
		//Else   `none avail
		//sCriterion1:=""
		//BEEP
		//ALERT(sCriterion2+" has no available quantity. Please try another r/m or make a 
		//sCriterion2:=""
		//sCriterion1:="Enter a Raw Material Code with available qty."
		//UNLOAD RECORD([RAW_MATERIALS])
		//GOTO AREA(sCriterion2)
		//End if   `any avail
		
	End if 
	
Else   //not an r/m
	BEEP:C151
	ALERT:C41(sCriterion2+" is not a valid raw material code. Please try again.")
	sCriterion2:=""
	sCriterion1:="Enter a VALID Raw Material Code."
	GOTO OBJECT:C206(sCriterion2)
End if   //r/m

//