// ----------------------------------------------------
// Form Method: [zz_control].FGtransfer_rtns
// SetObjectProperties, Modified by: Mark Zinke (5/14/13)
// ----------------------------------------------------

<>iLayout:=191  //(LP) [CONTROL]fgTransfer_rtns
//see also [CONTROL];"FGTranfers"
If (Form event code:C388=On Load:K2:1)
	tJobItNum:=""  // Added by: Mark Zinke (10/22/13) 
	sCriterion1:=""  //        cpn
	sCriterion2:=""  //custid
	rReal1:=0  //             qty
	sCriterion3:=""  //from
	sCriterion4:=""  //to
	sCriterion5:=""  //jobform
	i1:=0  //                job item
	sCriterion6:=""  //orderline
	sCriterion7:=""  //reason comment
	sCriterion8:=""  //action taken
	sCriterion9:=""  //reason
	sCriter10:=<>zResp+fYYMMDD(Current date:C33; 4)+"-"+Replace string:C233(String:C10(Current time:C178; HH MM SS:K7:1); ":"; "")  //""  //   skid ticket
	sCriter11:=<>zResp  //user
	sCriter12:=""  //release
	ARRAY TEXT:C222(asCriter2; 1)
	asCriter2{1}:="00000"
	asCriter2:=1
	sCriterion2:=asCriter2{asCriter2}
	
	SetObjectProperties(""; ->bPost; True:C214; "Return")
	sCriterion3:="Customer"
	COPY ARRAY:C226(<>asCust; asMove)
	asMove:=1
	sCriterion4:=asMove{1}
	sCriterion9:="Return"
	SetObjectProperties(""; ->sCriter10; True:C214; ""; True:C214)  //to skid
	SetObjectProperties(""; ->sCriterion4; True:C214; ""; True:C214)  //to location
	SetObjectProperties(""; ->sCriterion7; True:C214; ""; True:C214)  //reason comments
	SetObjectProperties(""; ->sCriterion8; True:C214; ""; True:C214)  //action taken
	SetObjectProperties(""; ->sCriterion9; True:C214; ""; True:C214)  //reason
	SetObjectProperties(""; ->sCriter12; True:C214; ""; True:C214)  //release
	SetReturnReject
End if 