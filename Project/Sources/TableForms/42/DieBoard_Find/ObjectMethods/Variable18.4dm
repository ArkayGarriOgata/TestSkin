//bSerach button

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

If (cb1=1)  // Modified by: Mel Bohince (12/9/15)  added bin option
	If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
		
		RELATE ONE SELECTION:C349([Job_Forms:42]; [Job_DieBoards:152])
		QUERY SELECTION:C341([Job_DieBoards:152]; [Job_DieBoards:152]Bin:4#""; *)
		QUERY SELECTION:C341([Job_DieBoards:152];  & ; [Job_DieBoards:152]Bin:4#"Kill")
		//RELATE MANY SELECTION([Job_DieBoards]JobformId) //doesn't fucking work
		SELECTION TO ARRAY:C260([Job_DieBoards:152]JobformId:1; $aJobforms)
		QUERY WITH ARRAY:C644([Job_Forms:42]JobFormID:5; $aJobforms)
		
	Else 
		
		QUERY SELECTION BY FORMULA:C207([Job_Forms:42]; \
			([Job_DieBoards:152]Bin:4#"Kill")\
			 & ([Job_DieBoards:152]Bin:4#"")\
			)
		
	End if   // END 4D Professional Services : January 2019 query selection
	
End if 

NumRecs1:=Records in selection:C76([Job_Forms:42])
If (NumRecs1>0)
	ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; <)
	CREATE SET:C116([Job_Forms:42]; "CurrentSet")
Else 
	uNoneFound
	REJECT:C38
End if 



