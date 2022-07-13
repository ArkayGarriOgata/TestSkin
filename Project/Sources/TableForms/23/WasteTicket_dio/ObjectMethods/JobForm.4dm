SET QUERY LIMIT:C395(1)
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=[Raw_Materials_Transactions:23]JobForm:12)
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([Job_Forms:42])=0)
	uConfirm([Raw_Materials_Transactions:23]JobForm:12+" is not a valid job form number."; "Try again"; "Help")
	[Raw_Materials_Transactions:23]JobForm:12:=""
	REDUCE SELECTION:C351([Jobs:15]; 0)
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]JobForm:12)
	iTotalQty:=0
Else 
	RELATE ONE:C42([Job_Forms:42]JobNo:2)
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]JobForm:12+"."+String:C10([Raw_Materials_Transactions:23]Sequence:13; "000")
	If (rb1=1)
		iTotalQty:=[Job_Forms:42]EstNetSheets:28*[Job_Forms:42]NumberUp:26
	Else 
		iTotalQty:=[Job_Forms:42]EstNetSheets:28
	End if 
End if 
//REDUCE SELECTION([JobForm];0) used later