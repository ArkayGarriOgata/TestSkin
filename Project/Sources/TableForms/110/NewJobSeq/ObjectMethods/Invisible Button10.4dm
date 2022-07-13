// ----------------------------------------------------
// Object Method: [ProductionSchedules].NewJobSeq.Invisible Button10
// ----------------------------------------------------

SetObjectProperties(""; ->dDate; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)
SetObjectProperties(""; ->tTime; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/13/13)

rb1:=1
rb2:=0
If (dDate#!00-00-00!)
	Cal_getDate(->dDate; Month of:C24(dDate); Year of:C25(dDate))
Else 
	Cal_getDate(->dDate)
End if 