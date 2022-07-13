//%attributes = {"publishedWeb":true}
//PM: CAR_onEnterJobit() -> 
//@author mlb - 8/10/01  09:26
// • mel (6/6/05, 10:11:33) add cust name

$i:=qryJMI([QA_Corrective_Actions:105]Jobit:9)

If ($i>0)
	[QA_Corrective_Actions:105]Custid:5:=[Job_Forms_Items:44]CustId:15
	[QA_Corrective_Actions:105]ProductCode:7:=[Job_Forms_Items:44]ProductCode:3
	[QA_Corrective_Actions:105]FGKey:8:=[QA_Corrective_Actions:105]Custid:5+":"+[QA_Corrective_Actions:105]ProductCode:7
	$i:=qryFinishedGood("#KEY"; [QA_Corrective_Actions:105]FGKey:8)
	QUERY:C277([Customers:16]; [Customers:16]ID:1=[QA_Corrective_Actions:105]Custid:5)
	[QA_Corrective_Actions:105]CustomerName:31:=[Customers:16]Name:2
	CAR_getCostCenters([QA_Corrective_Actions:105]Jobit:9)
	CAR_getPurchaseOrders([QA_Corrective_Actions:105]ProductCode:7)
	If (Size of array:C274(aPO)=1)
		If (Length:C16([QA_Corrective_Actions:105]CustomerPO:12)=0)
			[QA_Corrective_Actions:105]CustomerPO:12:=aPO{1}
		End if 
	End if 
	[QA_Corrective_Actions:105]QtyProduced:37:=Sum:C1([Job_Forms_Items:44]Qty_Actual:11)
	
	GOTO OBJECT:C206([QA_Corrective_Actions:105]CustomerRefer:11)
	
Else 
	BEEP:C151
	GOTO OBJECT:C206([QA_Corrective_Actions:105]Jobit:9)
End if 