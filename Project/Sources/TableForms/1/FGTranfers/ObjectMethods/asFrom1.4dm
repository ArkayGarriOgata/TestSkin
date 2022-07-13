// ----------------------------------------------------
// Object Method: [zz_control].FGTranfers.Variable4
// ----------------------------------------------------

If (asFrom#0)
	sCriterion3:=asFrom{asFrom}
	//◊asFrom:=0
	If (iMode=0)
		Case of 
			: (asFrom=1)
				COPY ARRAY:C226(<>asCC; asMove)
			: (asFrom=2)
				COPY ARRAY:C226(<>asEx; asMove)
			: (asFrom=3)
				COPY ARRAY:C226(<>asXC; asMove)
			: (asFrom=4)
				COPY ARRAY:C226(<>asFG; asMove)
				//: (asFrom=5)
				//COPY ARRAY(<>asQA;asMove)
				//: (asFrom=6)
				//COPY ARRAY(<>asRC;asMove)
				//: (asFrom=7)
				//COPY ARRAY(<>asCE;asMove)
				//: (asFrom=8)  //•090299  mlb  
				//COPY ARRAY(<>asBH;asMove)
				
		End case 
		asMove:=1
		sCriterion4:=asMove{asMove}
		If (Position:C15("EX"; sCriterion4)>0)  //move to exam `•100798  mlb  UPR 1972
			SetObjectProperties(""; ->sCriterion7; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
			SetObjectProperties(""; ->sCriterion9; True:C214; ""; True:C214)  // Modified by: Mark Zinke (5/14/13)
			sCriterion9:="Reject"
			OBJECT SET LIST BY NAME:C237(sCriterion7; "RejectReason")
		Else 
			sCriterion9:=""
			If (iMode=0)  //move
				SetObjectProperties(""; ->sCriterion7; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
				SetObjectProperties(""; ->sCriterion9; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/14/13)
			End if 
		End if 
	End if 
End if 