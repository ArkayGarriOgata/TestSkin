//OM: ApprovalQAMgr() -> 
//@author mlb - 8/8/01  17:12
//DJC - 5-23-05 - added code to check for open To Dos
// • mel (6/6/05, 10:03:00)` only stop if todo not complete

Case of 
	: (Form event code:C388=On Data Change:K2:15)
		C_LONGINT:C283($LRIS)
		SET QUERY DESTINATION:C396(Into variable:K19:4; $LRIS)
		QUERY:C277([To_Do_Tasks:100]; [To_Do_Tasks:100]Category:2="CAR"+[QA_Corrective_Actions:105]RequestNumber:1; *)
		QUERY:C277([To_Do_Tasks:100];  & ; [To_Do_Tasks:100]Done:4=False:C215)
		//QUERY([QA_Corrective_Actions_ToDos];[QA_Corrective_Actions_ToDos]RequestNumber=[QA_Corrective_Actions]RequestNumber;*)
		//QUERY([QA_Corrective_Actions_ToDos]; & ;[QA_Corrective_Actions_ToDos]Completed=False)  ` • mel (6/6/05, 10:03:00)
		SET QUERY DESTINATION:C396(Into current selection:K19:1)
		
		If ($LRIS>0)
			uConfirm("You cannot close this CAR until all To Dos have been completed. "+String:C10($LRIS)+" still open."; "Go to ToDo's"; "Cancel")
			[QA_Corrective_Actions:105]ApprovalQAMgr:21:=""
			FORM GOTO PAGE:C247(3)
			
		Else 
			//[QA_Corrective_Actions]ApprovalQAMgr:=String(Current date;System date short)
		End if 
		
	: (Form event code:C388=On Double Clicked:K2:5)
		[QA_Corrective_Actions:105]ApprovalQAMgr:21:=String:C10(Current date:C33; System date short:K1:1)
End case 


