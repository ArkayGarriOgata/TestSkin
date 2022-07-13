//%attributes = {"publishedWeb":true}
//PM: ToDo_findBtn() -> 

//@author mlb - 5/10/02  15:15

If (Not:C34(<>modification4D_14_01_19))  // BEGIN 4D Professional Services : January 2019 query selection
	
	Case of 
		: (aSelectBy{aSelectBy}="New")
			ADD RECORD:C56(filePtr->; *)
			
		: (aSelectBy{aSelectBy}="Std Set")
			ToDo_pickFromStdSets
			
		: (aSelectBy{aSelectBy}="All Records")
			ALL RECORDS:C47(filePtr->)
			
		: (aSelectBy{aSelectBy}="Last Selection")
			USE SET:C118("◊LastSelection"+String:C10(fileNum))
			
		: (aSelectBy{aSelectBy}="Query Editor")
			SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
			QUERY:C277(filePtr->)
			SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
			
		: (aComparison{aComparison}="starts with")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->=(sCriterion1+"@"))
			
		: (aComparison{aComparison}="ends with")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->=("@"+sCriterion1))
			
		: (aComparison{aComparison}="is")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->=sCriterion1)
			
		: (aComparison{aComparison}="is not")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->#sCriterion1)
			
		: (aComparison{aComparison}="is greater than")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->>sCriterion1)
			
		: (aComparison{aComparison}="is greater than or equal to")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->>=sCriterion1)
			
		: (aComparison{aComparison}="is less than")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}-><sCriterion1)
			
		: (aComparison{aComparison}="is less than or equal to")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}-><=sCriterion1)
			
		: (aComparison{aComparison}="contains")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->="@"+sCriterion1+"@")
			
		: (aComparison{aComparison}="doesn't contain")
			QUERY:C277(filePtr->; aSlctField{aSelectBy}->#"@"+sCriterion1+"@")
			
		Else 
			BEEP:C151
			REJECT:C38
	End case 
	
	If (cbDone=1)
		QUERY SELECTION:C341(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
	End if 
	
Else 
	
	Case of 
		: (aSelectBy{aSelectBy}="New")
			ADD RECORD:C56(filePtr->; *)
			
			If (cbDone=1)
				QUERY SELECTION:C341(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			End if 
			
		: (aSelectBy{aSelectBy}="Std Set")
			ToDo_pickFromStdSets
			If (cbDone=1)
				QUERY SELECTION:C341(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			End if 
			
		: (aSelectBy{aSelectBy}="All Records")
			
			
			If (cbDone=1)
				
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				
				ALL RECORDS:C47(filePtr->)
				
			End if 
			
		: (aSelectBy{aSelectBy}="Last Selection")
			USE SET:C118("◊LastSelection"+String:C10(fileNum))
			If (cbDone=1)
				QUERY SELECTION:C341(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			End if 
			
		: (aSelectBy{aSelectBy}="Query Editor")
			SET AUTOMATIC RELATIONS:C310(True:C214; True:C214)
			QUERY:C277(filePtr->)
			SET AUTOMATIC RELATIONS:C310(False:C215; False:C215)
			
			If (cbDone=1)
				QUERY SELECTION:C341(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			End if 
			
		: (aComparison{aComparison}="starts with")
			
			
			If (cbDone=1)
				
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->=(sCriterion1+"@"); *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
				
			Else 
				
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->=(sCriterion1+"@"))
			End if 
			
		: (aComparison{aComparison}="ends with")
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->=("@"+sCriterion1); *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->=("@"+sCriterion1))
			End if 
		: (aComparison{aComparison}="is")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->=sCriterion1; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->=sCriterion1)
			End if 
		: (aComparison{aComparison}="is not")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->#sCriterion1; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->#sCriterion1)
			End if 
		: (aComparison{aComparison}="is greater than")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->>sCriterion1; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->>sCriterion1)
			End if 
			
		: (aComparison{aComparison}="is greater than or equal to")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->>=sCriterion1; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->>=sCriterion1)
			End if 
			
		: (aComparison{aComparison}="is less than")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}-><sCriterion1; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}-><sCriterion1)
			End if 
			
		: (aComparison{aComparison}="is less than or equal to")
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}-><=sCriterion1; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}-><=sCriterion1)
			End if 
			
		: (aComparison{aComparison}="contains")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->="@"+sCriterion1+"@"; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->="@"+sCriterion1+"@")
			End if 
			
		: (aComparison{aComparison}="doesn't contain")
			
			
			If (cbDone=1)
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->#"@"+sCriterion1+"@"; *)
				QUERY:C277(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			Else 
				QUERY:C277(filePtr->; aSlctField{aSelectBy}->#"@"+sCriterion1+"@")
			End if 
			
		Else 
			BEEP:C151
			REJECT:C38
			
			If (cbDone=1)
				QUERY SELECTION:C341(filePtr->; [To_Do_Tasks:100]Done:4=False:C215)
			End if 
	End case 
	
	
End if   // END 4D Professional Services : January 2019 query selection

$numFound:=Records in selection:C76(filePtr->)
SET WINDOW TITLE:C213(sFile+"  "+String:C10($numFound)+"/"+String:C10(Records in table:C83(filePtr->)))
ToDo_collection("size"; 0)
If ($numFound>0)
	ToDo_collection("load")
	ToDo_collection("sort"; 1)
	CREATE SET:C116(filePtr->; "◊LastSelection"+String:C10(fileNum))
	
	rb1:=1
	rb2:=0
	rb3:=0
	rb4:=0
	rb5:=0
	rb6:=0
	rb7:=0
	rb8:=0
	rb9:=0
	rb10:=0
	
Else 
	BEEP:C151
	//CONFIRM("No ToDo's found.";"Create New";"Try Again")
	
	//If (ok=1)
	
	//ADD RECORD(filePtr->;*)
	
	//POST KEY(13)
	
	//End if 
	
End if 

//