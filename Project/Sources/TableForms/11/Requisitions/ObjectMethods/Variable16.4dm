//(s) bApprove

fSavePO:=False:C215
Case of 
	: (User in group:C338(Current user:C182; "Req_Approval"))  //is the user allowed to approve?
		If ([Purchase_Orders:11]Status:15="Requisition") | ([Purchase_Orders:11]Status:15="Req On Hold") | ([Purchase_Orders:11]Status:15="PlantMgr")
			ReqApprove
			util_ComboBoxSetup(->astat; [Purchase_Orders:11]Status:15)
		Else 
			uConfirm("Requistion is in the wrong status to be approved. "; "OK"; "Help")
		End if 
		
	: (User in group:C338(Current user:C182; "Req_PreApproval")) & (False:C215)
		If ([Purchase_Orders:11]Status:15="PlantMgr") | ([Purchase_Orders:11]Status:15="Req On Hold")
			ReqApprove
			util_ComboBoxSetup(->astat; [Purchase_Orders:11]Status:15)
		Else 
			uConfirm("Requistion is in the Wrong status to be pre-approved.  Status must be 'PlantMgr'"; "OK"; "Help")
		End if 
		
	Else 
		uNotAuthorized
End case 