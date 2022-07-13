// Modified by: Garri Ogata (12/9/20) added sCriterion2

$numJMI:=qryJMI(sJobit)  // Modified by: Mel Bohince (12/3/15) rewrite
If ($numJMI>0)
	sCriterion5:=Substring:C12(sJobit; 1; 5)
	sCriterion6:=Substring:C12(sJobit; 7; 2)
	i1:=Num:C11(Substring:C12(sJobit; 10))
	sCriterion1:=[Job_Forms_Items:44]CustId:15+":"+[Job_Forms_Items:44]ProductCode:3
	sCriterion2:=[Job_Forms_Items:44]CustId:15  // Added by: Garri Ogata (12/9/20) 
	GOTO OBJECT:C206(sCriterion3)
	
Else 
	sCriterion2:=CorektBlank  // Added by: Garri Ogata (12/9/20) 
	sCriterion5:=""
	sCriterion6:=""
	i1:=0
	sCriterion1:=sJobit+" was not found, try again."
	sJobit:=""
	GOTO OBJECT:C206(sJobit)
End if 