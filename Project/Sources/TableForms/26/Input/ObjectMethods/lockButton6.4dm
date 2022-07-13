//OM: Button4() -> 
//@author mlb - 8/20/01  15:54
//see also FG_PrepServiceSetFGrecord
CONFIRM:C162("Reset the Control Nº back to a prior?")
If (ok=1)
	$before:=[Finished_Goods:26]ControlNumber:61
	$prior:=Request:C163("What is the old Control Nº?"; [Finished_Goods:26]ControlNumber:61)
	If (ok=1) & ($prior#[Finished_Goods:26]ControlNumber:61)
		READ WRITE:C146([Finished_Goods_Specifications:98])
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$prior)
		If (Records in selection:C76([Finished_Goods_Specifications:98])=1)
			If (fLockNLoad(->[Finished_Goods_Specifications:98]))
				If ([Finished_Goods_Specifications:98]FG_Key:1=[Finished_Goods:26]FG_KEY:47)
					[Finished_Goods:26]ControlNumber:61:=[Finished_Goods_Specifications:98]ControlNumber:2
					[Finished_Goods:26]OutLine_Num:4:=[Finished_Goods_Specifications:98]OutLine_Num:65
					[Finished_Goods:26]ColorSpecMaster:77:=[Finished_Goods_Specifications:98]ColorSpecMaster:70
					[Finished_Goods:26]DateArtApproved:46:=[Finished_Goods_Specifications:98]DateReturned:9
					[Finished_Goods:26]PrepDoneDate:58:=[Finished_Goods_Specifications:98]DatePrepDone:6
					[Finished_Goods:26]GlueDirection:104:=[Finished_Goods_Specifications:98]GlueDirection:73
					[Finished_Goods:26]ArtReceivedDate:56:=[Finished_Goods_Specifications:98]DateArtReceived:63
					[Finished_Goods:26]PrepDoneDate:58:=[Finished_Goods_Specifications:98]DatePrepDone:6
					[Finished_Goods:26]DateArtSent:101:=[Finished_Goods_Specifications:98]DateSentToCustomer:8
					//[Finished_Goods]UPC:=[Finished_Goods_Specifications]UPC_encoded
					[Finished_Goods_Specifications:98]Approved:10:=True:C214
					[Finished_Goods_Specifications:98]CommentsFromPlanner:19:=Replace string:C233([Finished_Goods_Specifications:98]CommentsFromPlanner:19; "S U P E R C E D E D "; "REACTIVATED")
					SAVE RECORD:C53([Finished_Goods_Specifications:98])
					
					QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]ControlNumber:2=$before)
					If (Records in selection:C76([Finished_Goods_Specifications:98])=1)
						If (fLockNLoad(->[Finished_Goods_Specifications:98]))
							[Finished_Goods_Specifications:98]Approved:10:=False:C215
							util_setDateIfNull(->[Finished_Goods_Specifications:98]DateReturned:9; 4D_Current_date)
							[Finished_Goods_Specifications:98]CommentsFromPlanner:19:="RESET TO "+$prior+Char:C90(13)+[Finished_Goods_Specifications:98]CommentsFromPlanner:19
							//[FG_Specification]Status:="6 Rejected"   in TRIGGER
							SAVE RECORD:C53([Finished_Goods_Specifications:98])
						Else 
							BEEP:C151
							ALERT:C41($before+" was locked and couldn't be set to Rejected.")
						End if 
					End if 
					ALERT:C41("Done. But you need to verify the [FG_Specification] records.")
					
				Else 
					BEEP:C151
					ALERT:C41($prior+" was not for this Product Code.")
				End if 
				
			Else 
				BEEP:C151
				ALERT:C41($prior+" was locked.")
			End if 
		Else 
			BEEP:C151
			ALERT:C41($prior+" was not found.")
		End if 
		
	End if 
	
End if 