//%attributes = {"publishedWeb":true}
//PM: RMX_assignCostCenters() -> 
//@author mlb - 11/13/02  15:08

MESSAGES OFF:C175

READ ONLY:C145([Job_Forms_Machine_Tickets:61])
READ ONLY:C145([Job_Forms_Machines:43])
READ WRITE:C146([Raw_Materials_Transactions:23])

QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue"; *)
QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]XferDate:3>=(4D_Current_date-35))
If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
	APPLY TO SELECTION:C70([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]CostCenter:19:=x_VOC_applyFormula)
End if 