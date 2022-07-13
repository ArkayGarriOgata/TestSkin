//OM: Custid() -> 
//@author mlb - 7/18/01  13:39
// • mel (6/6/05, 10:11:33) add cust name
QUERY:C277([Customers:16]; [Customers:16]ID:1=[QA_Corrective_Actions:105]Custid:5)
If (Records in selection:C76([Customers:16])=1)
	[QA_Corrective_Actions:105]CustomerName:31:=[Customers:16]Name:2
	GOTO OBJECT:C206([QA_Corrective_Actions:105]CustomerRefer:11)
Else 
	BEEP:C151
	GOTO OBJECT:C206([QA_Corrective_Actions:105]Custid:5)
End if 