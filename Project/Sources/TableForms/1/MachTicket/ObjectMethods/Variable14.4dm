If (Length:C16(sMAJob)>=7)
	If (Find in array:C230(asChkJob; sMAJob)=-1)
		sCustName:=sMAJob+" is not valid"
		sMAJob:=""
		uConfirm("Invalid Job - Please Try Again!!!"; "Try Again"; "Help")
		GOTO OBJECT:C206(sMAJob)
		
	Else 
		SET QUERY LIMIT:C395(1)
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=(Num:C11(Substring:C12(sMAJob; 1; 5))))
		SET QUERY LIMIT:C395(0)
		sCustName:=[Jobs:15]CustomerName:5
	End if 
	
Else 
	uConfirm("Job Number (like 12345.12) must be entered to Post"; "Try Again"; "Help")
	GOTO OBJECT:C206(sMAJob)
End if 