If (aJobNo#"")  //this value set in dialog, alos in JCOCloseJobform    
	READ WRITE:C146([Job_Forms:42])
	QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=aJobNo)
	$numForms:=Records in selection:C76([Job_Forms:42])
	If ($numForms>0)
		If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 Next record
			
			ORDER BY:C49([Job_Forms:42]; [Job_Forms:42]JobFormID:5; >)
			FIRST RECORD:C50([Job_Forms:42])
			INSERT IN ARRAY:C227(aRpt; 1; $numForms)
			INSERT IN ARRAY:C227(aJFID; 1; $numForms)
			INSERT IN ARRAY:C227(aCustName; 1; $numForms)
			INSERT IN ARRAY:C227(aLine; 1; $numForms)
			For ($i; 1; $numForms)
				aRpt{$i}:="√"
				aJFID{$i}:=[Job_Forms:42]JobFormID:5
				aCustName{$i}:=[Jobs:15]CustomerName:5
				aLine{$i}:=[Jobs:15]Line:3
				NEXT RECORD:C51([Job_Forms:42])
			End for 
			
		Else 
			
			ARRAY TEXT:C222($_JobFormID; 0)
			ARRAY TEXT:C222($_CustomerName; 0)
			ARRAY TEXT:C222($_Line; 0)
			
			SELECTION TO ARRAY:C260([Job_Forms:42]JobFormID:5; $_JobFormID; [Jobs:15]CustomerName:5; $_CustomerName; [Jobs:15]Line:3; $_Line)
			
			SORT ARRAY:C229($_JobFormID; $_CustomerName; $_Line; >)
			
			INSERT IN ARRAY:C227(aRpt; 1; $numForms)
			INSERT IN ARRAY:C227(aJFID; 1; $numForms)
			INSERT IN ARRAY:C227(aCustName; 1; $numForms)
			INSERT IN ARRAY:C227(aLine; 1; $numForms)
			
			For ($i; 1; $numForms; 1)
				
				aRpt{$i}:="√"
				aJFID{$i}:=$_JobFormID{$i}
				aCustName{$i}:=$_CustomerName{$i}
				aLine{$i}:=$_Line{$i}
				
			End for 
			
		End if   // END 4D Professional Services : January 2019 First record
		
	End if 
	vSel:=vSel+$numForms
	vTotRec:=vTotRec+$numForms
	aJobNo:=""
	GOTO OBJECT:C206(aJobNo)
End if 