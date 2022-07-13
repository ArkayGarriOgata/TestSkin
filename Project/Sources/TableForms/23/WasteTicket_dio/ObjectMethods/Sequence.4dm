SET QUERY LIMIT:C395(1)
QUERY:C277([Job_Forms_Machines:43]; [Job_Forms_Machines:43]JobForm:1=[Raw_Materials_Transactions:23]JobForm:12; *)
QUERY:C277([Job_Forms_Machines:43];  & ; [Job_Forms_Machines:43]Sequence:5=[Raw_Materials_Transactions:23]Sequence:13)

If (Records in selection:C76([Job_Forms_Machines:43])=0)
	BEEP:C151
	ALERT:C41(String:C10([Raw_Materials_Transactions:23]Sequence:13; "000")+" is not a valid job form number."; "Try again")
	[Raw_Materials_Transactions:23]Sequence:13:=0
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Sequence:13)
	REDUCE SELECTION:C351([Cost_Centers:27]; 0)
Else 
	[Raw_Materials_Transactions:23]CostCenter:19:=[Job_Forms_Machines:43]CostCenterID:4
	QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Raw_Materials_Transactions:23]CostCenter:19)
	[Raw_Materials_Transactions:23]Raw_Matl_Code:1:=[Raw_Materials_Transactions:23]JobForm:12+"."+String:C10([Raw_Materials_Transactions:23]Sequence:13; "000")
	If (Position:C15([Raw_Materials_Transactions:23]CostCenter:19; <>GLUERS)>0)
		rb1:=1
		rb2:=0
	Else 
		rb1:=0
		rb2:=1
	End if 
	
End if 
SET QUERY LIMIT:C395(0)
REDUCE SELECTION:C351([Job_Forms_Machines:43]; 0)

