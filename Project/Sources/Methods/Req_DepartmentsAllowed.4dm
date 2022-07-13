//%attributes = {"publishedWeb":true}
//PM:  Req_DepartmentsAllowed  3/07/01  mlb
//see what department a user may charge to

ARRAY TEXT:C222(aDepartment; 0)

$dept:=<>zRespDept

SET QUERY LIMIT:C395(1)

If (Position:C15("All"; $dept)=0)
	While (Length:C16($dept)>0)
		INSERT IN ARRAY:C227(aDepartment; 1; 1)
		aDepartment{1}:=Substring:C12($dept; 1; 4)
		QUERY:C277([y_accounting_departments:4]; [y_accounting_departments:4]DepartmentID:1=aDepartment{1})
		If (Records in selection:C76([y_accounting_departments:4])>0)
			aDepartment{1}:=aDepartment{1}+"-"+Substring:C12([y_accounting_departments:4]Description:4; 1; 20)
		End if 
		$dept:=Substring:C12($dept; 6)
	End while 
Else 
	COPY ARRAY:C226(<>aDepartment; aDepartment)
End if 

SET QUERY LIMIT:C395(0)
aDepartment:=1