//(s) dDate [control]rmadjust
RM_DateLimitor(Self:C308)
If (dDate#!00-00-00!)
	sCriterion2:=Substring:C12([Raw_Materials:21]Raw_Matl_Code:1; 1; 5)+Substring:C12(String:C10(dDate; <>MIDDATE); 1; 5)
	sCriterion2:=Replace string:C233(sCriterion2; "/"; "")
	READ ONLY:C145([Purchase_Orders_Items:12])
	QUERY:C277([Purchase_Orders_Items:12]; [Purchase_Orders_Items:12]POItemKey:1=sCriterion2)
	If (Records in selection:C76([Purchase_Orders_Items:12])=1)
		sCriterion2:=""
		uClearSelection(->[Purchase_Orders_Items:12])
	End if 
	//  
Else 
	GOTO OBJECT:C206(dDate)
End if 

//