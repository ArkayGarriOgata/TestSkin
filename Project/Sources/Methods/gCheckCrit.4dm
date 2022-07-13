//%attributes = {"publishedWeb":true}
//(P) gCheckCrit: Checks Search Criteria forType and  Backwards order

C_DATE:C307($dHold)

Case of 
	: ((xSlctType="I") | (xSlctType="L") | (xSlctType="R"))  //Number
		If (Num:C11(xCriterion3)=0)
			Case of 
				: (xSlctType="I")
					xCriterion3:="32767"
				: (xSlctType="L")
					xCriterion3:="2147483647"
				: (xSlctType="R")
					xCriterion3:="1+E1022"
			End case 
		End if 
		lHiNum:=Num:C11(xCriterion2)
		lLoNum:=Num:C11(xCriterion3)
		If (lLoNum>lHiNum)
			lLoNum:=Num:C11(xCriterion2)
			lHiNum:=Num:C11(xCriterion3)
		End if 
	: (xSlctType="A")  //Alphanumeric
		If (xCriterion3="")
			xCriterion3:="~~~"
		End if 
		If ((xCriterion2#"") & (xCriterion3#"") & (xCriterion2>xCriterion3))
			xHiName:=xCriterion2
			xLoName:=xCriterion3
		Else 
			xLoName:=xCriterion2
			xHiName:=xCriterion3
		End if 
	: (xSlctType="D")  //Date
		If (xCriterion2="")
			xCriterion2:="000000"
		End if 
		dLoDate:=Date:C102(Substring:C12(xCriterion2; 1; 2)+"/"+Substring:C12(xCriterion2; 3; 2)+"/"+Substring:C12(xCriterion2; 5))
		If (xCriterion3="000000")
			xCriterion3:="12312100"
		End if 
		dHiDate:=Date:C102(Substring:C12(xCriterion3; 1; 2)+"/"+Substring:C12(xCriterion3; 3; 2)+"/"+Substring:C12(xCriterion3; 5))
		If (dHiDate<dLoDate)
			$dHold:=dHiDate
			dHiDate:=dLoDate
			dLoDate:=$dHold
		End if 
End case 