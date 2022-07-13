// ----------------------------------------------------
// Object Method: [zz_control].RMboardAtMill.Variable7
// SetObjectProperties, Mark Zinke (5/15/13)
// ----------------------------------------------------

If (RM_MillProductionLookup(sCriterion2))
	SetObjectProperties(""; ->bPost; True:C214; "Move To Warehouse: "+sCriterion3)
	GOTO OBJECT:C206(rReal1)
	
Else 
	sCriterion1:=""
	sCriterion2:="0"*9
	rReal1:=0
	sCriterion3:=""  //location
	sCriterion4:=""  //mill number
	t3:=""  //uom    
	SetObjectProperties(""; ->bPost; True:C214; "Move To Warehouse")
	GOTO OBJECT:C206(sCriterion2)
End if 