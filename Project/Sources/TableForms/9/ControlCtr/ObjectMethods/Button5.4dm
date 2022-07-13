// • mel (4/5/05, 11:18:27)

Pjt_setReferId(pjtId)
READ WRITE:C146([Jobs:15])
READ WRITE:C146([Job_Forms:42])
QUERY:C277([Jobs:15])
If (ok=1)
	$numJobs:=Records in selection:C76([Jobs:15])
	If (Pjt_AddToProjectLimitor(->[Jobs:15]))
		uConfirm("Change "+String:C10($numJobs)+" records to project number "+pjtId)
		If (ok=1)
			//see if project name matches a brand
			$numFound:=0  // Modified by: Mel Bohince (6/9/21) 
			SET QUERY DESTINATION:C396(Into variable:K19:4; $numFound)
			QUERY:C277([Customers_Brand_Lines:39]; [Customers_Brand_Lines:39]CustID:1=pjtCustid; *)
			QUERY:C277([Customers_Brand_Lines:39];  & ; [Customers_Brand_Lines:39]LineNameOrBrand:2=pjtName)
			SET QUERY DESTINATION:C396(Into current selection:K19:1)
			If ($numFound>0)
				$newLine:=pjtName
			Else 
				$newLine:=""
			End if 
			If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 First record
				
				For ($i; 1; $numJobs)
					[Jobs:15]ProjectNumber:18:=pjtId
					[Jobs:15]CustID:2:=pjtCustid
					[Jobs:15]CustomerName:5:=pjtCustName
					If (Length:C16($newLine)>0)
						[Jobs:15]Line:3:=$newLine
					End if 
					SAVE RECORD:C53([Jobs:15])
					
					QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=[Jobs:15]JobNo:1)
					APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56:=pjtId)
					If (Length:C16($newLine)>0)
						FIRST RECORD:C50([Job_Forms:42])
						APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]CustomerLine:62:=$newLine)
					End if 
					
					NEXT RECORD:C51([Jobs:15])
				End for 
				
			Else 
				
				
				RELATE MANY SELECTION:C340([Job_Forms:42]JobNo:2)
				APPLY TO SELECTION:C70([Jobs:15]; [Jobs:15]ProjectNumber:18:=pjtId)
				APPLY TO SELECTION:C70([Jobs:15]; [Jobs:15]CustID:2:=pjtCustid)
				APPLY TO SELECTION:C70([Jobs:15]; [Jobs:15]CustomerName:5:=pjtCustName)
				If (Length:C16($newLine)>0)
					APPLY TO SELECTION:C70([Jobs:15]; [Jobs:15]Line:3:=$newLine)
				End if 
				APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56:=pjtId)
				If (Length:C16($newLine)>0)
					APPLY TO SELECTION:C70([Job_Forms:42]; [Job_Forms:42]CustomerLine:62:=$newLine)
				End if 
				
				
				
			End if   // END 4D Professional Services : January 2019 First record
		End if 
	End if 
End if 
REDUCE SELECTION:C351([Jobs:15]; 0)
If (Not:C34(<>modification4D_13_02_19))  // BEGIN 4D Professional Services : January 2019 Query Selection (2) Pt. 3 + Sets (3) CREATE EMPTY SET
	
	REDUCE SELECTION:C351([Job_Forms:42]; 0)
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56=pjtId)
	
Else 
	
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]ProjectNumber:56=pjtId)
	
End if   // END 4D Professional Services : January 2019 

ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobNo:2; <)

//