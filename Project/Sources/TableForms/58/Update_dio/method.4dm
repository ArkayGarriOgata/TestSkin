// ----------------------------------------------------
// Form Method: [Raw_Materials_Allocations].Update.dio
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	sCriterion2:=""
	sCriterion3:="00000.00"
	rReal1:=0
	dDate:=!00-00-00!
	t3:="Then enter a Job Form, total quantity of the allocation, and date needed."
	sCriterion1:="First enter a Raw Material Code."
	If (iMode=4)
		SetObjectProperties(""; ->bPost; True:C214; "Remove Allocation")  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->rReal1; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		SetObjectProperties(""; ->dDate; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
	End if 
End if 