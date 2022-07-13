//%attributes = {"publishedWeb":true}
//PM: ToDo_collection() -> 
//@author mlb - 5/10/02  15:58

Case of 
	: ($1="size")
		ARRAY LONGINT:C221(aRecNum; $2)
		ARRAY TEXT:C222(aJobSeq; $2)
		ARRAY TEXT:C222(aCategory; $2)
		ARRAY TEXT:C222(aTask; $2)
		ARRAY BOOLEAN:C223(aDone; $2)
		ARRAY TEXT:C222(aPjtNum; $2)
		ARRAY DATE:C224(aDateDone; $2)
		ARRAY TEXT:C222(aDoneBy; $2)
		ARRAY TEXT:C222(aCreatedBy; $2)
		ARRAY TEXT:C222(aAssignedTo; $2)
		ARRAY DATE:C224(aDateDue; $2)
		ARRAY TEXT:C222(aCritical; $2)
		ARRAY BOOLEAN:C223($aCritical; $2)
		
	: ($1="load")
		SELECTION TO ARRAY:C260([To_Do_Tasks:100]; aRecNum; [To_Do_Tasks:100]Jobform:1; aJobSeq; [To_Do_Tasks:100]Category:2; aCategory; [To_Do_Tasks:100]Task:3; aTask; [To_Do_Tasks:100]Done:4; aDone; [To_Do_Tasks:100]PjtNumber:5; aPjtNum; [To_Do_Tasks:100]DateDone:6; aDateDone; [To_Do_Tasks:100]DoneBy:7; aDoneBy; [To_Do_Tasks:100]CreatedBy:8; aCreatedBy; [To_Do_Tasks:100]AssignedTo:9; aAssignedTo; [To_Do_Tasks:100]DateDue:10; aDateDue; [To_Do_Tasks:100]Critical:11; $aCritical)
		ARRAY TEXT:C222(aCritical; Size of array:C274($aCritical))
		For ($i; 1; Size of array:C274($aCritical))
			If ($aCritical{$i})
				aCritical{$i}:="X"
			Else 
				aCritical{$i}:=""
			End if 
		End for 
		ARRAY BOOLEAN:C223($aCritical; 0)
		
	: ($1="save")
		aJobSeq{$2}:=[To_Do_Tasks:100]Jobform:1
		aCategory{$2}:=[To_Do_Tasks:100]Category:2
		aTask{$2}:=[To_Do_Tasks:100]Task:3
		aDone{$2}:=[To_Do_Tasks:100]Done:4
		aPjtNum{$2}:=[To_Do_Tasks:100]PjtNumber:5
		aDateDone{$2}:=[To_Do_Tasks:100]DateDone:6
		aDoneBy{$2}:=[To_Do_Tasks:100]DoneBy:7
		aCreatedBy{$2}:=Substring:C12([To_Do_Tasks:100]CreatedBy:8; 1; 4)
		aAssignedTo{$2}:=[To_Do_Tasks:100]AssignedTo:9
		aDateDue{$2}:=[To_Do_Tasks:100]DateDue:10
		If ([To_Do_Tasks:100]Critical:11)
			aCritical{$2}:="X"
		Else 
			aCritical{$2}:=""
		End if 
		
	: ($1="store")
		[To_Do_Tasks:100]Jobform:1:=aJobSeq{$2}
		[To_Do_Tasks:100]Category:2:=aCategory{$2}
		[To_Do_Tasks:100]Task:3:=aTask{$2}
		[To_Do_Tasks:100]Done:4:=aDone{$2}
		[To_Do_Tasks:100]PjtNumber:5:=aPjtNum{$2}
		[To_Do_Tasks:100]DateDone:6:=aDateDone{$2}
		[To_Do_Tasks:100]DoneBy:7:=aDoneBy{$2}
		[To_Do_Tasks:100]CreatedBy:8:=aCreatedBy{$2}
		[To_Do_Tasks:100]AssignedTo:9:=aAssignedTo{$2}
		[To_Do_Tasks:100]DateDue:10:=aDateDue{$2}
		[To_Do_Tasks:100]Critical:11:=(aCritical{$2}="X")
		SAVE RECORD:C53([To_Do_Tasks:100])
		UNLOAD RECORD:C212([To_Do_Tasks:100])
		
	: ($1="delete")
		DELETE FROM ARRAY:C228(aJobSeq; $2; 1)
		DELETE FROM ARRAY:C228(aCategory; $2; 1)
		DELETE FROM ARRAY:C228(aTask; $2; 1)
		DELETE FROM ARRAY:C228(aDone; $2; 1)
		DELETE FROM ARRAY:C228(aPjtNum; $2; 1)
		DELETE FROM ARRAY:C228(aDateDone; $2; 1)
		DELETE FROM ARRAY:C228(aDoneBy; $2; 1)
		DELETE FROM ARRAY:C228(aCreatedBy; $2; 1)
		DELETE FROM ARRAY:C228(aAssignedTo; $2; 1)
		DELETE FROM ARRAY:C228(aDateDue; $2; 1)
		DELETE FROM ARRAY:C228(aCritical; $2; 1)
		
	: ($1="sort")
		Case of 
			: ($2=1)
				SORT ARRAY:C229(aJobSeq; aRecNum; aCategory; aTask; aDone; aPjtNum; aDateDone; aDoneBy; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=2)
				SORT ARRAY:C229(aAssignedTo; aJobSeq; aRecNum; aCategory; aTask; aDone; aPjtNum; aDateDone; aDoneBy; aCreatedBy; aDateDue; aCritical; >)
			: ($2=3)
				SORT ARRAY:C229(aDateDue; aAssignedTo; aJobSeq; aRecNum; aCategory; aTask; aDone; aPjtNum; aDateDone; aDoneBy; aCreatedBy; aCritical; >)
			: ($2=4)
				SORT ARRAY:C229(aCategory; aJobSeq; aRecNum; aTask; aDone; aPjtNum; aDateDone; aDoneBy; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=5)
				SORT ARRAY:C229(aTask; aJobSeq; aRecNum; aCategory; aDone; aPjtNum; aDateDone; aDoneBy; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=6)
				SORT ARRAY:C229(aDone; aJobSeq; aRecNum; aCategory; aTask; aPjtNum; aDateDone; aDoneBy; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=7)
				SORT ARRAY:C229(aDoneBy; aJobSeq; aRecNum; aCategory; aTask; aDone; aPjtNum; aDateDone; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=8)
				SORT ARRAY:C229(aDateDone; aJobSeq; aRecNum; aCategory; aTask; aDone; aPjtNum; aDoneBy; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=9)
				SORT ARRAY:C229(aPjtNum; aJobSeq; aRecNum; aCategory; aTask; aDone; aDateDone; aDoneBy; aCreatedBy; aAssignedTo; aDateDue; aCritical; >)
			: ($2=10)
				SORT ARRAY:C229(aCreatedBy; aJobSeq; aRecNum; aCategory; aTask; aDone; aPjtNum; aDateDone; aDoneBy; aAssignedTo; aDateDue; aCritical; >)
		End case 
		
End case 