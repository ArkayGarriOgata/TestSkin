SET QUERY LIMIT:C395(1)
QUERY:C277([Cost_Centers:27]; [Cost_Centers:27]ID:1=[Raw_Materials_Transactions:23]CostCenter:19)
SET QUERY LIMIT:C395(0)
If (Records in selection:C76([Cost_Centers:27])=0)
	BEEP:C151
	ALERT:C41([Raw_Materials_Transactions:23]CostCenter:19+" is not a valid Cost Center number."; "Try again")
	[Raw_Materials_Transactions:23]CostCenter:19:=""
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]CostCenter:19)
	REDUCE SELECTION:C351([Cost_Centers:27]; 0)
Else 
	If (Position:C15([Raw_Materials_Transactions:23]CostCenter:19; <>GLUERS)>0)
		rb1:=1
		rb2:=0
	Else 
		rb1:=0
		rb2:=1
	End if 
End if 
