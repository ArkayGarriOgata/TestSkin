
Case of 
	: (rb1=1)
		QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=(sCriterion1+"@"))
		
	: (rb2=1)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]OutlineNumber:43=sCriterion1)
		RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Job_Forms:42])
		
	: (rb3=1)
		QUERY:C277([Job_Forms_Items:44]; [Job_Forms_Items:44]ProductCode:3=sCriterion1)
		RELATE ONE SELECTION:C349([Job_Forms_Items:44]; [Job_Forms:42])
		
	: (rb4=1)
		QUERY:C277([Jobs:15]; [Jobs:15]CustomerName:5=("@"+sCriterion1+"@"))
		RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)
		
	: (rb5=1)
		QUERY:C277([Jobs:15]; [Jobs:15]Line:3=("@"+sCriterion1+"@"))
		RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)
		
	: (rbAll=1)
		ALL RECORDS:C47([Job_Forms:42])
		
	: (rbCurrSel=1)
		USE SET:C118("◊LastSelection"+String:C10(fileNum))
		
	Else 
		SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
		QUERY:C277([Job_Forms:42])
End case 

NumRecs1:=Records in selection:C76([Job_Forms:42])
If (NumRecs1>0)
	ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; <)
	CREATE SET:C116([Job_Forms:42]; "CurrentSet")
Else 
	uNoneFound
	REJECT:C38
End if 
