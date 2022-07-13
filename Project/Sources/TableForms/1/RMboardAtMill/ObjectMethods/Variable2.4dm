// ----------------------------------------------------
// User name (OS): MLB
// Date and time: 7/9/02  10:52
// ----------------------------------------------------
// Object Method: [zz_control].RMboardAtMill.Variable2
// ----------------------------------------------------

If (Not:C34(RM_MillProductionPost))
	BEEP:C151
	ALERT:C41("Post Failed"; "Enter a valid PO item.")
End if 

sCriterion1:=""
sCriterion2:="0"*9
rReal1:=0
sCriterion3:=""  //location
sCriterion4:=""  //mill number
t3:=""  //uom  
SetObjectProperties(""; ->bPost; True:C214; "Move To Warehouse")
GOTO OBJECT:C206(sCriterion2)