// ----------------------------------------------------
// User name (OS): cs
// Date: 3/27/97
// ----------------------------------------------------
// Form Method: [zz_control].FGAdjust
// ----------------------------------------------------

If (Form event code:C388=On Load:K2:1)
	LIST TO ARRAY:C288("FgAdjustReason"; aPreference)  //reuse of APREFERENCE
	dDate:=4D_Current_date
	sJobit:=""  // Added by: Mark Zinke (10/22/13) 
	tSkidNumber:=""  // Modified by: Mel Bohince (12/3/15) added
	sCriterion1:=""
	sCriterion2:=""
	sCriterion3:=""
	sCriterion4:="CycleCnt"
	sCriterion5:=""
	sCriterion6:=""
	sCriterion9:="Adjust"
	i1:=0
	rReal1:=0
	C_LONGINT:C283(qtyBeforeAdj)  // Modified by: Mel Bohince (7/13/16) 
	qtyBeforeAdj:=0
	C_BOOLEAN:C305(makeSkidDisappear)
	makeSkidDisappear:=False:C215
	wms_number_cases:=0
	//◊PHYSICAL_INVENORY_IN_PROGRESS:=false
	If (<>PHYSICAL_INVENORY_IN_PROGRESS)  //• mlb - 4/20/01 force tag entry
		SetObjectProperties(""; ->sCriterion9; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
		OBJECT SET LIST BY NAME:C237(sCriterion4; "")
	Else 
		SetObjectProperties(""; ->sCriterion4; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
	End if 
End if 