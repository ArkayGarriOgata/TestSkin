//%attributes = {}
// Method: JOB_PutOnHold (jobnumber;$reason) -> 
//see also uResetStatii
// ----------------------------------------------------
// by: mel: 11/04/04, 10:49:51
// ----------------------------------------------------
// Description:
// unified method for putting a job on hold
// Updates:
// • mel (11/12/04, 16:22:58) don't hold forms that weren't released
//10-31-05 mlb make hold optional
// ----------------------------------------------------

C_LONGINT:C283($i; $1)
C_TEXT:C284($2)

If ([Customers_Orders:40]JobNo:44>0)
	CONFIRM:C162("Do you want to put job "+String:C10([Customers_Orders:40]JobNo:44)+" on Hold pending this change?"; "No Chg"; "Hold")
	If (OK=0)
		READ WRITE:C146([Jobs:15])  //3/1/95 upr 1242
		QUERY:C277([Jobs:15]; [Jobs:15]JobNo:1=[Customers_Orders:40]JobNo:44; *)
		QUERY:C277([Jobs:15];  & ; [Jobs:15]Status:4#"Closed")
		If (Records in selection:C76([Jobs:15])>0)
			$reason:="Put on hold "+String:C10(4D_Current_date; System date short:K1:1)+", "+$2
			zwStatusMsg("Setting HOLD"; "on Job "+String:C10($1)+" and its uncompleted forms.")
			If (Position:C15("Hold"; [Jobs:15]Status:4)=0)
				[Jobs:15]LastStatus:16:=[Jobs:15]Status:4  //so gChgOApproval can rtn to that state
			End if 
			[Jobs:15]ChangeLog:19:=$reason+Char:C90(13)+[Jobs:15]ChangeLog:19
			[Jobs:15]Status:4:="Hold Change Pending"
			[Jobs:15]ModDate:8:=4D_Current_date
			[Jobs:15]ModWho:9:=<>zResp
			SAVE RECORD:C53([Jobs:15])
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]JobNo:2=[Jobs:15]JobNo:1; *)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]Completed:18=!00-00-00!; *)
			QUERY:C277([Job_Forms:42]; [Job_Forms:42]PlnnerReleased:59#!00-00-00!)  // • mel (11/12/04, 16:22:58)
			
			While (Not:C34(End selection:C36([Job_Forms:42])))
				If (fLockNLoad(->[Job_Forms:42]))
					[Job_Forms:42]Status:6:="HOLD"
					[Job_Forms:42]Notes:32:=$reason+Char:C90(13)+[Job_Forms:42]Notes:32
					SAVE RECORD:C53([Job_Forms:42])
				Else 
					BEEP:C151
					ALERT:C41("JobForm "+[Job_Forms:42]JobFormID:5+" was locked and could not be put on HOLD"; "Do Manually")
				End if 
				NEXT RECORD:C51([Job_Forms:42])
			End while 
			REDUCE SELECTION:C351([Jobs:15]; 0)
			REDUCE SELECTION:C351([Job_Forms:42]; 0)
		Else 
			zwStatusMsg("No HOLD"; "No Jobs found for this order.")
		End if 
		
	End if 
End if 