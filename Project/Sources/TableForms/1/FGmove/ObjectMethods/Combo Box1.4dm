If (sVerifyLocation(->asMove{0}))
	If (wms_locationsRequiringReason(asMove{0}))
		sCriterion9:="Reject"
		SetObjectProperties("Reason@"; -><>NULL; True:C214)
	Else 
		sCriterion9:=""
		SetObjectProperties("Reason@"; -><>NULL; False:C215)
	End if 
	SetReturnReject
	
End if 