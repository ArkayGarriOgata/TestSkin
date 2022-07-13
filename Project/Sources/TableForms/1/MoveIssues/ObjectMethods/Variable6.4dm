//(p) tSubgroup [control]MoveIssue

If (Self:C308->#"")
	QUERY:C277([Raw_Materials_Transactions:23]; [Raw_Materials_Transactions:23]JobForm:12=Self:C308->; *)
	QUERY:C277([Raw_Materials_Transactions:23];  & ; [Raw_Materials_Transactions:23]Xfer_Type:2="Issue")
	
	If (Records in selection:C76([Raw_Materials_Transactions:23])>0)
		SELECTION TO ARRAY:C260([Raw_Materials_Transactions:23]; aRmRecNo; [Raw_Materials_Transactions:23]Raw_Matl_Code:1; aRmCode; [Raw_Materials_Transactions:23]Qty:6; aFlex2; [Raw_Materials_Transactions:23]ReferenceNo:14; aLine; [Raw_Materials_Transactions:23]XferDate:3; aDate)
		ARRAY TEXT:C222(aBullet; 0)  //clear first
		ARRAY TEXT:C222(aBullet; Size of array:C274(aRmCode))
	Else 
		ALERT:C41("There were No issues found for the entered Jobform.")
		RM_MoveIssues
		GOTO OBJECT:C206(Self:C308->)
	End if 
Else 
	RM_MoveIssues
End if 
//