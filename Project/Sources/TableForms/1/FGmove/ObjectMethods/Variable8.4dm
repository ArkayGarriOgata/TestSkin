$numRecs:=qryJMI(sJobit)
If ($numRecs>0)  //5/4/95 
	
	sCriterion1:=[Job_Forms_Items:44]ProductCode:3
	sCriterion2:=[Job_Forms_Items:44]CustId:15
	sCriterion5:=[Job_Forms_Items:44]JobForm:1
	sCriterion6:=[Job_Forms_Items:44]OrderItem:2
	i1:=[Job_Forms_Items:44]ItemNumber:7
	UNLOAD RECORD:C212([Job_Forms_Items:44])
	
Else 
	BEEP:C151
	ALERT:C41(sJobit+" is not a valid job item.")
	sJobit:=""
	GOTO OBJECT:C206(sJobit)
End if 