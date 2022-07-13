//%attributes = {}
// Method: rfc_Approve () -> 
// ----------------------------------------------------
// by: mel: 03/10/04, 11:00:58
// ----------------------------------------------------
// Description:
//based on: FG_PrepServiceApprove(date) -> 
//@author mlb - 3/7/03  12:44

$continue:=False:C215

If ([Finished_Goods_SizeAndStyles:132]Approved:9)
	
	If (([Finished_Goods_SizeAndStyles:132]DateSubmitted:5=!00-00-00!) | ([Finished_Goods_SizeAndStyles:132]DateDone:6=!00-00-00!))
		uConfirm("Approve this S&S without normal workflow?"; "Approve"; "Ooops")
		If (ok=1)
			$continue:=True:C214
			If ([Finished_Goods_SizeAndStyles:132]DateApproved:8=!00-00-00!)
				[Finished_Goods_SizeAndStyles:132]DateApproved:8:=4D_Current_date
			End if 
		Else 
			[Finished_Goods_SizeAndStyles:132]DateApproved:8:=!00-00-00!
			[Finished_Goods_SizeAndStyles:132]Approved:9:=False:C215
		End if 
	Else 
		[Finished_Goods_SizeAndStyles:132]DateApproved:8:=4D_Current_date
		$continue:=True:C214
	End if 
	
	If ($continue)
		READ WRITE:C146([Finished_Goods:26])
		QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
		If (Records in selection:C76([Finished_Goods:26])>0)
			APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateSnS_Approved:83:=[Finished_Goods_SizeAndStyles:132]DateApproved:8)
			If (Records in set:C195("LockedSet")>0)
				BEEP:C151
				uConfirm("Some F/G records were locked, their DateSnSApproved was not set."; "OK"; "Ignore")
			End if 
		End if 
		
		READ WRITE:C146([Finished_Goods_Specifications:98])
		QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]OutLine_Num:65=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
		If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
			APPLY TO SELECTION:C70([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Size_n_style:79:=[Finished_Goods_SizeAndStyles:132]DateApproved:8)
			If (Records in set:C195("LockedSet")>0)
				BEEP:C151
				uConfirm("Some F/G Spec records were locked, their Size_n_style was not set."; "OK"; "Ignore")
			End if 
		End if 
	End if 
	
Else 
	
	[Finished_Goods_SizeAndStyles:132]DateApproved:8:=!00-00-00!
	READ WRITE:C146([Finished_Goods:26])
	QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
	If (Records in selection:C76([Finished_Goods:26])>0)
		APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateSnS_Approved:83:=!00-00-00!)
		If (Records in set:C195("LockedSet")>0)
			BEEP:C151
			uConfirm("Some F/G records were locked, their DateSnSApproved was not cleared."; "OK"; "Ignore")
		End if 
	End if 
	
	READ WRITE:C146([Finished_Goods_Specifications:98])
	QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]OutLine_Num:65=[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1)
	If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
		APPLY TO SELECTION:C70([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Size_n_style:79:=!00-00-00!)
		If (Records in set:C195("LockedSet")>0)
			BEEP:C151
			uConfirm("Some F/G Spec records were locked, their Size_n_style was not cleared."; "OK"; "Ignore")
		End if 
	End if 
End if 

REDUCE SELECTION:C351([Finished_Goods:26]; 0)