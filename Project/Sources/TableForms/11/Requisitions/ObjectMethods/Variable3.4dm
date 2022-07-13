

Case of 
	: (User in group:C338(Current user:C182; "Req_Approval"))  //is the user allowed to approve?
		[Purchase_Orders:11]Status:15:="Req On Hold"
		[Purchase_Orders:11]StatusTrack:51:=[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
		util_ComboBoxSetup(->astat; [Purchase_Orders:11]Status:15)
	: (User in group:C338(Current user:C182; "Req_PreApproval"))
		[Purchase_Orders:11]Status:15:="req on hold"
		[Purchase_Orders:11]StatusTrack:51:=[Purchase_Orders:11]Status:15+" "+<>zResp+" "+String:C10(4D_Current_date)+Char:C90(13)+[Purchase_Orders:11]StatusTrack:51
		util_ComboBoxSetup(->astat; [Purchase_Orders:11]Status:15)
	Else 
		uNotAuthorized
End case 
