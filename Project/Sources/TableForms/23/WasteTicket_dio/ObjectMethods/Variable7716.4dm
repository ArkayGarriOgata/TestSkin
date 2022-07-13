$picked:=CAR_BuildReasonList("pick"; ->[Raw_Materials_Transactions:23]Reason:5; ->[Raw_Materials_Transactions:23]ReferenceNo:14)
If (Length:C16([Raw_Materials_Transactions:23]Reason:5)=0)
	GOTO OBJECT:C206([Raw_Materials_Transactions:23]Reason:5)
End if 