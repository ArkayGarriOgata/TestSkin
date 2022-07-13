//%attributes = {"publishedWeb":true}
//PM: PSPEC_SetStatus([PROCESS_SPEC]PSpecKey;newstatus) -> 
//@author mlb - 10/25/02  14:23

C_TEXT:C284($newStatus; $2)
C_TEXT:C284($1)  //pspeckey

$newStatus:=$2

CUT NAMED SELECTION:C334([Process_Specs:18]; "pspecStatusChg")
READ WRITE:C146([Process_Specs:18])
QUERY:C277([Process_Specs:18]; [Process_Specs:18]PSpecKey:106=$1)
If (Records in selection:C76([Process_Specs:18])>0) & (fLockNLoad(->[Process_Specs:18]))
	Case of 
		: ($newStatus="Estimated")
			If ([Process_Specs:18]Status:2="New")
				[Process_Specs:18]Status:2:=$newStatus
				SAVE RECORD:C53([Process_Specs:18])
			End if 
		: ($newStatus="Final")
			If ([Process_Specs:18]Status:2="New") | ([Process_Specs:18]Status:2="Estimated")
				[Process_Specs:18]Status:2:=$newStatus
				SAVE RECORD:C53([Process_Specs:18])
			End if 
	End case 
	REDUCE SELECTION:C351([Process_Specs:18]; 0)
End if 

USE NAMED SELECTION:C332("pspecStatusChg")