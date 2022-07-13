//%attributes = {}
// ----------------------------------------------------
// User name (OS): work
// Date and time: 05/24/06, 11:18:30
// ----------------------------------------------------
// Method: Estimate_validate
// ----------------------------------------------------

[Estimates:17]ModDate:37:=4D_Current_date
[Estimates:17]ModWho:38:=<>zResp

If ([Estimates:17]Status:30="New")  //•062695  MLB  UPR 205
	uConfirm("Note: this RFQ is still in the 'New' Status."; "Keep New"; "Submit RFQ")
	If (OK=0)
		[Estimates:17]Status:30:="RFQ"
	End if 
End if 

If ([Estimates:17]Status:30="RFQ")
	If (uChkMissingInfo([Estimates:17]EstimateNo:1; "RFQ")#0)
		[Estimates:17]Status:30:="New"
		uConfirm("Supply the missing information before setting status to RFQ"; "Still New"; "Help")
	End if 
End if 

Case of 
	: ([Estimates:17]Status:30="New")
		If ([Estimates:17]DateRFQ:52=!00-00-00!)
			[Estimates:17]DateRFQ:52:=!00-00-00!
			[Estimates:17]DateRFQTime:53:=?00:00:00?
		End if 
		
	: ([Estimates:17]Status:30="RFQ")
		If ([Estimates:17]DateRFQ:52=!00-00-00!)
			[Estimates:17]DateRFQ:52:=4D_Current_date  //UPR 1353
			[Estimates:17]DateRFQTime:53:=4d_Current_time
		End if 
		
	: ([Estimates:17]Status:30="CONTRACT")
		If ([Estimates:17]DateRFQ:52=!00-00-00!)
			[Estimates:17]DateRFQ:52:=4D_Current_date  //UPR 1353
			[Estimates:17]DateRFQTime:53:=4d_Current_time
		End if 
		If ([Estimates:17]DatePrice:60=!00-00-00!)
			[Estimates:17]DatePrice:60:=4D_Current_date
		End if 
End case 

If (User in group:C338(Current user:C182; "RoleEstimator"))
	If ([Estimates:17]Status:30="Estimated")
		If (Length:C16([Estimates:17]EstimatedBy:14)=0)
			[Estimates:17]EstimatedBy:14:=<>zResp
			[Estimates:17]DateEstimated:64:=4D_Current_date
			[Estimates:17]DateEstimatedTime:65:=4d_Current_time
		End if 
	End if 
End if 

If (User in group:C338(Current user:C182; "PriceManager"))
	Case of 
		: ([Estimates:17]Status:30="Priced@")
			If (Length:C16([Estimates:17]EstimatedBy:14)=0)
				[Estimates:17]EstimatedBy:14:=<>zResp
				[Estimates:17]DateEstimated:64:=4D_Current_date
				[Estimates:17]DateEstimatedTime:65:=4d_Current_time
			End if 
			
			If ([Estimates:17]DateEstimated:64=!00-00-00!)
				[Estimates:17]DateEstimated:64:=4D_Current_date
				[Estimates:17]DateEstimatedTime:65:=4d_Current_time
			End if 
			
			If (Old:C35([Estimates:17]Status:30)#"Priced@")  //first save as priced
				[Estimates:17]DatePrice:60:=4D_Current_date
				[Estimates:17]PricedBy:15:=<>zResp
				//send an email
				Est_Send_Priced_Letter
			End if 
			
	End case 
End if 