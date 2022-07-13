//OM: Button1() -> 
//@author mlb - 7/2/01  16:42
//DJC - 5-5-05 - added [CorrectiveAction]CustomerName field to be set here

$recNo:=fPickList(->[Customers:16]ID:1; ->[Customers:16]Name:2; ->[Customers:16]ParentCorp:19)
If ($recNo>-1)
	GOTO RECORD:C242([Customers:16]; $recNo)
	[QA_Corrective_Actions:105]Custid:5:=[Customers:16]ID:1
	[QA_Corrective_Actions:105]CustomerName:31:=[Customers:16]Name:2  //DJC - 05/05/05
	GOTO OBJECT:C206([QA_Corrective_Actions:105]CustomerRefer:11)
Else 
	BEEP:C151
	GOTO OBJECT:C206([QA_Corrective_Actions:105]Custid:5)
End if 

