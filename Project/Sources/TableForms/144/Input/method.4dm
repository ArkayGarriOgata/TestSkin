// ----------------------------------------------------
// Form Method: [QA_Corrective_Actions_ToDos].Input
// ----------------------------------------------------

C_LONGINT:C283($LFormEvent)

$LFormEvent:=Form event code:C388

Case of 
	: (Is new record:C668([QA_Corrective_Actions_ToDos:144]))
		[QA_Corrective_Actions_ToDos:144]CAR_ToDo_ID:9:=app_GetPrimaryKey  //app_AutoIncrement (->[QA_Corrective_Actions_ToDos])
		[QA_Corrective_Actions_ToDos:144]RequestNumber:1:=[QA_Corrective_Actions:105]RequestNumber:1
		[QA_Corrective_Actions_ToDos:144]CreationAuthor:4:=<>zResp
		[QA_Corrective_Actions_ToDos:144]DateCreated:2:=4D_Current_date
		[QA_Corrective_Actions_ToDos:144]TimeCreated:3:=4d_Current_time
		SetObjectProperties(""; ->[QA_Corrective_Actions_ToDos:144]Completed:5; True:C214; ""; False:C215)  // Modified by: Mark Zinke (5/13/13)
		GOTO OBJECT:C206([QA_Corrective_Actions_ToDos:144]ToDo:8)
		
End case 