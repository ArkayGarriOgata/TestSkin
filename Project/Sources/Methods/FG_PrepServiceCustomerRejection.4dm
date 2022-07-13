//%attributes = {}
// Method: FG_PrepServiceCustomerRejection () -> 
// ----------------------------------------------------
// by: mel: 12/02/04, 11:36:14
// ----------------------------------------------------
// Description:
// reject a control number
// see also FG_PrepServiceSetFGrecord

uConfirm("Did the Customer Reject the Prep Work?"; "Yes"; "No")

If (OK=1)
	$controlNumber:=[Finished_Goods:26]ControlNumber:61
	[Finished_Goods:26]ArtReceivedDate:56:=!00-00-00!
	[Finished_Goods:26]PrepDoneDate:58:=!00-00-00!
	[Finished_Goods:26]DateArtApproved:46:=!00-00-00!
	//[Finished_Goods]HaveArt:=False
	[Finished_Goods:26]ArtWorkNotes:60:="Customer Rejected on "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods:26]ArtWorkNotes:60
	[Finished_Goods:26]ControlNumber:61:="REJECT"
	[Finished_Goods:26]Preflight:66:=False:C215
	[Finished_Goods:26]PreflightBy:67:=""
	
	CUT NAMED SELECTION:C334([Job_Forms_Master_Schedule:67]; "holdReject")
	READ WRITE:C146([Job_Forms_Master_Schedule:67])
	$numJML:=JML_findJobByFG([Finished_Goods:26]ProductCode:1)
	If ($numJML>0)
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateFinalArtApproved:12:=!00-00-00!)
		FIRST RECORD:C50([Job_Forms_Master_Schedule:67])
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]Preflighed:43:=False:C215)
		FIRST RECORD:C50([Job_Forms_Master_Schedule:67])
		APPLY TO SELECTION:C70([Job_Forms_Master_Schedule:67]; [Job_Forms_Master_Schedule:67]DateClosingMet:23:=!00-00-00!)
		//FIRST RECORD([JobMasterLog])
		//APPLY TO SELECTION([JobMasterLog];[JobMasterLog]DateFinalToolApproved:=!00/00/00!)
	End if 
	USE NAMED SELECTION:C332("holdReject")
	
	READ WRITE:C146([Finished_Goods_Specifications:98])
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$controlNumber)
	If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
		[Finished_Goods_Specifications:98]Approved:10:=False:C215
		[Finished_Goods_Specifications:98]Status:68:="6 Rejected"
		FG_PrepServiceStateChange("Reject"; !00-00-00!)
		If ([Finished_Goods_Specifications:98]DateReturned:9=!00-00-00!)
			[Finished_Goods_Specifications:98]DateReturned:9:=4D_Current_date
		End if 
		[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="REJECTED BY "+<>zResp+" ON "+String:C10(4D_Current_date)+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromPlanner:19
		[Finished_Goods_Specifications:98]ModDate:56:=4D_Current_date
		[Finished_Goods_Specifications:98]ModWho:55:=<>zResp
		SAVE RECORD:C53([Finished_Goods_Specifications:98])
		REDUCE SELECTION:C351([Finished_Goods_Specifications:98]; 0)
	End if 
End if 