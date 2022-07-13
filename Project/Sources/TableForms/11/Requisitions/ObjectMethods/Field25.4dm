//•091495 upr 1527
//• 4/27/98 cs when a change was done PO Items get 'lost'
//• mlb - 4/18/01  look for reserved jobs if form not found
// • mel (10/28/04, 10:36:16) only use valid jobforms, alway do the check
C_TEXT:C284($jobform)
C_LONGINT:C283($numJobs)
C_TEXT:C284($isDirectPurchase)
READ ONLY:C145([Job_Forms:42])
READ WRITE:C146([Purchase_Orders_Job_forms:59])
READ ONLY:C145([Raw_Materials_Groups:22])

$jobform:=[Purchase_Orders:11]DefaultJobId:3
QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobFormID:5=$jobform)

If (Records in selection:C76([Job_Forms:42])=1)
	If ([Job_Forms:42]Status:6#"Closed")
		FIRST RECORD:C50([Purchase_Orders_Items:12])
		While (Not:C34(End selection:C36([Purchase_Orders_Items:12])))
			QUERY:C277([Raw_Materials_Groups:22]; [Raw_Materials_Groups:22]Commodity_Key:3=[Purchase_Orders_Items:12]Commodity_Key:26; *)
			QUERY:C277([Raw_Materials_Groups:22];  & ; [Raw_Materials_Groups:22]ReceiptType:13=2)
			If (Records in selection:C76([Raw_Materials_Groups:22])>0)
				$isDirectPurchase:=" THIS IS A DIRECT PURCHASE ITEM! "+Char:C90(13)
			Else 
				$isDirectPurchase:=""
			End if 
			
			QUERY:C277([Purchase_Orders_Job_forms:59]; [Purchase_Orders_Job_forms:59]POItemKey:1=[Purchase_Orders_Items:12]POItemKey:1)
			Case of 
				: (Records in selection:C76([Purchase_Orders_Job_forms:59])=1)
					If ([Purchase_Orders_Job_forms:59]JobFormID:2#$jobform)
						CONFIRM:C162($isDirectPurchase+"Change "+[Purchase_Orders_Job_forms:59]JobFormID:2+" to "+$jobform+" for item "+[Purchase_Orders_Items:12]POItemKey:1; "Change"; "Ignor")
						If (ok=1)
							[Purchase_Orders_Job_forms:59]JobFormID:2:=$jobform
							SAVE RECORD:C53([Purchase_Orders_Job_forms:59])
						End if 
						
					End if 
					
				: (Records in selection:C76([Purchase_Orders_Job_forms:59])=0)
					CONFIRM:C162($isDirectPurchase+"Add a link to "+$jobform+" for item "+[Purchase_Orders_Items:12]POItemKey:1; "Add"; "Ignor")
					If (ok=1)
						CREATE RECORD:C68([Purchase_Orders_Job_forms:59])
						[Purchase_Orders_Job_forms:59]POItemKey:1:=[Purchase_Orders_Items:12]POItemKey:1
						[Purchase_Orders_Job_forms:59]JobFormID:2:=$jobform
						SAVE RECORD:C53([Purchase_Orders_Job_forms:59])
					End if 
					
				Else 
					BEEP:C151
					uConfirm($isDirectPurchase+"More than 1 jobform link found for "+[Purchase_Orders_Items:12]POItemKey:1+". You need to set this one up manually."; "Try Again"; "Help")
			End case 
			
			NEXT RECORD:C51([Purchase_Orders_Items:12])
		End while 
		
	Else 
		BEEP:C151
		uConfirm($jobform+" is closed."; "Try Again"; "Help")
		[Purchase_Orders:11]DefaultJobId:3:=""
		GOTO OBJECT:C206([Purchase_Orders:11]DefaultJobId:3)
	End if 
Else 
	BEEP:C151
	uConfirm($jobform+" is not a valid job form."; "Try Again"; "Help")
	[Purchase_Orders:11]DefaultJobId:3:=""
	GOTO OBJECT:C206([Purchase_Orders:11]DefaultJobId:3)
End if 

UNLOAD RECORD:C212([Job_Forms:42])
UNLOAD RECORD:C212([Raw_Materials_Groups:22])
UNLOAD RECORD:C212([Purchase_Orders_Job_forms:59])
//

