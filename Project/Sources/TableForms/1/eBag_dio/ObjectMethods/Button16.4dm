//OM: Button4() -> 
//@author mlb - 10/25/02  16:44

$recNum:=Job_ProdHistory("New"; ([Jobs:15]CustID:2+":"+[Job_Forms:42]ProcessSpec:46); sDepartment; [Jobs:15]CustomerName:5; [Jobs:15]Line:3)
If ($recNum>0)
	$recNum:=Job_ProdHistory("find"; ([Jobs:15]CustID:2+":"+[Job_Forms:42]ProcessSpec:46); sDepartment)
End if 