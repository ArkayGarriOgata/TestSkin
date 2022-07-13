//%attributes = {"publishedWeb":true}
//PM: ToDo_UI() -> 
//@author mlb - 5/10/02  10:53

C_LONGINT:C283($winRef; fileNum)
C_POINTER:C301(filePtr)
C_TEXT:C284($1; sFile)

If (Count parameters:C259=0)
	If (<>pid_ToDo=0)
		<>pid_ToDo:=uSpawnProcess("ToDo_UI"; <>lMidMemPart; "ToDo for Jobs"; False:C215; False:C215; "init")
		If (False:C215)
			ToDo_UI
		End if 
		
	Else 
		SHOW PROCESS:C325(<>pid_ToDo)
		BRING TO FRONT:C326(<>pid_ToDo)
		POST OUTSIDE CALL:C329(<>pid_ToDo)
	End if 
	
Else 
	app_Log_Usage("log"; "ToDo"; "")
	fileNum:=Table:C252(->[To_Do_Tasks:100])
	filePtr:=Table:C252(fileNum)
	sFile:=Table name:C256(filePtr)
	printMenuSupported:=True:C214
	SET MENU BAR:C67(<>DefaultMenu)
	
	ARRAY TEXT:C222(aComparison; 0)
	LIST TO ARRAY:C288("ExplorerComparisons"; aComparison)
	aComparison:=1
	aComparison{0}:=aComparison{1}
	sCriterion1:=""
	
	ToDo_collection("size"; 0)
	
	ARRAY INTEGER:C220($aFieldNums; 0)  //•090195  MLB      
	COPY ARRAY:C226(<>aSlctFF{Table:C252(filePtr)}; $aFieldNums)  //aSlctField  
	
	ARRAY POINTER:C280(aSlctField; 0)
	ARRAY POINTER:C280(aSlctField; 6)  // for backward compatiblity
	ARRAY TEXT:C222(aSelectBy; 0)
	ARRAY TEXT:C222(aSelectBy; 13)
	
	For ($i; 1; Size of array:C274($aFieldNums))
		If ($aFieldNums{$i}>0)
			aSlctField{$i}:=Field:C253(fileNum; $aFieldNums{$i})
			aSelectBy{$i}:=Field name:C257(fileNum; $aFieldNums{$i})
		Else 
			aSlctField{$i}:=<>NIL_PTR
			aSelectBy{$i}:=""
		End if 
	End for 
	
	aSlctField{$i}:=->[To_Do_Tasks:100]PjtNumber:5
	aSelectBy{6}:="Project Number"
	aSelectBy{7}:="-"
	aSelectBy{8}:="All Records"
	aSelectBy{9}:="Last Selection"
	aSelectBy{10}:="Query Editor"
	aSelectBy{11}:="-"
	aSelectBy{12}:="New"
	aSelectBy{13}:="Std Set"
	aSelectBy:=1
	aSelectBy{0}:=aSelectBy{1}
	C_LONGINT:C283(hlCategoryTypes)
	hlCategoryTypes:=ToDo_StdTaskList("init")
	C_LONGINT:C283(hlAssignable)
	hlAssignable:=Load list:C383("ToDoAssignable")
	$winRef:=OpenFormWindow(->[To_Do_Tasks:100]; "Input")
	SET WINDOW TITLE:C213(sFile+"  0/"+String:C10(Records in table:C83(filePtr->)); $winRef)
	FORM SET INPUT:C55([To_Do_Tasks:100]; "Input")
	DIALOG:C40([To_Do_Tasks:100]; "ToDoJobExplorer")
	CLOSE WINDOW:C154
	<>pid_ToDo:=0
	ToDo_StdTaskList("kill")
	
End if 