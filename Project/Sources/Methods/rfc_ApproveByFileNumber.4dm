//%attributes = {}
// Method: rfc_ApproveByFileNumber () -> 
// ----------------------------------------------------
// by: mel: 03/30/04, 14:54:22
// ----------------------------------------------------

C_TEXT:C284($fileNum; $0)
C_TEXT:C284($1; $request)
C_LONGINT:C283($numChrgs)

READ WRITE:C146([Finished_Goods_SizeAndStyles:132])
READ WRITE:C146([Finished_Goods:26])

$0:="*** Canceled ***"
$request:=$1
$pjtId:=$2
$today:=4D_Current_date

If ([Customers_Projects:9]id:1#$pjtId)
	QUERY:C277([Customers_Projects:9]; [Customers_Projects:9]id:1=$pjtId)
End if 

If (Records in selection:C76([Customers_Projects:9])=1)
	$fileNum:=Request:C163("What is the Size & Style's File 'A' number?"; ""; "Continue"; "Cancel")
	If (ok=1)
		$appvd:=Date:C102(Request:C163("What is the Size & Style's Approval Date?"; String:C10($today); "Continue"; "Cancel"))
		If (ok=1)
			zwStatusMsg("APRV S&S"; "Searching for "+$fileNum)
			QUERY:C277([Finished_Goods_SizeAndStyles:132]; [Finished_Goods_SizeAndStyles:132]FileOutlineNum:1=$fileNum)
			If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])=0)
				CONFIRM:C162("Create Size & Style record for "+$fileNum; "Yes"; "Cancel")
				If (ok=1)
					zwStatusMsg("APRV S&S"; "Creating "+$fileNum)
					CREATE RECORD:C68([Finished_Goods_SizeAndStyles:132])
					[Finished_Goods_SizeAndStyles:132]FileOutlineNum:1:=$fileNum
					[Finished_Goods_SizeAndStyles:132]ProjectNumber:2:=$pjtId
					[Finished_Goods_SizeAndStyles:132]DateCreated:3:=$today
					[Finished_Goods_SizeAndStyles:132]Started_TimeStamp:4:=0
					[Finished_Goods_SizeAndStyles:132]DateSubmitted:5:=$today
					[Finished_Goods_SizeAndStyles:132]DateDone:6:=$today
					[Finished_Goods_SizeAndStyles:132]z_DateSent:7:=$today
					SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
				Else 
					REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
				End if 
				
			Else 
				If ([Finished_Goods_SizeAndStyles:132]DateApproved:8#!00-00-00!)
					CONFIRM:C162("Already returned on "+String:C10([Finished_Goods_SizeAndStyles:132]DateApproved:8; System date short:K1:1); "Reset"; "Cancel")
					If (ok=0)
						REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
					End if 
				End if 
			End if 
			
			If (Records in selection:C76([Finished_Goods_SizeAndStyles:132])>0)
				If (fLockNLoad(->[Finished_Goods_SizeAndStyles:132]))
					zwStatusMsg("APRV S&S"; "Approving "+$fileNum)
					[Finished_Goods_SizeAndStyles:132]DateApproved:8:=$appvd
					[Finished_Goods_SizeAndStyles:132]Approved:9:=True:C214
					SAVE RECORD:C53([Finished_Goods_SizeAndStyles:132])
					REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
					
					zwStatusMsg("APRV S&S"; "Updating F/G records that use "+$fileNum)
					QUERY:C277([Finished_Goods:26]; [Finished_Goods:26]OutLine_Num:4=$fileNum)
					If (Records in selection:C76([Finished_Goods:26])>0)
						APPLY TO SELECTION:C70([Finished_Goods:26]; [Finished_Goods:26]DateSnS_Approved:83:=$appvd)
						If (Records in set:C195("LockedSet")>0)
							BEEP:C151
							ALERT:C41("Some F/G records were locked, their DateSnSApproved was not set.")
						End if 
						REDUCE SELECTION:C351([Finished_Goods:26]; 0)
					End if 
					
					READ WRITE:C146([Finished_Goods_Specifications:98])
					QUERY:C277([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]OutLine_Num:65=$fileNum)
					If (Records in selection:C76([Finished_Goods_Specifications:98])>0)
						APPLY TO SELECTION:C70([Finished_Goods_Specifications:98]; [Finished_Goods_Specifications:98]Size_n_style:79:=$appvd)
						If (Records in set:C195("LockedSet")>0)
							BEEP:C151
							uConfirm("Some F/G Spec records were locked, their Size_n_style was not set."; "OK"; "Ignore")
						End if 
					End if 
					
					$0:=$fileNum
				End if 
			End if 
			
		End if 
		
	End if 
	
End if   //project

REDUCE SELECTION:C351([Finished_Goods_SizeAndStyles:132]; 0)
REDUCE SELECTION:C351([Finished_Goods:26]; 0)
READ ONLY:C145([Finished_Goods_SizeAndStyles:132])
READ ONLY:C145([Finished_Goods:26])