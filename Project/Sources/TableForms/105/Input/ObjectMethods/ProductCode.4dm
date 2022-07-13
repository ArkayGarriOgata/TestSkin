//OM: ProductCode() -> 
//@author mlb - 7/18/01  12:40
// • mel (6/6/05, 10:11:33) add cust name
$i:=qryFinishedGood("#CPN"; [QA_Corrective_Actions:105]ProductCode:7)
If ($i=1)
	[QA_Corrective_Actions:105]Custid:5:=[Finished_Goods:26]CustID:2
	[QA_Corrective_Actions:105]FGKey:8:=[QA_Corrective_Actions:105]Custid:5+":"+[QA_Corrective_Actions:105]ProductCode:7
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[QA_Corrective_Actions:105]Custid:5)
	[QA_Corrective_Actions:105]CustomerName:31:=[Customers:16]Name:2
	CAR_getPurchaseOrders([QA_Corrective_Actions:105]ProductCode:7)
	If (Size of array:C274(aPO)=1)
		If (Length:C16([QA_Corrective_Actions:105]CustomerPO:12)=0)
			[QA_Corrective_Actions:105]CustomerPO:12:=aPO{1}
		End if 
	End if 
	GOTO OBJECT:C206([QA_Corrective_Actions:105]CustomerRefer:11)
	If (Length:C16([QA_Corrective_Actions:105]Jobit:9)=0)
		CONFIRM:C162("Open AskMe for CPN: "+[QA_Corrective_Actions:105]ProductCode:7; "Open"; "Continue")
		If (ok=1)
			<>AskMeFG:=[QA_Corrective_Actions:105]ProductCode:7
			<>AskMeCust:=""  //[CustomerOrder]CustID
			C_LONGINT:C283(<>pid_CAR)
			<>pid_CAR:=Current process:C322
			displayAskMe("New")
		End if 
	End if 
	
Else 
	BEEP:C151
	REDUCE SELECTION:C351([Finished_Goods:26]; 0)
	GOTO OBJECT:C206([QA_Corrective_Actions:105]ProductCode:7)
End if 